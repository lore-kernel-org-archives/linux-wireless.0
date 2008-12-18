Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:36679 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYLRQEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 11:04:53 -0500
Received: by ewy10 with SMTP id 10so552498ewy.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 08:04:51 -0800 (PST)
Message-ID: <eb3ff54b0812180804i3a782509oa009ff138e3f055c@mail.gmail.com> (sfid-20081218_170457_077765_CA95F78A)
Date: Thu, 18 Dec 2008 18:04:51 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] [v4] iwlwifi: iwl-tx.c cleanup (remove unused parameter and unused local variable).
Cc: "Tomas Winkler" <tomasw@gmail.com>, linux-wireless@vger.kernel.org,
	reinette.chatre@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused parameter and unused local variable in
methods in iwl-tx.c:

- Remove a parameter (is_unicast) from iwl_tx_cmd_build_basic().

- Remove an unused variable name unicast from iwl_tx_skb().

(wireless-testing).

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c
b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 3cb4363..43dcfe3 100644
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
@@ -834,7 +834,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	u16 len, len_org;
 	u16 seq_number = 0;
 	__le16 fc;
-	u8 hdr_len, unicast;
+	u8 hdr_len;
 	u8 sta_id;
 	u8 wait_write_ptr = 0;
 	u8 tid = 0;
@@ -854,8 +854,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		goto drop_unlock;
 	}

-	unicast = !is_multicast_ether_addr(hdr->addr1);
-
 	fc = hdr->frame_control;

 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -996,7 +994,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	len = (u16)skb->len;
 	tx_cmd->len = cpu_to_le16(len);
 	/* TODO need this for burst mode later on */
-	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, unicast, sta_id);
+	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);

 	/* set is_hcca to 0; it probably will never be implemented */
 	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);


On Thu, Dec 18, 2008 at 5:31 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Dec 18, 2008 at 12:42:37AM +0200, Tomas Winkler wrote:
>> On Wed, Dec 17, 2008 at 11:51 PM, Rami Rosen <ramirose@gmail.com> wrote:
>> > This patch removes unused parameters in methods in iwl-tx.c:
>> > remove a parameter (is_unicast) from iwl_tx_cmd_build_basic()
>> > remove a parameter (sta_id) from iwl_tx_cmd_build_rate()
>> > remove a parameter (sta_id ) from iwl_tx_cmd_build_hwcrypto()
>>
>> Unicast can go sta_id has to stay, we need it for merging 3945 back
>
> OK, I'll drop this patch and wait for a new submission.
>
> John
> --
> John W. Linville                Linux should be at the core
> linville@tuxdriver.com                  of your literate lifestyle.
>
