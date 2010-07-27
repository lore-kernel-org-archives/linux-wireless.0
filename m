Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48534 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab0G0QjT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 12:39:19 -0400
Message-ID: <4C4F0BB1.6030002@openwrt.org>
Date: Tue, 27 Jul 2010 18:39:13 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Bruno Randolf <br1@einfach.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
References: <20100727094732.27186.30900.stgit@tt-desk> <20100727094759.27186.79639.stgit@tt-desk> <AANLkTi=4BtktKxPmFnYwAHaf9Wg-VdLmupcOfXEr1Bpg@mail.gmail.com>
In-Reply-To: <AANLkTi=4BtktKxPmFnYwAHaf9Wg-VdLmupcOfXEr1Bpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-27 6:19 PM, Luis R. Rodriguez wrote:
>> + * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for transmitting.
>> + *     Each bit represents one antenna, starting with antenna 1 at the first
>> + *     bit. If the bitmap is zero (0), the TX antenna follows RX diversity.
> 
> What about for 802.11n? What if you want to disable TX?
Disabling tx shouldn't be handled by the antenna setting, IMHO.

>> + *     If multiple antennas are selected all selected antennas have to be used
>> + *     for transmitting (801.11n multiple TX chains).
> 
> I rather call this TX / RX chainmask then.
Well, for legacy hardware, these aren't really chains, as there is only
one rx and one tx path, just with switching onto multiple antennas.

>> + *     Drivers may reject configurations they cannot support.
>> + *
>> + * @NL80211_ATTR_WIPHY_ANTENNA_RX: Bitmap of allowed antennas for receiving.
>> + *     Each bit represents one antenna, starting with antenna 1 at the first
>> + *     bit. If multiple antennas are selected in the bitmap, 802.11n devices
>> + *     should use multiple RX chains on these antennas, while non-802.11n
>> + *     drivers should use antenna diversity between these antennas.
> 
> What about TX beamforming, and STBC?
Disabling one antenna/chain on a two-chain device would naturally
disable TxBF and STBC as well, since it limits the number of available
chains. The driver should simply act as if the disabled chains didn't exist.

> Unless 802.11n is completely dealt with I really prefer this patch to
> only address legacy. Otherwise I see sloppyness and inconsistencies on
> supporting this feature throughout different drivers. I'd like to
> avoid that at all costs on nl80211. What you are trying to address is
> legacy antenna setup, not 802.11n RX/TX chainmask dynamic settings so
> I'd really try to avoid it unless you really want to address all
> aspects of chain configuration for 802.11n and even then what I'm
> leading on to say is I think you'll see if you try to address both it
> just gets messy.
I think 802.11n is already completely dealt with if you treat this as
the chainmask on 11n devices.

- Felix
