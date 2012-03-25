Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:8975 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab2CYHn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Mar 2012 03:43:29 -0400
Message-ID: <4F6EBE8C.6000302@hartkopp.net> (sfid-20120325_094333_772257_5ED49723)
Date: Sun, 25 Mar 2012 08:43:24 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: [PATCH] iwlwifi: fix unused variable warning
References: <1318506157-10329-1-git-send-email-mkl@pengutronix.de>
In-Reply-To: <1318506157-10329-1-git-send-email-mkl@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the case of disabled CONFIG_IWLWIFI_DEBUGFS option the compiler complains
about the unused variable 'img'. Fix this by moving the 'img' definition.

Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>

---

diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index b6805f8..0f5db8b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -437,7 +437,6 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 	unsigned long flags;
 	u32 base, status = 0xffffffff;
 	int ret = -EIO;
-	const struct fw_img *img;
 
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 	mutex_lock(&priv->mutex);
@@ -458,6 +457,8 @@ static int iwlagn_mac_resume(struct ieee80211_hw *hw)
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (ret == 0) {
+			const struct fw_img *img;
+
 			img = &(priv->fw->img[IWL_UCODE_WOWLAN]);
 			if (!priv->wowlan_sram) {
 				priv->wowlan_sram =

