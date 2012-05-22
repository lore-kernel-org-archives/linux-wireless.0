Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:44168 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758444Ab2EVLQT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2012 07:16:19 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: add command to get current rssi
References: <1337669130-4229-1-git-send-email-victorg@ti.com>
Date: Tue, 22 May 2012 14:16:17 +0300
In-Reply-To: <1337669130-4229-1-git-send-email-victorg@ti.com> (Victor
	Goldenshtein's message of "Tue, 22 May 2012 09:45:30 +0300")
Message-ID: <871umc8nzy.fsf@purkki.adurom.net> (sfid-20120522_131628_562688_6C51C21E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Victor Goldenshtein <victorg@ti.com> writes:

> Get current rssi (in dBm) from the driver/FW.
>
> Instead of reporting the signal received in the last
> rx packet, which might be inaccurate if rx traffic is
> low and beacon filtering is enabled, get the singal
> from the driver/FW.
>
> Signed-off-by: Victor Goldenshtein <victorg@ti.com>
> ---
>  include/net/mac80211.h      |    4 ++++
>  net/mac80211/cfg.c          |   22 ++++++++++++++--------
>  net/mac80211/driver-ops.h   |   11 +++++++++++
>  net/mac80211/driver-trace.h |    6 ++++++
>  4 files changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 4d6e6c6..279126a 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2231,6 +2231,8 @@ enum ieee80211_rate_control_changed {
>   * @get_et_strings:  Ethtool API to get a set of strings to describe stats
>   *	and perhaps other supported types of ethtool data-sets.
>   *
> + * @get_rssi: Get current signal strength in dBm.

Please document that the callback is optional and it can sleep.

-- 
Kalle Valo
