Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58706 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946132Ab3BHJDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:03:37 -0500
Message-ID: <1360314212.29851.4.camel@jlt4.sipsolutions.net> (sfid-20130208_100343_330569_AE30FFC4)
Subject: Re: [PATCH v3 1/2] mac80211: Fix tx queue handling during scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 08 Feb 2013 10:03:32 +0100
In-Reply-To: <1360259677-19278-1-git-send-email-seth.forshee@canonical.com>
References: <1360189829.7910.84.camel@jlt4.sipsolutions.net>
	 <1360259677-19278-1-git-send-email-seth.forshee@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 11:54 -0600, Seth Forshee wrote:
> Scans currently work by stopping the netdev tx queues but leaving the
> mac80211 queues active. This stops the flow of incoming packets while
> still allowing mac80211 to transmit nullfunc and probe request frames to
> facilitate scanning. However, the driver may try to wake the mac80211
> queues while in this state, which will also wake the netdev queues.
> 
> To prevent this, add a new queue stop reason,
> IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL, to be used when stopping the tx
> queues for off-channel operation. This prevents the netdev queues from
> waking when a driver wakes the mac80211 queues.
> 
> This also stops all frames from being transmitted, even those required
> for scanning. To get around this, add a new offchan_tx_ok argument to
> most of the tx interfaces. This flag can be set for frames which need to
> be transmitted during off-channel operation, allowing off-channel frames
> to be passed down to the driver if the queues have only been stopped for
> off-channel. Add ieee80211_tx_skb_offchannel() for transmitting
> off-channel frames with this flag set.

I started wondering -- is there a reason to modify the entire TX path?
Could we maybe bypass it instead and call the driver's TX op almost
directly? The frames in question don't really need much TX handling, the
only thing that might be relevant _could_ be rate control but even that
I'd argue isn't really needed, just using rate_control_send_low() should
be ok (by setting IEEE80211_TX_CTL_USE_MINRATE it will always return
true). For the null data packets the sta pointer is also obvious, the AP
station (BSSID) ... we don't need any of the extra monitor/whatever
handling either.

That might be simpler overall?

johannes

