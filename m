Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:51767 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab0ETWGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 18:06:10 -0400
Received: by pxi18 with SMTP id 18so137349pxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 15:06:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilk0CIkmmIsBzPwchd6EBIVavw9R1amiSgCZOrx@mail.gmail.com>
References: <20100519012528.22206.77550.stgit@tt-desk> <201005201121.49846.br1@einfach.org>
	<AANLkTilG3c2UDEQa66PMvKysRVTt_dd-ZAS8FiDOe4Ob@mail.gmail.com>
	<201005201436.11667.br1@einfach.org> <AANLkTilk0CIkmmIsBzPwchd6EBIVavw9R1amiSgCZOrx@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 20 May 2010 15:05:48 -0700
Message-ID: <AANLkTinPVSkrawZ4OCjp6vb-f4bA7nSrmnXjRDi-Pvvm@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
	configuration
To: Bruno Randolf <br1@einfach.org>,
	David Quan <David.Quan@atheros.com>,
	Sam Ng <Sam.Ng@atheros.com>
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 19, 2010 at 11:43 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, May 19, 2010 at 10:36 PM, Bruno Randolf <br1@einfach.org> wrote:
>> On Thursday 20 May 2010 14:17:19 you wrote:
>>> None of the legacy 802.11 drivers we support have more than 2
>>> antennas, I am also not aware of any.
>>
>> i have heard of some solutions based on atheros chipsets with more than 2
>> antennas ("pre-11n RangeMax", "large phased array switch"). please check
>> internally.
>
> I will. David, are you aware of legacy (non 802.11n) devices with more
> than 2 antennas?

I picked David's brain and we're pretty certain these devices do not
exist in the market.

>>> You're right, then if you really don't mind lets think 802.11n through
>>> well then.
>>
>> i don't mind to do that, but as i said i dont know much about 802.11n yet.
>
> Thanks, give me some time to think about this then and get back to you.

OK so back to the drawing board, this is what I recommend:

For legacy, keep it simple, use 3 settings, fixed_a, fixed_b,
diversity, for all devices.

Lets use a different API for 802.11n. Reason being that even the case
I mentioned of an 802.11n device connecting on a legacy network needs
to be treated differently actually.

For 802.11n you have a few more considerations. You can actually TX at
the same time on two or more different antennas at the same time. The
data you transmit will be the contents on both chains on a dual stream
device. So both antenna 0 and antenna 1 will both be transmitting the
data for both stream 0 and stream 1. As it turns out the combination
of TX'ing on two antennas at the same time at a certain dBm power will
yield a higher received frame on the RX side. This is why when you use
multiple chains you have to take regulatory rules into considerations
as well, since adding more chains will increase the overall output
power. Today ath9k handles this itself since this data is calibrated
but the max EIRP is passed out from cfg80211. Devices which do not
deal with these regulatory considerations likely won't support
changing chainmasks unless they use an API to respect regulatory
internally somehow. Perhaps the iwlagn firmware does this, beats me.

The right terminology for antenna control for both TX and RX is
chainmask and a bitmap of 8 will suffice for existing hardware and up
to the not-yet-existant 600mbps 4 stream devices. Supporting 8 bits
will support up to 8 streams and we do not envision using beyond that
at this point. There is some considerations in the future for
supporting something other than HT40, like maybe HT80 and so forth but
those things won't be using more streams it seems.

Then, some devices won't support all possible chainmask settings. This
will vary depending on the chipset. I work for Atheros so I can only
tell you what we can support, we'll have to check with the Intel folks
about their chipset limitations and settings.

AR5416, AR5418 can only support chainmask settings which always keep
the first chain on. The AR9001 family and beyond cannot support the
0b110 chaimask (David, you had pointed out some other restrictions,
what were they again?), the details are complex and I did not get a
chance to review them.

I would not be surprised if other vendors had similar restrictions so
I'm thinking maybe we can express this as a requirement mask, or a set
of requirement masks. This way userspace utilities for debugging would
only expose certain chainmask settings.

Now technically then you can incorporate the legacy API with the
802.11n API here somehow but it just seems cleaner to keep them
separate.

Also, David indicated that when we change the chainmask when are are
associated we have to do an actual chip reset, this is different than
the antenna diversity settings which an be done on the fly. We likely
will need to reassociate for a chainmask setting, not sure.

  Luis
