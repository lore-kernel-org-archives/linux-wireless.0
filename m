Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:50811 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966263AbeFST1K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 15:27:10 -0400
Received: by mail-wm0-f68.google.com with SMTP id e16-v6so2189904wmd.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 12:27:09 -0700 (PDT)
Subject: Re: [PATCH V2] brcmfmac: stop watchdog before detach and free
 everything
To: Kalle Valo <kvalo@codeaurora.org>
References: <1527493857-2220-1-git-send-email-michael@amarulasolutions.com>
 <5B0D1C9E.4000800@broadcom.com> <20180530090633.GA15390@panicking>
 <5B294920.5050909@broadcom.com> <87fu1izjcs.fsf@kamboji.qca.qualcomm.com>
Cc: Michael Trimarchi <michael@amarulasolutions.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B29590C.3040800@broadcom.com> (sfid-20180619_212732_496449_B62C5897)
Date: Tue, 19 Jun 2018 21:27:08 +0200
MIME-Version: 1.0
In-Reply-To: <87fu1izjcs.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/19/2018 9:06 PM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 5/30/2018 11:06 AM, Michael Trimarchi wrote:
>>> Using built-in in kernel image without a firmware in filesystem
>>> or in the kernel image can lead to a kernel NULL pointer deference.
>>> Watchdog need to be stopped in brcmf_sdio_remove
>>>
>>> The system is going down NOW!
>>> [ 1348.110759] Unable to handle kernel NULL pointer dereference at
>>> virtual address 000002f8
>>> Sent SIGTERM to all processes
>>> [ 1348.121412] Mem abort info:
>>> [ 1348.126962]   ESR = 0x96000004
>>> [ 1348.130023]   Exception class = DABT (current EL), IL = 32 bits
>>> [ 1348.135948]   SET = 0, FnV = 0
>>> [ 1348.138997]   EA = 0, S1PTW = 0
>>> [ 1348.142154] Data abort info:
>>> [ 1348.145045]   ISV = 0, ISS = 0x00000004
>>> [ 1348.148884]   CM = 0, WnR = 0
>>> [ 1348.151861] user pgtable: 4k pages, 48-bit VAs, pgdp = (____ptrval____)
>>> [ 1348.158475] [00000000000002f8] pgd=0000000000000000
>>> [ 1348.163364] Internal error: Oops: 96000004 [#1] PREEMPT SMP
>>> [ 1348.168927] Modules linked in: ipv6
>>> [ 1348.172421] CPU: 3 PID: 1421 Comm: brcmf_wdog/mmc0 Not tainted
>>> 4.17.0-rc5-next-20180517 #18
>>> [ 1348.180757] Hardware name: Amarula A64-Relic (DT)
>>> [ 1348.185455] pstate: 60000005 (nZCv daif -PAN -UAO)
>>> [ 1348.190251] pc : brcmf_sdiod_freezer_count+0x0/0x20
>>> [ 1348.195124] lr : brcmf_sdio_watchdog_thread+0x64/0x290
>>> [ 1348.200253] sp : ffff00000b85be30
>>> [ 1348.203561] x29: ffff00000b85be30 x28: 0000000000000000
>>> [ 1348.208868] x27: ffff00000b6cb918 x26: ffff80003b990638
>>> [ 1348.214176] x25: ffff0000087b1a20 x24: ffff80003b94f800
>>> [ 1348.219483] x23: ffff000008e620c8 x22: ffff000008f0b660
>>> [ 1348.224790] x21: ffff000008c6a858 x20: 00000000fffffe00
>>> [ 1348.230097] x19: ffff80003b94f800 x18: 0000000000000001
>>> [ 1348.235404] x17: 0000ffffab2e8a74 x16: ffff0000080d7de8
>>> [ 1348.240711] x15: 0000000000000000 x14: 0000000000000400
>>> [ 1348.246018] x13: 0000000000000400 x12: 0000000000000001
>>> [ 1348.251324] x11: 00000000000002c4 x10: 0000000000000a10
>>> [ 1348.256631] x9 : ffff00000b85bc40 x8 : ffff80003be11870
>>> [ 1348.261937] x7 : ffff80003dfc7308 x6 : 000000078ff08b55
>>> [ 1348.267243] x5 : 00000139e1058400 x4 : 0000000000000000
>>> [ 1348.272550] x3 : dead000000000100 x2 : 958f2788d6618100
>>> [ 1348.277856] x1 : 00000000fffffe00 x0 : 0000000000000000
>>
>> Forgot about this one.
>>
>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>
> Should this go to 4.18?

It is a bit of a corner case, but yeah let's do that.

Regards,
Arend
