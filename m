Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:42678 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbYJ2Ovj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 10:51:39 -0400
Received: by wf-out-1314.google.com with SMTP id 27so27875wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 07:51:38 -0700 (PDT)
Message-ID: <40f31dec0810290751x74a2fec9rb239a7711506252@mail.gmail.com> (sfid-20081029_155143_832207_B5325098)
Date: Wed, 29 Oct 2008 16:51:37 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: honor FIF_BCN_PRBRESP_PROMISC in STA mode
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1225283457-24417-4-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1225283457-24417-4-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/29 Bob Copeland <me@bobcopeland.com>:
> We were setting RX_FILTER_BEACON even after entering STA mode,
> which leads to a lot of unnecessary wakeups.  This should fix the
> bug "Ath5k driver has too many interrupts per second at idle" at
> http://bugzilla.kernel.org/show_bug.cgi?id=11749.
>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/base.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index c7ffcbb..5ef8cc4 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -2952,10 +2952,8 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
>                sc->opmode != NL80211_IFTYPE_MESH_POINT &&
>                test_bit(ATH_STAT_PROMISC, sc->status))
>                rfilt |= AR5K_RX_FILTER_PROM;
> -       if (sc->opmode == NL80211_IFTYPE_STATION ||
> -               sc->opmode == NL80211_IFTYPE_ADHOC) {
> +       if (sc->opmode == NL80211_IFTYPE_ADHOC)
>                rfilt |= AR5K_RX_FILTER_BEACON;
> -       }
>        if (sc->opmode == NL80211_IFTYPE_MESH_POINT)
>                rfilt |= AR5K_RX_FILTER_CONTROL | AR5K_RX_FILTER_BEACON |
>                        AR5K_RX_FILTER_PROBEREQ | AR5K_RX_FILTER_PROM;

Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
