Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40896 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZDPBIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 21:08:44 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <Kalle.Valo@nokia.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1239841291.25334.18.camel@johannes.local>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239841291.25334.18.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 16 Apr 2009 03:08:36 +0200
Message-Id: <1239844116.11795.47.camel@violet> (sfid-20090416_030846_975400_60FBAE0B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > After a long debugging session with Reinette we finally tracked down
> > what is going on here. A full scan with this card takes 7-9 seconds and
> > that seems to be too long and trigger IEEE80211_MONITORING_INTERVAL
> > which then deauthenticates us with the AP (reason=6). 
> 
> Yeah, this is a bug. We analysed this problem a couple of days ago and I
> thought Kalle was going to fix it -- maybe he forgot. I forgot what
> exactly it was and how to fix it, hmm. Right now I'm confused and can't
> seem to reproduce my analysis. I thought it had something to do with
> using a different timer but we do seem to use the regular mgd.timer, so
> I'm not sure.
> 
> > Problem then is
> > that the attempt authenticate/associate with the AP fails with all the
> > time (reason=2). Bringing the interface down/up again doesn't help. It
> > seems that some internal mac80211 states are messed up. Some times the
> > whole process stalls completely and nothing happens anymore. Only
> > unloading and reloading the driver or rebooting helps.
> 
> Hmm. Reason 2 is "Previous authentication no longer valid" which would
> seem we get confused wrt. being authenticated or not (ie. we think we
> are, but are not). Jouni might know? Can you try wpa_supplicant from git
> with -Dnl80211?

as I wrote, that is exactly what I am using. Trying to get away from
this WEXT crap ;)

Regards

Marcel


