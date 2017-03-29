Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45316 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755543AbdC2LtN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 07:49:13 -0400
Message-ID: <1490788146.7948.19.camel@sipsolutions.net> (sfid-20170329_135101_011909_069F8A0C)
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
From: Johannes Berg <johannes@sipsolutions.net>
To: Dennis New <dennisn@dennisn.mooo.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 13:49:06 +0200
In-Reply-To: <20170329062808.032e71a5327f3405f82df4b2@dennisn.mooo.com> (sfid-20170329_122846_570548_1B99027C)
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
         <1490772890.18052.8.camel@sipsolutions.net>
         <20170329062808.032e71a5327f3405f82df4b2@dennisn.mooo.com>
         (sfid-20170329_122846_570548_1B99027C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-03-29 at 06:28 -0400, Dennis New wrote:
> On Wed, 29 Mar 2017 09:34:50 +0200, Johannes Berg wrote:
> > On Fri, 2017-03-24 at 21:32 -0400, Dennis New wrote:
> > > Ever since I upgraded to the 4.10 kernels (I don't think this
> > > behavior existed in the 4.8 series), after I startup my laptop
> > > (either from cold boot, or from standby), my wlan0 interface
> > > keeps
> > > deauthenticating
> > > ...
> > > 19:23:29 kernel: wlan0: authenticate with 00:11:22:33:44:55
> > > 19:23:29 kernel: ------------[ cut here ]------------
> > > 19:23:29 kernel: WARNING: CPU: 0 PID: 18925 at
> > > net/mac80211/mlme.c:287 ieee80211_determine_chantype+0x12e/0x380
> > 
> > This is already indicating a severe problem. I don't know how you
> > end
> > up in this situation with b43, since that doesn't have any
> > regulatory
> > magic afaict.
> > 
> > > 19:23:29 kernel: wlan0: associated
> > > 
> > > 19:24:29 kernel: wlan0: deauthenticating from 00:11:22:33:44:55
> > > by
> > > local choice (Reason: 3=DEAUTH_LEAVING)
> > 
> > I'm convinced that this comes from reg_check_channels().
> > 
> > The above WARN_ON() already told you that the channel was
> > considered
> > invalid.
> > 
> > Do you know what channel your AP is on?
> 
> 6
> 
> > Perhaps show the output of "iw wlan0 scan dump" while it's
> 
> connected (you have 60 seconds :P)
> 
> I have been having stable connections for the past few days,
> simply by putting a 60 second sleep before starting my wlan0.
> Although
> if I /etc/init.d/net.wlan0 restart it (without the delay), it will
> still do this deauth'ing.

Very strange.

> 	* 2437 MHz [6] 
> 	  Maximum TX power: 20.0 dBm
> 	  Channel widths:

That's quite odd, why isn't it listing any possible channel widths?!

I get:
	* 2437 MHz [6] 
	  Maximum TX power: 15.0 dBm
	  Channel widths: 20MHz HT40- HT40+

What's "iw reg get"?

johannes
