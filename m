Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:54487 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3LLF65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 00:58:57 -0500
Received: by mail-la0-f43.google.com with SMTP id n7so4510865lam.16
        for <linux-wireless@vger.kernel.org>; Wed, 11 Dec 2013 21:58:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A8BA8B.6040104@gmail.com>
References: <52A40FE5.30004@gmail.com>
	<CANUX_P0iO2YdDGO6_GcBOA2A6QvUfYQNz8E2L2SjLpMPYYviuQ@mail.gmail.com>
	<52A8BA8B.6040104@gmail.com>
Date: Thu, 12 Dec 2013 07:58:55 +0200
Message-ID: <CANUX_P1VC80TAexTJfR8EQWBGfOXpQOdj75piKaaJ=to9tuRuQ@mail.gmail.com> (sfid-20131212_065900_835688_F24CE457)
Subject: Re: Random lock-ups (?) of Centrino Ultimate-N 6300 (iwlwifi)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jeremy Johnathan Rodent <rat.o.drat@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> can you please apply this and report back?
>>
>> diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c
>> b/drivers/net/wireless/iwlwifi/pcie/tx.c
>> index c5746ed..0a1f39c 100644
>> --- a/drivers/net/wireless/iwlwifi/pcie/tx.c
>> +++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
>> @@ -708,10 +708,6 @@ void iwl_pcie_tx_start(struct iwl_trans *trans,
>> u32 scd_base_addr)
>>          reg_val = iwl_read_direct32(trans, FH_TX_CHICKEN_BITS_REG);
>>          iwl_write_direct32(trans, FH_TX_CHICKEN_BITS_REG,
>>                             reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
>> -
>> -       /* Enable L1-Active */
>> -       iwl_clear_bits_prph(trans, APMG_PCIDEV_STT_REG,
>> -                           APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
>>   }
>>
>>   void iwl_trans_pcie_tx_reset(struct iwl_trans *trans)
>
> Sorry it took so long.
> I've built 3.12.3 with this patch applied. What now?

Does it help?
Do you still the same issues?
If yes - please share the log again.
