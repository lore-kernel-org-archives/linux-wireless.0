Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C833FC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 16:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8695A21533
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 16:11:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8695A21533
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbeI0WaX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 18:30:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44339 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbeI0WaX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 18:30:23 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1g5Ysp-0004Yj-OF; Thu, 27 Sep 2018 16:11:19 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] b43: fix spelling mistake "hw_registred" -> "hw_registered"
Date:   Thu, 27 Sep 2018 17:11:19 +0100
Message-Id: <20180927161119.6698-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake struct field name, rename it.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/broadcom/b43/b43.h  | 2 +-
 drivers/net/wireless/broadcom/b43/main.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/b43.h b/drivers/net/wireless/broadcom/b43/b43.h
index b77d1a904f7e..9fc7c088a539 100644
--- a/drivers/net/wireless/broadcom/b43/b43.h
+++ b/drivers/net/wireless/broadcom/b43/b43.h
@@ -909,7 +909,7 @@ struct b43_wl {
 
 	/* Set this if we call ieee80211_register_hw() and check if we call
 	 * ieee80211_unregister_hw(). */
-	bool hw_registred;
+	bool hw_registered;
 
 	/* We can only have one operating interface (802.11 core)
 	 * at a time. General information about this interface follows.
diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index b37e7391f55d..4daa1ce8cba3 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -2611,7 +2611,7 @@ static void b43_request_firmware(struct work_struct *work)
 	err = ieee80211_register_hw(wl->hw);
 	if (err)
 		goto err_one_core_detach;
-	wl->hw_registred = true;
+	wl->hw_registered = true;
 	b43_leds_register(wl->current_dev);
 
 	/* Register HW RNG driver */
@@ -5610,7 +5610,7 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
-	wl->hw_registred = false;
+	wl->hw_registered = false;
 	hw->max_rates = 2;
 	SET_IEEE80211_DEV(hw, dev->dev);
 	if (is_valid_ether_addr(sprom->et1mac))
@@ -5693,7 +5693,7 @@ static void b43_bcma_remove(struct bcma_device *core)
 	B43_WARN_ON(!wl);
 	if (!wldev->fw.ucode.data)
 		return;			/* NULL if firmware never loaded */
-	if (wl->current_dev == wldev && wl->hw_registred) {
+	if (wl->current_dev == wldev && wl->hw_registered) {
 		b43_leds_stop(wldev);
 		ieee80211_unregister_hw(wl->hw);
 	}
@@ -5776,7 +5776,7 @@ static void b43_ssb_remove(struct ssb_device *sdev)
 	B43_WARN_ON(!wl);
 	if (!wldev->fw.ucode.data)
 		return;			/* NULL if firmware never loaded */
-	if (wl->current_dev == wldev && wl->hw_registred) {
+	if (wl->current_dev == wldev && wl->hw_registered) {
 		b43_leds_stop(wldev);
 		ieee80211_unregister_hw(wl->hw);
 	}
-- 
2.17.1

