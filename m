Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:44037 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab2DQVHz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 17:07:55 -0400
Message-ID: <4F8DDB9F.8030302@openwrt.org> (sfid-20120417_230804_249476_89B7865B)
Date: Tue, 17 Apr 2012 23:07:43 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: Gather and report IRQ sync_cause errors.
References: <1334250240-21038-1-git-send-email-greearb@candelatech.com> <1334250240-21038-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1334250240-21038-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Ben Greear <greearb@candelatech.com>
> 
> Report all defined sync_cause errors in debugfs
> to aid with debugging.
> 
> Use a macro to print out the interrupts file contents
> to decrease code duplication.

Now, that the patch is in wireless-testing, I have noticed a minor problem with it.

> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---


<...>

> diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> index aa1680a..fba99ef 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.h
> +++ b/drivers/net/wireless/ath/ath9k/hw.h
> @@ -965,6 +965,12 @@ bool ath9k_hw_check_alive(struct ath_hw *ah);
>  
>  bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
>  
> +#ifdef CONFIG_ATH9K_DEBUGFS
> +void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause);
> +#else
> +static void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause) {}

Due to a missing 'inline' keyword, this causes a bunch of warnings if
CONFIG_ATH9K_DEBUGFS is not enabled:

   CC [M]  drivers/net/wireless/ath/main.o
   CC [M]  drivers/net/wireless/ath/regd.o
   CC [M]  drivers/net/wireless/ath/hw.o
   CC [M]  drivers/net/wireless/ath/key.o
   LD [M]  drivers/net/wireless/ath/ath.o
   CC [M]  drivers/net/wireless/ath/ath9k/beacon.o
 drivers/net/wireless/ath/ath9k/hw.h:962: warning: ‘ath9k_debug_sync_cause’
defined but not used
   CC [M]  drivers/net/wireless/ath/ath9k/gpio.o
 drivers/net/wireless/ath/ath9k/hw.h:962: warning: ‘ath9k_debug_sync_cause’
defined but not used
   CC [M]  drivers/net/wireless/ath/ath9k/init.o
 drivers/net/wireless/ath/ath9k/hw.h:962: warning: ‘ath9k_debug_sync_cause’
defined but not used
   CC [M]  drivers/net/wireless/ath/ath9k/main.o
 drivers/net/wireless/ath/ath9k/hw.h:962: warning: ‘ath9k_debug_sync_cause’
defined but not used
   CC [M]  drivers/net/wireless/ath/ath9k/recv.o

-Gabor

