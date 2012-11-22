Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2KVUod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:44:33 -0500
Message-ID: <1353573671.9806.15.camel@jlt4.sipsolutions.net> (sfid-20121122_214500_330146_2FDA5F02)
Subject: Re: [PATCH v2] mac80211: support radiotap vendor namespace RX data
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 22 Nov 2012 09:41:11 +0100
In-Reply-To: <1353573266.9806.14.camel@jlt4.sipsolutions.net>
References: <1353061591-22284-1-git-send-email-johannes@sipsolutions.net>
	 <87ehjtygci.fsf@purkki.adurom.net>
	 <1353063966.9490.1.camel@jlt4.sipsolutions.net>
	 <50ADE0E3.2020909@neratec.com>
	 <1353573266.9806.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-22 at 09:34 +0100, Johannes Berg wrote:
> On Thu, 2012-11-22 at 09:22 +0100, Wojciech Dubowik wrote:
> > Shouldn't all functions between ieee80211_rx
> > and remove_monitor_info map header with
> > (struct ieee80211_hdr *)(skb->data + status->vendor_radiotap_len) ?
> > 
> > Otherwise function like should_drop_frame uses header mapped over
> > potential vendor data.
> 
> Huh, yes, how did I miss that. It only applies to should_drop_frame()
> though, or do you see any other place?

So I think this is sufficient?

johannes

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ec15a49..ec87902 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -62,13 +62,16 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 static inline int should_drop_frame(struct sk_buff *skb, int present_fcs_len)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_hdr *hdr;
+
+	hdr = (void *)(skb->data + status->vendor_radiotap_len);
 
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC |
 			    RX_FLAG_FAILED_PLCP_CRC |
 			    RX_FLAG_AMPDU_IS_ZEROLEN))
 		return 1;
-	if (unlikely(skb->len < 16 + present_fcs_len))
+	if (unlikely(skb->len < 16 + present_fcs_len +
+				status->vendor_radiotap_len))
 		return 1;
 	if (ieee80211_is_ctl(hdr->frame_control) &&
 	    !ieee80211_is_pspoll(hdr->frame_control) &&
@@ -341,8 +344,8 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS)
 		present_fcs_len = FCS_LEN;
 
-	/* make sure hdr->frame_control is on the linear part */
-	if (!pskb_may_pull(origskb, 2)) {
+	/* ensure hdr->frame_control and vendor radiotap data are in skb head */
+	if (!pskb_may_pull(origskb, 2 + status->vendor_radiotap_len)) {
 		dev_kfree_skb(origskb);
 		return NULL;
 	}


