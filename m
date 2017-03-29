Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41888 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753716AbdC2Hqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 03:46:37 -0400
Message-ID: <1490773593.7948.2.camel@sipsolutions.net> (sfid-20170329_094652_185068_E33217C7)
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Dennis New <dennisn@dennisn.mooo.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 29 Mar 2017 09:46:33 +0200
In-Reply-To: <3320e9f4-21c3-966f-df6e-0bc8292a88a0@broadcom.com> (sfid-20170329_094331_322329_065559F5)
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
         <1490772890.18052.8.camel@sipsolutions.net>
         <3320e9f4-21c3-966f-df6e-0bc8292a88a0@broadcom.com>
         (sfid-20170329_094331_322329_065559F5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > 19:23:29 kernel: wlan0: authenticate with 00:11:22:33:44:55
> > > 19:23:29 kernel: ------------[ cut here ]------------
> > > 19:23:29 kernel: WARNING: CPU: 0 PID: 18925 at
> > > net/mac80211/mlme.c:287 ieee80211_determine_chantype+0x12e/0x380
> 
> 284	while (!cfg80211_chandef_usable(sdata->local->hw.wiphy,
> chandef,
> 285					tracking ? 0 :
> 286					   IEEE80211_CHAN_DISABLED
> )) {
> 287		if (WARN_ON(chandef->width ==
> NL80211_CHAN_WIDTH_20_NOHT)) {
> 288			ret = IEEE80211_STA_DISABLE_HT |
> 289			      IEEE80211_STA_DISABLE_VHT;
> 290			break;
> 291		}
> 
> > This is already indicating a severe problem. I don't know how you
> > end
> > up in this situation with b43, since that doesn't have any
> > regulatory
> > magic afaict.
> 
> The only way this WARN_ON can kick in is below so may be interesting
> to log the three variables checked in 'if' statement.

Yeah we should probably extend the WARN_ON() to a WARN() with that
information.

> Could it be a radar channel and it's waiting for CAC timeout or
> whatever the term is ;-) ?

No. Not even tongue-in-cheek :-)
This code was designed for regulatory changes, but the WARN_ON()
indicates that we got connected on a channel that we think isn't
actually usable. We quite possibly should reject that connection there,
but it seems to me it should've been rejected elsewhere already...?

johannes
