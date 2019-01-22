Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A458EC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 550D220823
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 16:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="BjjT8eSl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbfAVQIa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 11:08:30 -0500
Received: from mout.web.de ([212.227.15.4]:35351 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728784AbfAVQIa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 11:08:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1548173295;
        bh=QjJzPMX63maaLY89pNlwXGO6b6OAG6gFaVtIgZIZ+X0=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=BjjT8eSllBNL/cUcG+LcI7++5lK+ct/W3xKSvZuXlag31Zdp5zJXJtcSJ5b91ot0u
         OZi1AFkTWET9tXKVNxtrqWUlNsOwfaTWI84iesTzyRpBWw1WUtgn1+w3hp7CPBxiti
         lzhi3DCzQM/CU4dgfl0ortv7MumfU8eFYsp6alyI=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.57.47]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LnSKE-1hQEEK3Rx0-00hij5; Tue, 22
 Jan 2019 17:08:14 +0100
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Tony Lindgren <tony@atomide.com>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
 <258ecb6b-c2b2-c8b8-9804-4df69002d9f5@web.de>
 <CAPDyKFoqfyvQRnSBRvPVxrL-nmf1YoSzxRkPfGwr==L3LOwgaw@mail.gmail.com>
 <5bf8514a-eb15-b098-1857-835b36d4a67c@web.de>
 <CAPDyKFo=m50jiQ639xzP9tzn+=Bn0CXXwO6p0_jPH0EnSc0UQg@mail.gmail.com>
 <CAPDyKFrt3+i83x_qyTrVVCSxda_+3HpJPR6RuPBxzRHnZTRVvA@mail.gmail.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <be41bf8a-df36-7f21-7616-b1983f78b5c7@web.de>
Date:   Tue, 22 Jan 2019 17:08:13 +0100
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <CAPDyKFrt3+i83x_qyTrVVCSxda_+3HpJPR6RuPBxzRHnZTRVvA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------2E959E0919DA253B8CAFCF24"
Content-Language: en-US
X-Provags-ID: V03:K1:TbGYnw1T2RqvP8udIP7MbVRr0sBQM+YJORl0/ozJQIGFZ98rIaD
 GGRulj1+0Wn0v13+XdwirJGSNquYg5AqMOc1qQ8T0zRX/BYfYBRREeW7Myw0qUTOR6UOs21
 XiQNr0JzNKoHvmrroi5ZlAfwAgdVIQj+yLR0y7Qh4atXEV8BGZrCkWLq8jhh4xZtEOpMCSP
 9ANRZXr7MaIABF6ULTS7A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:9v+BDVBl0fg=:5kGvDp3/Jwc7dAOHjzdYDu
 2/Yj2x7BZ32qYFhMqf688t7S3YEqMWKcLtduJZKxmJn3vMJ0Q7KbqHw7fBiv1hhZn5hEeblAa
 kSuYooN/2NEcP0U3ya6H97WEavrARmBh1M+/Oe6lve3TQ0VL1ltl2mw8xgr4zQiqun0tM1Rww
 sngH7SgvRnq8+mVIRhJudYaBbu+4lPwterOf1peYKaSqDUaGhZxLrDmDDhELErPa7w0Kb0SDC
 7gX4G/+JunjGcrpsuuWKBhmeVTMyu1O/hVX2M1r+zstclWdBWddT/ylCQtab28Onc5w5M80fh
 JzGvgQrlR/1b1xRSCMTDJR6BXmeYnlCFsJwAUXabnvj/zyzWaTXntjwmwgp/y1Xdr0sa2F19F
 W1wzBdGR5MbGb02OiRwt3OvujAP99kpWy3Ox9SA8u1bYnPdHUaG2GBHkgxjs6SfEqT4aXy0E4
 k5jDHF8dTEjfkIOpFC7L9krVs43TUYjzd8JQwAsONqrw9JOJ0qt8HwgGFpJyKgItS1USfBFUY
 llRYz/EpHjr0filbkdJxMBnsO8uBOlrZyaTOaXwjKH+SJufb4SKxBGSQv/QDqzNU/yF1+lH4y
 s4sN+WNKwzLLyEoENt79+xrjrmgp8DVGpS5uJbKrfs1/4+a/Gz4j5EDcqowPmXnvpGlxzpMet
 qWoRnYG/eZIf9VjUrGsiRspNN7TE+j0G/fOApm4+VTfiRJxN3qCKeHdauS6gozKGeWJO+896F
 IGBa8Zetlp5uDEUg2TGcDFBfYtx2u8qL8jWvNWwBXfoAYhEDqDZIcglXqFcqW++YJCDZNA4IC
 cBUGSE1d3izEGGLA+evgLE1WAjXqR7ifBEM7gls2AXXNXhuZIWRNc2RpDSXvBTU165ghbCht8
 3IvoxS9YGwlmFK53m5Z8VXao617MBdcJdsilmpRngFq2bie2dKY0sqSxjEbz/Y
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a multi-part message in MIME format.
--------------2E959E0919DA253B8CAFCF24
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 21.01.19 15:40, Ulf Hansson wrote:
> On Fri, 18 Jan 2019 at 16:09, Ulf Hansson <ulf.hansson@linaro.org> wrote=
:
>>
>> On Fri, 18 Jan 2019 at 13:09, Jan Kiszka <jan.kiszka@web.de> wrote:
>>>
>>> On 17.01.19 10:54, Ulf Hansson wrote:
>>>> On Wed, 16 Jan 2019 at 21:26, Jan Kiszka <jan.kiszka@web.de> wrote:
>>>>>
>>>>> On 16.01.19 12:37, Ulf Hansson wrote:
>>>>>> During "wlan-up", we are programming the FW into the WiFi-chip. How=
ever,
>>>>>> re-programming the FW doesn't work, unless a power cycle of the WiF=
i-chip
>>>>>> is made in-between the programmings.
>>>>>>
>>>>>> To conform to this requirement and to fix the regression in a simpl=
e way,
>>>>>> let's start by allowing that the SDIO card (WiFi-chip) may stay pow=
ered on
>>>>>> (runtime resumed) when wl12xx_sdio_power_off() returns. The intent =
with the
>>>>>> current code is to treat this scenario as an error, but unfortunate=
 this
>>>>>> doesn't work as expected, so let's fix this.
>>>>>>
>>>>>> The other part is to guarantee that a power cycle of the SDIO card =
has been
>>>>>> completed when wl12xx_sdio_power_on() returns, as to allow the FW
>>>>>> programming to succeed. However, relying solely on runtime PM to de=
al with
>>>>>> this isn't sufficient. For example, userspace may prevent runtime s=
uspend
>>>>>> via sysfs for the device that represents the SDIO card, leading to =
that the
>>>>>> mmc core also keeps it powered on. For this reason, let's instead d=
o a
>>>>>> brute force power cycle in wl12xx_sdio_power_on().
>>>>>>
>>>>>> Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM hand=
ling")
>>>>>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>>>>>> ---
>>>>>>
>>>>>> Changes in v2:
>>>>>>         - Keep the SDIO host claimed when calling mmc_hw_reset().
>>>>>>         - Add a fixes tag.
>>>>>> ---
>>>>>>     drivers/net/wireless/ti/wlcore/sdio.c | 15 +++++++--------
>>>>>>     1 file changed, 7 insertions(+), 8 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wi=
reless/ti/wlcore/sdio.c
>>>>>> index bd10165d7eec..4d4b07701149 100644
>>>>>> --- a/drivers/net/wireless/ti/wlcore/sdio.c
>>>>>> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
>>>>>> @@ -164,6 +164,12 @@ static int wl12xx_sdio_power_on(struct wl12xx_=
sdio_glue *glue)
>>>>>>         }
>>>>>>
>>>>>>         sdio_claim_host(func);
>>>>>> +     /*
>>>>>> +      * To guarantee that the SDIO card is power cycled, as requir=
ed to make
>>>>>> +      * the FW programming to succeed, let's do a brute force HW r=
eset.
>>>>>> +      */
>>>>>> +     mmc_hw_reset(card->host);
>>>>>> +
>>>>>>         sdio_enable_func(func);
>>>>>>         sdio_release_host(func);
>>>>>>
>>>>>> @@ -174,20 +180,13 @@ static int wl12xx_sdio_power_off(struct wl12x=
x_sdio_glue *glue)
>>>>>>     {
>>>>>>         struct sdio_func *func =3D dev_to_sdio_func(glue->dev);
>>>>>>         struct mmc_card *card =3D func->card;
>>>>>> -     int error;
>>>>>>
>>>>>>         sdio_claim_host(func);
>>>>>>         sdio_disable_func(func);
>>>>>>         sdio_release_host(func);
>>>>>>
>>>>>>         /* Let runtime PM know the card is powered off */
>>>>>> -     error =3D pm_runtime_put(&card->dev);
>>>>>> -     if (error < 0 && error !=3D -EBUSY) {
>>>>>> -             dev_err(&card->dev, "%s failed: %i\n", __func__, erro=
r);
>>>>>> -
>>>>>> -             return error;
>>>>>> -     }
>>>>>> -
>>>>>> +     pm_runtime_put(&card->dev);
>>>>>>         return 0;
>>>>>>     }
>>>>>>
>>>>>>
>>>>>
>>>>> Just tested on both HiKey (620) and Ultra96 but it fails to fix the =
issue on
>>>>> both. I'm getting
>>>>>
>>>>> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
>>>>>
>>>>> during boot again, and the interface is not available.
>>>>
>>>> Okay, sounds like this may be a different problem then. Can you share
>>>> the complete log and the kernel config?
>>>
>>> You can find the config here [1], log from the HiKey boot attached.
>>>
>>>> I can prepare a debug patch as well, if you are willing to re-run the=
 test?
>>>
>>> Sure, send it over, I can run it.
>>
>> Alright, sounds great. However, I need to defer that to Monday/Tuesday
>> next week.
>>
>>>
>>>>
>>>> Adding a post-power-on-delay-ms of 1 ms as you suggested [1], doesn't
>>>> sounds like the correct solution to me, unless I am overlooking some
>>>> things. The point is, since the mmc core succeeds to detect and
>>>> initialize the SDIO card, the power sequence seems to be correct.
>>>
>>> Yeah, I'm not claiming at all I know what I'm doing there, just that i=
t happens
>>> to work.
>>
>> I see. Good to know, thanks!
>>
>>>
>>> Jan
>>>
>>> [1]
>>> https://github.com/siemens/jailhouse-images/blob/next/recipes-kernel/l=
inux/files/arm64_defconfig_4.19
>>
>> I have looked through the log and the defconfig. No obvious things
>> found at this point. Thanks for sharing them!
>>
>
> So, I have put together a debug patch, mostly to verify that things
> seems to be correct in regards to runtime PM. It should produce some
> prints to the log, particular during power on/off of the SDIO card and
> during probe of the wifi driver. Please re-run the test on top of the
> v2 version of the $subject patch.
>

Log attached.

Jan

--------------2E959E0919DA253B8CAFCF24
Content-Type: text/x-log;
 name="wlan.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="wlan.log"

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd033]
[    0.000000] Linux version 4.19.16 (builder@870f50503134) (gcc version 6=
.3.0 20170516 (Debian 6.3.0-18)) #1 SMP PREEMPT Tue Jan 22 15:50:59 UTC 20=
19
[    0.000000] Machine model: HiKey Development Board
[    0.000000] Memory limited to 1820MB
[    0.000000] efi: Getting EFI parameters from FDT:
[    0.000000] efi: EFI v2.60 by EDK II
[    0.000000] efi:  MEMATTR=3D0x3cd48a98
[    0.000000] Reserved memory: created CMA memory pool at 0x000000006bc00=
000, size 128 MiB
[    0.000000] OF: reserved mem: initialized node linux,cma, compatible id=
 shared-dma-pool
[    0.000000] NUMA: No NUMA configuration found
[    0.000000] NUMA: Faking a node at [mem 0x0000000000000000-0x0000000073=
ef2fff]
[    0.000000] NUMA: NODE_DATA [mem 0x73ea95c0-0x73eaad7f]
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x0000000000000000-0x0000000073ef2fff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x0000000005dfffff]
[    0.000000]   node   0: [mem 0x0000000005f00000-0x0000000005f00fff]
[    0.000000]   node   0: [mem 0x0000000005f02000-0x0000000006dfefff]
[    0.000000]   node   0: [mem 0x0000000006e00000-0x000000000740efff]
[    0.000000]   node   0: [mem 0x0000000007410000-0x0000000021efffff]
[    0.000000]   node   0: [mem 0x0000000022000000-0x0000000034ffffff]
[    0.000000]   node   0: [mem 0x00000000350f0000-0x000000003864ffff]
[    0.000000]   node   0: [mem 0x0000000038650000-0x000000003888ffff]
[    0.000000]   node   0: [mem 0x0000000038890000-0x0000000038897fff]
[    0.000000]   node   0: [mem 0x0000000038898000-0x000000003889bfff]
[    0.000000]   node   0: [mem 0x000000003889c000-0x000000003d85ffff]
[    0.000000]   node   0: [mem 0x000000003d860000-0x000000003d89ffff]
[    0.000000]   node   0: [mem 0x000000003d8a0000-0x000000003d8affff]
[    0.000000]   node   0: [mem 0x000000003d8b0000-0x000000003d8fffff]
[    0.000000]   node   0: [mem 0x000000003d900000-0x000000003dffffff]
[    0.000000]   node   0: [mem 0x0000000040000000-0x0000000073ef2fff]
[    0.000000] Reserved but unavailable: 256 pages
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x0000000073ef=
2fff]
[    0.000000] On node 0 totalpages: 465920
[    0.000000]   DMA32 zone: 7420 pages used for memmap
[    0.000000]   DMA32 zone: 0 pages reserved
[    0.000000]   DMA32 zone: 465920 pages, LIFO batch:63
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: Trusted OS migration not required
[    0.000000] psci: SMC Calling Convention v1.1
[    0.000000] random: get_random_bytes called from start_kernel+0xac/0x41=
4 with crng_init=3D0
[    0.000000] percpu: Embedded 22 pages/cpu @(____ptrval____) s53016 r819=
2 d28904 u90112
[    0.000000] pcpu-alloc: s53016 r8192 d28904 u90112 alloc=3D22*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7
[    0.000000] Detected VIPT I-cache on CPU0
[    0.000000] CPU features: enabling workaround for ARM erratum 843419
[    0.000000] CPU features: enabling workaround for ARM erratum 845719
[    0.000000] Speculative Store Bypass Disable mitigation not required
[    0.000000] CPU features: detected: Kernel page table isolation (KPTI)
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 4585=
00
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=3D/vmlinuz root=3DPARTUUID=
=3D1250070a-bba0-4399-a775-c8a68ed480bd rootwait mem=3D1820M
[    0.000000] Memory: 1676320K/1863680K available (9980K kernel code, 129=
4K rwdata, 4312K rodata, 1152K init, 371K bss, 56288K reserved, 131072K cm=
a-reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8, =
Nodes=3D1
[    0.000000] rcu: Preemptible hierarchical RCU implementation.
[    0.000000] rcu: 	RCU restricting CPUs from NR_CPUS=3D64 to nr_cpu_ids=
=3D8.
[    0.000000] 	Tasks RCU enabled.
[    0.000000] rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_id=
s=3D8
[    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
[    0.000000] GIC: Using split EOI/Deactivate mode
[    0.000000] arch_timer: cp15 timer(s) running at 1.20MHz (phys).
[    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff max_c=
ycles: 0x11b661f8e, max_idle_ns: 1763180809113 ns
[    0.000004] sched_clock: 56 bits at 1200kHz, resolution 833ns, wraps ev=
ery 4398046510838ns
[    0.000125] clocksource: arm,sp804: mask: 0xffffffff max_cycles: 0xffff=
ffff, max_idle_ns: 99544814920 ns
[    0.000134] sched_clock: 32 bits at 19MHz, resolution 52ns, wraps every=
 111848106981ns
[    0.000805] Console: colour dummy device 80x25
[    0.001354] console [tty0] enabled
[    0.001435] Calibrating delay loop (skipped), value calculated using ti=
mer frequency.. 2.40 BogoMIPS (lpj=3D4800)
[    0.001459] pid_max: default: 32768 minimum: 301
[    0.001537] Security Framework initialized
[    0.002207] Dentry cache hash table entries: 262144 (order: 9, 2097152 =
bytes)
[    0.002553] Inode-cache hash table entries: 131072 (order: 8, 1048576 b=
ytes)
[    0.002594] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes=
)
[    0.002622] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 =
bytes)
[    0.024004] ASID allocator initialised with 32768 entries
[    0.031998] rcu: Hierarchical SRCU implementation.
[    0.042077] Remapping and enabling EFI services.
[    0.048039] smp: Bringing up secondary CPUs ...
[    0.080290] Detected VIPT I-cache on CPU1
[    0.080345] CPU1: Booted secondary processor 0x0000000001 [0x410fd033]
[    0.112304] Detected VIPT I-cache on CPU2
[    0.112330] CPU2: Booted secondary processor 0x0000000002 [0x410fd033]
[    0.144364] Detected VIPT I-cache on CPU3
[    0.144387] CPU3: Booted secondary processor 0x0000000003 [0x410fd033]
[    0.176477] Detected VIPT I-cache on CPU4
[    0.176520] CPU4: Booted secondary processor 0x0000000100 [0x410fd033]
[    0.208490] Detected VIPT I-cache on CPU5
[    0.208515] CPU5: Booted secondary processor 0x0000000101 [0x410fd033]
[    0.240555] Detected VIPT I-cache on CPU6
[    0.240579] CPU6: Booted secondary processor 0x0000000102 [0x410fd033]
[    0.272618] Detected VIPT I-cache on CPU7
[    0.272642] CPU7: Booted secondary processor 0x0000000103 [0x410fd033]
[    0.272729] smp: Brought up 1 node, 8 CPUs
[    0.272861] SMP: Total of 8 processors activated.
[    0.272874] CPU features: detected: 32-bit EL0 Support
[    0.277450] CPU: All CPU(s) started at EL2
[    0.277496] alternatives: patching kernel code
[    0.278226] devtmpfs: initialized
[    0.284175] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffff=
ff, max_idle_ns: 7645041785100000 ns
[    0.284240] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.288417] pinctrl core: initialized pinctrl subsystem
[    0.289983] DMI not present or invalid.
[    0.290363] NET: Registered protocol family 16
[    0.290763] audit: initializing netlink subsys (disabled)
[    0.290910] audit: type=3D2000 audit(0.288:1): state=3Dinitialized audi=
t_enabled=3D0 res=3D1
[    0.292415] cpuidle: using governor menu
[    0.292614] vdso: 2 pages (1 code @ (____ptrval____), 1 data @ (____ptr=
val____))
[    0.292634] hw-breakpoint: found 6 breakpoint and 4 watchpoint register=
s.
[    0.298153] DMA: preallocated 256 KiB pool for atomic allocations
[    0.299352] Serial: AMBA PL011 UART driver
[    0.301621] f8015000.uart: ttyAMA0 at MMIO 0xf8015000 (irq =3D 7, base_=
baud =3D 0) is a PL011 rev2
[    0.307188] hi6220-mbox f7510000.mailbox: Mailbox enabled
[    0.320408] HugeTLB registered 2.00 MiB page size, pre-allocated 0 page=
s
[    0.320870] cryptd: max_cpu_qlen set to 1000
[    0.321606] ACPI: Interpreter disabled.
[    0.322376] VDD_3V3: supplied by SYS_5V
[    0.322802] vgaarb: loaded
[    0.323062] SCSI subsystem initialized
[    0.323258] libata version 3.00 loaded.
[    0.323572] usbcore: registered new interface driver usbfs
[    0.323623] usbcore: registered new interface driver hub
[    0.323726] usbcore: registered new device driver usb
[    0.324374] pps_core: LinuxPPS API ver. 1 registered
[    0.324388] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo=
 Giometti <giometti@linux.it>
[    0.324420] PTP clock support registered
[    0.324540] EDAC MC: Ver: 3.0.0
[    0.324881] Registered efivars operations
[    0.326251] clocksource: Switched to clocksource arch_sys_counter
[    0.326427] VFS: Disk quotas dquot_6.6.0
[    0.326486] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byt=
es)
[    0.326620] pnp: PnP ACPI: disabled
[    0.331971] NET: Registered protocol family 2
[    0.332508] tcp_listen_portaddr_hash hash table entries: 1024 (order: 2=
, 16384 bytes)
[    0.332581] TCP established hash table entries: 16384 (order: 5, 131072=
 bytes)
[    0.332726] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.332939] TCP: Hash tables configured (established 16384 bind 16384)
[    0.333051] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.333106] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.333262] NET: Registered protocol family 1
[    0.333617] RPC: Registered named UNIX socket transport module.
[    0.333631] RPC: Registered udp transport module.
[    0.333642] RPC: Registered tcp transport module.
[    0.333653] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.333671] PCI: CLS 0 bytes, default 64
[    0.333812] Unpacking initramfs...
[    0.424700] Freeing initrd memory: 2372K
[    0.428683] Initialise system trusted keyrings
[    0.428834] workingset: timestamp_bits=3D44 max_order=3D19 bucket_order=
=3D0
[    0.434485] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.435121] NFS: Registering the id_resolver key type
[    0.435153] Key type id_resolver registered
[    0.435164] Key type id_legacy registered
[    0.435181] nfs4filelayout_init: NFSv4 File Layout Driver Registering..=
.
[    0.435330] 9p: Installing v9fs 9p2000 file system support
[    0.435417] pstore: using deflate compression
[    0.437819] Key type asymmetric registered
[    0.437838] Asymmetric key parser 'x509' registered
[    0.437892] Block layer SCSI generic (bsg) driver version 0.4 loaded (m=
ajor 246)
[    0.437911] io scheduler noop registered
[    0.438035] io scheduler cfq registered (default)
[    0.438049] io scheduler mq-deadline registered
[    0.438061] io scheduler kyber registered
[    0.441198] pinctrl-single f7010000.pinmux: 159 pins, size 636
[    0.441778] pinctrl-single f7010800.pinmux: 163 pins, size 652
[    0.442135] pinctrl-single f8001800.pinmux: 30 pins, size 120
[    0.443921] pl061_gpio f8011000.gpio: PL061 GPIO chip @0x00000000f80110=
00 registered
[    0.444208] pl061_gpio f8012000.gpio: PL061 GPIO chip @0x00000000f80120=
00 registered
[    0.444401] pl061_gpio f8013000.gpio: PL061 GPIO chip @0x00000000f80130=
00 registered
[    0.444503] gpio gpiochip3: names 9 do not match number of GPIOs 8
[    0.444605] pl061_gpio f8014000.gpio: PL061 GPIO chip @0x00000000f80140=
00 registered
[    0.444781] pl061_gpio f7020000.gpio: PL061 GPIO chip @0x00000000f70200=
00 registered
[    0.444952] pl061_gpio f7021000.gpio: PL061 GPIO chip @0x00000000f70210=
00 registered
[    0.445127] pl061_gpio f7022000.gpio: PL061 GPIO chip @0x00000000f70220=
00 registered
[    0.445301] pl061_gpio f7023000.gpio: PL061 GPIO chip @0x00000000f70230=
00 registered
[    0.445405] gpio gpiochip8: names 9 do not match number of GPIOs 8
[    0.445505] pl061_gpio f7024000.gpio: PL061 GPIO chip @0x00000000f70240=
00 registered
[    0.445702] pl061_gpio f7025000.gpio: PL061 GPIO chip @0x00000000f70250=
00 registered
[    0.445890] pl061_gpio f7026000.gpio: PL061 GPIO chip @0x00000000f70260=
00 registered
[    0.446065] pl061_gpio f7027000.gpio: PL061 GPIO chip @0x00000000f70270=
00 registered
[    0.446271] pl061_gpio f7028000.gpio: PL061 GPIO chip @0x00000000f70280=
00 registered
[    0.446479] pl061_gpio f7029000.gpio: PL061 GPIO chip @0x00000000f70290=
00 registered
[    0.446654] pl061_gpio f702a000.gpio: PL061 GPIO chip @0x00000000f702a0=
00 registered
[    0.446841] pl061_gpio f702b000.gpio: PL061 GPIO chip @0x00000000f702b0=
00 registered
[    0.447015] pl061_gpio f702c000.gpio: PL061 GPIO chip @0x00000000f702c0=
00 registered
[    0.447186] pl061_gpio f702d000.gpio: PL061 GPIO chip @0x00000000f702d0=
00 registered
[    0.447372] pl061_gpio f702e000.gpio: PL061 GPIO chip @0x00000000f702e0=
00 registered
[    0.447558] pl061_gpio f702f000.gpio: PL061 GPIO chip @0x00000000f702f0=
00 registered
[    0.456262] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.457809] SuperH (H)SCI(F) driver initialized
[    0.458120] msm_serial: driver initialized
[    0.465824] loop: module loaded
[    0.472021] libphy: Fixed MDIO Bus: probed
[    0.472860] tun: Universal TUN/TAP device driver, 1.6
[    0.473851] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    0.473872] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    0.473918] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4=
.0-k
[    0.473931] igb: Copyright (c) 2007-2014 Intel Corporation.
[    0.473980] igbvf: Intel(R) Gigabit Virtual Function Network Driver - v=
ersion 2.4.0-k
[    0.473996] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    0.474270] sky2: driver version 1.30
[    0.474730] VFIO - User Level meta-driver version: 0.3
[    0.475909] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.475936] ehci-pci: EHCI PCI platform driver
[    0.475977] ehci-platform: EHCI generic platform driver
[    0.476076] ehci-orion: EHCI orion driver
[    0.476151] ehci-exynos: EHCI EXYNOS driver
[    0.476219] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.476253] ohci-pci: OHCI PCI platform driver
[    0.476296] ohci-platform: OHCI generic platform driver
[    0.476386] ohci-exynos: OHCI EXYNOS driver
[    0.476732] usbcore: registered new interface driver usb-storage
[    0.478735] rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc0
[    0.479127] rtc-pl031 f8003000.rtc: rtc core: registered pl031 as rtc1
[    0.479451] rtc-pl031 f8004000.rtc: rtc core: registered pl031 as rtc2
[    0.479983] i2c /dev entries driver
[    0.484243] sdhci: Secure Digital Host Controller Interface driver
[    0.484273] sdhci: Copyright(c) Pierre Ossman
[    0.484429] Synopsys Designware Multimedia Card Interface Driver
[    0.485017] dwmmc_k3 f723d000.dwmmc0: fifo-depth property not found, us=
ing value of FIFOTH register as default
[    0.485140] dwmmc_k3 f723d000.dwmmc0: IDMAC supports 32-bit address mod=
e.
[    0.486286] dwmmc_k3 f723d000.dwmmc0: Using internal DMA controller.
[    0.486306] dwmmc_k3 f723d000.dwmmc0: Version ID is 250a
[    0.486363] dwmmc_k3 f723d000.dwmmc0: DW MMC controller at irq 41,32 bi=
t host data width,256 deep fifo
[    0.486480] dwmmc_k3 f723d000.dwmmc0: Linked as a consumer to regulator=
.10
[    0.486559] mmc_host mmc0: card is non-removable.
[    0.498585] mmc_host mmc0: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    0.511734] dwmmc_k3 f723e000.dwmmc1: fifo-depth property not found, us=
ing value of FIFOTH register as default
[    0.511996] dwmmc_k3 f723e000.dwmmc1: IDMAC supports 32-bit address mod=
e.
[    0.512893] dwmmc_k3 f723e000.dwmmc1: Using internal DMA controller.
[    0.512914] dwmmc_k3 f723e000.dwmmc1: Version ID is 250a
[    0.512965] dwmmc_k3 f723e000.dwmmc1: DW MMC controller at irq 42,32 bi=
t host data width,128 deep fifo
[    0.513058] dwmmc_k3 f723e000.dwmmc1: Linked as a consumer to regulator=
.5
[    0.513131] dwmmc_k3 f723e000.dwmmc1: Linked as a consumer to regulator=
.4
[    0.513198] dwmmc_k3 f723e000.dwmmc1: Got CD GPIO
[    0.526150] mmc_host mmc1: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    0.540311] dwmmc_k3 f723f000.dwmmc2: fifo-depth property not found, us=
ing value of FIFOTH register as default
[    0.540450] dwmmc_k3 f723f000.dwmmc2: IDMAC supports 32-bit address mod=
e.
[    0.541504] dwmmc_k3 f723f000.dwmmc2: Using internal DMA controller.
[    0.541528] dwmmc_k3 f723f000.dwmmc2: Version ID is 250a
[    0.541580] dwmmc_k3 f723f000.dwmmc2: DW MMC controller at irq 43,32 bi=
t host data width,128 deep fifo
[    0.541678] dwmmc_k3 f723f000.dwmmc2: Linked as a consumer to regulator=
.2
[    0.541760] dwmmc_k3 f723f000.dwmmc2: allocated mmc-pwrseq
[    0.541776] mmc_host mmc2: card is non-removable.
[    0.541896] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    0.554372] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    0.567010] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.569070] ledtrig-cpu: registered to indicate activity on CPUs
[    0.570064] usbcore: registered new interface driver usbhid
[    0.570087] usbhid: USB HID core driver
[    0.571877] NET: Registered protocol family 10
[    0.572489] Segment Routing with IPv6
[    0.572548] NET: Registered protocol family 17
[    0.572616] 9pnet: Installing 9P2000 support
[    0.572690] Key type dns_resolver registered
[    0.573216] registered taskstats version 1
[    0.573229] Loading compiled-in X.509 certificates
[    0.578841] f7111000.uart: ttyAMA1 at MMIO 0xf7111000 (irq =3D 8, base_=
baud =3D 0) is a PL011 rev2
[    0.579405] f7112000.uart: ttyAMA2 at MMIO 0xf7112000 (irq =3D 9, base_=
baud =3D 0) is a PL011 rev2
[    0.579754] f7113000.uart: ttyAMA3 at MMIO 0xf7113000 (irq =3D 10, base=
_baud =3D 0) is a PL011 rev2
[    0.580809] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_power_off clk_d=
isable_unprepare()
[    0.584406] mmc_host mmc0: Bus speed (slot 0) =3D 198400000Hz (slot req=
 200000000Hz, actual 198400000HZ div =3D 0)
[    0.584840] mmc0: new HS200 MMC card at address 0001
[    0.585647] mmcblk0: mmc0:0001 H8G1e=05 7.28 GiB
[    0.586215] console [ttyAMA3] enabled
[    0.586326] mmcblk0boot0: mmc0:0001 H8G1e=05 partition 1 4.00 MiB
[    0.586920] mmcblk0boot1: mmc0:0001 H8G1e=05 partition 2 4.00 MiB
[    0.587058] mmcblk0rpmb: mmc0:0001 H8G1e=05 partition 3 4.00 MiB, chard=
ev (241:0)
[    0.590367]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9
[    0.600720] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    0.604750] 5V_HUB: supplied by SYS_5V
[    0.618550] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
300000Hz, actual 295238HZ div =3D 42)
[    0.620103] ssp-pl022 f7106000.spi: ARM PL022 driver, device ID: 0x0004=
1022
[    0.648998] dwmmc_k3 f723f000.dwmmc2: card claims to support voltages b=
elow defined range
[    0.652706] ssp-pl022 f7106000.spi: mapped registers from 0x00000000f71=
06000 to (____ptrval____)
[    0.698032] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
25000000Hz, actual 24800000HZ div =3D 0)
[    0.703415] ssp-pl022 f7106000.spi: Failed to work in dma mode, work wi=
thout dma!
[    0.709637] mmc (null): mmc_attach_sdio Enabled runtime PM()
[    0.719864] phy phy-soc:usbphy.0: Linked as a consumer to regulator.13
[    0.725031] random: fast init done
[    0.729308] dwc2 f72c0000.usb: f72c0000.usb supply vusb_d not found, us=
ing dummy regulator
[    0.736405] mmc2: new SDIO card at address 0001
[    0.741034] dwc2 f72c0000.usb: Linked as a consumer to regulator.0
[    2.247186] dwc2 f72c0000.usb: f72c0000.usb supply vusb_a not found, us=
ing dummy regulator
[    2.247462] mmc mmc2:0001: mmc_attach_sdio pm_runtime_put()
[    2.255571] mmc_host mmc1: Bus speed (slot 0) =3D 99200000Hz (slot req =
100000000Hz, actual 99200000HZ div =3D 0)
[    2.261083] mmc mmc2:0001: mmc_sdio_runtime_suspend
[    2.270923] mmc1: new ultra high speed SDR50 SDHC card at address 1234
[    2.275843] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_power_off clk_d=
isable_unprepare()
[    2.283288] mmcblk1: mmc1:1234 SA16G 14.6 GiB
[    2.291814] mmc mmc2:0001: mmc_sdio_runtime_suspend - DONE
[    2.301156] GPT:Primary header thinks Alt. header is not at the end of =
the disk.
[    2.308588] GPT:755225 !=3D 30703615
[    2.312008] GPT:Alternate GPT header not at the end of the disk.
[    2.318034] GPT:755225 !=3D 30703615
[    2.321451] GPT: Use GNU Parted to correct GPT errors.
[    2.326634]  mmcblk1: p1 p2
[    2.490661] dwc2 f72c0000.usb: EPs: 16, dedicated fifos, 1920 entries i=
n SPRAM
[    2.500154] dwc2 f72c0000.usb: DWC OTG Controller
[    2.504920] dwc2 f72c0000.usb: new USB bus registered, assigned bus num=
ber 1
[    2.512023] dwc2 f72c0000.usb: irq 39, io mem 0xf72c0000
[    2.518435] hub 1-0:1.0: USB hub found
[    2.522226] hub 1-0:1.0: 1 port detected
[    2.528390] rtc-efi rtc-efi: setting system clock to 1970-01-01 00:00:1=
3 UTC (13)
[    2.536174] LDO2_2V8: disabling
[    2.539338] LDO13_1V8: disabling
[    2.542577] LDO14_2V8: disabling
[    2.545810] LDO17_2V5: disabling
[    2.549423] uart-pl011 f7113000.uart: no DMA platform data
[    2.555375] Freeing unused kernel memory: 1152K
[    2.559995] Run /init as init process
[    2.591174] random: systemd-udevd: uninitialized urandom read (16 bytes=
 read)
[    2.594870] random: udevadm: uninitialized urandom read (16 bytes read)
[    2.598927] random: systemd-udevd: uninitialized urandom read (16 bytes=
 read)
[    2.922606] dwc2 f72c0000.usb: Set speed to high-speed
[    2.927796] usb 1-1: new high-speed USB device number 2 using dwc2
[    3.122609] dwc2 f72c0000.usb: Set speed to high-speed
[    3.149712] hub 1-1:1.0: USB hub found
[    3.154043] hub 1-1:1.0: 3 ports detected
[    3.439743] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data m=
ode. Opts: (null)
[    3.788928] systemd[1]: System time before build time, advancing clock.
[    3.823109] systemd[1]: systemd 232 running in system mode. (+PAM +AUDI=
T +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +G=
NUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    3.841569] systemd[1]: Detected architecture arm64.
[    3.863341] systemd[1]: Set hostname to <demo>.
[    4.102781] systemd[1]: Listening on Journal Socket.
[    4.123099] systemd[1]: Created slice System Slice.
[    4.148749] systemd[1]: Starting Load Kernel Modules...
[    4.166761] systemd[1]: Listening on Journal Audit Socket.
[    4.187161] systemd[1]: Created slice system-serial\x2dgetty.slice.
[    4.204064] jailhouse: loading out-of-tree module taints kernel.
[    4.221264] systemd[1]: Mounting Huge Pages File System...
[    4.238907] systemd[1]: Listening on /dev/initctl Compatibility Named P=
ipe.
[    4.372111] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[    4.888925] systemd-journald[1590]: Received request to flush runtime j=
ournal from PID 1
[    5.069003] random: crng init done
[    5.069013] random: 7 urandom warning(s) missed due to ratelimiting
[    5.792047] k3-dma f7370000.dma: initialized
[    6.216442] mmc mmc2:0001: mmc_sdio_runtime_resume
[    6.216476] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    6.226783] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
300000Hz, actual 295238HZ div =3D 42)
[    6.251465] mmc mmc2:0001: mmc_sdio_runtime_resume - ret=3D-110 DONE
[    6.251543] wl1271_sdio mmc2:0001:1: sdio_bus_probe
[    6.251550] wl1271_sdio mmc2:0001:1: sdio_bus_probe - pm_runtime_get_sy=
nc()
[    6.251557] wl1271_sdio mmc2:0001:1: sdio_bus_probe - ERR call pm_runti=
me_put_noidle()
[    6.251573] wl1271_sdio: probe of mmc2:0001:1 failed with error -16
[    6.251612] wl1271_sdio mmc2:0001:2: sdio_bus_probe
[    6.251618] wl1271_sdio mmc2:0001:2: sdio_bus_probe - pm_runtime_get_sy=
nc()
[    6.251623] wl1271_sdio mmc2:0001:2: sdio_bus_probe - ERR call pm_runti=
me_put_noidle()
[    6.251631] wl1271_sdio: probe of mmc2:0001:2 failed with error -16
[    6.329559] EXT4-fs (mmcblk1p2): resizing filesystem from 359164 to 153=
33356 blocks
[   13.573757] EXT4-fs (mmcblk1p2): resized filesystem to 15333356

--------------2E959E0919DA253B8CAFCF24--
