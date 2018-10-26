Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5589FECDE44
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 222D92084D
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:01:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 222D92084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbeJZUi3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:38:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34314 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbeJZUi3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 16:38:29 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9E50330F559B;
        Fri, 26 Oct 2018 12:01:39 +0000 (UTC)
Received: from localhost (unknown [10.40.205.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6604A17AFC;
        Fri, 26 Oct 2018 12:00:59 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mt76: remove wait argument from mt76x02_mcu_function_select
Date:   Fri, 26 Oct 2018 14:00:28 +0200
Message-Id: <1540555229-28582-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
References: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 26 Oct 2018 12:01:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove wait argument from mt76x02_mcu_function_select and wait for
response when function is not Q_SELECT, what is the same behaviour
like in vendor driver.

Note this change behaviour for PCIe devices for Q_SELECT function
form wait to no-wait, and for mt76x0u BW_SETTING from no-wait to wait.
But the change is in align with vendor driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c    |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c     |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c    | 12 +++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h    |  5 ++---
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c |  2 +-
 6 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 64eb6f451541..0889196e79d4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -270,7 +270,7 @@ int mt76x0_init_hardware(struct mt76x02_dev *dev)
 		return -ETIMEDOUT;
 
 	mt76x0_reset_csr_bbp(dev);
-	ret = mt76x02_mcu_function_select(dev, Q_SELECT, 1, false);
+	ret = mt76x02_mcu_function_select(dev, Q_SELECT, 1);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 42351179c3cc..e1da7d6eee6b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -500,7 +500,7 @@ mt76x0_phy_bbp_set_bw(struct mt76x02_dev *dev, enum nl80211_chan_width width)
 		return ;
 	}
 
-	mt76x02_mcu_function_select(dev, BW_SETTING, bw, false);
+	mt76x02_mcu_function_select(dev, BW_SETTING, bw);
 }
 
 void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index 254bf3d22d94..964befc525f3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -132,9 +132,8 @@ int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_msg_send);
 
-int mt76x02_mcu_function_select(struct mt76x02_dev *dev,
-				enum mcu_function func,
-				u32 val, bool wait_resp)
+int mt76x02_mcu_function_select(struct mt76x02_dev *dev, enum mcu_function func,
+				u32 val)
 {
 	struct {
 	    __le32 id;
@@ -143,9 +142,12 @@ int mt76x02_mcu_function_select(struct mt76x02_dev *dev,
 	    .id = cpu_to_le32(func),
 	    .value = cpu_to_le32(val),
 	};
+	bool wait = false;
 
-	return mt76_mcu_send_msg(dev, CMD_FUN_SET_OP, &msg, sizeof(msg),
-				 wait_resp);
+	if (func != Q_SELECT)
+		wait = true;
+
+	return mt76_mcu_send_msg(dev, CMD_FUN_SET_OP, &msg, sizeof(msg), wait);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_function_select);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index 605cdb44961a..5cbf0e7c118c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -100,9 +100,8 @@ int mt76x02_mcu_cleanup(struct mt76x02_dev *dev);
 int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type, u32 param);
 int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 			 int len, bool wait_resp);
-int mt76x02_mcu_function_select(struct mt76x02_dev *dev,
-				enum mcu_function func,
-				u32 val, bool wait_resp);
+int mt76x02_mcu_function_select(struct mt76x02_dev *dev, enum mcu_function func,
+				u32 val);
 int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on,
 				bool wait_resp);
 void mt76x02_set_ethtool_fwver(struct mt76x02_dev *dev,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index b5067ee0b001..03e24ae7f66c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -182,6 +182,6 @@ int mt76x2_mcu_init(struct mt76x02_dev *dev)
 	if (ret)
 		return ret;
 
-	mt76x02_mcu_function_select(dev, Q_SELECT, 1, true);
+	mt76x02_mcu_function_select(dev, Q_SELECT, 1);
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index d6e3e663dd8a..ca9037af804c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -258,7 +258,7 @@ int mt76x2u_mcu_init(struct mt76x02_dev *dev)
 {
 	int err;
 
-	err = mt76x02_mcu_function_select(dev, Q_SELECT, 1, false);
+	err = mt76x02_mcu_function_select(dev, Q_SELECT, 1);
 	if (err < 0)
 		return err;
 
-- 
2.7.5

