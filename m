Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3ABNiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:38:46 -0500
Message-ID: <1357133940.9839.26.camel@jlt4.sipsolutions.net> (sfid-20130102_143849_695919_C27FA255)
Subject: Re: [PATCHv5 3/8] nl80211/cfg80211: add radar detection
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Jan 2013 14:39:00 +0100
In-Reply-To: <1355407113-27006-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1355407113-27006-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:

> +++ b/include/net/cfg80211.h
> @@ -133,6 +133,11 @@ enum ieee80211_channel_flags {
>   *	to enable this, this is useful only on 5 GHz band.
>   * @orig_mag: internal use
>   * @orig_mpwr: internal use
> + * @radar_detect_timeout: this timeout indicates the end of the channel
> + *	availability check for radar channels (in jiffies), only after this
> + *	period the user may initiate the tx on the channel.
> + * @cac_type: indicates that channel availability check is started for this
> + *	channel type.
>   */
>  struct ieee80211_channel {
>  	enum ieee80211_band band;
> @@ -145,6 +150,9 @@ struct ieee80211_channel {
>  	bool beacon_found;
>  	u32 orig_flags;
>  	int orig_mag, orig_mpwr;
> +	unsigned long radar_detect_timeout;
> +	enum nl80211_channel_type cac_type;
> +	bool cac_started;

Since we lock a channel, all of these should probably move to the
rdev/wiphy struct, I think.

And then the code checking channel contexts needs to be extended to not
allow another while a channel context is in use:

> +	mutex_lock(&rdev->devlist_mtx);
> +	err = cfg80211_can_use_chan(rdev, wdev, chandef.chan,
> +				    CHAN_MODE_SINGLE_ONLY);
> +	mutex_unlock(&rdev->devlist_mtx);

This only does a spot check, keeping state needs to be handled
separately.

johannes

