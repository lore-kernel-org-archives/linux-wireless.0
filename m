Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:53242 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750741AbaETVyg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 17:54:36 -0400
Message-ID: <1400622868.25946.12.camel@dubbel> (sfid-20140520_235440_913878_5DB3B6FF)
From: Luca Coelho <luca@coelho.fi>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 May 2014 00:54:28 +0300
In-Reply-To: <20140520203657.2C281E0300@pstew.mtv.corp.google.com>
References: <20140520203657.2C281E0300@pstew.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] nl80211: Provide TDLS link state
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

On Tue, 2014-05-20 at 13:27 -0700, Paul Stewart wrote:
> Provide a method to query TDLS state in drivers that use the
> NL80211_CMD_TDLS_OPER method for link setup.
> 
> Signed-off-by: Paul Stewart <pstew@chromium.org>
> ---
>  include/uapi/linux/nl80211.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 9922b9b..4f163f9 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -3866,6 +3866,7 @@ enum nl80211_pmksa_candidate_attr {
>   * @NL80211_TDLS_TEARDOWN: Teardown a TDLS link which is already established
>   * @NL80211_TDLS_ENABLE_LINK: Enable TDLS link
>   * @NL80211_TDLS_DISABLE_LINK: Disable TDLS link
> + * @NL80211_TDLS_QUERY_LINK: Query TDLS link status
>   */
>  enum nl80211_tdls_operation {
>  	NL80211_TDLS_DISCOVERY_REQ,
> @@ -3873,6 +3874,19 @@ enum nl80211_tdls_operation {
>  	NL80211_TDLS_TEARDOWN,
>  	NL80211_TDLS_ENABLE_LINK,
>  	NL80211_TDLS_DISABLE_LINK,
> +	NL80211_TDLS_QUERY_LINK,
> +};
> +
> +/**
> + * enum nl80211_tdls_link_state - values returned fo %NL80211_TDLS_QUERY_LINK

Small typo here.  s/fo/for/ ?

--
Luca.

