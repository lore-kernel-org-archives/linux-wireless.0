Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:41945 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab0EUTKr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 May 2010 15:10:47 -0400
Message-ID: <4BF6DAAE.6090903@openwrt.org>
Date: Fri, 21 May 2010 21:10:38 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Bruno Randolf <br1@einfach.org>,
	David Quan <David.Quan@Atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sam Ng <Sam.Ng@Atheros.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
 configuration
References: <20100519012528.22206.77550.stgit@tt-desk>	<AANLkTilk0CIkmmIsBzPwchd6EBIVavw9R1amiSgCZOrx@mail.gmail.com>	<AANLkTinPVSkrawZ4OCjp6vb-f4bA7nSrmnXjRDi-Pvvm@mail.gmail.com>	<201005211059.34081.br1@einfach.org> <20100521171102.GA27736@tux>
In-Reply-To: <20100521171102.GA27736@tux>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-05-21 7:11 PM, Luis R. Rodriguez wrote:
> On Thu, May 20, 2010 at 06:59:33PM -0700, Bruno Randolf wrote:
>> so from my point of view this is not very different from what we can support 
>> with the API i suggested. for RX it seems to be 100% equivalent.
> 
> Well I agree, the API *supports it* but I want *clean, clear and consistant
> API*. And it just seems cleaner to separate the two.
> 
>> the main difference as i see it is that with 802.11n you transmit on more than 
>> one antenna, while with 'legacy' we can only transmit on one antenna at a 
>> time.
> 
> True, but note how the fact that you transmit over two antennas actually
> has regulatory implications. Now, ath9k handles this within ath9k_hw already
> but this itself seems like a worthy reason for this API to be separated.
> While I think it is great for ath9k_hw to do this, wouldn't it be nice
> if we can eventually instead expose the gain by using different chains
> at the same time and do the regulatory calculation for all devices within
> cfg80211?
> 
>> actually i have to admit that on legacy "antenna set tx 3 (b11)" (select two 
>> antennas for transmit) does not make much sense. i have defined it before as 
>> "use diversity" but what about a different definition: like "bitmap of 
>> antennas/chains to TRANSMIT".
> 
> Right, and while that *works*, I think it would be clearer to just use a
> clear "diveristy" knob.
Splitting it by mode of operation (11n vs legacy) does not work, because
in AP mode you're doing both at the same time and there is an overlap in
both settings.
I think that Bruno's suggestion of keeping them as one setting makes
sense. About the regulatory concerns: where in the code does the
chainmask currently affect the regulatory constraints?

>> so for 802.11n that would allow you to select  multiple trasmit chains.
> 
> Instead of leaving the API to be interpreted by the mode of operation
> I think it would be much cleaner to just make your desires clearer and
> have the API define it well, and let the driver reject/accept it.
> 
>> on legacy you are only allowed to select one antenna 
>> in the bitmap. if it is set to "0" (or a separate flag) this could enable 
>> "follow RX antenna diversity" on legacy.
> 
> Sure that is one way, but it seems cleaner and easier for legacy purposes
> to just define an API that only fits legacy.
> 
>> most of the other things you mention (need a reset/reassociate, regulatory 
>> concerns...) are driver implementation issues, which can be dealt with in the 
>> driver.
> 
> Well so some of these things *could* be handled in mac80211 as well. For
> example, we may want to just dissociate upon a tx/rx chain setting change
> for all devices, but not for legacy. The regulatory stuff is another thing
> which could eventually be made more generic accross the board.
> 
> Additionally, suppose you write an iw-tweak-gui thingy, and you want to
> provide expose tx/rx chainmask settings. Since some cards do not support
> some chainmask settings we may want to allow for a query of unsupported
> chainmasks and that way the GUI application could just grey-out the
> unsupported chainmask settings instead of letting the user figure out
> by trial and error that they are indeed not supported.
The API should just provide a bitmask of possible chains/antennas to
user space, which will be used as a mask for any values that the user
space sets. That's easy for a GUI utility to process

- Felix
