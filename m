Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:38709 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758531Ab2HHQzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 12:55:36 -0400
Message-ID: <50229A06.9090106@net.t-labs.tu-berlin.de> (sfid-20120808_185540_052826_C25803D9)
Date: Wed, 08 Aug 2012 18:55:34 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH v2 5/5] ath5k: Return correct offset when
 reading frequencies
References: <1344195337-27461-1-git-send-email-mickflemm@gmail.com> <1344195337-27461-6-git-send-email-mickflemm@gmail.com>
In-Reply-To: <1344195337-27461-6-git-send-email-mickflemm@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick, hi Felix,

This patch does break the operation of all DCMA82 (AR5413), as this
chips have only 8 valid piers, but with the "continue" all 10 got read.
So the former version was correct as it break after 8 piers.
The patch was initiated by my observation and after revisiting what I
did, blame Thomas is correct here... The power variation is properly
working and I miss measured based on an uncleaned patch mess in my env.

Please revert this patch to get proper pier readings back in ath5k.


Greetings Thomas


Nick Kossifidis schrieb:

> If we have a zeroed frequency on the calibration piers it means that we
> shouldn't use that pier, not stop reading the EEPROM and break out from
> the loop. By doing that we return the wrong offset and the whole dataset
> gets corrupted.
> 
> Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> Tested-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
>  drivers/net/wireless/ath/ath5k/eeprom.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
> index 4026c90..10a4396 100644
> --- a/drivers/net/wireless/ath/ath5k/eeprom.c
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.c
> @@ -522,7 +522,7 @@ ath5k_eeprom_read_freq_list(struct ath5k_hw *ah, int *offset, int max,
>  
>  		freq1 = val & 0xff;
>  		if (!freq1)
> -			break;
> +			continue;
>  
>  		pc[i++].freq = ath5k_eeprom_bin2freq(ee,
>  				freq1, mode);
> @@ -530,7 +530,7 @@ ath5k_eeprom_read_freq_list(struct ath5k_hw *ah, int *offset, int max,
>  
>  		freq2 = (val >> 8) & 0xff;
>  		if (!freq2)
> -			break;
> +			continue;
>  
>  		pc[i++].freq = ath5k_eeprom_bin2freq(ee,
>  				freq2, mode);

