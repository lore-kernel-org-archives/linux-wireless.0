Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646B6C4321A
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4182C206BA
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 07:58:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfDZH66 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 03:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbfDZH65 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 03:58:57 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1505030A3AF1;
        Fri, 26 Apr 2019 07:58:57 +0000 (UTC)
Received: from localhost (unknown [10.40.205.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7A755D70A;
        Fri, 26 Apr 2019 07:58:56 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v3 3/3] mt76x02: remove bogus mutex usage
Date:   Fri, 26 Apr 2019 09:58:42 +0200
Message-Id: <20190426075842.2986-4-sgruszka@redhat.com>
In-Reply-To: <20190426075842.2986-1-sgruszka@redhat.com>
References: <20190426075842.2986-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 26 Apr 2019 07:58:57 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

mac80211 .start(), .stop() callbacks are never called concurrently with
other callbacks. The only concurencly is with mt76 works which we cancel
on stop() and schedule on start().

This fixes possible deadlock on cancel_delayed_work_sync(&dev->mac_work)
as mac_work also take mutex.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  6 -----
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 22 +++++--------------
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  | 13 +++--------
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  | 10 ++-------
 4 files changed, 10 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index f106dbfa665f..0eeccc3b529d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -25,8 +25,6 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 {
 	struct mt76x02_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mt76.mutex);
-
 	mt76x02_mac_start(dev);
 	mt76x0_phy_calibrate(dev, true);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mt76.mac_work,
@@ -35,8 +33,6 @@ static int mt76x0e_start(struct ieee80211_hw *hw)
 				     MT_CALIBRATE_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
-	mutex_unlock(&dev->mt76.mutex);
-
 	return 0;
 }
 
@@ -62,10 +58,8 @@ static void mt76x0e_stop(struct ieee80211_hw *hw)
 {
 	struct mt76x02_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mt76.mutex);
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	mt76x0e_stop_hw(dev);
-	mutex_unlock(&dev->mt76.mutex);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 406ebfa74195..7c38ec4418db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -81,8 +81,10 @@ static void mt76x0u_cleanup(struct mt76x02_dev *dev)
 	mt76u_queues_deinit(&dev->mt76);
 }
 
-static void mt76x0u_mac_stop(struct mt76x02_dev *dev)
+static void mt76x0u_stop(struct ieee80211_hw *hw)
 {
+	struct mt76x02_dev *dev = hw->priv;
+
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mt76.mac_work);
@@ -106,11 +108,9 @@ static int mt76x0u_start(struct ieee80211_hw *hw)
 	struct mt76x02_dev *dev = hw->priv;
 	int ret;
 
-	mutex_lock(&dev->mt76.mutex);
-
 	ret = mt76x0_mac_start(dev);
 	if (ret)
-		goto out;
+		return ret;
 
 	mt76x0_phy_calibrate(dev, true);
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->mt76.mac_work,
@@ -118,19 +118,7 @@ static int mt76x0u_start(struct ieee80211_hw *hw)
 	ieee80211_queue_delayed_work(dev->mt76.hw, &dev->cal_work,
 				     MT_CALIBRATE_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
-
-out:
-	mutex_unlock(&dev->mt76.mutex);
-	return ret;
-}
-
-static void mt76x0u_stop(struct ieee80211_hw *hw)
-{
-	struct mt76x02_dev *dev = hw->priv;
-
-	mutex_lock(&dev->mt76.mutex);
-	mt76x0u_mac_stop(dev);
-	mutex_unlock(&dev->mt76.mutex);
+	return 0;
 }
 
 static const struct ieee80211_ops mt76x0u_ops = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index 77f63cb14f35..ab716957b8ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -22,15 +22,13 @@ mt76x2_start(struct ieee80211_hw *hw)
 	struct mt76x02_dev *dev = hw->priv;
 	int ret;
 
-	mutex_lock(&dev->mt76.mutex);
-
 	ret = mt76x2_mac_start(dev);
 	if (ret)
-		goto out;
+		return ret;
 
 	ret = mt76x2_phy_start(dev);
 	if (ret)
-		goto out;
+		return ret;
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
 				     MT_MAC_WORK_INTERVAL);
@@ -38,10 +36,7 @@ mt76x2_start(struct ieee80211_hw *hw)
 				     MT_WATCHDOG_TIME);
 
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
-
-out:
-	mutex_unlock(&dev->mt76.mutex);
-	return ret;
+	return 0;
 }
 
 static void
@@ -49,10 +44,8 @@ mt76x2_stop(struct ieee80211_hw *hw)
 {
 	struct mt76x02_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mt76.mutex);
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	mt76x2_stop_hardware(dev);
-	mutex_unlock(&dev->mt76.mutex);
 }
 
 static int
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 305977a874a4..97bcf6494ec1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -21,30 +21,24 @@ static int mt76x2u_start(struct ieee80211_hw *hw)
 	struct mt76x02_dev *dev = hw->priv;
 	int ret;
 
-	mutex_lock(&dev->mt76.mutex);
-
 	ret = mt76x2u_mac_start(dev);
 	if (ret)
-		goto out;
+		return ret;
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
 				     MT_MAC_WORK_INTERVAL);
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
-out:
-	mutex_unlock(&dev->mt76.mutex);
-	return ret;
+	return 0;
 }
 
 static void mt76x2u_stop(struct ieee80211_hw *hw)
 {
 	struct mt76x02_dev *dev = hw->priv;
 
-	mutex_lock(&dev->mt76.mutex);
 	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 	mt76u_stop_tx(&dev->mt76);
 	mt76x2u_stop_hw(dev);
-	mutex_unlock(&dev->mt76.mutex);
 }
 
 static int
-- 
2.20.1

