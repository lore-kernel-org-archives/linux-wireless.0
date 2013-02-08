Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946749Ab3BHRRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 12:17:38 -0500
Message-ID: <1360343852.29851.26.camel@jlt4.sipsolutions.net> (sfid-20130208_182336_214168_5B8A14BF)
Subject: Re: [PATCH v3 1/2] mac80211: Fix tx queue handling during scans
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Fri, 08 Feb 2013 18:17:32 +0100
In-Reply-To: <20130208171155.GC2622@thinkpad-t410>
References: <1360189829.7910.84.camel@jlt4.sipsolutions.net>
	 <1360259677-19278-1-git-send-email-seth.forshee@canonical.com>
	 <1360314212.29851.4.camel@jlt4.sipsolutions.net>
	 <20130208171155.GC2622@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 11:11 -0600, Seth Forshee wrote:

> > I started wondering -- is there a reason to modify the entire TX path?
> > Could we maybe bypass it instead and call the driver's TX op almost
> > directly? The frames in question don't really need much TX handling, the
> > only thing that might be relevant _could_ be rate control but even that
> > I'd argue isn't really needed, just using rate_control_send_low() should
> > be ok (by setting IEEE80211_TX_CTL_USE_MINRATE it will always return
> > true). For the null data packets the sta pointer is also obvious, the AP
> > station (BSSID) ... we don't need any of the extra monitor/whatever
> > handling either.
> > 
> > That might be simpler overall?
> 
> Okay, I'll take a look at this.
> 
> Another option that might simplify things a bit  would be to use a
> ieee80211_tx_data flag. If I added another interface into tx.c for
> offchannel frames then the offchan argument would only be needed for
> ieee80211_xmit() and ieee80211_tx(). Though it would be nice to avoid
> adding an argument to ieee80211_xmit().

Oh, I forgot all about ROC and off-channel frames there, but those are
public action frames (only?) so the same applies with min-rate etc.

Overall I'm not sure. On the one hand that might make the code changes
simpler, on the other it might make the code more complex?

johannes

