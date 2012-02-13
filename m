Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab2BMQRs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 11:17:48 -0500
Message-ID: <1329149958.2094.4.camel@dcbw.foobar.com> (sfid-20120213_171754_223900_79825F73)
Subject: Re: [PATCH 20/24] iwlegacy: only enable rfkill interrupt during UP
From: Dan Williams <dcbw@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 13 Feb 2012 10:19:18 -0600
In-Reply-To: <1329128611-6815-21-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
	 <1329128611-6815-21-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-13 at 11:23 +0100, Stanislaw Gruszka wrote:
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlegacy/4965-mac.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)

By UP here I'll assume IFF_UP; did the previous code enable the
interrupt while the interface was down too?  The problem we have here is
that if there's no platform rfkill switch, but only the iwlwifi one,
then we don't get notifications of rfkill changes, which breaks showing
in the UI when you can and cannot use the card.

There are various complexities with rfkill here; for example I think for
3945 it used to be that you couldn't UP the interface when it was
rfkilled, so when it was killed (and thus down) you couldn't get
notifications of rfkill change at all, and thus you wouldn't know if you
could start using it again, except to poll (which sucks).

Dan

> diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
> index 24a3bbc..cf14861 100644
> --- a/drivers/net/wireless/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/iwlegacy/4965-mac.c
> @@ -5523,13 +5523,11 @@ __il4965_up(struct il_priv *il)
>  	/* If platform's RF_KILL switch is NOT set to KILL */
>  	if (_il_rd(il, CSR_GP_CNTRL) & CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW)
>  		clear_bit(S_RF_KILL_HW, &il->status);
> -	else
> +	else {
>  		set_bit(S_RF_KILL_HW, &il->status);
> -
> -	if (il_is_rfkill(il)) {
>  		wiphy_rfkill_set_hw_state(il->hw->wiphy, true);
>  
> -		il_enable_interrupts(il);
> +		il_enable_rfkill_int(il);
>  		IL_WARN("Radio disabled by HW RF Kill switch\n");
>  		return 0;
>  	}


