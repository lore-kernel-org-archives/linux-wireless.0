Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37105 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0E1SQH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 May 2010 14:16:07 -0400
Received: by gyg13 with SMTP id 13so1218948gyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 28 May 2010 11:16:06 -0700 (PDT)
Message-ID: <4C000873.4070708@gmail.com>
Date: Fri, 28 May 2010 14:16:19 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Weedy <weedy2887@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack
 	suite)
References: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>	<AANLkTimaLEQYH4Y7HO4Fv4zT8w8AsPkaAQtk9EauX4Bt@mail.gmail.com>	<AANLkTikRt1fUgngBQxEoEFe1VDrYVFRAoMSR53et7gxf@mail.gmail.com>	<AANLkTim-A_TWT-flrW88gJGan47Xhm7llyrQE3ehDKU6@mail.gmail.com>	<AANLkTim4zLxIQH2r76WZRh9kNigVNAngcK1d9-Cu65Ag@mail.gmail.com>	<AANLkTimH3p-dBA_6ee2a0iCnPDhtPZONzCEVkzMHrUWo@mail.gmail.com>	<AANLkTim-4UNn8acYvF7AF2FDzdC9xRY-9JS0lSurwBc6@mail.gmail.com>	<AANLkTimYeL4KQozuTl4le9WUpObsjwp0YAx7eAYq6MBr@mail.gmail.com>	<AANLkTikOgv6d0FlXu2-smnYPApeehjRq_j8UxEealqFC@mail.gmail.com>	<AANLkTinynNqs6_zyTJcpi7yKiSvC5fBhbM2tVZcnoNUq@mail.gmail.com>	<AANLkTinyGlwqq4xshLU5Ol74p0VfcUXBjBGKXlsB2pMy@mail.gmail.com>	<AANLkTimIeTadyAhUuri2P630mpDwmBk4B90RpERLbaFE@mail.gmail.com>	<AANLkTilXJHs8emXX4YNHbPq0SkuC4Z22NEh-T6mwUSHS@mail.gmail.com>	<4BFDEBDC.4070304@gmail.com> <AANLkTin3VSp_FcSiadD4efE1Yo1vKiDXmOngsHEKiQmF@mail.gmail.com>
In-Reply-To: <AANLkTin3VSp_FcSiadD4efE1Yo1vKiDXmOngsHEKiQmF@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Wed, May 26, 2010 at 11:49 PM, Richard Farina <sidhayn@gmail.com> wrote:
>   
>> Bob Copeland wrote:
>>     
>>> Ok, it should be enough to look at the filter flags instead of
>>> the opmode -- I knew in the back of my mind that the monitor
>>> stuff was bogus (part of the reason I did the patch in the first
>>> place) but just got confused by what was already there I guess.
>>>       
>> I've got a lot of people very interested in this fix. Let me know what kind
>> of support you need to make this happen.  You know where to find me on irc
>> ;-)
>>     
>
> Ok, can you and Weedy try this patch?
>
> Use the attachment -- gmail will screw up the whitespace, but I included
> it inline for reference.
>
> Weedy, if you want reported-by credit can you give your full name and
> preferred email address?
>
> From: Bob Copeland <me@bobcopeland.com>
> Date: Thu, 27 May 2010 08:54:38 -0400
> Subject: [PATCH] ath5k: retain promiscuous setting
>
> Commit 56d1de0a21db28e41741cfa0a66e18bc8d920554, "ath5k: clean up
> filter flags setting" introduced a regression in monitor mode such
> that the promisc filter flag would get lost.
>
> Although we set the promisc flag when it changed, we did not
> preserve it across subsequent calls to configure_filter.  This patch
> restores the original functionality.
>
> Cc: stable@kernel.org
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>
> Note, a better fix would be to just unconditionally look at new_flags,
> but this is the minimal change for stable.  I'll add fixing all this
> stuff up to my todo.
>
>  drivers/net/wireless/ath/ath5k/base.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c
> index 9c27623..9e023b8 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -3153,13 +3153,15 @@ static void ath5k_configure_filter(struct
> ieee80211_hw *hw,
>
>  	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
>  		if (*new_flags & FIF_PROMISC_IN_BSS) {
> -			rfilt |= AR5K_RX_FILTER_PROM;
>  			__set_bit(ATH_STAT_PROMISC, sc->status);
>  		} else {
>  			__clear_bit(ATH_STAT_PROMISC, sc->status);
>  		}
>  	}
>
> +	if (test_bit(ATH_STAT_PROMISC, sc->status))
> +		rfilt |= AR5K_RX_FILTER_PROM;
> +
>  	/* Note, AR5K_RX_FILTER_MCAST is already enabled */
>  	if (*new_flags & FIF_ALLMULTI) {
>  		mfilt[0] =  ~0;
>   
Tested-By: Rick Farina

This patch fixes the problem, data packets are now captured while in 
monitor mode.  Incidentally when I tried to chase this back to see when 
it started I found the same behavior in 2.6.32_rc and even in 2.6.29 
(which is funny since Weedy bisected the change to some time during 
2.6.31_rc5).  This fix should be pushed out to as much of stable as 
possible as soon as possible.  Thanks for the patch Bob!

-Rick Farina
