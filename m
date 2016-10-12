Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42233 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932329AbcJLJPy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 05:15:54 -0400
Message-ID: <1476257614.5271.8.camel@sipsolutions.net> (sfid-20161012_111608_452604_97038F50)
Subject: Re: [PATCH v2] mac80211: enable to inject a-msdu frames using
 monitor interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Date: Wed, 12 Oct 2016 09:33:34 +0200
In-Reply-To: <1476118105-7641-1-git-send-email-michael-dev@fami-braun.de>
References: <1476118105-7641-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-10 at 18:48 +0200, Michael Braun wrote:
> Problem: When injecting an A-MSDU using a PF_PACKET socket, the qos
> flag
> IEEE80211_QOS_CTL_A_MSDU_PRESENT is cleared.
> 
> How to reproduce: Inject a frame on a mac80211 hwsim monitor
> interface and
> have tshark sniffing on this monitor interface.
> You'll see the packet twice: Once with correct flag and once with
> flag
> cleared. On hwsim0, you'll only see the packet with a cleared flag.
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
> ---
>  net/mac80211/wme.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
> index 9eb0aee..f6a708c 100644
> --- a/net/mac80211/wme.c
> +++ b/net/mac80211/wme.c
> @@ -248,6 +248,11 @@ void ieee80211_set_qos_hdr(struct
> ieee80211_sub_if_data *sdata,
>  	/* preserve EOSP bit */
>  	ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
>  
> +	/* preserve A-MSDU bit for MONITOR interfaces to allow
> injecting
> +	 * A-MSDU frames
> +	 */
> +	ack_policy |= *p & IEEE80211_QOS_CTL_A_MSDU_PRESENT;

Conceptually this seems OK, though I'd probably make some adjustments
to the commit log.

However, re-reading *p looks strange to me. Why don't we just refactor
this to preserve everything but the TID and ACK policy, after all, we
have just previous created this all zeroed in most cases, so it won't
really matter.

Like this:

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index f6a708c67219..3e3d3014e9ab 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -236,31 +236,35 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	u8 tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
+	u8 flags;
 	u8 *p;
-	u8 ack_policy, tid;
 
 	if (!ieee80211_is_data_qos(hdr->frame_control))
 		return;
 
 	p = ieee80211_get_qos_ctl(hdr);
-	tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
 
-	/* preserve EOSP bit */
-	ack_policy = *p & IEEE80211_QOS_CTL_EOSP;
+	/* set up the first byte */
 
-	/* preserve A-MSDU bit for MONITOR interfaces to allow injecting
-	 * A-MSDU frames
+	/*
+	 * preserve everything but the TID and ACK policy
+	 * (which we both write here)
 	 */
-	ack_policy |= *p & IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+	flags = *p & ~(IEEE80211_QOS_CTL_TID_MASK |
+		       IEEE80211_QOS_CTL_ACK_POLICY_MASK);
 
 	if (is_multicast_ether_addr(hdr->addr1) ||
 	    sdata->noack_map & BIT(tid)) {
-		ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
+		flags |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
 		info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	}
 
-	/* qos header is 2 bytes */
-	*p++ = ack_policy | tid;
+	*p = flags | tid;
+
+	/* set up the second byte */
+	p++;
+
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		/* preserve RSPI and Mesh PS Level bit */
 		*p &= ((IEEE80211_QOS_CTL_RSPI |



johannes
