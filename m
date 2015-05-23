Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:55578 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbbEWGr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2015 02:47:59 -0400
Message-ID: <5560229C.9040008@broadcom.com> (sfid-20150523_084802_179403_7581F392)
Date: Sat, 23 May 2015 08:47:56 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCH V3] brcmfmac: allow NVRAM values to contain spaces
References: <1432145701-15150-1-git-send-email-zajec5@gmail.com> <1432331128-24011-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1432331128-24011-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/15 23:45, Rafał Miłecki wrote:
> Platform NVRAMs often contain values with spaces. Even if right now most
> firmware-supported entries are simple values, we shouldn't reject these
> with spaces. It was semi-confirmed by Broadocm in the early patch adding
> support for platform NVRAMs.

Well, here is my full confirmation ;-) and thanks.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
> V2: Minor change in commit message only. Provide an example of NVRAM entry
>      using space (not just a '#'). It's unprefixed (shouldn't be uploaded to
>      hardware anyway), but proves it's allowed in general.
> V3: As commented by Arend, accept space only (not a '#').
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> index 45d7191..baad939 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
> @@ -66,6 +66,12 @@ struct nvram_parser {
>   	bool multi_dev_v2;
>   };
>
> +/**
> + * is_nvram_char() - check if char is a valid one for NVRAM entry
> + *
> + * It accepts all printable ASCII chars except for '#' which opens a comment.
> + * Please note that ' ' (space) while accepted is not a valid key name char.
> + */
>   static bool is_nvram_char(char c)
>   {
>   	/* comment marker excluded */
> @@ -73,7 +79,7 @@ static bool is_nvram_char(char c)
>   		return false;
>
>   	/* key and value may have any other readable character */
> -	return (c>  0x20&&  c<  0x7f);
> +	return (c>= 0x20&&  c<  0x7f);
>   }
>
>   static bool is_whitespace(char c)
> @@ -120,7 +126,7 @@ static enum nvram_parser_state brcmf_nvram_handle_key(struct nvram_parser *nvp)
>   			nvp->multi_dev_v1 = true;
>   		if (strncmp(&nvp->fwnv->data[nvp->entry], "pcie/", 5) == 0)
>   			nvp->multi_dev_v2 = true;
> -	} else if (!is_nvram_char(c)) {
> +	} else if (!is_nvram_char(c) || c == ' ') {
>   		brcmf_dbg(INFO, "warning: ln=%d:col=%d: '=' expected, skip invalid key entry\n",
>   			  nvp->line, nvp->column);
>   		return COMMENT;

