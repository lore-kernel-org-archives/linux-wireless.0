Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na6sys009bog030.obsmtp.com ([74.125.150.104]:46702 "EHLO
	na6sys009bog030.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496Ab2FKFpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 01:45:40 -0400
Received: by lbbgg6 with SMTP id gg6so3389123lbb.22
        for <linux-wireless@vger.kernel.org>; Sun, 10 Jun 2012 22:45:29 -0700 (PDT)
Message-ID: <1339393188.3840.73.camel@cumari.coelho.fi> (sfid-20120611_074544_188760_7FD26545)
Subject: Re: [RFC 1/2] nl80211: specify RSSI threshold when scanning
From: Luciano Coelho <coelho@ti.com>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	ath6kl-devel@qualcomm.com, victorg@ti.com
Date: Mon, 11 Jun 2012 08:39:48 +0300
In-Reply-To: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 19:43 -0700, Thomas Pedersen wrote:
> Support configuring an RSSI threshold in dBm (s32) when scanning,
> below which a BSS won't be reported by the cfg80211 driver.
> 
> Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
> ---
>  include/linux/nl80211.h |    6 ++++++
>  include/net/cfg80211.h  |    7 +++++++
>  net/wireless/nl80211.c  |   17 +++++++++++++++++
>  3 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index a6959f7..dc051a8 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -1222,6 +1222,10 @@ enum nl80211_commands {
>   * @NL80211_ATTR_BG_SCAN_PERIOD: Background scan period in seconds
>   *      or 0 to disable background scan.
>   *
> + * @NL80211_ATTR_SCAN_RSSI: rssi threshold (in s32 dBm) below which a BSS is
> + *	not reported in scan results. Will be disabled if 0 or not specified.
> + *	Supported in %NL80211_CMD_START_SCHED_SCAN and %NL80211_TRIGGER_SCAN.
> + *
>   * @NL80211_ATTR_MAX: highest attribute number currently defined
>   * @__NL80211_ATTR_AFTER_LAST: internal use
>   */

BTW, I actually had discussed this feature with Victor internally some
time ago.  And, IIRC, I also talked about it briefly with Johannes.

My idea was that we could maybe make this more generic? There are lots
of different values that could be used as thresholds or filter options.
Couldn't we make this API generic as well? The first thing that comes to
my mind is the existing NL80211_ATTR_SCHED_SCAN_MATCH.  It is
essentially the same, we only want to report certain matches and filter
everything else out...

Does it make sense?

--
Luca.

