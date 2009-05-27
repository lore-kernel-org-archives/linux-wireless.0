Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50434 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759046AbZE0FMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 01:12:54 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 26 May 2009 22:12:57 -0700
Subject: Re: [PATCH 4/4] mac80211: Fix typos in "set default QoS values
 according to spec"
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Jeff Hansen <x@jeffhansen.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>
In-Reply-To: <1243400715-13561-4-git-send-email-x@jeffhansen.com>
References: <1243400715-13561-1-git-send-email-x@jeffhansen.com>
	 <1243400715-13561-4-git-send-email-x@jeffhansen.com>
Content-Type: text/plain
Date: Wed, 27 May 2009 08:12:52 +0300
Message-ID: <1243401172.30310.4.camel@jm-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 22:05 -0700, Jeff Hansen wrote:
> Some of the acwmin and acwmax values were backwards in the original patch,
> which cut TX performance (on my device at least) down from ~25-30Mbps to
> 2Mbps.  Performance is back up after this commit.

Thanks for reporting these and verifying that this fixes the issue.
However, not all of these are typos.. In addition,
linux-wireless@vger.kernel.org should be cc'ed.

> diff --git a/net/mac80211/util.c b/net/mac80211/util.c

> @@ -657,20 +657,20 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
> 
>                 switch (queue) {
>                 case 3: /* AC_BK */
> -                       qparam.cw_max = aCWmin;
> -                       qparam.cw_min = aCWmax;
> +                       qparam.cw_max = aCWmax;
> +                       qparam.cw_min = aCWmin;
>                         qparam.txop = 0;
>                         qparam.aifs = 7;
>                         break;
>                 default: /* never happens but let's not leave undefined */
>                 case 2: /* AC_BE */
> -                       qparam.cw_max = aCWmin;
> -                       qparam.cw_min = aCWmax;
> +                       qparam.cw_max = aCWmax;
> +                       qparam.cw_min = aCWmin;
>                         qparam.txop = 0;
>                         qparam.aifs = 3;
>                         break;

These are correct fixes.

>                 case 1: /* AC_VI */
> -                       qparam.cw_max = aCWmin;
> +                       qparam.cw_max = aCWmax;
>                         qparam.cw_min = (aCWmin + 1) / 2 - 1;
>                         if (use_11b)
>                                 qparam.txop = 6016/32;
> @@ -679,7 +679,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
>                         qparam.aifs = 2;
>                         break;
>                 case 0: /* AC_VO */
> -                       qparam.cw_max = (aCWmin + 1) / 2 - 1;
> +                       qparam.cw_max = (aCWmax + 1) / 2 - 1;
>                         qparam.cw_min = (aCWmin + 1) / 4 - 1;
>                         if (use_11b)
>                                 qparam.txop = 3264/32;

These were actually already correct (yes, it may look like a typo, but
it is not, both of VI and VO are indeed using aCWmin in calculation for
both min and max values) and should not be changed.

- Jouni


