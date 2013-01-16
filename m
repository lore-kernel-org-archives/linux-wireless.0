Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52976 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab3APWOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 17:14:21 -0500
Message-ID: <1358374485.15012.20.camel@jlt4.sipsolutions.net> (sfid-20130116_231425_267929_6F39D3C7)
Subject: Re: [PATCHv2 6/6] mac80211: mesh power save basics
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Wed, 16 Jan 2013 23:14:45 +0100
In-Reply-To: <1357571093-12868-7-git-send-email-marco@cozybit.com> (sfid-20130107_160510_532684_9863E9B0)
References: <1357571093-12868-1-git-send-email-marco@cozybit.com>
	 <1357571093-12868-7-git-send-email-marco@cozybit.com>
	 (sfid-20130107_160510_532684_9863E9B0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-07 at 16:04 +0100, Marco Porsch wrote:

> mode determines when non-peer mesh STA may send Probe Requests and Mesh Peering

Please break lines to less than 72 characters, I personally prefer
around 60 or so but I'll apply 72 too.

> +static inline bool ieee80211_has_qos_mesh_ps(__le16 qc)
> +{
> +	return (qc & cpu_to_le16(IEEE80211_QOS_CTL_MESH_PS_LEVEL)) != 0;

bool means you don't need the !=0 and parentheses.


> @@ -1208,6 +1214,7 @@ struct ieee802_11_elems {
>  	struct ieee80211_meshconf_ie *mesh_config;
>  	u8 *mesh_id;
>  	u8 *peering;
> +	u8 *awake_window;

maybe that should be an __le16 pointer?

> +			/* we need some delay here, otherwise the announcement
> +			 * Null would arrive before the CONFIRM
> +			 */
> +			ieee80211_mps_set_sta_local_pm(sta, mshcfg->power_mode,
> +						       100);

???

How can a *delay* ever cause correctness? That doesn't seem right.

> +	/* announce peer-specific power mode transition
> +	 * see IEEE802.11-2012 13.14.3.2 and 13.14.3.3
> +	 */

I feel a bit bad about asking this, but mac80211 actually doesn't use
the "networking" style, all other comments have

 /*
  * announce ...
  * ...
  */

so please adjust yours as well.

I think I deleted this, but nonetheless:


> static void mpsp_trigger_send(struct sta_info *sta,
>                               bool rspi, bool eosp)

that easily fits on one line.


> +/**
> + * mps_frame_deliver - transmit frames during mesh powersave
> + *
> + * @sta: STA info to transmit to
> + * @n_frames: number of frames to transmit. -1 for all
> + */
> +static void mps_frame_deliver(struct sta_info *sta, int n_frames)
> +{
> +	struct ieee80211_sub_if_data *sdata = sta->sdata;
> +	struct ieee80211_local *local = sdata->local;
> +	int ac;
> +	struct sk_buff_head frames;
> +	struct sk_buff *skb;
> +	bool more_data = false;
> +
> +	skb_queue_head_init(&frames);

You really don't need a spinlock for on-stack queues, so you should use
the __ versions of the functions modifying "frames".

> +			if (!skb)
> +				break;
> +			n_frames--;

I guess you're assuming there never will be > 2^31 frames ;-)

> +			skb_queue_tail(&frames, skb);

__skb_queue_tail(), etc.

> +		}
> +
> +		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
> +		    !skb_queue_empty(&sta->ps_tx_buf[ac])) {
> +			more_data = true;
> +		}

No need for the braces

> +	/* in a MPSP make sure the last skb is a QoS Data frame */
> +	if (test_sta_flag(sta, WLAN_STA_MPSP_OWNER))
> +		mpsp_qos_null_append(sta, &frames);



> +	mps_dbg(sta->sdata, "sending %d frames to PS STA %pM\n",
> +		skb_queue_len(&frames), sta->sta.addr);
> +
> +	/* prepare collected frames for transmission */
> +	skb_queue_walk(&frames, skb) {
> +		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +		struct ieee80211_hdr *hdr = (void *) skb->data;
> +
> +		/* Tell TX path to send this frame even though the
> +		 * STA may still remain is PS mode after this frame
> +		 * exchange.
> +		 */
> +		info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;

I'm not convinced that the PS integration with drivers here is correct
at all, but I don't really care all that much either.


> + * @WLAN_STA_MPSP_OWNER: local STA is owner of a mesh Peer Service Period.
> + * @WLAN_STA_MPSP_RECIPIENT: local STA is recipient of a MPSP.
> + * @WLAN_STA_MPS_WAIT_FOR_BEACON: STA beacon is imminent -> stay awake
> + * @WLAN_STA_MPS_WAIT_FOR_CAB: STA multicast frames are imminent -> stay awake

??

There's also a compiler warning -- variable shadowing -- that this
probably solves:

@@ -487,8 +487,6 @@ static void mps_frame_deliver(struct sta_info *sta,
int n_frames)
 
        /* collect frame(s) from buffers */
        for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-               struct sk_buff *skb;
-
                while (n_frames != 0) {
                        skb = skb_dequeue(&sta->tx_filtered[ac]);
                        if (!skb) {


johannes

