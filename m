Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17446 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbYLBU3U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 15:29:20 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 12:29:20 -0800
Date: Tue, 2 Dec 2008 12:29:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Henning Rogge <rogge@fgan.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Henning Rogge <hrogge@googlemail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Message-ID: <20081202202919.GC9351@tesla> (sfid-20081202_212924_341811_7AF129BB)
References: <200811252131.30161.hrogge@googlemail.com> <200812011422.30671.rogge@fgan.de> <20081201173948.GD5992@tesla> <200812021425.44488.rogge@fgan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200812021425.44488.rogge@fgan.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 02, 2008 at 05:25:36AM -0800, Henning Rogge wrote:
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index e08c8bc..3a83e97 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -404,6 +404,10 @@ enum nl80211_sta_flags {
>   * @NL80211_STA_INFO_TX_BYTES: total transmitted bytes (u32, to this station)
>   * @__NL80211_STA_INFO_AFTER_LAST: internal
>   * @NL80211_STA_INFO_MAX: highest possible station info attribute
> + * @NL80211_STA_INFO_SIGNAL: signal strength of last received package (u8, 
> dBm)

Shouldn't this be s8?

> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 1d57835..cdf9433 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -167,6 +167,9 @@ struct station_parameters {
>   * @STATION_INFO_LLID: @llid filled
>   * @STATION_INFO_PLID: @plid filled
>   * @STATION_INFO_PLINK_STATE: @plink_state filled
> + * @STATION_INFO_SIGNAL: @signal filled

Can you extend this to indicate drivers which enable this must
pass the singal in dBm (IEEE80211_HW_SIGNAL_DBM for mac80211 drivers)
as that is what cfg80211 expects?

This is important as mac80211 drivers not using IEEE80211_HW_SIGNAL_DBM
will luck out of getting signal reports. This means these drivers won't
get signal reports right now:

adm8211.c:1865: dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
rtl818x/rtl8187_dev.c:1416:             dev->flags |= IEEE80211_HW_SIGNAL_UNSPEC;
rtl818x/rtl8180_dev.c:900:                   IEEE80211_HW_SIGNAL_UNSPEC;
zd1211rw/zd_mac.c:972:              IEEE80211_HW_SIGNAL_DB;

I guess this is the iffy part... I'll see if zd1211rw can somehow use
dBm though.

> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 16423f9..77f0b1e 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -17,6 +17,41 @@
>  #include "rate.h"
>  #include "mesh.h"
>  
> +/* bitrate of 802.11n ht20 connections with 800ns guard interval in 100kbit/s 
> */
> +const u16 ieee80211n_ht20_gi800[] = {
> +    65, 130, 195, 260, 390, 520, 585, 650,
> +    130, 260, 390, 520, 780, 1040, 1170, 1300,
> +    195, 390, 585, 780, 1170, 1560, 1755, 1950,
> +    260, 520, 780, 1040, 1560, 2080, 2340, 2600
> +};
> +
> +/* bitrate of 802.11n ht20 connections with 400ns guard interval
> + * in 100kbit/s per spatial stream */
> +const u16 ieee80211n_ht20_gi400[] = {
> +    72, 144, 217, 289, 433, 578, 650, 722,
> +    144, 289, 433, 578, 867, 1156, 1300, 1440,
> +    217, 433, 650, 867, 1300, 1733, 1950, 2167,
> +    289, 578, 867, 1157, 1733, 2311, 2600, 2889
> +};
> +
> +/* bitrate of 802.11n ht40 connections with 800ns guard interval
> + * in 100kbit/s per spatial stream */
> +const u16 ieee80211n_ht40_gi800[] = {
> +    135, 270, 405, 540, 810, 1080, 1215, 1350,
> +    270, 540, 810, 1080, 1620, 2160, 2430, 2700,
> +    405, 810, 1215, 1620, 2430, 3240, 3645, 4050,
> +    540, 1080, 1620, 2160, 3240, 4320, 4860, 5400
> +};
> +
> +/* bitrate of 802.11n ht40 connections with 400ns guard interval
> + * in 100kbit/s per spatial stream */
> +const u16 ieee80211n_ht40_gi400[] = {
> +    150, 300, 450, 600, 900, 1200, 1350, 1500,
> +    300, 600, 900, 1200, 1800, 2400, 2700, 3000,
> +    450, 900, 1350, 1800, 2700, 3600, 4050, 4500,
> +    600, 1200, 1800, 2400, 3600, 4800, 5400, 6000
> +};
> +

Awesome stuff, now come to think of it, perhaps its best we let
userspace do the calculation and we just give it the last RX/TX
guard interval and the MCS index? Technically speaking it seems
we don't have duplicate rates though so a reverse map is possible
but it seems useful to just provide the information directly.

Any thoughts?

  Luis
