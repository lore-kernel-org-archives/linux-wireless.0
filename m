Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946702Ab3BHSKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 13:10:05 -0500
Date: Fri, 8 Feb 2013 12:10:02 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v3 1/2] mac80211: Fix tx queue handling during scans
Message-ID: <20130208181002.GD2622@thinkpad-t410> (sfid-20130208_191012_225445_06535202)
References: <1360189829.7910.84.camel@jlt4.sipsolutions.net>
 <1360259677-19278-1-git-send-email-seth.forshee@canonical.com>
 <1360314212.29851.4.camel@jlt4.sipsolutions.net>
 <20130208171155.GC2622@thinkpad-t410>
 <1360343852.29851.26.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360343852.29851.26.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 08, 2013 at 06:17:32PM +0100, Johannes Berg wrote:
> On Fri, 2013-02-08 at 11:11 -0600, Seth Forshee wrote:
> 
> > > I started wondering -- is there a reason to modify the entire TX path?
> > > Could we maybe bypass it instead and call the driver's TX op almost
> > > directly? The frames in question don't really need much TX handling, the
> > > only thing that might be relevant _could_ be rate control but even that
> > > I'd argue isn't really needed, just using rate_control_send_low() should
> > > be ok (by setting IEEE80211_TX_CTL_USE_MINRATE it will always return
> > > true). For the null data packets the sta pointer is also obvious, the AP
> > > station (BSSID) ... we don't need any of the extra monitor/whatever
> > > handling either.
> > > 
> > > That might be simpler overall?
> > 
> > Okay, I'll take a look at this.
> > 
> > Another option that might simplify things a bit  would be to use a
> > ieee80211_tx_data flag. If I added another interface into tx.c for
> > offchannel frames then the offchan argument would only be needed for
> > ieee80211_xmit() and ieee80211_tx(). Though it would be nice to avoid
> > adding an argument to ieee80211_xmit().

This actually doesn't work out. ieee80211_tx_data doesn't propogate down
to ieee80211_tx_frags() and isn't even there in the txpending case. So
without more substantial changes it just turns back into an argument
after a couple of levels.

> Oh, I forgot all about ROC and off-channel frames there, but those are
> public action frames (only?) so the same applies with min-rate etc.

I thought of that and was going to check and see what kind of ROC frames
are sent. Also probe request frames are obviously sent off-channel, but
I'd guess the same applies to them as well?

> Overall I'm not sure. On the one hand that might make the code changes
> simpler, on the other it might make the code more complex?

Well, I think the way that will be simplest with the fewest code changes
would be to use a tx control flag. Of course then we've gobbled up one
of the last available flags.

Seth

