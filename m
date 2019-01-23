Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD11C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 20:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA530218A2
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 20:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="iF9k7PKZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbfAWURw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 15:17:52 -0500
Received: from mout.web.de ([212.227.15.4]:55859 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726035AbfAWURw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 15:17:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1548274657;
        bh=2n6QQDAc9E9g9i/5XIblQohIT4STGXFOl6wgtznzMRc=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=iF9k7PKZGJ5DjeFNMfu1MyCkkmH71lUb44vmY9yPPrMPKRqhZQ0Nrf7ejw8nFCmuo
         f5Tbd+j0P8tS9LCRrAUttS/yERXXMFStVGf63JGn65CMfuyScY6Og3/Qj0uKV9Gcl4
         OOctD1/zMEqVFNKIhVszjyMKNgk8b0KzyDsZqyuQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.57.47]) by smtp.web.de (mrweb002
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0M2dt7-1h5Ahg06FB-00sJjF; Wed, 23
 Jan 2019 21:17:37 +0100
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
 <be41bf8a-df36-7f21-7616-b1983f78b5c7@web.de>
 <CAPDyKFpj1yU0dDWjZnJN5uqkjcQSy=3gRo1=6grAfdTTD6Z+zg@mail.gmail.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <179da213-d7e1-74c5-8f67-fcbf6337264f@web.de>
Date:   Wed, 23 Jan 2019 21:17:34 +0100
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <CAPDyKFpj1yU0dDWjZnJN5uqkjcQSy=3gRo1=6grAfdTTD6Z+zg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------20CAF90CF3CE4D80A7FDD059"
Content-Language: en-US
X-Provags-ID: V03:K1:W3g7iWrB5PiQvthc+EbVxLnAy2nBscjrV7SWWcF2dTW5qEIeegw
 Q1dv6K5WZt0MDb/J3wmBNFi+vj4IAXVpmJioquysAi4WnBcN5X0kaNJVBccDE4lS18IX/iC
 iwNCjR6+BWS62iPSfCMoOqtZNAF6a2ZBZrvn/XKbbJirUvSq8o34Br+4N3NPfAjbCktlNe9
 +ISbAfvh0FOp4TRBhXzlQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2t2gi0RErs4=:FYrBsFfoUaklPWkUnt5bgh
 KIHL635HYXY1RNJMcVKeg6iC2YQTjdczUzrgsfI4Q5dejomxcujUgh/Ff4MTTcxr9hZt3aIxo
 WNamcCv2eVCBwsrtjrvltAspMbdSDtwibT/9+21WN7QZ5SBt1Ny8ISUNFkFnRknFyRnLSStp9
 1QujVvs6+bOaRopXQ6KTeUXRMO5nFQsBw9Hlr8TgidsjpTFkrRvGgLd1ZwKUDH4lpspYpChDT
 DUrRZlTYVndvPdcmml1OM7xd08wQS3U4YztQptzZZIr41gZwf64cKJ0qKqQULBOnIs5O+3T5w
 axX9iIPLtxd1hx1e1hGqgr+wcj55wTc6A0jpXiXSRuaylLpeegfXBj9DIJEiJpgPBM4YrWf97
 oAL0djPWDt9bdo20/d15gzRZqeRRsr7HMrT6W/vm41+0PHKvMaGJ1xL+teUkw9EuNhwPDNNPd
 SDOU7DmUQHFqsL9Bc5sJAf8MrSokeAc+pJEVcBzHNoWHFLQgQN18bvJbZ0EaaKQ37ww3Bno13
 wLwUyeiRCnAQVrj8IMGgK/MXoXTuvnvxH5AZqEi+GYl8L3j87d9ubCNOh9Nzpv7/JUqusLDPt
 H6gxD5bsJxhmMAnI3nYqQvOYv9UUORuTOO3CdWEjPt8MTzHCZ4CR2vNgGH0I8XzcWU+WwSYkF
 HuKGknKRQR1zPSWUuGMR4vefFLeU+V4+7J0/ICqNQZUFbDnAt/Xn485kYK+cEJ7PxOpgICqsB
 rlHUQI7EJDQqg6jsqbM7T6ZTkDwHTGgmWIrQIMHKgp6pL4rYKtv7Ct2bxwFo560HnixVKXhS9
 +QYpvz1MDjTepSvNJz8EYqeYSorxGjzlGeOp25y/s7Qlc8y3wgfNX2mWJumtcDl0/WLglP+T7
 CcnyVBTHxnEtiB0CjVnW9EeoWs39XZs8brOWZ4hhoWMnNWnUr0rfm4DsPp1GQP
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a multi-part message in MIME format.
--------------20CAF90CF3CE4D80A7FDD059
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 23.01.19 09:50, Ulf Hansson wrote:
> On Tue, 22 Jan 2019 at 17:08, Jan Kiszka <jan.kiszka@web.de> wrote:
>>
>> On 21.01.19 15:40, Ulf Hansson wrote:
>>> On Fri, 18 Jan 2019 at 16:09, Ulf Hansson <ulf.hansson@linaro.org> wro=
te:
>>>>
>>>> On Fri, 18 Jan 2019 at 13:09, Jan Kiszka <jan.kiszka@web.de> wrote:
>>>>>
>>>>> On 17.01.19 10:54, Ulf Hansson wrote:
>>>>>> On Wed, 16 Jan 2019 at 21:26, Jan Kiszka <jan.kiszka@web.de> wrote:
>>>>>>>
>>>>>>> On 16.01.19 12:37, Ulf Hansson wrote:
>>>>>>>> During "wlan-up", we are programming the FW into the WiFi-chip. H=
owever,
>>>>>>>> re-programming the FW doesn't work, unless a power cycle of the W=
iFi-chip
>>>>>>>> is made in-between the programmings.
>>>>>>>>
>>>>>>>> To conform to this requirement and to fix the regression in a sim=
ple way,
>>>>>>>> let's start by allowing that the SDIO card (WiFi-chip) may stay p=
owered on
>>>>>>>> (runtime resumed) when wl12xx_sdio_power_off() returns. The inten=
t with the
>>>>>>>> current code is to treat this scenario as an error, but unfortuna=
te this
>>>>>>>> doesn't work as expected, so let's fix this.
>>>>>>>>
>>>>>>>> The other part is to guarantee that a power cycle of the SDIO car=
d has been
>>>>>>>> completed when wl12xx_sdio_power_on() returns, as to allow the FW
>>>>>>>> programming to succeed. However, relying solely on runtime PM to =
deal with
>>>>>>>> this isn't sufficient. For example, userspace may prevent runtime=
 suspend
>>>>>>>> via sysfs for the device that represents the SDIO card, leading t=
o that the
>>>>>>>> mmc core also keeps it powered on. For this reason, let's instead=
 do a
>>>>>>>> brute force power cycle in wl12xx_sdio_power_on().
>>>>>>>>
>>>>>>>> Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM ha=
ndling")
>>>>>>>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>>>>>>>> ---
>>>>>>>>
>>>>>>>> Changes in v2:
>>>>>>>>          - Keep the SDIO host claimed when calling mmc_hw_reset()=
.
>>>>>>>>          - Add a fixes tag.
>>>>>>>> ---
>>>>>>>>      drivers/net/wireless/ti/wlcore/sdio.c | 15 +++++++--------
>>>>>>>>      1 file changed, 7 insertions(+), 8 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/=
wireless/ti/wlcore/sdio.c
>>>>>>>> index bd10165d7eec..4d4b07701149 100644
>>>>>>>> --- a/drivers/net/wireless/ti/wlcore/sdio.c
>>>>>>>> +++ b/drivers/net/wireless/ti/wlcore/sdio.c
>>>>>>>> @@ -164,6 +164,12 @@ static int wl12xx_sdio_power_on(struct wl12x=
x_sdio_glue *glue)
>>>>>>>>          }
>>>>>>>>
>>>>>>>>          sdio_claim_host(func);
>>>>>>>> +     /*
>>>>>>>> +      * To guarantee that the SDIO card is power cycled, as requ=
ired to make
>>>>>>>> +      * the FW programming to succeed, let's do a brute force HW=
 reset.
>>>>>>>> +      */
>>>>>>>> +     mmc_hw_reset(card->host);
>>>>>>>> +
>>>>>>>>          sdio_enable_func(func);
>>>>>>>>          sdio_release_host(func);
>>>>>>>>
>>>>>>>> @@ -174,20 +180,13 @@ static int wl12xx_sdio_power_off(struct wl1=
2xx_sdio_glue *glue)
>>>>>>>>      {
>>>>>>>>          struct sdio_func *func =3D dev_to_sdio_func(glue->dev);
>>>>>>>>          struct mmc_card *card =3D func->card;
>>>>>>>> -     int error;
>>>>>>>>
>>>>>>>>          sdio_claim_host(func);
>>>>>>>>          sdio_disable_func(func);
>>>>>>>>          sdio_release_host(func);
>>>>>>>>
>>>>>>>>          /* Let runtime PM know the card is powered off */
>>>>>>>> -     error =3D pm_runtime_put(&card->dev);
>>>>>>>> -     if (error < 0 && error !=3D -EBUSY) {
>>>>>>>> -             dev_err(&card->dev, "%s failed: %i\n", __func__, er=
ror);
>>>>>>>> -
>>>>>>>> -             return error;
>>>>>>>> -     }
>>>>>>>> -
>>>>>>>> +     pm_runtime_put(&card->dev);
>>>>>>>>          return 0;
>>>>>>>>      }
>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>> Just tested on both HiKey (620) and Ultra96 but it fails to fix th=
e issue on
>>>>>>> both. I'm getting
>>>>>>>
>>>>>>> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
>>>>>>>
>>>>>>> during boot again, and the interface is not available.
>>>>>>
>>>>>> Okay, sounds like this may be a different problem then. Can you sha=
re
>>>>>> the complete log and the kernel config?
>>>>>
>>>>> You can find the config here [1], log from the HiKey boot attached.
>>>>>
>>>>>> I can prepare a debug patch as well, if you are willing to re-run t=
he test?
>>>>>
>>>>> Sure, send it over, I can run it.
>>>>
>>>> Alright, sounds great. However, I need to defer that to Monday/Tuesda=
y
>>>> next week.
>>>>
>>>>>
>>>>>>
>>>>>> Adding a post-power-on-delay-ms of 1 ms as you suggested [1], doesn=
't
>>>>>> sounds like the correct solution to me, unless I am overlooking som=
e
>>>>>> things. The point is, since the mmc core succeeds to detect and
>>>>>> initialize the SDIO card, the power sequence seems to be correct.
>>>>>
>>>>> Yeah, I'm not claiming at all I know what I'm doing there, just that=
 it happens
>>>>> to work.
>>>>
>>>> I see. Good to know, thanks!
>>>>
>>>>>
>>>>> Jan
>>>>>
>>>>> [1]
>>>>> https://github.com/siemens/jailhouse-images/blob/next/recipes-kernel=
/linux/files/arm64_defconfig_4.19
>>>>
>>>> I have looked through the log and the defconfig. No obvious things
>>>> found at this point. Thanks for sharing them!
>>>>
>>>
>>> So, I have put together a debug patch, mostly to verify that things
>>> seems to be correct in regards to runtime PM. It should produce some
>>> prints to the log, particular during power on/off of the SDIO card and
>>> during probe of the wifi driver. Please re-run the test on top of the
>>> v2 version of the $subject patch.
>>>
>>
>> Log attached.
>
> Thanks! Okay, so the re-initialization of the SDIO card is failing,
> that's very valuable information.
>
> I noticed one difference while comparing your log with the one I
> received (offlist) from Anders... In your case the initialization
> frequency that works the first time is 300KHz, while in Anders case
> it's 100KHz. This sounds a bit fishy to me, so maybe there are some
> problems with the pwrseq after all.
>
> Let me think a bit and see what I can come up with as a possible solutio=
n.
>
> In the meantime, can you re-run the test with same debug patch, but
> change the post-power-on-delay-ms to let's say 10 ms in the DTS? I am
> going to ask Anders to do the same test on his side, as to see if we
> get different values of the found initialization frequency.

Here is a log with 10 ms power-on-delay.

Jan

--------------20CAF90CF3CE4D80A7FDD059
Content-Type: text/x-log;
 name="wlan-ok.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="wlan-ok.log"

[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x410fd033]
[    0.000000] Linux version 4.19.16 (builder@a9d1a77f2ff6) (gcc version 6=
.3.0 20170516 (Debian 6.3.0-18)) #1 SMP PREEMPT Wed Jan 23 17:59:41 UTC 20=
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
=3D2aa1d65d-cfdc-4ffa-b59c-c70cb3e25633 rootwait mem=3D1820M
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
[    0.000126] clocksource: arm,sp804: mask: 0xffffffff max_cycles: 0xffff=
ffff, max_idle_ns: 99544814920 ns
[    0.000135] sched_clock: 32 bits at 19MHz, resolution 52ns, wraps every=
 111848106981ns
[    0.000801] Console: colour dummy device 80x25
[    0.001349] console [tty0] enabled
[    0.001433] Calibrating delay loop (skipped), value calculated using ti=
mer frequency.. 2.40 BogoMIPS (lpj=3D4800)
[    0.001457] pid_max: default: 32768 minimum: 301
[    0.001534] Security Framework initialized
[    0.002211] Dentry cache hash table entries: 262144 (order: 9, 2097152 =
bytes)
[    0.002554] Inode-cache hash table entries: 131072 (order: 8, 1048576 b=
ytes)
[    0.002596] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes=
)
[    0.002624] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 =
bytes)
[    0.024001] ASID allocator initialised with 32768 entries
[    0.031997] rcu: Hierarchical SRCU implementation.
[    0.042067] Remapping and enabling EFI services.
[    0.048040] smp: Bringing up secondary CPUs ...
[    0.080291] Detected VIPT I-cache on CPU1
[    0.080345] CPU1: Booted secondary processor 0x0000000001 [0x410fd033]
[    0.112305] Detected VIPT I-cache on CPU2
[    0.112331] CPU2: Booted secondary processor 0x0000000002 [0x410fd033]
[    0.144364] Detected VIPT I-cache on CPU3
[    0.144388] CPU3: Booted secondary processor 0x0000000003 [0x410fd033]
[    0.176479] Detected VIPT I-cache on CPU4
[    0.176519] CPU4: Booted secondary processor 0x0000000100 [0x410fd033]
[    0.208491] Detected VIPT I-cache on CPU5
[    0.208516] CPU5: Booted secondary processor 0x0000000101 [0x410fd033]
[    0.240557] Detected VIPT I-cache on CPU6
[    0.240580] CPU6: Booted secondary processor 0x0000000102 [0x410fd033]
[    0.272621] Detected VIPT I-cache on CPU7
[    0.272645] CPU7: Booted secondary processor 0x0000000103 [0x410fd033]
[    0.272733] smp: Brought up 1 node, 8 CPUs
[    0.272864] SMP: Total of 8 processors activated.
[    0.272877] CPU features: detected: 32-bit EL0 Support
[    0.277459] CPU: All CPU(s) started at EL2
[    0.277506] alternatives: patching kernel code
[    0.278231] devtmpfs: initialized
[    0.284194] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffff=
ff, max_idle_ns: 7645041785100000 ns
[    0.284259] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    0.288449] pinctrl core: initialized pinctrl subsystem
[    0.290020] DMI not present or invalid.
[    0.290393] NET: Registered protocol family 16
[    0.290790] audit: initializing netlink subsys (disabled)
[    0.290922] audit: type=3D2000 audit(0.288:1): state=3Dinitialized audi=
t_enabled=3D0 res=3D1
[    0.292454] cpuidle: using governor menu
[    0.292657] vdso: 2 pages (1 code @ (____ptrval____), 1 data @ (____ptr=
val____))
[    0.292678] hw-breakpoint: found 6 breakpoint and 4 watchpoint register=
s.
[    0.298210] DMA: preallocated 256 KiB pool for atomic allocations
[    0.299481] Serial: AMBA PL011 UART driver
[    0.301783] f8015000.uart: ttyAMA0 at MMIO 0xf8015000 (irq =3D 7, base_=
baud =3D 0) is a PL011 rev2
[    0.307567] hi6220-mbox f7510000.mailbox: Mailbox enabled
[    0.320751] HugeTLB registered 2.00 MiB page size, pre-allocated 0 page=
s
[    0.321189] cryptd: max_cpu_qlen set to 1000
[    0.321948] ACPI: Interpreter disabled.
[    0.322765] VDD_3V3: supplied by SYS_5V
[    0.323184] vgaarb: loaded
[    0.323435] SCSI subsystem initialized
[    0.323651] libata version 3.00 loaded.
[    0.323953] usbcore: registered new interface driver usbfs
[    0.324002] usbcore: registered new interface driver hub
[    0.324107] usbcore: registered new device driver usb
[    0.324960] pps_core: LinuxPPS API ver. 1 registered
[    0.324974] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo=
 Giometti <giometti@linux.it>
[    0.325006] PTP clock support registered
[    0.325128] EDAC MC: Ver: 3.0.0
[    0.325428] Registered efivars operations
[    0.326780] clocksource: Switched to clocksource arch_sys_counter
[    0.326965] VFS: Disk quotas dquot_6.6.0
[    0.327023] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 byt=
es)
[    0.327163] pnp: PnP ACPI: disabled
[    0.332699] NET: Registered protocol family 2
[    0.333225] tcp_listen_portaddr_hash hash table entries: 1024 (order: 2=
, 16384 bytes)
[    0.333310] TCP established hash table entries: 16384 (order: 5, 131072=
 bytes)
[    0.333467] TCP bind hash table entries: 16384 (order: 6, 262144 bytes)
[    0.333678] TCP: Hash tables configured (established 16384 bind 16384)
[    0.333789] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.333846] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.333998] NET: Registered protocol family 1
[    0.334352] RPC: Registered named UNIX socket transport module.
[    0.334365] RPC: Registered udp transport module.
[    0.334376] RPC: Registered tcp transport module.
[    0.334388] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.334405] PCI: CLS 0 bytes, default 64
[    0.334542] Unpacking initramfs...
[    0.425489] Freeing initrd memory: 2372K
[    0.429435] Initialise system trusted keyrings
[    0.429581] workingset: timestamp_bits=3D44 max_order=3D19 bucket_order=
=3D0
[    0.435281] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    0.435949] NFS: Registering the id_resolver key type
[    0.435981] Key type id_resolver registered
[    0.435992] Key type id_legacy registered
[    0.436009] nfs4filelayout_init: NFSv4 File Layout Driver Registering..=
.
[    0.436165] 9p: Installing v9fs 9p2000 file system support
[    0.436251] pstore: using deflate compression
[    0.438738] Key type asymmetric registered
[    0.438758] Asymmetric key parser 'x509' registered
[    0.438839] Block layer SCSI generic (bsg) driver version 0.4 loaded (m=
ajor 246)
[    0.438858] io scheduler noop registered
[    0.439004] io scheduler cfq registered (default)
[    0.439019] io scheduler mq-deadline registered
[    0.439030] io scheduler kyber registered
[    0.442121] pinctrl-single f7010000.pinmux: 159 pins, size 636
[    0.442672] pinctrl-single f7010800.pinmux: 163 pins, size 652
[    0.443068] pinctrl-single f8001800.pinmux: 30 pins, size 120
[    0.444788] pl061_gpio f8011000.gpio: PL061 GPIO chip @0x00000000f80110=
00 registered
[    0.445019] pl061_gpio f8012000.gpio: PL061 GPIO chip @0x00000000f80120=
00 registered
[    0.445191] pl061_gpio f8013000.gpio: PL061 GPIO chip @0x00000000f80130=
00 registered
[    0.445293] gpio gpiochip3: names 9 do not match number of GPIOs 8
[    0.445396] pl061_gpio f8014000.gpio: PL061 GPIO chip @0x00000000f80140=
00 registered
[    0.445568] pl061_gpio f7020000.gpio: PL061 GPIO chip @0x00000000f70200=
00 registered
[    0.445753] pl061_gpio f7021000.gpio: PL061 GPIO chip @0x00000000f70210=
00 registered
[    0.445931] pl061_gpio f7022000.gpio: PL061 GPIO chip @0x00000000f70220=
00 registered
[    0.446116] pl061_gpio f7023000.gpio: PL061 GPIO chip @0x00000000f70230=
00 registered
[    0.446208] gpio gpiochip8: names 9 do not match number of GPIOs 8
[    0.446306] pl061_gpio f7024000.gpio: PL061 GPIO chip @0x00000000f70240=
00 registered
[    0.446491] pl061_gpio f7025000.gpio: PL061 GPIO chip @0x00000000f70250=
00 registered
[    0.446697] pl061_gpio f7026000.gpio: PL061 GPIO chip @0x00000000f70260=
00 registered
[    0.446925] pl061_gpio f7027000.gpio: PL061 GPIO chip @0x00000000f70270=
00 registered
[    0.447119] pl061_gpio f7028000.gpio: PL061 GPIO chip @0x00000000f70280=
00 registered
[    0.447315] pl061_gpio f7029000.gpio: PL061 GPIO chip @0x00000000f70290=
00 registered
[    0.447494] pl061_gpio f702a000.gpio: PL061 GPIO chip @0x00000000f702a0=
00 registered
[    0.447686] pl061_gpio f702b000.gpio: PL061 GPIO chip @0x00000000f702b0=
00 registered
[    0.447871] pl061_gpio f702c000.gpio: PL061 GPIO chip @0x00000000f702c0=
00 registered
[    0.448064] pl061_gpio f702d000.gpio: PL061 GPIO chip @0x00000000f702d0=
00 registered
[    0.448243] pl061_gpio f702e000.gpio: PL061 GPIO chip @0x00000000f702e0=
00 registered
[    0.448432] pl061_gpio f702f000.gpio: PL061 GPIO chip @0x00000000f702f0=
00 registered
[    0.457044] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.458604] SuperH (H)SCI(F) driver initialized
[    0.458944] msm_serial: driver initialized
[    0.466574] loop: module loaded
[    0.472927] libphy: Fixed MDIO Bus: probed
[    0.473747] tun: Universal TUN/TAP device driver, 1.6
[    0.474730] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    0.474753] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    0.474827] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.4=
.0-k
[    0.474842] igb: Copyright (c) 2007-2014 Intel Corporation.
[    0.474886] igbvf: Intel(R) Gigabit Virtual Function Network Driver - v=
ersion 2.4.0-k
[    0.474902] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[    0.475163] sky2: driver version 1.30
[    0.475622] VFIO - User Level meta-driver version: 0.3
[    0.476795] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.476818] ehci-pci: EHCI PCI platform driver
[    0.476858] ehci-platform: EHCI generic platform driver
[    0.476957] ehci-orion: EHCI orion driver
[    0.477032] ehci-exynos: EHCI EXYNOS driver
[    0.477105] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.477137] ohci-pci: OHCI PCI platform driver
[    0.477178] ohci-platform: OHCI generic platform driver
[    0.477261] ohci-exynos: OHCI EXYNOS driver
[    0.477611] usbcore: registered new interface driver usb-storage
[    0.479541] rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc0
[    0.479903] rtc-pl031 f8003000.rtc: rtc core: registered pl031 as rtc1
[    0.480211] rtc-pl031 f8004000.rtc: rtc core: registered pl031 as rtc2
[    0.480731] i2c /dev entries driver
[    0.484962] sdhci: Secure Digital Host Controller Interface driver
[    0.484992] sdhci: Copyright(c) Pierre Ossman
[    0.485166] Synopsys Designware Multimedia Card Interface Driver
[    0.485765] dwmmc_k3 f723d000.dwmmc0: fifo-depth property not found, us=
ing value of FIFOTH register as default
[    0.485889] dwmmc_k3 f723d000.dwmmc0: IDMAC supports 32-bit address mod=
e.
[    0.486903] dwmmc_k3 f723d000.dwmmc0: Using internal DMA controller.
[    0.486924] dwmmc_k3 f723d000.dwmmc0: Version ID is 250a
[    0.486990] dwmmc_k3 f723d000.dwmmc0: DW MMC controller at irq 41,32 bi=
t host data width,256 deep fifo
[    0.487113] dwmmc_k3 f723d000.dwmmc0: Linked as a consumer to regulator=
.10
[    0.487193] mmc_host mmc0: card is non-removable.
[    0.500101] mmc_host mmc0: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    0.513254] dwmmc_k3 f723e000.dwmmc1: fifo-depth property not found, us=
ing value of FIFOTH register as default
[    0.513517] dwmmc_k3 f723e000.dwmmc1: IDMAC supports 32-bit address mod=
e.
[    0.514226] dwmmc_k3 f723e000.dwmmc1: Using internal DMA controller.
[    0.514247] dwmmc_k3 f723e000.dwmmc1: Version ID is 250a
[    0.514298] dwmmc_k3 f723e000.dwmmc1: DW MMC controller at irq 42,32 bi=
t host data width,128 deep fifo
[    0.514403] dwmmc_k3 f723e000.dwmmc1: Linked as a consumer to regulator=
.5
[    0.514453] dwmmc_k3 f723e000.dwmmc1: Linked as a consumer to regulator=
.4
[    0.514520] dwmmc_k3 f723e000.dwmmc1: Got CD GPIO
[    0.527407] mmc_host mmc1: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    0.541535] dwmmc_k3 f723f000.dwmmc2: fifo-depth property not found, us=
ing value of FIFOTH register as default
[    0.541674] dwmmc_k3 f723f000.dwmmc2: IDMAC supports 32-bit address mod=
e.
[    0.542630] dwmmc_k3 f723f000.dwmmc2: Using internal DMA controller.
[    0.542653] dwmmc_k3 f723f000.dwmmc2: Version ID is 250a
[    0.542703] dwmmc_k3 f723f000.dwmmc2: DW MMC controller at irq 43,32 bi=
t host data width,128 deep fifo
[    0.542824] dwmmc_k3 f723f000.dwmmc2: Linked as a consumer to regulator=
.2
[    0.542910] dwmmc_k3 f723f000.dwmmc2: allocated mmc-pwrseq
[    0.542926] mmc_host mmc2: card is non-removable.
[    0.543046] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    0.574948] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    0.588535] sdhci-pltfm: SDHCI platform and OF driver helper
[    0.589747] mmc_host mmc0: Bus speed (slot 0) =3D 198400000Hz (slot req=
 200000000Hz, actual 198400000HZ div =3D 0)
[    0.590218] mmc0: new HS200 MMC card at address 0001
[    0.591431] ledtrig-cpu: registered to indicate activity on CPUs
[    0.591933] mmcblk0: mmc0:0001 H8G1e=05 7.28 GiB
[    0.592628] mmcblk0boot0: mmc0:0001 H8G1e=05 partition 1 4.00 MiB
[    0.592959] usbcore: registered new interface driver usbhid
[    0.592977] usbhid: USB HID core driver
[    0.593340] mmcblk0boot1: mmc0:0001 H8G1e=05 partition 2 4.00 MiB
[    0.593494] mmcblk0rpmb: mmc0:0001 H8G1e=05 partition 3 4.00 MiB, chard=
ev (241:0)
[    0.594671] mmc_host mmc1: Bus speed (slot 0) =3D 99200000Hz (slot req =
100000000Hz, actual 99200000HZ div =3D 0)
[    0.594724] mmc1: new ultra high speed SDR50 SDHC card at address 1234
[    0.594917] dwmmc_k3 f723f000.dwmmc2: card claims to support voltages b=
elow defined range
[    0.595199] NET: Registered protocol family 10
[    0.595964] mmcblk1: mmc1:1234 SA16G 14.6 GiB
[    0.596108] Segment Routing with IPv6
[    0.596206] NET: Registered protocol family 17
[    0.596273] 9pnet: Installing 9P2000 support
[    0.596343] Key type dns_resolver registered
[    0.596959] registered taskstats version 1
[    0.596978] Loading compiled-in X.509 certificates
[    0.597659]  mmcblk0: p1 p2 p3 p4 p5 p6 p7 p8 p9
[    0.602127]  mmcblk1: p1 p2
[    0.602869] f7111000.uart: ttyAMA1 at MMIO 0xf7111000 (irq =3D 8, base_=
baud =3D 0) is a PL011 rev2
[    0.603351] f7112000.uart: ttyAMA2 at MMIO 0xf7112000 (irq =3D 9, base_=
baud =3D 0) is a PL011 rev2
[    0.603821] f7113000.uart: ttyAMA3 at MMIO 0xf7113000 (irq =3D 10, base=
_baud =3D 0) is a PL011 rev2
[    0.777768] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
25000000Hz, actual 24800000HZ div =3D 0)
[    0.777784] mmc (null): mmc_attach_sdio Enabled runtime PM()
[    1.184324] random: fast init done
[    1.189466] console [ttyAMA3] enabled
[    2.218195] 5V_HUB: supplied by SYS_5V
[    2.222613] ssp-pl022 f7106000.spi: ARM PL022 driver, device ID: 0x0004=
1022
[    2.229737] ssp-pl022 f7106000.spi: mapped registers from 0x00000000f71=
06000 to (____ptrval____)
[    2.238604] ssp-pl022 f7106000.spi: Failed to work in dma mode, work wi=
thout dma!
[    2.246119] mmc2: new SDIO card at address 0001
[    2.250884] mmc mmc2:0001: mmc_attach_sdio pm_runtime_put()
[    2.256626] mmc mmc2:0001: mmc_sdio_runtime_suspend
[    2.261567] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_power_off clk_d=
isable_unprepare()
[    2.271185] mmc mmc2:0001: mmc_sdio_runtime_suspend - DONE
[    2.277843] phy phy-soc:usbphy.0: Linked as a consumer to regulator.13
[    2.285272] dwc2 f72c0000.usb: f72c0000.usb supply vusb_d not found, us=
ing dummy regulator
[    2.293638] dwc2 f72c0000.usb: Linked as a consumer to regulator.0
[    2.299839] dwc2 f72c0000.usb: f72c0000.usb supply vusb_a not found, us=
ing dummy regulator
[    2.515191] dwc2 f72c0000.usb: EPs: 16, dedicated fifos, 1920 entries i=
n SPRAM
[    2.524180] dwc2 f72c0000.usb: DWC OTG Controller
[    2.528954] dwc2 f72c0000.usb: new USB bus registered, assigned bus num=
ber 1
[    2.536046] dwc2 f72c0000.usb: irq 39, io mem 0xf72c0000
[    2.542413] hub 1-0:1.0: USB hub found
[    2.546222] hub 1-0:1.0: 1 port detected
[    2.552410] rtc-efi rtc-efi: setting system clock to 1970-01-01 00:00:1=
3 UTC (13)
[    2.560169] LDO2_2V8: disabling
[    2.563340] LDO13_1V8: disabling
[    2.566573] LDO14_2V8: disabling
[    2.569814] LDO17_2V5: disabling
[    2.573421] uart-pl011 f7113000.uart: no DMA platform data
[    2.579353] Freeing unused kernel memory: 1152K
[    2.583976] Run /init as init process
[    2.613909] random: systemd-udevd: uninitialized urandom read (16 bytes=
 read)
[    2.617366] random: udevadm: uninitialized urandom read (16 bytes read)
[    2.621636] random: systemd-udevd: uninitialized urandom read (16 bytes=
 read)
[    2.943139] dwc2 f72c0000.usb: Set speed to high-speed
[    2.948330] usb 1-1: new high-speed USB device number 2 using dwc2
[    3.139132] dwc2 f72c0000.usb: Set speed to high-speed
[    3.166187] hub 1-1:1.0: USB hub found
[    3.170415] hub 1-1:1.0: 3 ports detected
[    3.497735] EXT4-fs (mmcblk1p2): mounted filesystem with ordered data m=
ode. Opts: (null)
[    3.880254] systemd[1]: System time before build time, advancing clock.
[    3.919810] systemd[1]: systemd 232 running in system mode. (+PAM +AUDI=
T +SELINUX +IMA +APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +G=
NUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    3.938260] systemd[1]: Detected architecture arm64.
[    3.960044] systemd[1]: Set hostname to <demo>.
[    4.202660] systemd[1]: Reached target Remote File Systems.
[    4.223196] systemd[1]: Listening on /dev/initctl Compatibility Named P=
ipe.
[    4.247522] systemd[1]: Listening on Journal Audit Socket.
[    4.267212] systemd[1]: Listening on Journal Socket (/dev/log).
[    4.287267] systemd[1]: Started Dispatch Password Requests to Console D=
irectory Watch.
[    4.311077] systemd[1]: Reached target Swap.
[    4.327134] systemd[1]: Started Forward Password Requests to Wall Direc=
tory Watch.
[    4.498311] EXT4-fs (mmcblk1p2): re-mounted. Opts: (null)
[    4.647830] jailhouse: loading out-of-tree module taints kernel.
[    5.158443] systemd-journald[1592]: Received request to flush runtime j=
ournal from PID 1
[    5.201856] k3-dma f7370000.dma: initialized
[    5.274730] mmc mmc2:0001: mmc_sdio_runtime_resume
[    5.274813] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    5.311065] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    5.352148] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
25000000Hz, actual 24800000HZ div =3D 0)
[    5.352169] mmc mmc2:0001: mmc_sdio_runtime_resume - ret=3D0 DONE
[    5.352237] wl1271_sdio mmc2:0001:1: sdio_bus_probe
[    5.352244] wl1271_sdio mmc2:0001:1: sdio_bus_probe - pm_runtime_get_sy=
nc()
[    5.352251] wl1271_sdio mmc2:0001:1: sdio_bus_runtime_resume
[    5.352303] wl1271_sdio mmc2:0001:1: sdio_bus_probe - ERR call pm_runti=
me_put_noidle()
[    5.352334] sdio mmc2:0001:1: sdio_bus_runtime_suspend
[    5.352351] mmc mmc2:0001: mmc_sdio_runtime_suspend
[    5.352411] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_power_off clk_d=
isable_unprepare()
[    5.353713] mmc mmc2:0001: mmc_sdio_runtime_suspend - DONE
[    5.353854] mmc mmc2:0001: mmc_sdio_runtime_resume
[    5.353877] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    5.386849] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    5.441732] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
25000000Hz, actual 24800000HZ div =3D 0)
[    5.441753] mmc mmc2:0001: mmc_sdio_runtime_resume - ret=3D0 DONE
[    5.441807] wl1271_sdio mmc2:0001:2: sdio_bus_probe
[    5.441816] wl1271_sdio mmc2:0001:2: sdio_bus_probe - pm_runtime_get_sy=
nc()
[    5.441823] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[    5.442065] wl1271_sdio mmc2:0001:2: sdio PM caps =3D 0x0
[    5.442072] wl1271_sdio mmc2:0001:2: chip_family is wl18xx
[    5.442084] wl1271_sdio mmc2:0001:2: About to add core dev (child)...
[    5.442564] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[    5.442582] wl1271_sdio mmc2:0001:2: ...added core dev (child) - probe =
complete!
[    5.442588] wl1271_sdio mmc2:0001:2: sdio_bus_probe - probe OK
[    5.442672] mmc mmc2:0001: mmc_sdio_runtime_suspend
[    5.442734] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_power_off clk_d=
isable_unprepare()
[    5.444122] mmc mmc2:0001: mmc_sdio_runtime_suspend - DONE
[    5.481727] cfg80211: Loading compiled-in X.509 certificates for regula=
tory database
[    5.488722] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    5.489716] platform regulatory.0: Direct firmware load for regulatory.=
db failed with error -2
[    5.489730] cfg80211: failed to load regulatory.db
[    5.560312] mmc mmc2:0001: mmc_sdio_runtime_resume
[    5.560344] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    5.591249] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    5.652199] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
25000000Hz, actual 24800000HZ div =3D 0)
[    5.652221] mmc mmc2:0001: mmc_sdio_runtime_resume - ret=3D0 DONE
[    5.652235] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[    5.653256] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[    5.653269] mmc mmc2:0001: mmc_sdio_runtime_suspend
[    5.653324] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_power_off clk_d=
isable_unprepare()
[    5.654652] wl18xx_driver wl18xx.3.auto: Direct firmware load for ti-co=
nnectivity/wl18xx-conf.bin failed with error -2
[    5.654663] wlcore: ERROR could not get configuration binary ti-connect=
ivity/wl18xx-conf.bin: -2
[    5.654667] wlcore: WARNING falling back to default config
[    5.654690] mmc mmc2:0001: mmc_sdio_runtime_suspend - DONE
[    5.683522] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP1
[    5.683538] mmc mmc2:0001: mmc_sdio_runtime_resume
[    5.683566] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    5.715041] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    5.768567] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
25000000Hz, actual 24800000HZ div =3D 0)
[    5.768587] mmc mmc2:0001: mmc_sdio_runtime_resume - ret=3D0 DONE
[    5.768599] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP2
[    5.768605] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP3
[    5.768610] mmc mmc2:0001: mmc_sdio_hw_reset
[    5.768668] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_power_off clk_d=
isable_unprepare()
[    5.771229] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    5.806938] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    5.849536] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
25000000Hz, actual 24800000HZ div =3D 0)
[    5.849555] mmc mmc2:0001: mmc_sdio_hw_reset - ret=3D0 DONE
[    5.849613] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP4
[    5.849621] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP5
[    6.057307] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
[    6.058866] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_off: STEP1
[    6.058908] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_off: STEP2
[    6.058916] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_off: STEP3
[    6.058929] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_off: STEP4
[    6.058939] wlcore: WARNING Detected unconfigured mac address in nvs, d=
erive from fuse instead.
[    6.058942] wlcore: WARNING This default nvs file can be removed from t=
he file system
[    6.059360] mmc mmc2:0001: mmc_sdio_runtime_suspend
[    6.059431] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_power_off clk_d=
isable_unprepare()
[    6.060764] mmc mmc2:0001: mmc_sdio_runtime_suspend - DONE
[    6.070262] wlcore: loaded
[    6.407037] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP1
[    6.407055] mmc mmc2:0001: mmc_sdio_runtime_resume
[    6.407084] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    6.438967] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    6.499607] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
25000000Hz, actual 24800000HZ div =3D 0)
[    6.499630] mmc mmc2:0001: mmc_sdio_runtime_resume - ret=3D0 DONE
[    6.499643] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP2
[    6.499650] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP3
[    6.499656] mmc mmc2:0001: mmc_sdio_hw_reset
[    6.499715] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_power_off clk_d=
isable_unprepare()
[    6.502401] dwmmc_k3 f723f000.dwmmc2: mmc_pwrseq_simple_pre_power_on cl=
k_prepare_enable()
[    6.535419] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
400000Hz, actual 400000HZ div =3D 31)
[    6.593615] mmc_host mmc2: Bus speed (slot 0) =3D 24800000Hz (slot req =
25000000Hz, actual 24800000HZ div =3D 0)
[    6.593636] mmc mmc2:0001: mmc_sdio_hw_reset - ret=3D0 DONE
[    6.593713] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP4
[    6.593721] wl1271_sdio mmc2:0001:2: wl12xx_sdio_power_on: STEP5
[    7.071691] wlcore: PHY firmware version: Rev 8.2.0.0.236
[    7.097309] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[    7.198175] wlcore: firmware booted (Rev 8.9.0.0.69)
[    7.220230] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    7.275524] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[    7.288748] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[    7.351658] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[    7.352957] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[    7.415441] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[    7.442367] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[    7.499248] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[    7.664877] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[    7.759207] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[    7.813956] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[    7.979209] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[    8.041710] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[    8.143207] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   11.511579] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   11.513676] wlan0: authenticate with 00:26:f2:a6:54:9b
[   11.518209] wlan0: send auth to 00:26:f2:a6:54:9b (try 1/3)
[   11.548949] wlan0: authenticated
[   11.551101] wlan0: associate with 00:26:f2:a6:54:9b (try 1/3)
[   11.555771] wlan0: RX AssocResp from 00:26:f2:a6:54:9b (capab=3D0x431 s=
tatus=3D0 aid=3D4)
[   11.569988] wlan0: associated
[   11.583652] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   11.585286] wlcore: Association completed.
[   11.663208] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   11.903311] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   11.959544] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   12.223401] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   12.279756] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   13.247416] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   13.303324] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   13.999476] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   14.079304] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   14.239127] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   14.294940] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   17.119299] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   17.179547] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   19.573020] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   19.675205] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   23.795813] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   23.851205] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   23.903410] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   23.959755] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   23.969946] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   24.059205] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   24.543304] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   24.599606] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   29.422337] random: crng init done
[   29.422350] random: 7 urandom warning(s) missed due to ratelimiting
[   33.013600] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   33.067210] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   35.674097] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   35.735759] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   35.791301] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   35.887623] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   35.993765] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   36.083209] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   38.879248] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   38.939401] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend
[   46.327234] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_resume
[   46.382961] wl1271_sdio mmc2:0001:2: sdio_bus_runtime_suspend

--------------20CAF90CF3CE4D80A7FDD059--
