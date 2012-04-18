Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab2DRB63 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 21:58:29 -0400
Message-ID: <1334714275.3725.28.camel@jlt3.sipsolutions.net> (sfid-20120418_035831_464770_92531C7A)
Subject: Re: [RESEND PATCH 2/2] iw: Show Toffset on station dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	devel@lists.open80211s.org
Date: Tue, 17 Apr 2012 18:57:55 -0700
In-Reply-To: <1334274414-17541-2-git-send-email-ashok@cozybit.com> (sfid-20120413_014738_360418_9CEC2E31)
References: <1334274414-17541-1-git-send-email-ashok@cozybit.com>
	 <1334274414-17541-2-git-send-email-ashok@cozybit.com>
	 (sfid-20120413_014738_360418_9CEC2E31)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-12 at 16:46 -0700, Ashok Nagarajan wrote:
> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
> ---
>  station.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/station.c b/station.c
> index ef69ea5..75e2369 100644
> --- a/station.c
> +++ b/station.c
> @@ -45,6 +45,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
>  		[NL80211_STA_INFO_RX_PACKETS] = { .type = NLA_U32 },
>  		[NL80211_STA_INFO_TX_PACKETS] = { .type = NLA_U32 },
>  		[NL80211_STA_INFO_SIGNAL] = { .type = NLA_U8 },
> +		[NL80211_STA_INFO_T_OFFSET] = { .type = NLA_U64 },
>  		[NL80211_STA_INFO_TX_BITRATE] = { .type = NLA_NESTED },
>  		[NL80211_STA_INFO_LLID] = { .type = NLA_U16 },
>  		[NL80211_STA_INFO_PLID] = { .type = NLA_U16 },
> @@ -113,6 +114,9 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
>  	if (sinfo[NL80211_STA_INFO_SIGNAL_AVG])
>  		printf("\n\tsignal avg:\t%d dBm",
>  			(int8_t)nla_get_u8(sinfo[NL80211_STA_INFO_SIGNAL_AVG]));
> +	if (sinfo[NL80211_STA_INFO_T_OFFSET])
> +		printf("\n\tToffset:\t%lld us",
> +			(int64_t)nla_get_u64(sinfo[NL80211_STA_INFO_T_OFFSET]));

Or maybe this did, that seems more likely.

johannes

