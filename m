Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10903 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbcFNNxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 09:53:33 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Bob Copeland <me@bobcopeland.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix potential null dereference bugs
Date: Tue, 14 Jun 2016 13:53:12 +0000
Message-ID: <87oa733mig.fsf@kamboji.qca.qualcomm.com> (sfid-20160614_155336_242373_8299E16B)
References: <1465563164-783-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1465563164-783-1-git-send-email-me@bobcopeland.com> (Bob
	Copeland's message of "Fri, 10 Jun 2016 08:52:44 -0400")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> writes:

> Smatch warns about a number of cases in ath10k where a pointer is
> null-checked after it has already been dereferenced, in code involving
> ath10k private virtual interface pointers.
>
> Fix these by making the dereference happen later.
>
> Addresses the following smatch warnings:
>
> drivers/net/wireless/ath/ath10k/mac.c:3651 ath10k_mac_txq_init() warn: variable dereferenced before check 'txq' (see line 3649)
> drivers/net/wireless/ath/ath10k/mac.c:3664 ath10k_mac_txq_unref() warn: variable dereferenced before check 'txq' (see line 3659)
> drivers/net/wireless/ath/ath10k/htt_tx.c:70 __ath10k_htt_tx_txq_recalc() warn: variable dereferenced before check 'txq->sta' (see line 52)
> drivers/net/wireless/ath/ath10k/htt_tx.c:740 ath10k_htt_tx_get_vdev_id() warn: variable dereferenced before check 'cb->vif' (see line 736)
> drivers/net/wireless/ath/ath10k/txrx.c:86 ath10k_txrx_tx_unref() warn: variable dereferenced before check 'txq' (see line 84)
> drivers/net/wireless/ath/ath10k/wmi.c:1837 ath10k_wmi_op_gen_mgmt_tx() warn: variable dereferenced before check 'cb->vif' (see line 1825)
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

There was a new checkpatch warning:

drivers/net/wireless/ath/ath10k/htt_tx.c:740: braces {} should be used on all arms of this statement

I "fixed" it like this, which is folded to the patch in pending branch
(pushed soon):

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index dfcc43d80808..ae5b33fe5ba8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -737,15 +737,16 @@ static u8 ath10k_htt_tx_get_vdev_id(struct ath10k *ar, struct sk_buff *skb)
 	struct ath10k_skb_cb *cb = ATH10K_SKB_CB(skb);
 	struct ath10k_vif *arvif;
 
-	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) {
 		return ar->scan.vdev_id;
-	else if (cb->vif) {
+	} else if (cb->vif) {
 		arvif = (void *)cb->vif->drv_priv;
 		return arvif->vdev_id;
-	} else if (ar->monitor_started)
+	} else if (ar->monitor_started) {
 		return ar->monitor_vdev_id;
-	else
+	} else {
 		return 0;
+	}
 }
 
 static u8 ath10k_htt_tx_get_tid(struct sk_buff *skb, bool is_eth)