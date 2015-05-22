Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:50268 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbbEVJOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 05:14:12 -0400
Message-ID: <555EF361.3000407@broadcom.com> (sfid-20150522_111418_585152_49E1BC7C)
Date: Fri, 22 May 2015 11:14:09 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH] brcmfmac: allow NVRAM values to contain space and '#'
 chars
References: <1432145442-14284-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1432145442-14284-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/15 20:10, Rafał Miłecki wrote:
> Both chars often require special handling (and brcmf_nvram_handle_idle
> already takes care of them) but they should be allowed when parsing
> entry value. Some example entries from SR400ac device NVRAM:
> 1:ccode=#a
> wl_realmlist=mail.example.com+0+21=2,4#5,7?cisco.com+0+21=2,4#5,7

Actually, if ccode=#a is sent to the firmware it will be ignored as it 
is an invalid value. The other entry is not intended to be sent to the 
device so it will be discarded anyway. So I don't see value in accepting 
the '#' sign.

Regards,
Arend

> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 21 +++++++++++----------
>   1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> index 45d7191..64e2491 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> @@ -66,14 +66,15 @@ struct nvram_parser {
>   	bool multi_dev_v2;
>   };
>
> -static bool is_nvram_char(char c)
> +/**
> + * is_printable_char() - check if char is ASCII printable one
> + *
> + * Please note that '#' may require different handling depending on the context.
> + * It's used as comment beginning and it's not allowed in key name.
> + */
> +static bool is_printable_char(char c)
>   {
> -	/* comment marker excluded */
> -	if (c == '#')
> -		return false;
> -
> -	/* key and value may have any other readable character */
> -	return (c>  0x20&&  c<  0x7f);
> +	return (c>= 0x20&&  c<  0x7f);
>   }
>
>   static bool is_whitespace(char c)
> @@ -92,7 +93,7 @@ static enum nvram_parser_state brcmf_nvram_handle_idle(struct nvram_parser *nvp)
>   		goto proceed;
>   	if (c == '#')
>   		return COMMENT;
> -	if (is_nvram_char(c)) {
> +	if (is_printable_char(c)) {
>   		nvp->entry = nvp->pos;
>   		return KEY;
>   	}
> @@ -120,7 +121,7 @@ static enum nvram_parser_state brcmf_nvram_handle_key(struct nvram_parser *nvp)
>   			nvp->multi_dev_v1 = true;
>   		if (strncmp(&nvp->fwnv->data[nvp->entry], "pcie/", 5) == 0)
>   			nvp->multi_dev_v2 = true;
> -	} else if (!is_nvram_char(c)) {
> +	} else if (!is_printable_char(c) || c == ' ' || c == '#') {
>   		brcmf_dbg(INFO, "warning: ln=%d:col=%d: '=' expected, skip invalid key entry\n",
>   			  nvp->line, nvp->column);
>   		return COMMENT;
> @@ -140,7 +141,7 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
>   	u32 cplen;
>
>   	c = nvp->fwnv->data[nvp->pos];
> -	if (!is_nvram_char(c)) {
> +	if (!is_printable_char(c)) {
>   		/* key,value pair complete */
>   		ekv = (u8 *)&nvp->fwnv->data[nvp->pos];
>   		skv = (u8 *)&nvp->fwnv->data[nvp->entry];

