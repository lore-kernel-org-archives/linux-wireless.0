Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58497 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab2BWPON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 10:14:13 -0500
Received: by iacb35 with SMTP id b35so1661047iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 07:14:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330009145.3448.13.camel@jlt3.sipsolutions.net>
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
	<20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
	<1330004364.3448.8.camel@jlt3.sipsolutions.net>
	<CA+yqC4bcLz5xBTqOV_C4cjm4MDwEaifbJNi9dCSh7CTbjPiXBg@mail.gmail.com>
	<1330009145.3448.13.camel@jlt3.sipsolutions.net>
Date: Thu, 23 Feb 2012 07:14:13 -0800
Message-ID: <CAMcMvshr_1gx0y55ne5wia03OaSASZAh1vvJyeY02v1yTwU4aQ@mail.gmail.com> (sfid-20120223_161419_874833_564D24DA)
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sam Leffler <sleffler@google.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 23, 2012 at 6:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Thu, 2012-02-23 at 06:53 -0800, Sam Leffler wrote:
> > On Thu, Feb 23, 2012 at 5:39 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > On Mon, 2012-02-20 at 21:25 -0800, Paul Stewart wrote:
> > >> When regulatory information changes our HT behavior (e.g,
> > >> when we get a country code from the AP we have just associated
> > >> with), we should use this information to change the power with
> > >> which we transmit, and what channels we transmit.  Sometimes
> > >> the channel parameters we derive from regulatory information
> > >> contradicts the parameters we used in association.  For example,
> > >> we could have associated specifying HT40, but the regulatory
> > >> rules we apply may forbid HT40 operation.
> > >>
> > >> In the situation above, we should reconfigure ourselves to
> > >> transmit in HT20 only, however it makes no sense for us to
> > >> disable receive in HT40, since if we associated with these
> > >> parameters, the AP has every reason to expect we can and
> > >> will receive packets this way.  The code in mac80211 does
> > >> not have the capability of sending the appropriate action
> > >> frames to signal a change in HT behaviour so the AP has
> > >> no clue we can no longer receive frames encoded this way.
> > >> In some broken AP implementations, this can leave us
> > >> effectively deaf if the AP never retries in lower HT rates.
> > >>
> > >> This change breaks up the channel_type parameter in the
> > >> ieee80211_enable_ht function into a separate receive and
> > >> transmit part.  It honors the channel flags set by regulatory
> > >> in order to configure the rate control algorithm, but uses
> > >> the capability flags to configure the channel on the radio,
> > >> since these were used in association to set the AP's transmit
> > >> rate.
> > >
> > > Quite the stupid APs, obviously ...
> >
> > Actually the AP is operating correctly (modulo the question of whether
> > HT40 may be used in kr).
>
> Ah, yes. I was thinking the AP was actually saying you can't use 40 MHz,
> but it's obviously just saying that you're in KR and our database says
> you then can't use 40 Mhz...

More succinctly, Sam is posing the possibility that a STA we should
ignore regulatory on TX as well as RX in this situation, since the AP
clearly negotiated HT40 with us.  This patch does not do this.  If we
are allowed to do that, what if we imposed that regulatory domain
beforehand (ala iw reg set) then associated?  In this scenario we
would have negotiated HT20.  If we then received a beacon where the AP
claimed it supported HT40, should we now allow transmit in HT40
(without having said so to the AP)?  The current version of this patch
prevents that behavior.

>
> johannes
>
