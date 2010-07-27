Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51344 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0G0QUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 12:20:10 -0400
Received: by pwi5 with SMTP id 5so520708pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 09:20:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100727094759.27186.79639.stgit@tt-desk>
References: <20100727094732.27186.30900.stgit@tt-desk> <20100727094759.27186.79639.stgit@tt-desk>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 27 Jul 2010 09:19:49 -0700
Message-ID: <AANLkTi=4BtktKxPmFnYwAHaf9Wg-VdLmupcOfXEr1Bpg@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] cfg80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 2:48 AM, Bruno Randolf <br1@einfach.org> wrote:
> Allow setting TX and RX antenna configuration via nl80211.
>
> The antenna configuration is defined as a bitmap of allowed antennas to use for
> either receiving or transmitting. Separate bitmaps are used for RX and TX to
> allow configuring different antennas for receiving and transmitting. The bitmap
> is 8 bit long, each bit representing one antenna, starting with antenna 1.
>
> If multiple receive (RX) antennas are selected, the driver may use diversity or
> multiple 802.11n RX chains, according to the chipset capabilities and
> configuration.
>
> If multiple transmit (TX) antennas are selected, the driver has to send on all
> selected antennas, making this mode of operation only possible on 802.11n
> chipsets with multiple TX chains. If the transmit antenna bitmap is set to the
> special value zero (0) the driver should select the TX antenna based on the
> antenna which was used for receiving (TX antenna follows RX diversity - this is
> the usual mode of 'diversity') for pre 802.11n devices.
>
> Using bitmaps has the benefit of allowing for a flexible configuration
> interface which can support many different configurations. Drivers should
> reject configurations they cannot support. While covering the standard modes
> "fixed antenna 1", "fixed antenna 2" and "diversity" this API also allows more
> rare - but useful - configurations as follows:
>
> 1) Send on antenna 1, receive on antenna 2 (or vice versa). This can be used to
> have a low gain antenna for TX in order to keep within the regulatory
> constraints and a high gain antenna for RX in order to receive weaker signals
> ("speak softly, but listen harder"). This can be useful for building long-shot
> outdoor links. Another usage of this setup is having a low-noise pre-amplifier
> on antenna 1 and a power amplifier on the other antenna. This way transmit
> noise is mostly kept out of the low noise receive channel.
> (This would be bitmaps: tx 1 rx 2).
>
> 2) Another similar setup is: Use RX diversity on both antennas, but always send
> on antenna 1. Again that would allow us to benefit from a higher gain RX
> antenna, while staying within the legal limits.
> (This would be: tx 0 rx 3).
>
> 3) And finally there can be special experimental setups in research and
> development where more than 2 antennas are available. It's good to keep the API
> flexible.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  include/linux/nl80211.h |   17 +++++++++++++++++
>  include/net/cfg80211.h  |    3 +++
>  net/wireless/nl80211.c  |   30 +++++++++++++++++++++++++++++-
>  3 files changed, 49 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 2c87016..b9de53c 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -731,6 +731,20 @@ enum nl80211_commands {
>  *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
>  *      for non-automatic settings.
>  *
> + * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for transmitting.
> + *     Each bit represents one antenna, starting with antenna 1 at the first
> + *     bit. If the bitmap is zero (0), the TX antenna follows RX diversity.

What about for 802.11n? What if you want to disable TX?

> + *     If multiple antennas are selected all selected antennas have to be used
> + *     for transmitting (801.11n multiple TX chains).

I rather call this TX / RX chainmask then.

> + *     Drivers may reject configurations they cannot support.
> + *
> + * @NL80211_ATTR_WIPHY_ANTENNA_RX: Bitmap of allowed antennas for receiving.
> + *     Each bit represents one antenna, starting with antenna 1 at the first
> + *     bit. If multiple antennas are selected in the bitmap, 802.11n devices
> + *     should use multiple RX chains on these antennas, while non-802.11n
> + *     drivers should use antenna diversity between these antennas.

What about TX beamforming, and STBC?

Unless 802.11n is completely dealt with I really prefer this patch to
only address legacy. Otherwise I see sloppyness and inconsistencies on
supporting this feature throughout different drivers. I'd like to
avoid that at all costs on nl80211. What you are trying to address is
legacy antenna setup, not 802.11n RX/TX chainmask dynamic settings so
I'd really try to avoid it unless you really want to address all
aspects of chain configuration for 802.11n and even then what I'm
leading on to say is I think you'll see if you try to address both it
just gets messy.

  Luis
