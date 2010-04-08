Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:12588 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752289Ab0DHENO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 00:13:14 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0548429992
	for <linux-wireless@vger.kernel.org>; Thu,  8 Apr 2010 13:13:12 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 4/4] ath5k: add bounds check to pdadc table
Date: Thu, 8 Apr 2010 13:15:45 +0900
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
References: <1270698959-7844-1-git-send-email-me@bobcopeland.com> <1270698959-7844-5-git-send-email-me@bobcopeland.com>
In-Reply-To: <1270698959-7844-5-git-send-email-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201004081315.45624.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 April 2010 12:55:59 Bob Copeland wrote:
> We check the bounds on pdadc once when correcting for
> negative curves but not when we later copy values from
> from the pdadc_tmp array, leading to a potential overrun.
> 
> Although we shouldn't hit this case in practice, let's
> be consistent.
> 
> Reported-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath/ath5k/phy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c
> b/drivers/net/wireless/ath/ath5k/phy.c index 81bdebd..65ac50b 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -2560,7 +2560,7 @@ ath5k_combine_pwr_to_pdadc_curves(struct ath5k_hw
> *ah, max_idx = (pdadc_n < table_size) ? pdadc_n : table_size;
> 
>  		/* Fill pdadc_out table */
> -		while (pdadc_0 < max_idx)
> +		while (pdadc_0 < max_idx && pdadc_i < 128)
>  			pdadc_out[pdadc_i++] = pdadc_tmp[pdadc_0++];
> 
>  		/* Need to extrapolate above this pdgain? */

for whatever it's worth :-)

Acked-by: Bruno Randolf <br1@einfach.org>
