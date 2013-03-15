Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51642 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab3COBci (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 21:32:38 -0400
Message-ID: <51427A2D.9090900@openwrt.org> (sfid-20130315_023242_433742_7628AF83)
Date: Fri, 15 Mar 2013 02:32:29 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.8 1/3] ath9k_hw: fix calibration issues on chainmask
 that don't include chain 0
References: <1358715322-46447-1-git-send-email-nbd@openwrt.org> <5138A4C8.7040500@neratec.com> <5138AB4A.7000405@openwrt.org> <5138B656.5090408@neratec.com> <513996DE.6030500@neratec.com> <5139B35D.9060803@neratec.com> <5139DCAA.8050003@openwrt.org> <513D78C8.5020708@neratec.com> <513DA74B.7000205@neratec.com> <514264C6.2080204@openwrt.org>
In-Reply-To: <514264C6.2080204@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-15 1:01 AM, Felix Fietkau wrote:
> On 2013-03-11 10:43 AM, Wojciech Dubowik wrote:
>> This could be the solution if you are ok with it.
>> Wojtek
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c 
>> b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
>> index 4cc1394..58c6256 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
>> @@ -1023,7 +1023,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
>> AR_PHY_AGC_CONTROL_FLTR_CAL   |
>> AR_PHY_AGC_CONTROL_PKDET_CAL;
>> 
>> -       ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, 
>> ah->caps.tx_chainmask);
>> +       ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
> I will do some testing, but I think this will probably be equivalent to
> a revert of the patch.
Please try this patch instead:
---
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1023,6 +1023,7 @@ static bool ar9003_hw_init_cal(struct at
 					  AR_PHY_AGC_CONTROL_FLTR_CAL   |
 					  AR_PHY_AGC_CONTROL_PKDET_CAL;
 
+	/* Use chip chainmask only for calibration */
 	ar9003_hw_set_chain_masks(ah, ah->caps.rx_chainmask, ah->caps.tx_chainmask);
 
 	if (rtt) {
@@ -1150,6 +1151,9 @@ skip_tx_iqcal:
 		ar9003_hw_rtt_disable(ah);
 	}
 
+	/* Revert chainmask to runtime parameters */
+	ar9003_hw_set_chain_masks(ah, ah->rxchainmask, ah->txchainmask);
+
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 

