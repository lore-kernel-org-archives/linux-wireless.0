Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:43207 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaJMKYc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 06:24:32 -0400
Date: Mon, 13 Oct 2014 12:24:19 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: stable@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: fix typo in starting baserate for
 rts_cts_rate_idx
Message-ID: <20141013102419.GA31608@magnum.frso.rivierawaves.com> (sfid-20141013_122436_435395_79C64183)
References: <1413193692-30521-1-git-send-email-karl.beldan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1413193692-30521-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Properly cc'ing stable (I used kernel.org instead of vger.kernel.org).

On Mon, Oct 13, 2014 at 11:48:12AM +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> It affects non-(V)HT rates and can lead to selecting an rts_cts rate
> that is not a basic rate or way superior to the reference rate (ATM
> rates[0] used for the 1st attempt of the protected frame data).
> 
> E.g, assuming drivers register growing (bitrate) sorted tables of
> ieee80211_rate-s, having :
> - rates[0].idx == d'2 and basic_rates == b'10100
> will select rts_cts idx b'10011 & ~d'(BIT(2)-1), i.e. 1, likewise
> - rates[0].idx == d'2 and basic_rates == b'10001
> will select rts_cts idx b'10000
> The first is not a basic rate and the second is > rates[0].
> 
> Also, wrt severity of the addressed misbehavior, ATM we only have one
> rts_cts_rate_idx rather than one per rate table entry, so this idx might
> still point to bitrates > rates[1..MAX_RATES].
> 
> Fixes: 5253ffb8 ("mac80211: always pick a basic rate to tx RTS/CTS for pre-HT rates")
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> ---
>  net/mac80211/rate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
> index 8fdadfd..6081329 100644
> --- a/net/mac80211/rate.c
> +++ b/net/mac80211/rate.c
> @@ -448,7 +448,7 @@ static void rate_fixup_ratelist(struct ieee80211_vif *vif,
>  	 */
>  	if (!(rates[0].flags & IEEE80211_TX_RC_MCS)) {
>  		u32 basic_rates = vif->bss_conf.basic_rates;
> -		s8 baserate = basic_rates ? ffs(basic_rates - 1) : 0;
> +		s8 baserate = basic_rates ? ffs(basic_rates) - 1 : 0;
>  
>  		rate = &sband->bitrates[rates[0].idx];
>  
> -- 
> 2.0.1
> 
