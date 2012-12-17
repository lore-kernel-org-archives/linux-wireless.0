Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:60910 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab2LVOyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2012 09:54:23 -0500
Received: by mail-we0-f176.google.com with SMTP id r5so2717629wey.35
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2012 06:54:21 -0800 (PST)
Message-Id: <97df7bfd2d02a7cf3862c2b86878c3a9aa3d6ccf.1356186145.git.chunkeey@googlemail.com> (sfid-20121222_155425_818231_8DF3424D)
In-Reply-To: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
References: <8f92b38a456c1dd901ce2022fcb66609a5b8ac4b.1356186145.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 17 Dec 2012 16:30:05 +0100
Subject: [PATCH 5/8] carl9170: don't enable hw crypto offload, if the fw
 doesn't support it
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously, op_start would set disable_offload always
to false, even if it was set to true by the fw parser.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/carl9170.h |    1 +
 drivers/net/wireless/ath/carl9170/fw.c       |    2 +-
 drivers/net/wireless/ath/carl9170/main.c     |   33 +++++++++++++++++---------
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 2df17f1..c77874c 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -290,6 +290,7 @@ struct ar9170 {
 		unsigned int rx_size;
 		unsigned int tx_seq_table;
 		bool ba_filter;
+		bool disable_offload_fw;
 	} fw;
 
 	/* interface configuration combinations */
diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 401a080..6e76179 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -282,7 +282,7 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 	if (!SUPP(CARL9170FW_COMMAND_CAM)) {
 		dev_info(&ar->udev->dev, "crypto offloading is disabled "
 			 "by firmware.\n");
-		ar->disable_offload = true;
+		ar->fw.disable_offload_fw = true;
 	}
 
 	if (SUPP(CARL9170FW_PSM) && SUPP(CARL9170FW_FIXED_5GHZ_PSM))
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 5d3cb88..c1a272d 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -358,8 +358,13 @@ static int carl9170_op_start(struct ieee80211_hw *hw)
 	ar->ps.last_action = jiffies;
 	ar->ps.last_slept = jiffies;
 	ar->erp_mode = CARL9170_ERP_AUTO;
-	ar->rx_software_decryption = false;
-	ar->disable_offload = false;
+
+	/* Set "disable hw crypto offload" whenever the module parameter
+	 * nohwcrypt is true or if the firmware does not support it.
+	 */
+	ar->disable_offload = modparam_nohwcrypt |
+		ar->fw.disable_offload_fw;
+	ar->rx_software_decryption = ar->disable_offload;
 
 	for (i = 0; i < ar->hw->queues; i++) {
 		ar->queue_stop_timeout[i] = jiffies;
@@ -565,12 +570,20 @@ static int carl9170_init_interface(struct ar9170 *ar,
 
 	memcpy(common->macaddr, vif->addr, ETH_ALEN);
 
-	if (modparam_nohwcrypt ||
-	    ((vif->type != NL80211_IFTYPE_STATION) &&
-	     (vif->type != NL80211_IFTYPE_AP))) {
-		ar->rx_software_decryption = true;
-		ar->disable_offload = true;
-	}
+	/* We have to fall back to software crypto, whenever
+	 * the user choose to participates in an IBSS. HW
+	 * offload for IBSS RSN is not supported by this driver.
+	 *
+	 * NOTE: If the previous main interface has already
+	 * disabled hw crypto offload, we have to keep this
+	 * previous disable_offload setting as it was.
+	 * Altough ideally, we should notify mac80211 and tell
+	 * it to forget about any HW crypto offload for now.
+	 */
+	ar->disable_offload |= ((vif->type != NL80211_IFTYPE_STATION) &&
+	    (vif->type != NL80211_IFTYPE_AP));
+
+	ar->rx_software_decryption = ar->disable_offload;
 
 	err = carl9170_set_operating_mode(ar);
 	return err;
@@ -1160,9 +1173,7 @@ static int carl9170_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (ar->disable_offload || !vif)
 		return -EOPNOTSUPP;
 
-	/*
-	 * We have to fall back to software encryption, whenever
-	 * the user choose to participates in an IBSS or is connected
+	/* Fall back to software encryption whenever the driver is connected
 	 * to more than one network.
 	 *
 	 * This is very unfortunate, because some machines cannot handle
-- 
1.7.10.4

