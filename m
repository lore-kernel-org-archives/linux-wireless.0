Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32847 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754112AbdASSIh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 13:08:37 -0500
Subject: Re: [PATCH] rtlwifi: rtl8192x: Enabling and disabling hardware
 interrupts after enabling local irq flags
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>
References: <1484820854-16719-1-git-send-email-bharatku@xilinx.com>
 <trinity-12e38a0e-85af-457b-9d4e-3c40ab1f6fd1-1484836538110@3capp-gmx-bs75>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        netdev@vger.kernel.org, rgummal@xilinx.com,
        Bharat Kumar Gogada <bharatku@xilinx.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <294d2858-2554-1b51-3142-b0470423537a@lwfinger.net> (sfid-20170119_190857_542148_46EC2CFA)
Date: Thu, 19 Jan 2017 12:08:34 -0600
MIME-Version: 1.0
In-Reply-To: <trinity-12e38a0e-85af-457b-9d4e-3c40ab1f6fd1-1484836538110@3capp-gmx-bs75>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/19/2017 08:35 AM, Lino Sanfilippo wrote:
> Hi,
>
> altek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
>> index a47be73..143766c4 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
>> @@ -1306,9 +1306,9 @@ void rtl92ce_enable_interrupt(struct ieee80211_hw *hw)
>>  	struct rtl_priv *rtlpriv = rtl_priv(hw);
>>  	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
>>
>> +	rtlpci->irq_enabled = true;
>>  	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
>>  	rtl_write_dword(rtlpriv, REG_HIMRE, rtlpci->irq_mask[1] & 0xFFFFFFFF);
>> -	rtlpci->irq_enabled = true;
>>  }
>>
>>  void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
>> @@ -1316,9 +1316,9 @@ void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
>>  	struct rtl_priv *rtlpriv = rtl_priv(hw);
>>  	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
>>
>> +	rtlpci->irq_enabled = false;
>>  	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
>>  	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
>> -	rtlpci->irq_enabled = false;
>>  }
>>
>
> AFAIK you also have to use memory barriers here to ensure that
> the concerning instructions are not reordered, and both irq handler
> and process have a consistent perception of irq_enabled, e.g:
>
> rtlpci->irq_enabled = true;
> smp_wmb();
> rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
>
> and in the irq handler
>
> if (rtlpci->irq_enabled == 0) {
>         smp_rmb();
> 	return ret;
> }

I can see the potential race condition between setting interrupts and setting 
the flag, and I will likely accept Bharat's patch after testing.

I am likely displaying my ignorance regarding instruction reordering, but what 
compiler/cpu combination is likely to move a simple set operation after a call 
to an external routine? Is the smp_wmb() operation really needed? I am also 
unsure of the smp_rmb() call in the interrupt handler. Neither instruction 
should cause any problems, but I'm not sure they are needed.

Larry
