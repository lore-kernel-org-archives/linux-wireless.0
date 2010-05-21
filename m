Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54917 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab0EUU2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 16:28:38 -0400
Received: by pwi5 with SMTP id 5so608082pwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 May 2010 13:28:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BF6DAAE.6090903@openwrt.org>
References: <20100519012528.22206.77550.stgit@tt-desk> <AANLkTilk0CIkmmIsBzPwchd6EBIVavw9R1amiSgCZOrx@mail.gmail.com>
	<AANLkTinPVSkrawZ4OCjp6vb-f4bA7nSrmnXjRDi-Pvvm@mail.gmail.com>
	<201005211059.34081.br1@einfach.org> <20100521171102.GA27736@tux>
	<4BF6DAAE.6090903@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 21 May 2010 13:28:18 -0700
Message-ID: <AANLkTilLA1lz2qiredIcYyD1gGoxRUFGmL7T9m0buRwL@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
	configuration
To: Felix Fietkau <nbd@openwrt.org>
Cc: Bruno Randolf <br1@einfach.org>,
	David Quan <David.Quan@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Sam Ng <Sam.Ng@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 21, 2010 at 12:10 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-05-21 7:11 PM, Luis R. Rodriguez wrote:
>> On Thu, May 20, 2010 at 06:59:33PM -0700, Bruno Randolf wrote:
>>> so from my point of view this is not very different from what we can support
>>> with the API i suggested. for RX it seems to be 100% equivalent.
>>
>> Well I agree, the API *supports it* but I want *clean, clear and consistant
>> API*. And it just seems cleaner to separate the two.
>>
>>> the main difference as i see it is that with 802.11n you transmit on more than
>>> one antenna, while with 'legacy' we can only transmit on one antenna at a
>>> time.
>>
>> True, but note how the fact that you transmit over two antennas actually
>> has regulatory implications. Now, ath9k handles this within ath9k_hw already
>> but this itself seems like a worthy reason for this API to be separated.
>> While I think it is great for ath9k_hw to do this, wouldn't it be nice
>> if we can eventually instead expose the gain by using different chains
>> at the same time and do the regulatory calculation for all devices within
>> cfg80211?
>>
>>> actually i have to admit that on legacy "antenna set tx 3 (b11)" (select two
>>> antennas for transmit) does not make much sense. i have defined it before as
>>> "use diversity" but what about a different definition: like "bitmap of
>>> antennas/chains to TRANSMIT".
>>
>> Right, and while that *works*, I think it would be clearer to just use a
>> clear "diveristy" knob.
> Splitting it by mode of operation (11n vs legacy) does not work, because
> in AP mode you're doing both at the same time and there is an overlap in
> both settings.

Ah, hm, good point.

> I think that Bruno's suggestion of keeping them as one setting makes
> sense. About the regulatory concerns: where in the code does the
> chainmask currently affect the regulatory constraints?

I'm not sure, this was based on a quick review with David, I'll have
to review and poke at it but IIRC this was related to the chainmask
gains and I think we may get that from the EEPROM.

>>> so for 802.11n that would allow you to select  multiple trasmit chains.
>>
>> Instead of leaving the API to be interpreted by the mode of operation
>> I think it would be much cleaner to just make your desires clearer and
>> have the API define it well, and let the driver reject/accept it.
>>
>>> on legacy you are only allowed to select one antenna
>>> in the bitmap. if it is set to "0" (or a separate flag) this could enable
>>> "follow RX antenna diversity" on legacy.
>>
>> Sure that is one way, but it seems cleaner and easier for legacy purposes
>> to just define an API that only fits legacy.
>>
>>> most of the other things you mention (need a reset/reassociate, regulatory
>>> concerns...) are driver implementation issues, which can be dealt with in the
>>> driver.
>>
>> Well so some of these things *could* be handled in mac80211 as well. For
>> example, we may want to just dissociate upon a tx/rx chain setting change
>> for all devices, but not for legacy. The regulatory stuff is another thing
>> which could eventually be made more generic accross the board.
>>
>> Additionally, suppose you write an iw-tweak-gui thingy, and you want to
>> provide expose tx/rx chainmask settings. Since some cards do not support
>> some chainmask settings we may want to allow for a query of unsupported
>> chainmasks and that way the GUI application could just grey-out the
>> unsupported chainmask settings instead of letting the user figure out
>> by trial and error that they are indeed not supported.
> The API should just provide a bitmask of possible chains/antennas to
> user space, which will be used as a mask for any values that the user
> space sets. That's easy for a GUI utility to process

The bitmask of possible chains/antennas makes more sense, we could
just add it to the general phy info request, it would just be a matter
of piggy backing a new attribute back.

  Luis
