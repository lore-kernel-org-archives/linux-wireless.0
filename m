Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:32081 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753703Ab0G1CF6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 22:05:58 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0699212756
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 11:05:57 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
Date: Wed, 28 Jul 2010 11:06:06 +0900
Cc: Felix Fietkau <nbd@openwrt.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100727094732.27186.30900.stgit@tt-desk> <4C4F0BB1.6030002@openwrt.org> <AANLkTi=QWMwVTqOqL3wNUnLAWHDw60HmYXtngXJrQOu+@mail.gmail.com>
In-Reply-To: <AANLkTi=QWMwVTqOqL3wNUnLAWHDw60HmYXtngXJrQOu+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007281106.06813.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed July 28 2010 01:47:34 Luis R. Rodriguez wrote:
> On Tue, Jul 27, 2010 at 9:39 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> > On 2010-07-27 6:19 PM, Luis R. Rodriguez wrote:
> >>> + * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for
> >>> transmitting. + *     Each bit represents one antenna, starting with
> >>> antenna 1 at the first + *     bit. If the bitmap is zero (0), the TX
> >>> antenna follows RX diversity.
> >> 
> >> What about for 802.11n? What if you want to disable TX?
> > 
> > Disabling tx shouldn't be handled by the antenna setting, IMHO.
> > 
> >>> + *     If multiple antennas are selected all selected antennas have to
> >>> be used + *     for transmitting (801.11n multiple TX chains).
> >> 
> >> I rather call this TX / RX chainmask then.
> > 
> > Well, for legacy hardware, these aren't really chains, as there is only
> > one rx and one tx path, just with switching onto multiple antennas.
> > 
> >>> + *     Drivers may reject configurations they cannot support.
> >>> + *
> >>> + * @NL80211_ATTR_WIPHY_ANTENNA_RX: Bitmap of allowed antennas for
> >>> receiving. + *     Each bit represents one antenna, starting with
> >>> antenna 1 at the first + *     bit. If multiple antennas are selected
> >>> in the bitmap, 802.11n devices + *     should use multiple RX chains
> >>> on these antennas, while non-802.11n + *     drivers should use
> >>> antenna diversity between these antennas.
> >> 
> >> What about TX beamforming, and STBC?
> > 
> > Disabling one antenna/chain on a two-chain device would naturally
> > disable TxBF and STBC as well, since it limits the number of available
> > chains. The driver should simply act as if the disabled chains didn't
> > exist.
> 
> That would work.
> 
> >> Unless 802.11n is completely dealt with I really prefer this patch to
> >> only address legacy. Otherwise I see sloppyness and inconsistencies on
> >> supporting this feature throughout different drivers. I'd like to
> >> avoid that at all costs on nl80211. What you are trying to address is
> >> legacy antenna setup, not 802.11n RX/TX chainmask dynamic settings so
> >> I'd really try to avoid it unless you really want to address all
> >> aspects of chain configuration for 802.11n and even then what I'm
> >> leading on to say is I think you'll see if you try to address both it
> >> just gets messy.
> > 
> > I think 802.11n is already completely dealt with if you treat this as
> > the chainmask on 11n devices.
> 
> Its fine by me if the above cases are also embedded into the
> documentation, just don't want these questions lingering. I can't
> think of other 802.11n special cases.

thanks felix :)

luis, could you tell me what exactly you would want to include in the 
documentation?

bruno
