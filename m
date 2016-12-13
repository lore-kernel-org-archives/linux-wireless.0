Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36574 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935046AbcLMR00 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 12:26:26 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "michal.kazior@tieto.com" <michal.kazior@tieto.com>
CC: Erik Stromdahl <erik.stromdahl@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v2 05/11] ath10k: htc: refactorization
Date: Tue, 13 Dec 2016 17:26:18 +0000
Message-ID: <871sxbzqo6.fsf@kamboji.qca.qualcomm.com> (sfid-20161213_182647_092448_02C07AEF)
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
        <1479496971-19174-6-git-send-email-erik.stromdahl@gmail.com>
        <87inqoymd0.fsf@kamboji.qca.qualcomm.com>
        <CA+BoTQkuUFxnra75B4LpF5+k9yE7hkNYDXbtUMBLq2LFuPSasg@mail.gmail.com>
In-Reply-To: <CA+BoTQkuUFxnra75B4LpF5+k9yE7hkNYDXbtUMBLq2LFuPSasg@mail.gmail.com>       (Michal
 Kazior's message of "Tue, 13 Dec 2016 14:52:41 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 13 December 2016 at 14:44, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
>> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>>
>>> Code refactorization:
>>>
>>> Moved the code for ep 0 in ath10k_htc_rx_completion_handler
>>> to ath10k_htc_control_rx_complete.
>>>
>>> This eases the implementation of SDIO/mbox significantly since
>>> the ep_rx_complete cb is invoked directly from the SDIO/mbox
>>> hif layer.
>>>
>>> Since the ath10k_htc_control_rx_complete already is present
>>> (only containing a warning message) there is no reason for not
>>> using it (instead of having a special case for ep 0 in
>>> ath10k_htc_rx_completion_handler).
>>>
>>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>>
>> I tested this on QCA988X PCI board just to see if there are any
>> regressions. It crashes immediately during module load, every time, and
>> bisected that the crashing starts on this patch:
>>
>> [ 1239.715325] ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_=
mode 0 reset_mode 0
>> [ 1239.885125] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/=
pre-cal-pci-0000:02:00.0.bin failed with error -2
>> [ 1239.885260] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/=
cal-pci-0000:02:00.0.bin failed with error -2
>> [ 1239.885687] ath10k_pci 0000:02:00.0: qca988x hw2.0 target 0x4100016c =
chip_id 0x043202ff sub 0000:0000
>> [ 1239.885699] ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracin=
g 1 dfs 1 testmode 1
>> [ 1239.885899] ath10k_pci 0000:02:00.0: firmware ver 10.2.4.70.59-2 api =
5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 4159f498
>> [ 1239.941836] ath10k_pci 0000:02:00.0: Direct firmware load for ath10k/=
QCA988X/hw2.0/board-2.bin failed with error -2
>> [ 1239.941993] ath10k_pci 0000:02:00.0: board_file api 1 bmi_id N/A crc3=
2 bebc7c08
>> [ 1241.136693] BUG: unable to handle kernel NULL pointer dereference at =
  (null)
>> [ 1241.136738] IP: [<  (null)>]   (null)
>> [ 1241.136759] *pdpt =3D 0000000000000000 *pde =3D f0002a55f0002a55 [ 12=
41.136781]
>> [ 1241.136793] Oops: 0010 [#1] SMP
>>
>> What's odd is that when I added some printks on my own and enabled both
>> boot and htc debug levels it doesn't crash anymore. After everything
>> works normally after that, I can start AP mode and connect to it. Is it
>> a race somewhere?
>
> Yes. htc_wait_target() is called after hif_start(). The ep_rx_complete
> is set in htc_wait_target() [changed patch 4, but still too late].
>
> ep_rx_complete must be set prior to calling hif_start(). You probably
> crash on end of ath10k_htc_rx_completion_handler() when trying to call
> ep->ep_ops.ep_rx_complete(ar, skb).

Yeah, just checked and ep->ep_ops.ep_rx_complete is NULL at the end of
ath10k_htc_rx_completion_handler().

--=20
Kalle Valo=
