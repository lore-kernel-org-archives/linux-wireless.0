Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35647 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946671Ab3BHRMC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:12:02 -0500
Date: Fri, 8 Feb 2013 11:11:55 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v3 1/2] mac80211: Fix tx queue handling during scans
Message-ID: <20130208171155.GC2622@thinkpad-t410> (sfid-20130208_181347_134971_EC9696DA)
References: <1360189829.7910.84.camel@jlt4.sipsolutions.net>
 <1360259677-19278-1-git-send-email-seth.forshee@canonical.com>
 <1360314212.29851.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360314212.29851.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 08, 2013 at 10:03:32AM +0100, Johannes Berg wrote:
> On Thu, 2013-02-07 at 11:54 -0600, Seth Forshee wrote:
> > Scans currently work by stopping the netdev tx queues but leaving the
> > mac80211 queues active. This stops the flow of incoming packets while
> > still allowing mac80211 to transmit nullfunc and probe request frames to
> > facilitate scanning. However, the driver may try to wake the mac80211
> > queues while in this state, which will also wake the netdev queues.
> > 
> > To prevent this, add a new queue stop reason,
> > IEEE80211_QUEUE_STOP_REASON_OFFCHANNEL, to be used when stopping the tx
> > queues for off-channel operation. This prevents the netdev queues from
> > waking when a driver wakes the mac80211 queues.
> > 
> > This also stops all frames from being transmitted, even those required
> > for scanning. To get around this, add a new offchan_tx_ok argument to
> > most of the tx interfaces. This flag can be set for frames which need to
> > be transmitted during off-channel operation, allowing off-channel frames
> > to be passed down to the driver if the queues have only been stopped for
> > off-channel. Add ieee80211_tx_skb_offchannel() for transmitting
> > off-channel frames with this flag set.
> 
> I started wondering -- is there a reason to modify the entire TX path?
> Could we maybe bypass it instead and call the driver's TX op almost
> directly? The frames in question don't really need much TX handling, the
> only thing that might be relevant _could_ be rate control but even that
> I'd argue isn't really needed, just using rate_control_send_low() should
> be ok (by setting IEEE80211_TX_CTL_USE_MINRATE it will always return
> true). For the null data packets the sta pointer is also obvious, the AP
> station (BSSID) ... we don't need any of the extra monitor/whatever
> handling either.
> 
> That might be simpler overall?

Okay, I'll take a look at this.

Another option that might simplify things a bit  would be to use a
ieee80211_tx_data flag. If I added another interface into tx.c for
offchannel frames then the offchan argument would only be needed for
ieee80211_xmit() and ieee80211_tx(). Though it would be nice to avoid
adding an argument to ieee80211_xmit().

Seth

