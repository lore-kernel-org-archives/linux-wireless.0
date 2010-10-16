Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49877 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab0JPNKP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Oct 2010 09:10:15 -0400
Message-ID: <4CB9A433.5050007@openwrt.org>
Date: Sat, 16 Oct 2010 15:10:11 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 1/6] ath9k_hw: optimize interrupt mask changes
References: <1287165813-94331-1-git-send-email-nbd@openwrt.org> <20101016115041.GA4028@vmraj-lnx.users.atheros.com>
In-Reply-To: <20101016115041.GA4028@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-16 1:51 PM, Rajkumar Manoharan wrote:
> On Fri, Oct 15, 2010 at 11:33:28PM +0530, Felix Fietkau wrote:
>> @@ -751,8 +751,8 @@ chip_reset:
>>  	ath_debug_stat_interrupt(sc, status);
>>  
>>  	if (sched) {
>> -		/* turn off every interrupt except SWBA */
>> -		ath9k_hw_set_interrupts(ah, (ah->imask & ATH9K_INT_SWBA));
>> +		/* turn off every interrupt */
>> +		ath9k_hw_disable_interrupts(ah);
> 
> won't it affect beacon generation?
No, because the original code did not leave SWBA interrupts enabled
either, as it was masking out ATH9K_INT_GLOBAL. So far I haven't seen
issues with beacons under high load, even on slow embedded hardware.

- Felix
