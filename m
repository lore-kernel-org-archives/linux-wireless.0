Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:60675 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933089AbbLWG2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 01:28:45 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Joe Perches <joe@perches.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 44/45] iwlwifi: fix printf specifier
Date: Wed, 23 Dec 2015 06:28:40 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E94D2D2@hasmsx107.ger.corp.intel.com> (sfid-20151223_072850_034412_9F564D5D)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
 <1450731046-2796-44-git-send-email-emmanuel.grumbach@intel.com>
 <1450843714.3537.8.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/23/2015 06:08 AM, Joe Perches wrote:
> On Mon, 2015-12-21 at 22:50 +0200, Emmanuel Grumbach wrote:
>> Smatch warned about a bad specifier being used. Fix that.
> I see nothing here other than a signed/unsigned
> issue that shouldn't need fixing.  The conversion
> from hex to decimal may not be useful.

Yes so maybe I could just use the 0x%x specifier since
printk-formats.txt seems to say that 0x%x is good for s32 as well. Seems
that the "02" makes it "unsigned only".
Printing those values in hexadecimal is annoying anyway since we usually
express Tx power in decimal.
Thanks for pointing that out!

>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> ---
>>  drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
>> index b395854..c15f5be 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
>> @@ -454,11 +454,11 @@ static void iwl_eeprom_enhanced_txpower(struct device *dev,
>>  				 TXP_CHECK_AND_PRINT(COMMON_TYPE),
>>  				 txp->flags);
>>  		IWL_DEBUG_EEPROM(dev,
>> -				 "\t\t chain_A: 0x%02x chain_B: 0X%02x chain_C: 0X%02x\n",
>> +				 "\t\t chain_A: %d chain_B: %d chain_C: %d\n",
>>  				 txp->chain_a_max, txp->chain_b_max,
>>  				 txp->chain_c_max);
>>  		IWL_DEBUG_EEPROM(dev,
>> -				 "\t\t MIMO2: 0x%02x MIMO3: 0x%02x High 20_on_40: 0x%02x Low 20_on_40: 0x%02x\n",
>> +				 "\t\t MIMO2: %d MIMO3: %d High 20_on_40: 0x%02x Low 20_on_40: 0x%02x\n",
>>  				 txp->mimo2_max, txp->mimo3_max,
>>  				 ((txp->delta_20_in_40 & 0xf0) >> 4),
>>  				 (txp->delta_20_in_40 & 0x0f));
>

