Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36761 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab3LPLRQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 06:17:16 -0500
Message-ID: <52AEE12F.5020008@openwrt.org> (sfid-20131216_121720_660096_148F833C)
Date: Mon, 16 Dec 2013 12:17:03 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 06/11] ath9k_hw: remove ah->config.pcie_clock_req
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>	<1387040625-38114-6-git-send-email-nbd@openwrt.org> <21166.30518.304613.545323@gargle.gargle.HOWL>
In-Reply-To: <21166.30518.304613.545323@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-16 04:44, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> -	if (ah->config.pcie_clock_req)
>> -		INIT_INI_ARRAY(&ah->iniPcieSerdes,
>> -			   ar9280PciePhy_clkreq_off_L1_9280);
>> -	else
>> -		INIT_INI_ARRAY(&ah->iniPcieSerdes,
>> -			   ar9280PciePhy_clkreq_always_on_L1_9280);
>> +	INIT_INI_ARRAY(&ah->iniPcieSerdes,
>> +		       ar9280PciePhy_clkreq_always_on_L1_9280);
>>  
>>  	if (AR_SREV_9287_11_OR_LATER(ah)) {
>>  		INIT_INI_ARRAY(&ah->iniModes, ar9287Modes_9287_1_1);
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>> index a403cfc..eeb0741 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -446,7 +446,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
>>  	ah->config.additional_swba_backoff = 0;
>>  	ah->config.ack_6mb = 0x0;
>>  	ah->config.cwm_ignore_extcca = 0;
>> -	ah->config.pcie_clock_req = 0;
>>  	ah->config.analog_shiftreg = 1;
> 
> Please leave this in the driver, this has to be set for selected
> cards. I'll look at the Windows registry and add platform support.
Fine with me, let's leave this one out and merge the others (if there
aren't any other issues).

- Felix
