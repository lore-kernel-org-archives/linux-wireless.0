Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33025 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753084AbdATQaI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 11:30:08 -0500
Subject: Re: [PATCH] rtlwifi: rtl8192x: Enabling and disabling hardware
 interrupts after enabling local irq flags
To: Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        "chaoming_li@realsil.com.cn" <chaoming_li@realsil.com.cn>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1484820854-16719-1-git-send-email-bharatku@xilinx.com>
 <b2e783f6-fa09-e287-8119-266299cdae22@lwfinger.net>
 <8520D5D51A55D047800579B094147198263CA86D@XAP-PVEXMBX02.xlnx.xilinx.com>
Cc: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ravikiran Gummaluri <rgummal@xilinx.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <07fff87e-4dc2-f7b1-76f1-263be2410905@lwfinger.net> (sfid-20170120_173012_702244_B09CE471)
Date: Fri, 20 Jan 2017 10:30:05 -0600
MIME-Version: 1.0
In-Reply-To: <8520D5D51A55D047800579B094147198263CA86D@XAP-PVEXMBX02.xlnx.xilinx.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2017 08:14 AM, Bharat Kumar Gogada wrote:
>  > On 01/19/2017 04:14 AM, Bharat Kumar Gogada wrote:
>>> -Realtek 8192CE chipset maintains local irq flags after enabling/disabling
>>> hardware interrupts.
>>> -Hardware interrupts are enabled before enabling the local irq
>>> flags(these flags are being checked in interrupt handler),
>>> leading to race condition on some RP, where the irq line between
>>> bridge and GIC goes high at ASSERT_INTx and goes low only
>>> at DEASSERT_INTx. In this kind of RP by the time ASSERT_INTx is seen
>>> irq_enable flag is still set to false, resulting in continuous
>>> interrupts seen by CPU as DEASSERT_INTx cannot be sent since
>>> flag is still false and making CPU stall.
>>> -Changing the sequence of setting these irq flags.
>>>
>>> Signed-off-by: Bharat Kumar Gogada <bharatku@xilinx.com>
>>> ---
>>
>> This patch should be enhanced with the smb_xx() calls as suggested by by Lino.
>>
>> The subject should be changed. I would suggest something like "rtlwifi:
>> rtl8192ce: Prevent race condition when enabling interrupts", as it explains the
>> condition you are preventing.
>>
>> The other PCI drivers also have the same problem. Do you want to prepare the
>> patches, or should I do it?
>>
> Thanks Larry. Please send out the patches adding the above enhancements suggested by Lino.

I have prepared a patch fixing all the drivers. By the way, what CPU hardware 
showed this problem?

Larry
