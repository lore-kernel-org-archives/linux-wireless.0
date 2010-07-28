Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45365 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab0G1Ruv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 13:50:51 -0400
Message-ID: <4C506DF7.9020907@openwrt.org>
Date: Wed, 28 Jul 2010 19:50:47 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Bruno Randolf <br1@einfach.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
References: <20100727094732.27186.30900.stgit@tt-desk> <4C4F0BB1.6030002@openwrt.org> 	<AANLkTi=QWMwVTqOqL3wNUnLAWHDw60HmYXtngXJrQOu+@mail.gmail.com> 	<201007281106.06813.br1@einfach.org> <AANLkTimBu2=9XhzKwUi1ZpRmGWA+C4GCDgXqp-YJVLxt@mail.gmail.com>
In-Reply-To: <AANLkTimBu2=9XhzKwUi1ZpRmGWA+C4GCDgXqp-YJVLxt@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-28 7:24 PM, Luis R. Rodriguez wrote:
> On Tue, Jul 27, 2010 at 7:06 PM, Bruno Randolf <br1@einfach.org> wrote:
>> On Wed July 28 2010 01:47:34 Luis R. Rodriguez wrote:
>>> On Tue, Jul 27, 2010 at 9:39 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> > On 2010-07-27 6:19 PM, Luis R. Rodriguez wrote:
>>> >>> + * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for
>>> >>> transmitting. + *     Each bit represents one antenna, starting with
>>> >>> antenna 1 at the first + *     bit. If the bitmap is zero (0), the TX
>>> >>> antenna follows RX diversity.
>>> >>
>>> >> What about for 802.11n? What if you want to disable TX?
>>> >
>>> > Disabling tx shouldn't be handled by the antenna setting, IMHO.
>>> >
>>> >>> + *     If multiple antennas are selected all selected antennas have to
>>> >>> be used + *     for transmitting (801.11n multiple TX chains).
>>> >>
>>> >> I rather call this TX / RX chainmask then.
>>> >
>>> > Well, for legacy hardware, these aren't really chains, as there is only
>>> > one rx and one tx path, just with switching onto multiple antennas.
>>> >
>>> >>> + *     Drivers may reject configurations they cannot support.
>>> >>> + *
>>> >>> + * @NL80211_ATTR_WIPHY_ANTENNA_RX: Bitmap of allowed antennas for
>>> >>> receiving. + *     Each bit represents one antenna, starting with
>>> >>> antenna 1 at the first + *     bit. If multiple antennas are selected
>>> >>> in the bitmap, 802.11n devices + *     should use multiple RX chains
>>> >>> on these antennas, while non-802.11n + *     drivers should use
>>> >>> antenna diversity between these antennas.
>>> >>
>>> >> What about TX beamforming, and STBC?
>>> >
>>> > Disabling one antenna/chain on a two-chain device would naturally
>>> > disable TxBF and STBC as well, since it limits the number of available
>>> > chains. The driver should simply act as if the disabled chains didn't
>>> > exist.
>>>
>>> That would work.
>>>
>>> >> Unless 802.11n is completely dealt with I really prefer this patch to
>>> >> only address legacy. Otherwise I see sloppyness and inconsistencies on
>>> >> supporting this feature throughout different drivers. I'd like to
>>> >> avoid that at all costs on nl80211. What you are trying to address is
>>> >> legacy antenna setup, not 802.11n RX/TX chainmask dynamic settings so
>>> >> I'd really try to avoid it unless you really want to address all
>>> >> aspects of chain configuration for 802.11n and even then what I'm
>>> >> leading on to say is I think you'll see if you try to address both it
>>> >> just gets messy.
>>> >
>>> > I think 802.11n is already completely dealt with if you treat this as
>>> > the chainmask on 11n devices.
>>>
>>> Its fine by me if the above cases are also embedded into the
>>> documentation, just don't want these questions lingering. I can't
>>> think of other 802.11n special cases.
>>
>> thanks felix :)
>>
>> luis, could you tell me what exactly you would want to include in the
>> documentation?
> 
> Sure, but after some though I'm sticking to my preference for an API
> for this, legacy and 802.11n chainmask / antenna selection should be
> dealt with separately.
As I pointed out in an earlier discussion, they *cannot* really be
treated separately if you're running in AP mode, dealing with both
legacy and 11n clients.

> Reason is I just reviewed the IEEE 802.11 sections 19.19 for TX
> beamforming but also happened to stumble upon section 19.20 Antenna
> selection. This Antenna Selection section indicates you can support
> more antennas than chains and you can use and that the antenna you use
> for your chains can vary over time. You select which antenna to use
> based on training/sounding tests on each antenna. Antenna selection as
> per 19.19 supports up to 8 antennas and up to 4 RF chains. Section
> 19.20.2 deals with how a STA can initiate antenna selection training
> with another STA. Now granted we don't have code for this and I don't
> think this is all done explicitly in hardware so one can argue we can
> deal with this when/if we do add support for this but this just
> highlights how different "antenna selection" or knobs to tune antennas
> is even from a standard perspective than legacy. For STBC and TX
> beamforming requirements I would like to see mac80211 actually have
> code which disables STBC and later TX beamforming (once we have code
> for it) if we enable only one chain, I don't see why drivers should
> deal with this.
This is easy to handle, it can work like this:
We treat the setting not as a raw chainmask, but actually as an antenna
mask. The chainmask gets calculated from that. If we disable all
antennas belonging to a particular chain, we disable the entire chain.
For AR9285 we will already deviate from treating this as a chainmask,
because it has one chain with rx diversity. Please accept this API, I'm
sure the API can be used to handle everything related to 802.11n
antenna/chain selection properly. :)

- Felix
