Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:46140 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbYLPHfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 02:35:25 -0500
Received: by ewy10 with SMTP id 10so3507929ewy.13
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 23:35:24 -0800 (PST)
Message-ID: <eb3ff54b0812152335p6f768aa4r7ad68b33e62bd20b@mail.gmail.com> (sfid-20081216_083528_441215_59DA681A)
Date: Tue, 16 Dec 2008 09:35:23 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH] [v2] iwlwifi: iwl-tx.c cleanup (remove unused parameters).
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused parameters in methods in iwl-tx.c:

- remove a parameter (is_unicast) from iwl_tx_cmd_build_basic()
- remove a parameter (sta_id) from iwl_tx_cmd_build_rate()
- remove two parameters (sta_id and priv) from iwl_tx_cmd_build_hwcrypto()

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c
b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3cb4363..1d72a19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -645,7 +645,7 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 				  struct iwl_tx_cmd *tx_cmd,
 				  struct ieee80211_tx_info *info,
 				  struct ieee80211_hdr *hdr,
-				  int is_unicast, u8 std_id)
+				  u8 std_id)
 {
 	__le16 fc = hdr->frame_control;
 	__le32 tx_flags = tx_cmd->tx_flags;
@@ -705,7 +705,7 @@ static void iwl_tx_cmd_build_basic(struct iwl_priv *priv,
 static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 			      struct iwl_tx_cmd *tx_cmd,
 			      struct ieee80211_tx_info *info,
-			      __le16 fc, int sta_id,
+			      __le16 fc,
 			      int is_hcca)
 {
 	u32 rate_flags = 0;
@@ -764,11 +764,10 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 	tx_cmd->rate_n_flags = iwl_hw_set_rate_n_flags(rate_plcp, rate_flags);
 }

-static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
-				      struct ieee80211_tx_info *info,
+static void iwl_tx_cmd_build_hwcrypto(struct ieee80211_tx_info *info,
 				      struct iwl_tx_cmd *tx_cmd,
-				      struct sk_buff *skb_frag,
-				      int sta_id)
+				      struct sk_buff *skb_frag)
+
 {
 	struct ieee80211_key_conf *keyconf = info->control.hw_key;

@@ -834,7 +833,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u16 len, len_org;
 	u16 seq_number = 0;
 	__le16 fc;
-	u8 hdr_len, unicast;
+	u8 hdr_len;
 	u8 sta_id;
 	u8 wait_write_ptr = 0;
 	u8 tid = 0;
@@ -854,7 +853,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		goto drop_unlock;
 	}

-	unicast = !is_multicast_ether_addr(hdr->addr1);

 	fc = hdr->frame_control;

@@ -977,7 +975,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);

 	if (info->control.hw_key)
-		iwl_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
+		iwl_tx_cmd_build_hwcrypto(info, tx_cmd, skb);

 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -996,10 +994,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	len = (u16)skb->len;
 	tx_cmd->len = cpu_to_le16(len);
 	/* TODO need this for burst mode later on */
-	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, unicast, sta_id);
+	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);

 	/* set is_hcca to 0; it probably will never be implemented */
-	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);
+	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, 0);

 	iwl_update_tx_stats(priv, le16_to_cpu(fc), len);
