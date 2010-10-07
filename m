Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:51037 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab0JGV7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 17:59:36 -0400
Date: Thu, 7 Oct 2010 23:59:33 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.36-rc7 warning in __cfg80211_auth_remove
Message-ID: <20101007215933.GA18210@sig21.net>
References: <20101007151844.GB3183@sig21.net>
 <1286482766.20974.39.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286482766.20974.39.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 07, 2010 at 10:19:26PM +0200, Johannes Berg wrote:
> On Thu, 2010-10-07 at 17:18 +0200, Johannes Stezenbach wrote:
> > 
> > just got the following while testing with rt73usb on
> > kernel 2.6.36-rc7 with wpa_supplicant v0.6.10:
> > 
> > wlan0: authentication with 00:22:b0:xx:xx:xx timed out
> > ------------[ cut here ]------------
> > WARNING: at net/wireless/mlme.c:284 __cfg80211_auth_remove+0xc3/0xd0 [cfg80211]()
> 
> >  [<ffffffffa002d980>] __cfg80211_auth_remove+0xc3/0xd0 [cfg80211]
> >  [<ffffffffa002e27c>] cfg80211_send_auth_timeout+0x93/0xaa [cfg80211]
> >  [<ffffffffa004c3eb>] ieee80211_probe_auth_done+0x2a/0x97 [mac80211]
> >  [<ffffffffa004e551>] ieee80211_work_work+0xecd/0xf3e [mac80211]
> 
> Oh *crap*. I thought we'd fixed these :-(
> 
> But then I really don't see how it might have happened. Was there
> anything in the log before this?

Nothing interesting.  I started and ^C'ed wpa_supplicant
a few times in quick succession for testing because of
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2010-October/002152.html


Johannes
