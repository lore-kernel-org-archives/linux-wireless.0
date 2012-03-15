Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32803 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2COFxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 01:53:03 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20321.33695.439509.73251@gargle.gargle.HOWL> (sfid-20120315_065309_436823_1A6F4771)
Date: Thu, 15 Mar 2012 11:22:31 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: [PATCH 03/14] ath9k_hw: remove ath9k_hw_htc_resetinit
In-Reply-To: <1331739634-22318-3-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
	<1331739634-22318-2-git-send-email-nbd@openwrt.org>
	<1331739634-22318-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Automatically set the ah->htc_reset_init on init and after PHY disable.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    1 -
>  drivers/net/wireless/ath/ath9k/hw.c           |    8 ++------
>  drivers/net/wireless/ath/ath9k/hw.h           |    3 ---
>  3 files changed, 2 insertions(+), 10 deletions(-)

ath9k_htc still has remnants of the old radio enable/disable code when
drivers were handling RFKILL events. And until that area is cleaned up,
this should probably be kept - since PHY disable is done there too, and
we are fiddling with RST/RF registers.

Sujith
