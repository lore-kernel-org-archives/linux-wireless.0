Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33196 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388271AbeGXKMf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 06:12:35 -0400
Received: by mail-lj1-f193.google.com with SMTP id s12-v6so2943131ljj.0
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2018 02:07:06 -0700 (PDT)
Subject: Re: [PATCH] mwifiex: Fix skipped vendor specific IEs
To: roman.stratiienko@globallogic.com, akarwar@marvell.com
Cc: nishants@marvell.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1532352699-3232-1-git-send-email-roman.stratiienko@globallogic.com>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <c378bdc5-23f9-4eb2-948f-a5944f0a7136@cogentembedded.com> (sfid-20180724_110724_358233_7EFF0019)
Date: Tue, 24 Jul 2018 12:07:04 +0300
MIME-Version: 1.0
In-Reply-To: <1532352699-3232-1-git-send-email-roman.stratiienko@globallogic.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On 7/23/2018 4:31 PM, roman.stratiienko@globallogic.com wrote:

> From: Roman Stratiienko <roman.stratiienko@globallogic.com>
> 
> Only microsoft specific IE is added by FW
> Let other IEs to pass from userspace

    "To" not needed here.

> 
> Signed-off-by: Roman Stratiienko <roman.stratiienko@globallogic.com>
> ---
>   drivers/net/wireless/marvell/mwifiex/ie.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c b/drivers/net/wireless/marvell/mwifiex/ie.c
> index c488c30..c58b345 100644
> --- a/drivers/net/wireless/marvell/mwifiex/ie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/ie.c
> @@ -353,8 +353,16 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
>   		case WLAN_EID_HT_OPERATION:
>   		case WLAN_EID_VHT_CAPABILITY:
>   		case WLAN_EID_VHT_OPERATION:
> -		case WLAN_EID_VENDOR_SPECIFIC:
>   			break;
> +		case WLAN_EID_VENDOR_SPECIFIC:
> +			/* Skip only Microsoft IE that added by FW
                                                   ^^^^
    That's?

> +			 * Let other vendor specific IE to pass

    "To" not needed here as well...

[...]

MBR, Sergei
