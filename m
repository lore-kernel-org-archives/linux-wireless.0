Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34505 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2CGFqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 00:46:49 -0500
Received: by iagz16 with SMTP id z16so8139545iag.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2012 21:46:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120227134610.GA5070@w1.fi>
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
	<20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
	<1330254954.4401.9.camel@jlt3.sipsolutions.net>
	<1330255537.4401.10.camel@jlt3.sipsolutions.net>
	<1330338898.3483.10.camel@jlt3.sipsolutions.net>
	<20120227113212.GA4576@w1.fi>
	<1330342730.3483.34.camel@jlt3.sipsolutions.net>
	<20120227134610.GA5070@w1.fi>
Date: Tue, 6 Mar 2012 21:46:48 -0800
Message-ID: <CAMcMvshUH5faQ7xZTkXgWE=v-WMShBa9dOPZ=nu3hYiGJvoeFA@mail.gmail.com> (sfid-20120307_064656_816543_A8CAE08B)
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
From: Paul Stewart <pstew@chromium.org>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Arik Nemtsov <anamtsov@gmail.com>,
	Eliad Peller <eliad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 5:46 AM, Jouni Malinen <j@w1.fi> wrote:
> On Mon, Feb 27, 2012 at 12:38:50PM +0100, Johannes Berg wrote:
>> On Mon, 2012-02-27 at 13:32 +0200, Jouni Malinen wrote:
>> > However, there
>> > could be some hardware/firmware designs that would refuse HT+TKIP at
>> > lower layer, so skipping the channel (re-)configuration could
>> > potentially cause some problems.
>
>> That's a good point, but I don't really think is likely to exist. I can
>> see this in a full-MAC scenario, but there you get all the relevant
>> parameters in the nl80211 connect() call so can do the right choices
>> earlier than mac80211 can with auth/assoc calls.
>
> Even full MAC designs may end up moving towards auth/assoc calls for
> things like IEEE 802.11r.. (And maybe even more so with 802.11ai
> eventually.)
>
>> Of course, if this we actually happen to come across a device that needs
>> this it could set a flag somehwere and mac80211 could re-configure the
>> channel to non-HT on the assoc request, but right now I'd rather not
>> worry about that since we're moving towards multi-channel and have no
>> indication of such devices existing. Agree?
>
> Yeah, that works for me.

Discussions seem to have come to an end here, however I'm not sure
what we ended up deciding. :-)  I see mention of HT+TKIP -- not sure
I'm familiar enough with what the issues are there -- as well as
pushing the channel configuration earlier and perhaps changes to the
association process.  Since I may not have a complete handle on all
these adjacent issues, where do we want to go with the current change
(fixes a real-life issue) and how do we want to stage that with
respect to the other issues this seems to have brought to the surface?

--
Paul
