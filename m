Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:49493 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933453AbaGUTCz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 15:02:55 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de
Subject: Re: [PATCHv2 2/2] ath10k: add spectral scan feature
Date: Mon, 21 Jul 2014 21:02:47 +0200
Message-ID: <43945028.YYV8n3Af3F@sven-edge> (sfid-20140721_210259_105510_8BBE35B5)
In-Reply-To: <1405945943-8303-3-git-send-email-sw@simonwunderlich.de>
References: <1405945943-8303-1-git-send-email-sw@simonwunderlich.de> <1405945943-8303-3-git-send-email-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 July 2014 14:32:23 Simon Wunderlich wrote:
> diff --git a/drivers/net/wireless/ath/ath10k/Makefile
> b/drivers/net/wireless/ath/ath10k/Makefile index 2110a5c..e1dcefd 100644
> --- a/drivers/net/wireless/ath/ath10k/Makefile
> +++ b/drivers/net/wireless/ath/ath10k/Makefile
> @@ -8,7 +8,8 @@ ath10k_core-y += mac.o \
>  		 htt_tx.o \
>  		 txrx.o \
>  		 wmi.o \
> -		 bmi.o
> +		 bmi.o \
> +		 spectral.o


ath9k doesn't compile the debugfs+spectral source files when 
CONFIG_ATH9K_DEBUGFS is not enabled. So this most likely has to be changed to 

ath10k_core-$(CONFIG_ATH10K_DEBUGFS) += spectral.o

Otherwise the static inline functions in the spectral.h may collide with the 
functions inside spectral.c when CONFIG_ATH10K_DEBUGFS is disabled.

Kind regards,
	Sven
