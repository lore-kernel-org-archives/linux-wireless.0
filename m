Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab2BWO7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 09:59:09 -0500
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@google.com>
Cc: Paul Stewart <pstew@chromium.org>, linux-wireless@vger.kernel.org
In-Reply-To: <CA+yqC4bcLz5xBTqOV_C4cjm4MDwEaifbJNi9dCSh7CTbjPiXBg@mail.gmail.com> (sfid-20120223_155421_196241_A5146573)
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
	 <20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
	 <1330004364.3448.8.camel@jlt3.sipsolutions.net>
	 <CA+yqC4bcLz5xBTqOV_C4cjm4MDwEaifbJNi9dCSh7CTbjPiXBg@mail.gmail.com>
	 (sfid-20120223_155421_196241_A5146573)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 15:59:05 +0100
Message-ID: <1330009145.3448.13.camel@jlt3.sipsolutions.net> (sfid-20120223_155913_244681_39FC9E77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 06:53 -0800, Sam Leffler wrote:
> On Thu, Feb 23, 2012 at 5:39 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2012-02-20 at 21:25 -0800, Paul Stewart wrote:
> >> When regulatory information changes our HT behavior (e.g,
> >> when we get a country code from the AP we have just associated
> >> with), we should use this information to change the power with
> >> which we transmit, and what channels we transmit.  Sometimes
> >> the channel parameters we derive from regulatory information
> >> contradicts the parameters we used in association.  For example,
> >> we could have associated specifying HT40, but the regulatory
> >> rules we apply may forbid HT40 operation.
> >>
> >> In the situation above, we should reconfigure ourselves to
> >> transmit in HT20 only, however it makes no sense for us to
> >> disable receive in HT40, since if we associated with these
> >> parameters, the AP has every reason to expect we can and
> >> will receive packets this way.  The code in mac80211 does
> >> not have the capability of sending the appropriate action
> >> frames to signal a change in HT behaviour so the AP has
> >> no clue we can no longer receive frames encoded this way.
> >> In some broken AP implementations, this can leave us
> >> effectively deaf if the AP never retries in lower HT rates.
> >>
> >> This change breaks up the channel_type parameter in the
> >> ieee80211_enable_ht function into a separate receive and
> >> transmit part.  It honors the channel flags set by regulatory
> >> in order to configure the rate control algorithm, but uses
> >> the capability flags to configure the channel on the radio,
> >> since these were used in association to set the AP's transmit
> >> rate.
> >
> > Quite the stupid APs, obviously ...
> 
> Actually the AP is operating correctly (modulo the question of whether
> HT40 may be used in kr).

Ah, yes. I was thinking the AP was actually saying you can't use 40 MHz,
but it's obviously just saying that you're in KR and our database says
you then can't use 40 Mhz...

johannes

