Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47463 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab3CVN4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 09:56:53 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr12so479705wgb.23
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2013 06:56:52 -0700 (PDT)
Date: Fri, 22 Mar 2013 14:53:42 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sam Leffler <sleffler@chromium.org>
Subject: Re: Radiotap injected rates
Message-ID: <20130322135342.GD29340@magnum.frso.rivierawaves.com> (sfid-20130322_145658_821916_9A672735)
References: <20130317215544.GA7031@gobelin>
 <1363634768.8260.16.camel@jlt4.sipsolutions.net>
 <20130318195406.GB17878@gobelin>
 <1363955094.8238.32.camel@jlt4.sipsolutions.net>
 <20130322132716.GB29340@magnum.frso.rivierawaves.com>
 <1363959125.8238.49.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363959125.8238.49.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 22, 2013 at 02:32:05PM +0100, Johannes Berg wrote:
> On Fri, 2013-03-22 at 14:27 +0100, Karl Beldan wrote:
> 
> > > > And, oops typo, I meant :
> > > > 
> > > > +	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[0] != -1))
> > > > 
> > > Well actually this won't work anyway because control.rates[] isn't
> > > initialized to -1.
> > > 
> > Of course we would set info->control.rates[0] to -1 by default in
> > ieee80211_parse_tx_radiotap and set it to something else if we parse a
> > IEEE80211_RADIOTAP_{RATE,MCS} (i.e what I was referring to in 1b).
> 
> That still wouldn't work though, there are other paths leading to point
> you're looking at. You'd have to set it always, which would probably
> work but is tricky to ensure at the right points.
> 
The only path I could see setting IEEE80211_TX_CTL_INJECTED seems
ieee80211_monitor_start_xmit, am I missing another one ?
 
Karl
