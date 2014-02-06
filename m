Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0020.hostedemail.com ([216.40.44.20]:35661 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753942AbaBFEo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Feb 2014 23:44:27 -0500
Message-ID: <1391661863.30094.56.camel@joe-AO722> (sfid-20140206_054516_604946_58DF29E9)
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
From: Joe Perches <joe@perches.com>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 05 Feb 2014 20:44:23 -0800
In-Reply-To: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-05 at 19:44 -0600, Calvin Owens wrote:
> Create a function to return a descriptive string for each reason code,
> and print that instead of the numeric value in the kernel log. These
> codes are easily found on popular search engines, but one is generally
> not able to access the internet when dealing with wireless connectivity
> issues.

Hello Calvin.

Some suggestions below...

> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
[]
> @@ -743,6 +743,72 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
>  	return 0;
>  }
>  
> +static const char *reason_code_strings[49] = {

static const char * const reason_etc...

> +	"(RESERVED)",
> +	"UNSPECIFIED",

etc..., but perhaps this thing below is fragile.

> +const char *ieee80211_get_reason_code_string(u16 reason_code)
> +{
> +	if (reason_code <= 24)
> +		return reason_code_strings[reason_code];
> +	else if (reason_code >= 32 && reason_code <= 39)
> +		return reason_code_strings[reason_code - 7];
> +	else if (reason_code == 45)
> +		return reason_code_strings[33];
> +	else if (reason_code >= 52 && reason_code <= 66)
> +		return reason_code_strings[reason_code - 18];
> +	else
> +		return "(INVALID)";
> +}

Perhaps use a more common kernel style

struct ieee80211_reason_descriptions {
	u16		code;
	const char *	desc;
}

and enumerate the reason codes with #defines and use a
macro to populate the descriptions

#define IEEE80211_REASON_RESERVED		0
#define IEEE80211_REASON_UNSPECIFIED		1

etc.

#define POPULATE_IEEE_REASON(code)			\
	{.code = IEEE80211_REASON_##code, .desc = #code}

static const struct ieee80211_reason_descriptions reasons[] = {
	POPULATE_IEEE_REASON(RESERVED),
	POPULATE_IEEE_REASON(UNSPECIFIED),
	[etc...]
};

So this function becomes something like:

const char *ieee80211_get_reason_code_string(u16 reason_code)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(reasons); i++) {
		if (reasons[i].code == reason_code)
			return reasons[i].desc;
	}

	return "UNKNOWN";
}

This seems a lot less fragile.

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
[]
> @@ -2231,8 +2231,8 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
>  
>  	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
>  
> -	sdata_info(sdata, "deauthenticated from %pM (Reason: %u)\n",
> -		   bssid, reason_code);
> +	sdata_info(sdata, "deauthenticated from %pM (reason: %s)\n",
> +		   bssid, ieee80211_get_reason_code_string(reason_code));

Perhaps

	"%u:%s",
	reason_code, ieee80211_get_reason_code_string(reason_code))

might be better here and the other places.

