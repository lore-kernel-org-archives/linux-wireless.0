Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:37145 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753505AbeDSWcz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 18:32:55 -0400
Subject: Re: [PATCH] reg: Rename confusing 'country IE' in log output
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org, johannes@sipsolutions.net
References: <20180419091738.9068-1-toke@toke.dk>
From: Bernhard Gabler <Bernhard_Gabler@web.de>
Message-ID: <8ced0b02-af10-4d9d-9a68-cc08643a5cda@web.de> (sfid-20180420_003320_600187_79732FFF)
Date: Fri, 20 Apr 2018 00:32:49 +0200
MIME-Version: 1.0
In-Reply-To: <20180419091738.9068-1-toke@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Toke & all,

looking at the patch, I see more occurences of the outdated "IE" in a 
constant name and function name:

         case NL80211_REGDOM_SET_BY_COUNTRY_IE:
or
         reg_process_hint_country_ie()

Would it make sense to likewise fix these (and possibly more) 
occurrences too, to match the spec from 2016?
For the sake of readability and consistency of code ...

Bernhard


Am 19.04.2018 um 11:17 schrieb Toke Høiland-Jørgensen:

> The 'country IE' messages in the log can be confusing and make people think
> that the country code has been set to Ireland. Fix this by changing the
> log messages to use 'country element' instead (as they are no longer called
> 'information element' in the spec anyway).
>
> Reported-by: Bernhard Gabler <Bernhard_Gabler@web.de>
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
>   net/wireless/reg.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 16c7e4ef5820..ecfee5f06c76 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1652,7 +1652,7 @@ const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
>   	case NL80211_REGDOM_SET_BY_DRIVER:
>   		return "driver";
>   	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
> -		return "country IE";
> +		return "country element";
>   	default:
>   		WARN_ON(1);
>   		return "bug";
> @@ -2618,7 +2618,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
>   		 * This doesn't happen yet, not sure we
>   		 * ever want to support it for this case.
>   		 */
> -		WARN_ONCE(1, "Unexpected intersection for country IEs");
> +		WARN_ONCE(1, "Unexpected intersection for country elements");
>   		return REG_REQ_IGNORE;
>   	}
>   
