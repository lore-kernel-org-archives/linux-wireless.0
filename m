Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0091.hostedemail.com ([216.40.44.91]:51791 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752174AbbA3Kga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 05:36:30 -0500
Message-ID: <1422614186.2675.2.camel@perches.com> (sfid-20150130_113643_537741_00D0A250)
Subject: Re: [PATCH] iw: print human readable radar events
From: Joe Perches <joe@perches.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 30 Jan 2015 02:36:26 -0800
In-Reply-To: <1422610964-23252-1-git-send-email-helmut.schaa@googlemail.com>
References: <1422610964-23252-1-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-01-30 at 10:42 +0100, Helmut Schaa wrote:
> diff --git a/event.c b/event.c
[]
> @@ -565,6 +565,31 @@ static int print_event(struct nl_msg *msg, void *arg)
>  				   nla_data(tb[NL80211_ATTR_VENDOR_DATA]),
>  				   nla_len(tb[NL80211_ATTR_VENDOR_DATA]));
>  		break;
> +	case NL80211_CMD_RADAR_DETECT:
> +		printf("radar event ");
> +		if (tb[NL80211_ATTR_RADAR_EVENT]) {
> +			switch (nla_get_u32(tb[NL80211_ATTR_RADAR_EVENT])) {
> +				case NL80211_RADAR_DETECTED:
> +					printf("(radar detected)");
> +					break;
> +				case NL80211_RADAR_CAC_FINISHED:
> +					printf("(cac finished)");
> +					break;
> +				case NL80211_RADAR_CAC_ABORTED:
> +					printf("(cac aborted)");
> +					break;
> +				case NL80211_RADAR_NOP_FINISHED:
> +					printf("(nop finished)");
> +					break;
> +				default:
> +					printf("(unknown)");
> +					break;
> +			};
> +		} else {
> +			printf("(unknown)");
> +		}
> +		printf("\n");
> +		break;

Might be better with a const char * use

	case NL80211_CMD_RADAR_DETECT: {
		const char *type = "unknown";

		if (tb[NL80211_ATTR_RADAR_EVENT]) {
			switch (nla_get_u32(tb[NL80211_ATTR_RADAR_EVENT])) {
			case NL80211_RADAR_DETECTED:
				type = "radar detected";
				break;
			case NL80211_RADAR_CAC_FINISHED:
				type = "cac finished";
				break;
			case NL80211_RADAR_CAC_ABORTED:
				type = "cac aborted";
				break;
			case NL80211_RADAR_NOP_FINISHED:
				type = "nop finished";
				break;
			}
		}
		printf("radar event: (%s)\n", type);
	}


