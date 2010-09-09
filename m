Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:5802 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751342Ab0IIAlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 20:41:42 -0400
Received: from vs3007.wh2.ocn.ne.jp (125.206.180.235)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0829262898
	for <linux-wireless@vger.kernel.org>; Thu,  9 Sep 2010 09:41:40 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Fabio Rossi <rossi.f@inwind.it>
Subject: Re: [PATCH] ath5k: avoid unneeded calibration error messages
Date: Thu, 9 Sep 2010 09:40:57 +0900
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <201009070110.11495.rossi.f@inwind.it> <201009070948.29066.br1@einfach.org> <201009082237.41479.rossi.f@inwind.it>
In-Reply-To: <201009082237.41479.rossi.f@inwind.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009090940.57621.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu September 9 2010 05:37:41 Fabio Rossi wrote:
> Don't generate calibration errors messages when not needed.
> 
> Signed-off-by: Fabio Rossi <rossi.f@inwind.it>
> ---
> diff --git a/drivers/net/wireless/ath/ath5k/phy.c
> b/drivers/net/wireless/ath/ath5k/phy.c
> index 984ba92..4932bf2 100644
> --- a/drivers/net/wireless/ath/ath5k/phy.c
> +++ b/drivers/net/wireless/ath/ath5k/phy.c
> @@ -1377,7 +1377,7 @@ ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
> 
>         /* protect against divide by 0 and loss of sign bits */
>         if (i_coffd == 0 || q_coffd < 2)
> -               return -1;
> +               return 0;
> 
>         i_coff = (-iq_corr) / i_coffd;
>         i_coff = clamp(i_coff, -32, 31); /* signed 6 bit */

Acked-by: Bruno Randolf <br1@einfach.org>
