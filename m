Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31433 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008Ab1EMPP6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:15:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 08:15:29 -0700
Message-ID: <4DCD4B29.2020505@atheros.com> (sfid-20110513_171603_708074_D1D5963C)
Date: Fri, 13 May 2011 20:45:53 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Kent Chuang <Kent.Chuang@Atheros.com>,
	Ming-Yi Lin <Ming-Yi.Lin@Atheros.com>
Subject: Re: [PATCH 0/9] ath9k: Add Antenna diversity support for AR9485
References: <1305298667-3212-1-git-send-email-mshajakhan@atheros.com>
In-Reply-To: <1305298667-3212-1-git-send-email-mshajakhan@atheros.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 13 May 2011 08:27 PM, Mohammed Shajakhan wrote:
> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>
> *This patch set adds Antenna diversity support for AR9485, previously
>   antenna diversity is only supported in AR9285
> *The basic antenna diversity algorithm remains the same
> *slight change in the diversity field in eeprom
> *introduction of main/alt gain table and lna1_lna2 delta fields
> *initially set LNA1 for main antenna
> *introduction of diversity group
> *based on diversity group, fast diversity bias parmaters and
> lna1_lna2_delta varies
> *implement an API to take the decision of swapping main/ALT LNA's
> for AR9485
> *configure fast diversity bias based on diversity group
>
> Mohammed Shafi Shajakhan (9):
>    ath9k_hw: make antenna diversity modules chip specific
>    ath9k_hw: enable Antenna diversity for AR9485
>    ath9k_hw: define registers/macros to support Antenna diversity
>    ath9k_hw: config diversity based on eeprom contents
>    ath9k_hw: define modules to get/set Antenna diversity paramaters
>    ath9k_hw: define antenna diversity group
>    ath9k: Implement an API to swap main/ALT LNA's
>    ath9k: configure fast_div_bias based on diversity group
>    ath9k: make sure main_rssi is positive
>
>   drivers/net/wireless/ath/ath9k/ar9002_phy.c    |   44 +++---
>   drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   50 +++++-
>   drivers/net/wireless/ath/ath9k/ar9003_phy.c    |   46 +++++
>   drivers/net/wireless/ath/ath9k/ar9003_phy.h    |   22 +++
>   drivers/net/wireless/ath/ath9k/ath9k.h         |    1 -
>   drivers/net/wireless/ath/ath9k/hw-ops.h        |   12 ++
>   drivers/net/wireless/ath/ath9k/hw.c            |   16 ++
>   drivers/net/wireless/ath/ath9k/hw.h            |   13 +-
>   drivers/net/wireless/ath/ath9k/recv.c          |  211 ++++++++++++++++++------
>   9 files changed, 337 insertions(+), 78 deletions(-)
>
> .
>
hi all,
	mostly this will never happen. in case you get a card with antenna 
diversity not enabled in your eeprom settings, please try to do this 
manually in the driver by the following way. even this itself is 
sufficient to boost the Rx(may be Tx) throughput tremendously when you 
use a single antenna in the Tx/Rx chain!
thanks to Kent Chaung.

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c 
b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index d76a1bd..0aa62ee 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3038,7 +3038,7 @@ static u32 ath9k_hw_ar9300_get_eeprom(struct 
ath_hw *ah,
         case EEP_CHAIN_MASK_REDUCE:
                 return (pBase->miscConfiguration >> 0x3) & 0x1;
         case EEP_ANT_DIV_CTL1:
-               return le32_to_cpu(eep->base_ext1.ant_div_control);
+               return le32_to_cpu(0xc9);
         default:
                 return 0;
         }
