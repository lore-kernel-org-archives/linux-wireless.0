Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47176 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753565AbdCFNIo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 08:08:44 -0500
Message-ID: <1488803525.5761.8.camel@sipsolutions.net> (sfid-20170306_140851_468491_4E00689E)
Subject: Re: [RFC] mac80211_hwsim: report survey data for scanned channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Mar 2017 13:32:05 +0100
In-Reply-To: <20170304091036.GA5388@w1.fi>
References: <20170221103118.18441-1-johannes@sipsolutions.net>
         <20170304091036.GA5388@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-03-04 at 11:10 +0200, Jouni Malinen wrote:
> On Tue, Feb 21, 2017 at 11:31:18AM +0100, Johannes Berg wrote:
> > Currently, hwsim is reporting survey data (only a fake noise floor)
> > for the current channel. This breaks when the multi-channel support
> > is enabled since then there's no current channel.
> > 
> > Make the dummy implementation closer to a real one and only report
> > data while scanning, for all the scanned channels. At other times,
> > no survey data might be available (in real hardware) due to power-
> > save for example.
> > Had this lying around - is it useful for anyone?
> 
> Yes, it seems to make the ap_acs hwsim test cases in hostap.git quite
> a
> bit more useful in hitting proper acs.c coverage in hostapd.. And
> also
> allow having to have hacks to force previous AP instance on the same
> band just to be able to hit any of this code.
> 
> > -	survey->filled = SURVEY_INFO_NOISE_DBM;
> > +	survey->filled = SURVEY_INFO_NOISE_DBM |
> > +			 SURVEY_INFO_CHANNEL_TIME |
> > +			 SURVEY_INFO_CHANNEL_TIME_BUSY;
> 
> This is pretty old, though.. :)  Had to remove the "CHANNEL_" part
> here..
> 
> > +	survey->channel_time =
> > +	survey->channel_time_busy = survey->channel_time/8;
> 
> .. and "channel_" in these to make this compile.

Right, yeah.

> Anyway, with those
> trivial changes, the hwsim test cases did start looking more
> interesting, so it would seem reasonable to get this applied.

Applied it now with the fixes.

johannes
