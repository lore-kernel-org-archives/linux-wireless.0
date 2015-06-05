Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:36625 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbbFEPbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 11:31:51 -0400
Received: by oihb142 with SMTP id b142so55758980oih.3
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jun 2015 08:31:50 -0700 (PDT)
Message-ID: <5571C0E3.1050601@lwfinger.net> (sfid-20150605_173154_804662_A3A5CB66)
Date: Fri, 05 Jun 2015 10:31:47 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Taehee Yoo <ap420073@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] rtlwifi: rtl8192cu: Fix variable isfirst_ampdu
References: <1433512898-30137-1-git-send-email-ap420073@gmail.com> <1433512898-30137-3-git-send-email-ap420073@gmail.com>
In-Reply-To: <1433512898-30137-3-git-send-email-ap420073@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2015 09:01 AM, Taehee Yoo wrote:
> rtl92cu_rx_query_desc set a isampdu twice.
> but second code is related to isfirst_ampdu.
> so i change it.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>   drivers/net/wireless/rtlwifi/rtl8192cu/trx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Looks good.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> index cbead00..95880fe 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
> @@ -321,7 +321,7 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
>   	stats->rate = (u8) GET_RX_DESC_RX_MCS(pdesc);
>   	stats->shortpreamble = (u16) GET_RX_DESC_SPLCP(pdesc);
>   	stats->isampdu = (bool) (GET_RX_DESC_PAGGR(pdesc) == 1);
> -	stats->isampdu = (bool) ((GET_RX_DESC_PAGGR(pdesc) == 1)
> +	stats->isfirst_ampdu = (bool)((GET_RX_DESC_PAGGR(pdesc) == 1)
>   				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
>   	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
>   	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
>

