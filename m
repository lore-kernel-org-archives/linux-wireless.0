Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:18827 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751067Ab0DHEMK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 00:12:10 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-096159928
	for <linux-wireless@vger.kernel.org>; Thu,  8 Apr 2010 13:12:08 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 1/4] ath5k: correct channel setting for 2.5 mhz spacing
Date: Thu, 8 Apr 2010 13:14:41 +0900
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <1270698959-7844-1-git-send-email-me@bobcopeland.com> <1270698959-7844-2-git-send-email-me@bobcopeland.com>
In-Reply-To: <1270698959-7844-2-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201004081314.41703.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 April 2010 12:55:56 Bob Copeland wrote:
> These channels aren't selectable anyway, but our calculations
> for 2.5 mhz frequencies are incorrect.  The value is supposed to
> be:
> 
>   (frequency - reference) * (10/25)
> 
> i.e., divide by 2.5, but we were instead doing:
> 
>   (10 * frequency - reference) / 25.
> 
> Additionally, the check for (frequency % 5 == 2) had an extra
> subtraction that wasn't in madwifi HAL.
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c
> b/drivers/net/wireless/ath/ath5k/phy.c index b83ca8a..81bdebd 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -979,7 +979,7 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
>  			return -EINVAL;
> 
>  		data0 = ath5k_hw_bitswap((data0 << 2) & 0xff, 8);
> -	} else if ((c - (c % 5)) != 2 || c > 5435) {
> +	} else if ((c % 5) != 2 || c > 5435) {
>  		if (!(c % 20) && c >= 5120) {
>  			data0 = ath5k_hw_bitswap(((c - 4800) / 20 << 2), 8);
>  			data2 = ath5k_hw_bitswap(3, 2);
> @@ -992,7 +992,7 @@ static int ath5k_hw_rf5112_channel(struct ath5k_hw *ah,
>  		} else
>  			return -EINVAL;
>  	} else {
> -		data0 = ath5k_hw_bitswap((10 * (c - 2) - 4800) / 25 + 1, 8);
> +		data0 = ath5k_hw_bitswap((10 * (c - 2 - 4800)) / 25 + 1, 8);
>  		data2 = ath5k_hw_bitswap(0, 2);
>  	}
> 
> @@ -1020,7 +1020,7 @@ static int ath5k_hw_rf2425_channel(struct ath5k_hw
> *ah, data0 = ath5k_hw_bitswap((c - 2272), 8);
>  		data2 = 0;
>  	/* ? 5GHz ? */
> -	} else if ((c - (c % 5)) != 2 || c > 5435) {
> +	} else if ((c % 5) != 2 || c > 5435) {
>  		if (!(c % 20) && c < 5120)
>  			data0 = ath5k_hw_bitswap(((c - 4800) / 20 << 2), 8);
>  		else if (!(c % 10))
> @@ -1031,7 +1031,7 @@ static int ath5k_hw_rf2425_channel(struct ath5k_hw
> *ah, return -EINVAL;
>  		data2 = ath5k_hw_bitswap(1, 2);
>  	} else {
> -		data0 = ath5k_hw_bitswap((10 * (c - 2) - 4800) / 25 + 1, 8);
> +		data0 = ath5k_hw_bitswap((10 * (c - 2 - 4800)) / 25 + 1, 8);
>  		data2 = ath5k_hw_bitswap(0, 2);
>  	}

for whatever it's worth :-)

Acked-by: Bruno Randolf <br1@einfach.org>
