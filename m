Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44131 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0LNDMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 22:12:13 -0500
Received: by iyi12 with SMTP id 12so89115iyi.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 19:12:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012141131.59086.br1@einfach.org>
References: <20101214022018.2343.8216.stgit@localhost6.localdomain6>
 <AANLkTinS35SU=RZ+G=b6Q1729Zpfm5cfqjTNOCr6zSe4@mail.gmail.com> <201012141131.59086.br1@einfach.org>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 13 Dec 2010 19:11:52 -0800
Message-ID: <AANLkTi=6o=tK1fRhOtchT9UPy+EWCcqzhebVYv+8XJP3@mail.gmail.com>
Subject: Re: [PATCH 1/2] nl80211: Export available antennas
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several of the Intel ones, I believe.  For instance 4965 can RX with 3
antennas but can maybe only TX with A and B?  Intel also has a 1x2
(5100 maybe?) chipset.

Dan

On Mon, Dec 13, 2010 at 6:31 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Tue December 14 2010 11:23:09 Daniel Halperin wrote:
>> > diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
>> > index b8fa25d..63b603c 100644
>> > --- a/include/linux/nl80211.h
>> > +++ b/include/linux/nl80211.h
>> > @@ -841,6 +841,9 @@ enum nl80211_commands {
>> >  *     the hardware should not be configured to receive on this antenna.
>> >  *     For a more detailed descripton see @NL80211_ATTR_WIPHY_ANTENNA_TX.
>> >  *
>> > + * @NL80211_ATTR_WIPHY_ANTENNA_AVAIL: Bitmap of antennas which are
>> > available for + *     configuration via the above parameters.
>> > + *
>>
>> Not clear exactly what the point of this is -- there's no commit
>> message -- but should not this API distinguish between TX and RX?
>> E.g., several chipsets can only TX from a subset of RX antennas.
>
> This is just the nl80211 part of a patch that got merged earlier, the
> description of which has more info:
>
> https://patchwork.kernel.org/patch/389682/
>
> If it's necessary to distinguish between RX and TX it has to be done there
> too. Can you give us examples of these chipsets which you mentioned?
>
> bruno
>
