Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:55534 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYAIJcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 04:32:13 -0500
Received: by fk-out-0910.google.com with SMTP id z23so38964fkz.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2008 01:32:10 -0800 (PST)
Message-ID: <47849498.5070605@gmail.com> (sfid-20080109_093225_633945_DE1A480C)
Date: Wed, 09 Jan 2008 10:32:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bruno Randolf <bruno@thinktube.com>
CC: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 6/6] ath5k: simplify beacon configuration
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com> <1199870169-10476-2-git-send-email-bruno@thinktube.com> <1199870169-10476-3-git-send-email-bruno@thinktube.com> <1199870169-10476-4-git-send-email-bruno@thinktube.com> <1199870169-10476-5-git-send-email-bruno@thinktube.com> <1199870169-10476-6-git-send-email-bruno@thinktube.com> <1199870169-10476-7-git-send-email-bruno@thinktube.com>
In-Reply-To: <1199870169-10476-7-git-send-email-bruno@thinktube.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2008 10:16 AM, Bruno Randolf wrote:
> make ath5k_beacon_config() clearer and move timer configuration into a seperate
> function. it will be needed later when we can detect HW merges.
> 
> Changes-licensed-under: 3-clause-BSD
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
>  drivers/net/wireless/ath5k/base.c |  105 +++++++++++++++++-------------------
>  1 files changed, 50 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 92361df..4f1ff1a 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
[...]
> +/*
> + * Configure the beacon timers and interrupts based on the operating mode
> + *
> + * When operating in station mode we want to receive a BMISS interrupt when we
> + * stop seeing beacons from the AP we've associated with so we can look for
> + * another AP to associate with.
> + *
> + * In IBSS mode we need to configure the beacon timers and use a self-linked tx
> + * descriptor if possible. If the hardware cannot deal with that we enable SWBA
> + * interrupts to send the beacons from the interrupt handler.
> + */
> +static void
> +ath5k_beacon_config(struct ath5k_softc *sc)
> +{
> +	struct ath5k_hw *ah = sc->ah;
>  
> -		sc->bmisscount = 0;
> -		ath5k_hw_set_intr(ah, sc->imask);
> +	ath5k_hw_set_intr(ah, 0);
> +	sc->bmisscount = 0;
> +
> +	if (sc->opmode == IEEE80211_IF_TYPE_STA) {
> +		sc->imask |= AR5K_INT_BMISS;
> +	}
> +	else if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {

checkpatch doesn't like this, please put the else path next time on the same 
line as } is.

the output:
WARNING: braces {} are not necessary for single statement blocks
#144: FILE: drivers/net/wireless/ath5k/base.c:2026:
+       if (sc->opmode == IEEE80211_IF_TYPE_STA) {
+               sc->imask |= AR5K_INT_BMISS;
+       }

ERROR: else should follow close brace '}'
#147: FILE: drivers/net/wireless/ath5k/base.c:2029:
+       }
+       else if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {

total: 1 errors, 1 warnings, 130 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
