Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4226 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab3GOQ0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 12:26:17 -0400
Message-ID: <51E4229A.5070803@broadcom.com> (sfid-20130715_182620_097114_B8F82CAC)
Date: Mon, 15 Jul 2013 18:26:02 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John Greene" <jogreene@redhat.com>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] brcmsmac: Further reduce log spam from tx phy
 messages
References: <1373895092-27057-1-git-send-email-jogreene@redhat.com>
In-Reply-To: <1373895092-27057-1-git-send-email-jogreene@redhat.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/15/13 15:31, John Greene wrote:
> Relegate 2 phy messages to debug status as they create excessive
> log spam, noted in multiple bugzillas for brcmsmac v3.8 and up.
> This is a follow on to net-next 99e94940697adec4f84758adb2db71f4a82c7ba5:
> brcmsmac: Reduce log spam in heavy tx, make err print in debug
>
>   brcmsmac bcma0:0: phyerr 0x10, rate 0x14
>   brcmsmac bcma0:0: brcms_c_ampdu_dotxstatus_complete:
> ampdu tx phy error (0x10)

Hi John,

Thanks for the patch. Still trying to find where these are coming from, 
but we seem to have slight variation of this device not showing this.

> ver 2: Two trivial whitespace fixes.

this kind of info recommended to be placed under the signed-off line so 
it does not end up in the git log. Apart from that you can add my ack.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: John Greene<jogreene@redhat.com>
> ---
so here
---
>   drivers/net/wireless/brcm80211/brcmsmac/ampdu.c | 6 +++---
>   drivers/net/wireless/brcm80211/brcmsmac/main.c  | 4 ++--
>   2 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> index bd98285..fa391e4 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> @@ -928,9 +928,9 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
>   			}
>   		} else if (txs->phyerr) {
>   			update_rate = false;
> -			brcms_err(wlc->hw->d11core,
> -				  "%s: ampdu tx phy error (0x%x)\n",
> -				  __func__, txs->phyerr);
> +			brcms_dbg_ht(wlc->hw->d11core,
> +				     "%s: ampdu tx phy error (0x%x)\n",
> +				     __func__, txs->phyerr);
>   		}
>   	}
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 9fd6f2f..7ca10bf 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -882,8 +882,8 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
>   	mcl = le16_to_cpu(txh->MacTxControlLow);
>
>   	if (txs->phyerr)
> -		brcms_err(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
> -			  txs->phyerr, txh->MainRates);
> +		brcms_dbg_tx(wlc->hw->d11core, "phyerr 0x%x, rate 0x%x\n",
> +			     txs->phyerr, txh->MainRates);
>
>   	if (txs->frameid != le16_to_cpu(txh->TxFrameID)) {
>   		brcms_err(wlc->hw->d11core, "frameid != txh->TxFrameID\n");


