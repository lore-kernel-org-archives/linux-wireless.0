Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:59662 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965004Ab3GLSAX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 14:00:23 -0400
Message-ID: <1373652022.2614.13.camel@joe-AO722> (sfid-20130712_200026_675750_43EF9307)
Subject: Re: [PATCH] brcmsmac: Further reduce log spam from tx phy messages
From: Joe Perches <joe@perches.com>
To: John Greene <jogreene@redhat.com>
Cc: linville@tuxdriver.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Date: Fri, 12 Jul 2013 11:00:22 -0700
In-Reply-To: <1373640919-2685-1-git-send-email-jogreene@redhat.com>
References: <1373640919-2685-1-git-send-email-jogreene@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-07-12 at 10:55 -0400, John Greene wrote:
> Relegate 2 phy messages to debug status as they create excessive
> log spam, noted in multiple bugzillas for brcmsmac v3.8 and up.

Hi John,

Just trivia:

> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
[]
> @@ -928,7 +928,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
[]
> -			brcms_err(wlc->hw->d11core,
> +			brcms_dbg_ht(wlc->hw->d11core,
>  				  "%s: ampdu tx phy error (0x%x)\n",
>  				  __func__, txs->phyerr);

Please keep the indentation of the arguments of
the same statement aligned to the open parenthesis.

> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
[]
> @@ -882,7 +882,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
[]
> -		brcms_err(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
> +		brcms_dbg_tx(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
>  			  txs->phyerr, txh->MainRates);

Here too.


