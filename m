Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45653 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab0G2GMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jul 2010 02:12:51 -0400
Received: by iwn7 with SMTP id 7so260337iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 23:12:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100729035820.5930.29864.stgit@tt-desk>
References: <20100729035820.5930.29864.stgit@tt-desk>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 28 Jul 2010 23:12:29 -0700
Message-ID: <AANLkTika8nD5oEXt-nHx7BHzZzCK1i8VQ9b-ubmcMze+@mail.gmail.com>
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
To: Bruno Randolf <br1@einfach.org>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com, nbd@openwrt.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 28, 2010 at 8:58 PM, Bruno Randolf <br1@einfach.org> wrote:
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index 2c87016..8a88921 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -731,6 +731,28 @@ enum nl80211_commands {
>  *      This is used in association with @NL80211_ATTR_WIPHY_TX_POWER_SETTING
>  *      for non-automatic settings.
>  *
> + * @NL80211_ATTR_WIPHY_ANTENNA_TX: Bitmap of allowed antennas for transmitting.
> + *     This can be used to mask out antennas which are not attached or should
> + *     not be used for transmitting. If an antenna is not selected in this
> + *     bitmap the hardware is not allowed to transmit on this antenna.
> + *
> + *     Each bit represents one antenna, starting with antenna 1 at the first
> + *     bit. Depending on which antennas are selected in the bitmap, 802.11n
> + *     drivers can derive which chainmasks to use (if all antennas belonging to
> + *     a particular chain are disabled this chain should be disabled) and if
> + *     a chain has diversity antennas wether diversity should be used or not.
> + *     HT capabilities (STBC, TX Beamforming, Antenna selection) can be
> + *     derived from the available chains after applying the antenna mask.

I don't want to do any work myself on drivers for this, can we have
cfg80211/mac80211 do this for us?

  Luis
