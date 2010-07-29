Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50741 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694Ab0G2PFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 11:05:09 -0400
Received: by gyg10 with SMTP id 10so160562gyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jul 2010 08:05:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201007291812.28639.br1@einfach.org>
References: <20100729035820.5930.29864.stgit@tt-desk> <AANLkTika8nD5oEXt-nHx7BHzZzCK1i8VQ9b-ubmcMze+@mail.gmail.com>
	<201007291812.28639.br1@einfach.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 29 Jul 2010 08:04:49 -0700
Message-ID: <AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com>
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com, nbd@openwrt.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 29, 2010 at 2:12 AM, Bruno Randolf <br1@einfach.org> wrote:
> On Thu July 29 2010 15:12:29 you wrote:
>> On Wed, Jul 28, 2010 at 8:58 PM, Bruno Randolf <br1@einfach.org> wrote:
>> > diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
>> > index 2c87016..8a88921 100644
>> > --- a/include/linux/nl80211.h
>> > +++ b/include/linux/nl80211.h
>> > @@ -731,6 +731,28 @@ enum nl80211_commands {
>> >  *      This is used in association with
>> > @NL80211_ATTR_WIPHY_TX_POWER_SETTING *      for non-automatic settings.
>> >  *
>> > + * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for
>> > transmitting. + *     This can be used to mask out antennas which are
>> > not attached or should + *     not be used for transmitting. If an
>> > antenna is not selected in this + *     bitmap the hardware is not
>> > allowed to transmit on this antenna. + *
>> > + *     Each bit represents one antenna, starting with antenna 1 at the
>> > first + *     bit. Depending on which antennas are selected in the
>> > bitmap, 802.11n + *     drivers can derive which chainmasks to use (if
>> > all antennas belonging to + *     a particular chain are disabled this
>> > chain should be disabled) and if + *     a chain has diversity antennas
>> > wether diversity should be used or not. + *     HT capabilities (STBC,
>> > TX Beamforming, Antenna selection) can be + *     derived from the
>> > available chains after applying the antenna mask.
>>
>> I don't want to do any work myself on drivers for this, can we have
>> cfg80211/mac80211 do this for us?
>
> is this not a separate issue from defining the API? you could have it do this
> for you even now, with or without the antenna API, no?

It depends on the consumer and at what level we think the consumer
should be doing whatever checks or changes it should. For starters I
would expect at least a check for association within cfg80211 which
disallows hw config changes. Then, we would need to address changes on
the hw config, and caching the original values and determine whether
or not we want to differentiate them on userspace to make it clear to
the user that the hw config is just tweaked right now but the real
capability is different than the current setting.

> i think this should be dealt with seperately. for now let's just define an API
> for an antenna mask.

This needs to be dealt with in cfg80211 if we want to allow cfg80211
drivers to use this and can deal with sanity checks in cfg80211. If
mac80211 and other cfg80211 drivers will be the consumers then the
change would be in mac80211 but a separate patch would be required.

  Luis
