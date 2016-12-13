Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35357 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933689AbcLMShf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 13:37:35 -0500
Received: by mail-lf0-f66.google.com with SMTP id p100so4413399lfg.2
        for <linux-wireless@vger.kernel.org>; Tue, 13 Dec 2016 10:37:33 -0800 (PST)
Subject: Re: [RFC v2 05/11] ath10k: htc: refactorization
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
 <1479496971-19174-6-git-send-email-erik.stromdahl@gmail.com>
 <87inqoymd0.fsf@kamboji.qca.qualcomm.com>
 <CA+BoTQkuUFxnra75B4LpF5+k9yE7hkNYDXbtUMBLq2LFuPSasg@mail.gmail.com>
 <871sxbzqo6.fsf@kamboji.qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <70b8a055-e6ba-857d-8b03-06f50e3f10fe@gmail.com> (sfid-20161213_193738_787319_36ED7802)
Date: Tue, 13 Dec 2016 19:37:30 +0100
MIME-Version: 1.0
In-Reply-To: <871sxbzqo6.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/13/2016 06:26 PM, Valo, Kalle wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
> 
>> On 13 December 2016 at 14:44, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>>>
>>>> Code refactorization:
>>>>
>>>> Moved the code for ep 0 in ath10k_htc_rx_completion_handler
>>>> to ath10k_htc_control_rx_complete.
>>>>
>>>> This eases the implementation of SDIO/mbox significantly since
>>>> the ep_rx_complete cb is invoked directly from the SDIO/mbox
>>>> hif layer.
>>>>
>>>> Since the ath10k_htc_control_rx_complete already is present
>>>> (only containing a warning message) there is no reason for not
>>>> using it (instead of having a special case for ep 0 in
>>>> ath10k_htc_rx_completion_handler).
>>>>
>>>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>>>
>>> I tested this on QCA988X PCI board just to see if there are any
>>> regressions. It crashes immediately during module load, every time, and
>>> bisected that the crashing starts on this patch:
>>>
>>> [ 1239.715325] ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
>>> [ 1239.885125] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/pre-cal-pci-0000:02:00.0.bin failed with error -2
>>> [ 1239.885260] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/cal-pci-0000:02:00.0.bin failed with error -2
>>> [ 1239.885687] ath10k_pci 0000:02:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff sub 0000:0000
>>> [ 1239.885699] ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
>>> [ 1239.885899] ath10k_pci 0000:02:00.0: firmware ver 10.2.4.70.59-2 api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 4159f498
>>> [ 1239.941836] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/QCA988X/hw2.0/board-2.bin failed with error -2
>>> [ 1239.941993] ath10k_pci 0000:02:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
>>> [ 1241.136693] BUG: unable to handle kernel NULL pointer dereference at   (null)
>>> [ 1241.136738] IP: [<  (null)>]   (null)
>>> [ 1241.136759] *pdpt = 0000000000000000 *pde = f0002a55f0002a55 [ 1241.136781]
>>> [ 1241.136793] Oops: 0010 [#1] SMP
>>>
>>> What's odd is that when I added some printks on my own and enabled both
>>> boot and htc debug levels it doesn't crash anymore. After everything
>>> works normally after that, I can start AP mode and connect to it. Is it
>>> a race somewhere?
>>
>> Yes. htc_wait_target() is called after hif_start(). The ep_rx_complete
>> is set in htc_wait_target() [changed patch 4, but still too late].
>>
>> ep_rx_complete must be set prior to calling hif_start(). You probably
>> crash on end of ath10k_htc_rx_completion_handler() when trying to call
>> ep->ep_ops.ep_rx_complete(ar, skb).
> 
> Yeah, just checked and ep->ep_ops.ep_rx_complete is NULL at the end of
> ath10k_htc_rx_completion_handler().
> 
It is indeed correct as Michal points out, there is a risk that the
first HTC control message (typically an HTC ready message) is received
before the HTC control endpoint is connected.

I have experienced a similar race with my SDIO implementation as well.
In this case I did solve the issue by enabling HIF target interrupts
after the HTC control endpoint was connected. I am not sure however if
this is the most elegant way to solve this problem.

My SDIO target won't send the HTC ready message before this is done.
The fix essentially consists of moving the ..._irg_enable call from
hif_start into another hif op.

I have made a few updates since I submitted the original RFC and created
a repo on github:

https://github.com/erstrom/linux-ath

I have a bunch of branches that are all based on the tags on the ath master.

As of this moment the latest version is:

ath-201612131156-ath10k-sdio

This branch contains the original RFC patches plus some addons/fixes.

In the above mentioned branch there are a few commits related to this
race condition. Perhaps you can have a look at them?

The commits are:
821672913328cf737c9616786dc28d2e4e8a4a90
dd7fcf0a1f78e68876d14f90c12bd37f3a700ad7
7434b7b40875bd08a3a48a437ba50afed7754931

Perhaps this approach can work with PCIe as well?

/Erik
