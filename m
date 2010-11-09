Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45811 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab0KIVSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 16:18:14 -0500
Received: by gxk23 with SMTP id 23so4675092gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Nov 2010 13:18:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101105065311.8122.83439.stgit@localhost6.localdomain6>
References: <20101105064851.8122.57278.stgit@localhost6.localdomain6> <20101105065311.8122.83439.stgit@localhost6.localdomain6>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 9 Nov 2010 13:17:52 -0800
Message-ID: <AANLkTi=9X5ue3TD+7O=UnPUE54uv0fHdtMn99yf60iQq@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] cfg80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com, nbd@openwrt.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 11:53 PM, Bruno Randolf <br1@einfach.org> wrote:
> Allow setting of TX and RX antenna configuration via nl80211.
>
> The antenna configuration is defined as a bitmap of allowed antennas to use.
> This API can be used to mask out antennas which are not attached or should not
> be used for other reasons like regulatory concerns or special setups.
>
> Separate bitmaps are used for RX and TX to allow configuring different antennas
> for receiving and transmitting. The bitmap is 8 bit long, each bit representing
> one antenna, starting with antenna 1 at the first bit. If an antenna bit is
> set, this means the driver is allowed to use this antenna for RX or TX
> respectively; if the bit is not set the hardware is not allowed to use this
> antenna.
>
> Using bitmaps has the benefit of allowing for a flexible configuration
> interface which can support many different configurations and which can be used
> for 802.11n as well as non-802.11n devices. Instead of relying on some hardware
> specific assumptions, drivers can use this information to know which antennas
> are actually attached to the system and derive their capabilities based on
> that.
>
> 802.11n devices should enable or disable chains, based on which antennas are
> present (If all antennas belonging to a particular chain are disabled, the
> entire chain should be disabled). HT capabilities (like STBC, TX Beamforming,
> Antenna selection) should be calculated based on the available chains after
> applying the antenna masks. Should a 802.11n device have diversity antennas
> attached to one of their chains, diversity can be enabled or disabled based on
> the antenna information.
>
> Non-802.11n drivers can use the antenna masks to enable or disable antenna
> diversity.
>
> While covering chainmasks for 802.11n and the standard "legacy" modes "fixed
> antenna 1", "fixed antenna 2" and "diversity" this API also allows more rare,
> but useful configurations as follows:
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
> development even with pre 802.11n hardware where more than 2 antennas are
> available. It's good to keep the API simple, yet flexible.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>

Can you please make the TX/RX antenna stuff 32 bits so that way we
never run out? 8-bits will get us far but better to not be sorry about
this later.

  Luis
