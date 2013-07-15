Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49983 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3GOSAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 14:00:14 -0400
Date: Mon, 15 Jul 2013 13:55:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: John Greene <jogreene@redhat.com>
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] brcmsmac: Further reduce log spam from tx phy messages
Message-ID: <20130715175553.GA18093@tuxdriver.com> (sfid-20130715_200021_538387_08FC5E6F)
References: <1373909435-29811-1-git-send-email-jogreene@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1373909435-29811-1-git-send-email-jogreene@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 15, 2013 at 01:30:35PM -0400, John Greene wrote:
> Relegate 2 phy messages to debug status as they create excessive
> log spam, noted in multiple bugzillas for brcmsmac v3.8 and up.
> This is a follow on to net-next 99e94940697adec4f84758adb2db71f4a82c7ba5:
> brcmsmac: Reduce log spam in heavy tx, make err print in debug
> 
>  brcmsmac bcma0:0: phyerr 0x10, rate 0x14
>  brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete:
> ampdu tx phy error (0x10)
> 
> Signed-off-by: John Greene <jogreene@redhat.com>
> 
> ver 2: Two trivial whitespace fixes.
> ver 3: My ver 2 comment in wrong place.

These lines...

> ---

Should go here, after the "---" line...

>  drivers/net/wireless/brcm80211/brcmsmac/ampdu.c | 6 +++---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c  | 4 ++--
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> index bd98285..fa391e4 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> @@ -928,9 +928,9 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
>  			}
>  		} else if (txs->phyerr) {
>  			update_rate = false;
> -			brcms_err(wlc->hw->d11core,
> -				  "%s: ampdu tx phy error (0x%x)\n",
> -				  __func__, txs->phyerr);
> +			brcms_dbg_ht(wlc->hw->d11core,
> +				     "%s: ampdu tx phy error (0x%x)\n",
> +				     __func__, txs->phyerr);
>  		}
>  	}
>  
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 9fd6f2f..7ca10bf 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -882,8 +882,8 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
>  	mcl = le16_to_cpu(txh->MacTxControlLow);
>  
>  	if (txs->phyerr)
> -		brcms_err(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
> -			  txs->phyerr, txh->MainRates);
> +		brcms_dbg_tx(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
> +			     txs->phyerr, txh->MainRates);
>  
>  	if (txs->frameid != le16_to_cpu(txh->TxFrameID)) {
>  		brcms_err(wlc->hw->d11core, "frameid != txh->TxFrameID\n");
> -- 
> 1.7.11.7
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
