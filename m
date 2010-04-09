Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:33563 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755874Ab0DIVN1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 17:13:27 -0400
Message-ID: <4BBF986F.3090704@openwrt.org>
Date: Fri, 09 Apr 2010 23:13:19 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 073/102] ath9k_hw: move AR9280 PCI EEPROM fix to ar9002_hw.c
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>	 <1270754858-26266-74-git-send-email-lrodriguez@atheros.com> <1270847076.23853.48.camel@mj>
In-Reply-To: <1270847076.23853.48.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-04-09 11:04 PM, Pavel Roskin wrote:
> On Thu, 2010-04-08 at 15:27 -0400, Luis R. Rodriguez wrote:
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/ar9002_hw.c |   56 ++++++++++++++++++++++++++++
>>  drivers/net/wireless/ath/ath9k/hw.c        |   56 +---------------------------
>>  drivers/net/wireless/ath/ath9k/hw.h        |    1 +
>>  3 files changed, 58 insertions(+), 55 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
>> index ecc0699..487cd8d 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
>> @@ -479,6 +479,62 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
>>  	}
>>  }
>>  
>> +static u32 ar9280_pci_hw_def_ini_fixup(struct ath_hw *ah,
>> +				       struct ar5416_eeprom_def *pEepData,
>> +				       u32 reg,
>> +				       u32 value)
>> +{
>> +#define PWDCL_KIND	(pBase->pwdclkind << AR_AN_TOP2_PWDCLKIND_S);
>> +	struct base_eep_header *pBase = &(pEepData->baseEepHeader);
>> +	struct ath_common *common = ath9k_hw_common(ah);
>> +
>> +	switch (ah->hw_version.devid) {
>> +	case AR9280_DEVID_PCI:
>> +		if (reg == 0x7894) {
> 
> Too late.  My patch is in wireless-testing already.  This will need to
> be rebased.  Sorry for the trouble.
> 
> And by the way, the ini data is also modified in set_addac routines for
> AR9160.  Once it's fixed, the casts that allow writing to the ini data
> should be removed.
Don't worry, I already took care of the rebase, a new series will be
posted soon. I'm still working on fixing some of the new tx code.

- Felix
