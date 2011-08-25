Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1HYFIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 01:08:05 -0400
Subject: Re: [PATCH 2/9] mac80211: Limit amount of HWMP frames and
 forwarded data packets in queues on mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Pedro Larbig <pedro.larbig@carhs.de>, linville@tuxdriver.com
In-Reply-To: <1314236452-7226-3-git-send-email-thomas@cozybit.com> (sfid-20110825_034140_614123_A977E37D)
References: <1314236452-7226-1-git-send-email-thomas@cozybit.com>
	 <1314236452-7226-3-git-send-email-thomas@cozybit.com>
	 (sfid-20110825_034140_614123_A977E37D)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 22:08:20 -0700
Message-ID: <1314248900.5054.45.camel@jlt3.sipsolutions.net> (sfid-20110825_070809_988754_80576F05)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-24 at 18:40 -0700, Thomas Pedersen wrote:
> From: Pedro Larbig <pedro.larbig@carhs.de>
> 
> To avoid contention problems in a mesh network's high load areas, this patch
> adds a 2-stage packet dropping mechanism:
> * If the transmit queue for HWMP frames is filled with 256 or more packets,
> additional HWMP frames will be dropped
> * If the transmit queue for forwarded packets is at 384 or more, drop those,
> too

> +	/* Frames going through ieee80211_tx_skb will be on the voice queue,
> +	 * Therefor we need to check only IEEE80211_AC_VO */
> +	if (unlikely(skb_queue_len(&local->pending[IEEE80211_AC_VO]) >=
> +	   MESH_MGMT_QUEUE_LEN)) {
> +		kfree_skb(skb);
> +		I802_DEBUG_INC(local->tx_handlers_drop_mesh_mgmt);
> +		return;
> +	}

I still don't think this should be done. If the HW queue is full, we
will get a stop_queue from the driver, this could also tell mesh to stop
forwarding or so.

johannes

