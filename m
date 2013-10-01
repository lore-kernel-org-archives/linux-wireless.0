Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3JALWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:22:04 -0400
Message-ID: <1380626514.14430.25.camel@jlt4.sipsolutions.net> (sfid-20131001_132208_212857_4435C8E2)
Subject: Re: [PATCH 1/5] mac80211: process the CSA frame for mesh accordingly
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Tue, 01 Oct 2013 13:21:54 +0200
In-Reply-To: <1379115372-28426-2-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130914_013631_722279_4FCA5354)
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1379115372-28426-2-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20130914_013631_722279_4FCA5354)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-09-13 at 16:36 -0700, Chun-Yeow Yeoh wrote:

> +	skb = dev_alloc_skb(local->tx_headroom + len);
> +	if (!skb)
> +		return -1;

-ENOMEM ?

> +	skb_reserve(skb, local->tx_headroom);
> +	mgmt_fwd = (struct ieee80211_mgmt *) skb_put(skb, len);
> +
> +	/* offset_ttl is based on whether the secondary channel
> +	 * offset is available or not. Substract 1 from the mesh TTL
> +	 * and disable the initiator flag before forwarding.
> +	 */
> +	offset_ttl = (len < 42) ? 7 : 10;
> +	*(pos + offset_ttl) -= 1;
> +	*(pos + offset_ttl + 1) &= ~WLAN_EID_CHAN_SWITCH_PARAM_INITIATOR;

That's somewhat ugly, is there no better way to express that? Maybe with
different structs or something? I guess I can live with it, just asking
though.


> +	/* forward or re-broadcast the CSA frame */
> +	if (fwd_csa) {
> +		if (mesh_fwd_csa_frame(sdata, mgmt, len) < 0)
> +			mcsa_dbg(sdata, "Failed to forward the CSA frame");
> +	}
> +
> +	/* block the Tx only after fowarding the CSA frame if required */

typo: forwarding

> +	block_tx = !!(elems.mesh_chansw_params_ie->mesh_flags
> +		      & WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT);

No need for !! with bool variables

johannes

