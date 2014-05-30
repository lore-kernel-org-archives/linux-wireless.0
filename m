Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:34798 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaE3Jow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 05:44:52 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so782890wiw.14
        for <linux-wireless@vger.kernel.org>; Fri, 30 May 2014 02:44:51 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] mac80211: allow tx via monitor iface when DFS
Date: Fri, 30 May 2014 11:44:41 +0200
Message-Id: <1401443081-10277-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140530_114509_286876_E47E2FBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow send frames using monitor interface
when DFS chandef and we pass CAC (beaconing
allowed).

This fix problem when old kernel and new backports used,
in such case hostapd create/use also monitor interface.
Before this patch all frames hostapd send using monitor
were dropped when AP was configured on DFS channel.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/mac80211/tx.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5214686..a32ca9b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1618,12 +1618,12 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_chanctx_conf *chanctx_conf;
-	struct ieee80211_channel *chan;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_sub_if_data *tmp_sdata, *sdata;
+	struct cfg80211_chan_def chandef;
 	u16 len_rthdr;
 	int hdrlen;
 
@@ -1721,9 +1721,9 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	}
 
 	if (chanctx_conf)
-		chan = chanctx_conf->def.chan;
+		chandef = chanctx_conf->def;
 	else if (!local->use_chanctx)
-		chan = local->_oper_chandef.chan;
+		chandef = local->_oper_chandef;
 	else
 		goto fail_rcu;
 
@@ -1743,10 +1743,11 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * radar detection by itself. We can do that later by adding a
 	 * monitor flag interfaces used for AP support.
 	 */
-	if ((chan->flags & (IEEE80211_CHAN_NO_IR | IEEE80211_CHAN_RADAR)))
+	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef,
+				     sdata->vif.type))
 		goto fail_rcu;
 
-	ieee80211_xmit(sdata, skb, chan->band);
+	ieee80211_xmit(sdata, skb, chandef.chan->band);
 	rcu_read_unlock();
 
 	return NETDEV_TX_OK;
-- 
1.7.9.5

