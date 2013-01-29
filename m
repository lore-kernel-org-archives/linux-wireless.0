Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:47458 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3A2N0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 08:26:44 -0500
Message-ID: <5107CE12.3090209@neratec.com> (sfid-20130129_142647_583282_EFA16066)
Date: Tue, 29 Jan 2013 14:26:42 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 2/3] mac80211: add radar detection command/event
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1359462120-22898-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2013 01:21 PM, Simon Wunderlich wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> [...]
> @@ -2080,7 +2087,7 @@ enum ieee80211_frame_release_type {
>   * @IEEE80211_RC_SMPS_CHANGED: The SMPS state of the station changed.
>   * @IEEE80211_RC_SUPP_RATES_CHANGED: The supported rate set of this peer
>   *	changed (in IBSS mode) due to discovering more information about
> - *	the peer.
> + *	the peern.
>   */
typo?
> [...]
> +	/* TODO: some channels (e.g. ETSI weather channels between 5.600 and
> +	 * 5.6500 require longer waiting time, if we want to support them at
> +	 * all.
> +	 */
> +	timeout = msecs_to_jiffies(NL80211_DFS_MIN_CAC_TIME_MS);
> +	ieee80211_queue_delayed_work(&sdata->local->hw,
> +				     &sdata->dfs_cac_timer_work, timeout);
> +
> +	return 0;
> +}
> +
The required minimum detection probability for weather channels is purposely
defined such that it can't be reached, so it is safe to assume they will never be
supported. As for CAC and NOP timings, they are luckily same for ETSI and FCC
right now, and if they differ in the future, we have the countrycode's DFS
regulatory domain available to differentiate.


