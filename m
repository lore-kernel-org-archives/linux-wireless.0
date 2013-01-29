Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:48168 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab3A2Ns5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 08:48:57 -0500
Message-ID: <5107D345.7010101@neratec.com> (sfid-20130129_144901_292749_D404292C)
Date: Tue, 29 Jan 2013 14:48:53 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection command/event
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2013 01:21 PM, Simon Wunderlich wrote:
> From: Victor Goldenshtein <victorg@ti.com>
> 
> [...]
>  
>  /**
> + * enum ieee80211_dfs_state - DFS states for channels
> + *
> + * Channel states used by the DFS code.
> + *
> + * @IEEE80211_DFS_USABLE: The channel can be used, but channel availability
> + *	check (CAC) must be performed before using it for AP or IBSS.
> + * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
> + *	is therefore marked as not available.
> + * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
> + */
> +
> +enum ieee80211_dfs_state {
> +	IEEE80211_DFS_USABLE,
> +	IEEE80211_DFS_UNAVAILABLE,
> +	IEEE80211_DFS_AVAILABLE,
> +};
> +
Not sure if IEEE80211_DFS_UNKNOWN is not missing here, i.e. whether a channel that
never passed a CAC (or the CAC has been aborted) is always USABLE. Once I realized
why ETSI defined an UNKNOWN state, but forgot meanwhile - so maybe only relevant
for managed operation (like an UNKNOWN state can be overridden by external
information, whereas e.g. UNAVAILABLE can't).

Furthermore, is there a reason to define an additional wireless_dev.cac_started
flag vs. adding a IEEE80211_DFS_CAC state?


