Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47822 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbaK1USB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 15:18:01 -0500
Message-ID: <1417205873.5813.1.camel@coelho.fi> (sfid-20141128_211806_189558_CB672DB7)
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Date: Fri, 28 Nov 2014 22:17:53 +0200
In-Reply-To: <1417162740-4044-2-git-send-email-luca@coelho.fi>
References: <1417162740-4044-1-git-send-email-luca@coelho.fi>
	 <1417162740-4044-2-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH iw v2 2/2] add WoWLAN net-detect trigger
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-28 at 10:19 +0200, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Adds a netdetect option to the wowlan triggers that allows the user to
> request network detection to be started when the device goes to
> suspend mode.
> 
> Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> ---
> 
> In v2:
> 
>    * renamed the option in the code from "match" to "matches" (the
>      help already used the plural form).
> ---
>  event.c  |  30 ++++++++++-
>  info.c   |   3 ++
>  wowlan.c | 177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  3 files changed, 207 insertions(+), 3 deletions(-)
> 
> diff --git a/event.c b/event.c
> index 25f8099..99f9f15 100644
> --- a/event.c
> +++ b/event.c
> @@ -200,7 +200,8 @@ static void parse_mic_failure(struct nlattr **attrs)
>  
>  static void parse_wowlan_wake_event(struct nlattr **attrs)
>  {
> -	struct nlattr *tb[NUM_NL80211_WOWLAN_TRIG];
> +	struct nlattr *tb[NUM_NL80211_WOWLAN_TRIG],
> +		*tb_match[NUM_NL80211_ATTR];
>  
>  	printf("WoWLAN wakeup\n");
>  	if (!attrs[NL80211_ATTR_WOWLAN_TRIGGERS]) {
> @@ -227,6 +228,33 @@ static void parse_wowlan_wake_event(struct nlattr **attrs)
>  		printf("\t* 4-way handshake\n");
>  	if (tb[NL80211_WOWLAN_TRIG_RFKILL_RELEASE])
>  		printf("\t* RF-kill released\n");
> +	if (tb[NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS]) {
> +		struct nlattr *match, *freq;
> +		int rem_nst, rem_nst2;
> +
> +		printf("\t* network detected\n");
> +		nla_for_each_nested(match,
> +				    tb[NL80211_WOWLAN_TRIG_NET_DETECT_RESULTS],
> +				    rem_nst) {
> +			nla_parse(tb_match, NUM_NL80211_ATTR, nla_data(match),
> +				  nla_len(match),
> +				  NULL);
> +			printf("\t\tSSID: \"");
> +			/* printf("len %d %p\n", nla_len(tb_match[NL80211_ATTR_SSID]), */
> +			/*        nla_data(tb_match[NL80211_ATTR_SSID])); */

Argh, this shouldn't be here... I'll respin.

--
Luca.

