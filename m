Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:49398 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab1GMMUK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 08:20:10 -0400
Date: Wed, 13 Jul 2011 17:42:06 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Subject: [PATCH] mwl8k: Fixing sta dereference when
 ieee80211_tx_info->control.sta is NULL
Message-ID: <20110713121159.GA8135@hertz.marvell.com> (sfid-20110713_142013_704897_30EBA58D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following oops was seen on SMP machine

>BUG: unable to handle kernel NULL pointer dereference at 00000012
>IP: [<f8c56691>] mwl8k_tx+0x20e/0x561 [mwl8k]
>*pde = 00000000
>Oops: 0000 [#1] SMP
>Modules linked in: mwl8k mac80211 cfg80211 [last unloaded: cfg80211]

As ieee80211_tx_info->control.sta may be NULL during ->tx call, avoiding sta
dereference in such scenario with the following patch.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index aeac3cc..a09b945 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -1891,9 +1891,9 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw, int index, struct sk_buff *skb)
 
 	txpriority = index;
 
-	if (ieee80211_is_data_qos(wh->frame_control) &&
-	    skb->protocol != cpu_to_be16(ETH_P_PAE) &&
-	    sta->ht_cap.ht_supported && priv->ap_fw) {
+	if (priv->ap_fw && sta && sta->ht_cap.ht_supported
+			&& skb->protocol != cpu_to_be16(ETH_P_PAE)
+			&& ieee80211_is_data_qos(wh->frame_control)) {
 		tid = qos & 0xf;
 		mwl8k_tx_count_packet(sta, tid);
 		spin_lock(&priv->stream_lock);
-- 
1.5.4.1

