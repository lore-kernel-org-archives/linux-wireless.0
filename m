Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751501AbdF1Ska (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 14:40:30 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [v2 01/20] rsi: changes in eeprom read frame
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
        <1497624881-2315-2-git-send-email-amit.karwar@redpinesignals.com>
Date: Wed, 28 Jun 2017 21:40:26 +0300
In-Reply-To: <1497624881-2315-2-git-send-email-amit.karwar@redpinesignals.com>
        (Amitkumar Karwar's message of "Fri, 16 Jun 2017 20:24:22 +0530")
Message-ID: <87h8z02bxh.fsf@purkki.adurom.net> (sfid-20170628_204034_472107_E7DC82FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> writes:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>
> EEPROM read frame is sent during device initialization to read mac address.
> The format of the frame is modified in firmware to include eeprom length
> and offset. This frame does not return firmware version now. Also same
> frame is sent again to read rf type and band information.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

[...]

> --- a/drivers/net/wireless/rsi/rsi_main.h
> +++ b/drivers/net/wireless/rsi/rsi_main.h
> @@ -37,6 +37,7 @@ enum RSI_FSM_STATES {
>  	FSM_COMMON_DEV_PARAMS_SENT,
>  	FSM_BOOT_PARAMS_SENT,
>  	FSM_EEPROM_READ_MAC_ADDR,
> +	FSM_EEPROM_READ_RF_TYPE,
>  	FSM_RESET_MAC_SENT,
>  	FSM_RADIO_CAPS_SENT,
>  	FSM_BB_RF_PROG_SENT,

Shouldn't you also update fsm_state array, just like Colin fixed earlier
this week:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=58828680af495bc4863af3a006f2018c71714665

I think a some kind of build time check for this is in order, should be
doable with BUILD_BUG_ON().

-- 
Kalle Valo
