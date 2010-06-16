Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43201 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab0FPHSy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 03:18:54 -0400
Subject: Re: [PATCH v3] iw: Configure basic rates when joining ibss network
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1276669336-32266-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276669336-32266-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 09:18:49 +0200
Message-ID: <1276672729.3640.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-16 at 09:22 +0300, Teemu Paasikivi wrote:
> This patch adds option to configure basic rates when joining ibss network.

Applied, thanks.

> Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> ---
>  ibss.c |   35 ++++++++++++++++++++++++++++++++++-
>  1 files changed, 34 insertions(+), 1 deletions(-)
> 
> diff --git a/ibss.c b/ibss.c
> index 4715ac8..7e3ff89 100644
> --- a/ibss.c
> +++ b/ibss.c
> @@ -18,6 +18,11 @@ static int join_ibss(struct nl80211_state *state,
>  {
>  	char *end;
>  	unsigned char abssid[6];
> +	unsigned char rates[NL80211_MAX_SUPP_RATES];
> +	int n_rates = 0;
> +	char *value = NULL, *sptr = NULL;
> +	float rate;
> +
>  
>  	if (argc < 2)
>  		return 1;
> @@ -49,6 +54,32 @@ static int join_ibss(struct nl80211_state *state,
>  		}
>  	}
>  
> +	/* basic rates */
> +	if (argc > 1 && strcmp(argv[0], "basic-rates") == 0) {
> +		argv++;
> +		argc--;
> +
> +		value = strtok_r(argv[0], ",", &sptr);
> +
> +		while (value && n_rates < NL80211_MAX_SUPP_RATES) {
> +			rate = strtod(value, &end);
> +			rates[n_rates] = rate * 2;
> +
> +			/* filter out suspicious values  */
> +			if (*end != '\0' || !rates[n_rates] ||
> +			    rate*2 != rates[n_rates])
> +				return 1;
> +
> +			n_rates++;
> +			value = strtok_r(NULL, ",", &sptr);
> +		}
> +
> +		NLA_PUT(msg, NL80211_ATTR_BSS_BASIC_RATES, n_rates, rates);
> +
> +		argv++;
> +		argc--;
> +	}
> +
>  	if (!argc)
>  		return 0;
>  
> @@ -73,7 +104,9 @@ static int leave_ibss(struct nl80211_state *state,
>  COMMAND(ibss, leave, NULL,
>  	NL80211_CMD_LEAVE_IBSS, 0, CIB_NETDEV, leave_ibss,
>  	"Leave the current IBSS cell.");
> -COMMAND(ibss, join, "<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] [key d:0:abcde]",
> +COMMAND(ibss, join,
> +	"<SSID> <freq in MHz> [fixed-freq] [<fixed bssid>] "
> +	"[basic-rates <rate in Mbps,rate2,...>] [key d:0:abcde]",
>  	NL80211_CMD_JOIN_IBSS, 0, CIB_NETDEV, join_ibss,
>  	"Join the IBSS cell with the given SSID, if it doesn't exist create\n"
>  	"it on the given frequency. When fixed frequency is requested, don't\n"


