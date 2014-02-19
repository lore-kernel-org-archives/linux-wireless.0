Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34271 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaBSQLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 11:11:13 -0500
Received: by mail-pa0-f53.google.com with SMTP id lj1so581746pab.12
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 08:11:12 -0800 (PST)
Date: Wed, 19 Feb 2014 08:11:05 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>
Subject: Re: [PATCH v4 1/5] cfg80211: Add indoor only and GO concurrent
 channel attributes
Message-ID: <20140219161101.GJ14296@garbanzo.do-not-panic.com> (sfid-20140219_171116_741294_E7D5506D)
References: <1392824377-18254-1-git-send-email-ilan.peer@intel.com>
 <1392824377-18254-2-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392824377-18254-2-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 05:39:33PM +0200, Ilan Peer wrote:
> From: David Spinadel <david.spinadel@intel.com>
> 
> The FCC are clarifying some soft configuration requirements,
> which among other include the following:
> 
> 1. Indoor operation, where a device can use channels requiring indoor
>    operation, subject to that it can guarantee indoor operation,
>    i.e., the device is connected to AC Power or the device is under
>    the control of a local master that is acting as an AP and is
>    connected to AC Power.
> 2. Concurrent GO operation, where devices may instantiate a P2P GO
>    while they are under the guidance of an authorized master. For example,
>    on a channel on which a BSS is connected to an authorized master, i.e.,
>    with DFS and radar detection capability in the UNII band.
> 
> See https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122
> 
> Add support for advertising Indoor-only and GO-Concurrent channel
> properties.
> 
> Signed-off-by: David Spinadel <david.spinadel@intel.com>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> ---
>  include/net/cfg80211.h       |   22 ++++++++++++++++++++++
>  include/uapi/linux/nl80211.h |    8 ++++++++
>  net/wireless/nl80211.c       |    6 ++++++
>  net/wireless/reg.c           |    2 ++
>  4 files changed, 38 insertions(+)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9f90554..5b2f275 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -109,6 +109,26 @@ enum ieee80211_band {
>   *	channel as the control or any of the secondary channels.
>   *	This may be due to the driver or due to regulatory bandwidth
>   *	restrictions.
> + * @IEEE80211_CHAN_INDOOR_ONLY: Only indoor use is permitted on this channel.
> + *	A channel marked with IEEE80211_CHAN_INDOOR_ONLY can only be used when
> + *	there is a clear assessment that the device is operating in an indoor
> + *	surroundings, i.e., it is connected to AC power (and not through
> + *	portable DC inverters) or is under the control of a master that is
> + *	acting as an AP and is connected to AC power.
> + * @IEEE80211_CHAN_GO_CONCURRENT: GO operation is allowed on this channel if
> + *	it's connected concurrently to a BSS on the same channel on the 2 GHz
> + *	band or to a channel in the same UNII band (on the 5 GHz band), and
> + *	IEEE80211_CHAN_RADAR is not set
> + *	Instantiating a GO on a channel marked with IEEE80211_CHAN_GO_CONCURRENT
> + *	can be done when there is a clear assessment that the device is
> + *	operating under the guidance of an authorized master, i.e., setting up a
> + *	GO while the device is also connected to an AP with DFS and radar
> + *	detection on the UNII band.


Would make sense to add here a comment indicating what you mentioned
on the other thread about userspace being responsible for this
verification. In this case the supplicant (wpa_supplicant).

> + *
> + *	See https://apps.fcc.gov/eas/comments/GetPublishedDocument.html?id=327&tn=528122
> + *	for more information on the FCC description of the relaxations allowed
> + *	by IEEE80211_CHAN_INDOOR_ONLY and IEEE80211_CHAN_GO_CONCURRENT.
> + *
>   */
>  enum ieee80211_channel_flags {
>  	IEEE80211_CHAN_DISABLED		= 1<<0,
> @@ -120,6 +140,8 @@ enum ieee80211_channel_flags {
>  	IEEE80211_CHAN_NO_OFDM		= 1<<6,
>  	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
>  	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
> +	IEEE80211_CHAN_INDOOR_ONLY	= 1<<9,
> +	IEEE80211_CHAN_GO_CONCURRENT	= 1<<10,
>  };
>  
>  #define IEEE80211_CHAN_NO_HT40 \
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index a12e6ca..da27ca4 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -2329,6 +2329,12 @@ enum nl80211_band_attr {
>   * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
>   *	using this channel as the primary or any of the secondary channels
>   *	isn't possible
> + * @NL80211_FREQUENCY_ATTR_INDOOR_ONLY: Indoor only use is permitted
> + *	on this channel in current regulatory domain

I'd prefer the more verbose documentation to go here as this is
the userspace API. What you can do is on the IEEE80211_CHAN_INDOOR_ONLY
documetnation refer for further information to
%NL80211_FREQUENCY_ATTR_INDOOR_ONLY.

> + * @NL80211_FREQUENCY_ATTR_GO_CONCURRENT: GO operation is allowed on this
> + *      channel if it's connected concurrently to a BSS on the same channel on
> + *      the 2 GHz band or to a channel in the same UNII band (on the 5 GHz
> + *      band), and NL80211_FREQUENCY_ATTR_RADAR is not set

Same here.

  Luis
