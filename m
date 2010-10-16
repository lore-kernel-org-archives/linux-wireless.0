Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:17821 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0JPLpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Oct 2010 07:45:09 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 16 Oct 2010 04:44:59 -0700
Date: Sat, 16 Oct 2010 17:21:02 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 1/6] ath9k_hw: optimize interrupt mask changes
Message-ID: <20101016115041.GA4028@vmraj-lnx.users.atheros.com>
References: <1287165813-94331-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1287165813-94331-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 15, 2010 at 11:33:28PM +0530, Felix Fietkau wrote:
> @@ -751,8 +751,8 @@ chip_reset:
>  	ath_debug_stat_interrupt(sc, status);
>  
>  	if (sched) {
> -		/* turn off every interrupt except SWBA */
> -		ath9k_hw_set_interrupts(ah, (ah->imask & ATH9K_INT_SWBA));
> +		/* turn off every interrupt */
> +		ath9k_hw_disable_interrupts(ah);

won't it affect beacon generation?

- Rajkumar
