Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20855 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbZF3QRe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 12:17:34 -0400
Subject: Re: iwlagn: possible regressions from 2.6.29 in 2.6.30
From: reinette chatre <reinette.chatre@intel.com>
To: Paul Collins <paul@burly.ondioline.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <874oty9tlf.fsf@bulky.wgtn.ondioline.org>
References: <874oty9tlf.fsf@bulky.wgtn.ondioline.org>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 09:17:31 -0700
Message-Id: <1246378651.17896.523.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

On Mon, 2009-06-29 at 22:30 -0700, Paul Collins wrote:
> Two things I liked about iwlagn in 2.6.29 no longer happen with 2.6.30:
> 
> 1. reassociation following resume from suspend-to-ram
> 2. transmission of packets > 250 bytes following resume from suspend-to-ram
> 
> I can script around the first problem just by doing "iwconfig wlan0 ap
> auto" on resume, but the second problem requires me to ifdown/ifup wlan0
> before I can usefully use my network again, so fixing the first problem
> doesn't get me very far.

For reliable reassociation you need to use a userspace application like
wpa_supplicant.

> 
> When I say "packets > 250 bytes" I mean 250-byte packets as claimed by
> "ping -s 222 mygateway":
> 
>         PING cornelius.lan (10.2.4.1) 222(250) bytes of data.
> 
> The above will work, but "ping -s 223 cornelius" yields no replies.

Are you saying this works before suspend, but not after resume? What do
you usually do to get this working again?

Could you please try this patch?

---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 753fca3..3f3147e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -873,7 +876,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
-	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
+	if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
 						     le16_to_cpu(tx_cmd->len));
 
 	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
-- 
1.5.6.3



