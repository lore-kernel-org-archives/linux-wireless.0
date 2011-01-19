Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34615 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1ASPzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 10:55:50 -0500
Received: by pva4 with SMTP id 4so172035pva.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 07:55:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110119092102.19628.68971.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
	<20110119092102.19628.68971.stgit@localhost6.localdomain6>
Date: Wed, 19 Jan 2011 17:55:50 +0200
Message-ID: <AANLkTi=QDMw08caRXMXZcavAq-2xSYNbCGRxiAWDCvk7@mail.gmail.com>
Subject: Re: [PATCH 6/8] ath5: Remove unused CTL definitions
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/19 Bruno Randolf <br1@einfach.org>:
> They are unused in ath5k and a more detailled definition is in
> ath/regd_common.h.
>
> Signed-off-by: Bruno Randolf <br1@einfach.org>
> ---
>  drivers/net/wireless/ath/ath5k/eeprom.h |   23 -----------------------
>  1 files changed, 0 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
> index d46f105..6511c27 100644
> --- a/drivers/net/wireless/ath/ath5k/eeprom.h
> +++ b/drivers/net/wireless/ath/ath5k/eeprom.h
> @@ -268,29 +268,6 @@ enum ath5k_ctl_mode {
>        AR5K_CTL_MODE_M = 15,
>  };
>
> -/* Default CTL ids for the 3 main reg domains.
> - * Atheros only uses these by default but vendors
> - * can have up to 32 different CTLs for different
> - * scenarios. Note that theese values are ORed with
> - * the mode id (above) so we can have up to 24 CTL
> - * datasets out of these 3 main regdomains. That leaves
> - * 8 ids that can be used by vendors and since 0x20 is
> - * missing from HAL sources i guess this is the set of
> - * custom CTLs vendors can use. */
> -#define        AR5K_CTL_FCC    0x10
> -#define        AR5K_CTL_CUSTOM 0x20
> -#define        AR5K_CTL_ETSI   0x30
> -#define        AR5K_CTL_MKK    0x40
> -
> -/* Indicates a CTL with only mode set and
> - * no reg domain mapping, such CTLs are used
> - * for world roaming domains or simply when
> - * a reg domain is not set */
> -#define        AR5K_CTL_NO_REGDOMAIN   0xf0
> -
> -/* Indicates an empty (invalid) CTL */
> -#define AR5K_CTL_NO_CTL                0xff
> -
>  /* Per channel calibration data, used for power table setup */
>  struct ath5k_chan_pcal_info_rf5111 {
>        /* Power levels in half dbm units
>


Acked-by: Nick Kossifidis <mickflemm@gmail.com>



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
