Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:45959 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbYLQVv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 16:51:28 -0500
Received: by nf-out-0910.google.com with SMTP id d3so18029nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 13:51:24 -0800 (PST)
Message-ID: <eb3ff54b0812171351r50de6af0td15bf29d7e863212@mail.gmail.com> (sfid-20081217_225133_096278_DBA00583)
Date: Wed, 17 Dec 2008 23:51:23 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] [v3] iwlwifi: iwl-tx.c cleanup (remove unused parameters).
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
In-Reply-To: <20081217163908.GD12679@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0812152335p6f768aa4r7ad68b33e62bd20b@mail.gmail.com>
	 <20081217163908.GD12679@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused parameters in methods in iwl-tx.c:
remove a parameter (is_unicast) from iwl_tx_cmd_build_basic()
remove a parameter (sta_id) from iwl_tx_cmd_build_rate()
remove a parameter (sta_id ) from iwl_tx_cmd_build_hwcrypto()

(This version fixes the build error when compiling with debugging enabled.)

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>


diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c
b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3cb4363..a1607cd 100644
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
@@ -767,8 +767,8 @@ static void iwl_tx_cmd_build_rate(struct iwl_priv *priv,
 static void iwl_tx_cmd_build_hwcrypto(struct iwl_priv *priv,
 				      struct ieee80211_tx_info *info,
 				      struct iwl_tx_cmd *tx_cmd,
-				      struct sk_buff *skb_frag,
-				      int sta_id)
+				      struct sk_buff *skb_frag)
+
 {
 	struct ieee80211_key_conf *keyconf = info->control.hw_key;

@@ -834,7 +834,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u16 len, len_org;
 	u16 seq_number = 0;
 	__le16 fc;
-	u8 hdr_len, unicast;
+	u8 hdr_len;
 	u8 sta_id;
 	u8 wait_write_ptr = 0;
 	u8 tid = 0;
@@ -854,7 +854,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		goto drop_unlock;
 	}

-	unicast = !is_multicast_ether_addr(hdr->addr1);

 	fc = hdr->frame_control;

@@ -977,7 +976,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);

 	if (info->control.hw_key)
-		iwl_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
+		iwl_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb);

 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -996,10 +995,10 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	len = (u16)skb->len;
 	tx_cmd->len = cpu_to_le16(len);
 	/* TODO need this for burst mode later on */
-	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, unicast, sta_id);
+	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);

 	/* set is_hcca to 0; it probably will never be implemented */
-	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);
+	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, 0);

 	iwl_update_tx_stats(priv, le16_to_cpu(fc), len);



On Wed, Dec 17, 2008 at 6:39 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Dec 16, 2008 at 09:35:23AM +0200, Rami Rosen wrote:
>> This patch removes unused parameters in methods in iwl-tx.c:
>>
>> - remove a parameter (is_unicast) from iwl_tx_cmd_build_basic()
>> - remove a parameter (sta_id) from iwl_tx_cmd_build_rate()
>> - remove two parameters (sta_id and priv) from iwl_tx_cmd_build_hwcrypto()
>
>  CC [M]  drivers/net/wireless/iwlwifi/iwl-tx.o
> drivers/net/wireless/iwlwifi/iwl-tx.c: In function 'iwl_tx_cmd_build_hwcrypto':
> drivers/net/wireless/iwlwifi/iwl-tx.c:780: error: 'priv' undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-tx.c:780: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-tx.c:780: error: for each function it appears in.)
> make[2]: *** [drivers/net/wireless/iwlwifi/iwl-tx.o] Error 1
>
> Did you compile w/ debugging enabled?
>
> John
> --
> John W. Linville                Linux should be at the core
> linville@tuxdriver.com                  of your literate lifestyle.
>
