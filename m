Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60018 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab0LBWdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 17:33:08 -0500
Received: by wyb28 with SMTP id 28so8733069wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 14:33:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinpTyikX2xCTJqx45BdqeyeL7C8y92ci+k5n0w0@mail.gmail.com>
References: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
	<201012011921.11151.br1@einfach.org>
	<AANLkTimcV+pHp8ui-hExnsBfuQ2PtGA2aZidCYSFsQnh@mail.gmail.com>
	<AANLkTinvV-6FqMni86MEYrBN6q0255M6cFjBOpR9vdP2@mail.gmail.com>
	<AANLkTinpTyikX2xCTJqx45BdqeyeL7C8y92ci+k5n0w0@mail.gmail.com>
Date: Fri, 3 Dec 2010 00:33:06 +0200
Message-ID: <AANLkTi=WH6S5zW3abTyFz=bUu7p6USkVz1341W+aPh66@mail.gmail.com>
Subject: Re: [linux-next] next-20101201: ath5k permanently disconnecting
From: Nick Kossifidis <mickflemm@gmail.com>
To: sedat.dilek@gmail.com
Cc: Bruno Randolf <br1@einfach.org>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Jonathan Guerin <jonathan@guerin.id.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/2 Nick Kossifidis <mickflemm@gmail.com>:
> 2010/12/2 Nick Kossifidis <mickflemm@gmail.com>:
>> 2010/12/2 Sedat Dilek <sedat.dilek@googlemail.com>:
>>> On Wed, Dec 1, 2010 at 11:21 AM, Bruno Randolf <br1@einfach.org> wrote:
>>>> On Wed December 1 2010 19:09:03 Sedat Dilek wrote:
>>>>> Hi,
>>>>>
>>>>> I have built today a linux-next (next-20101201) kernel which includes
>>>>> wireless-next-2.6 up to master-2010-11-30.
>>> [...]
>>>>> Unfortunately, my wlan network connection is totally unstable.
>>> [...]
>>>> 1.) For identification of the chipset, please:
>>>> dmesg |grep "ath5.*chip"
>>>>
>>>> 2.) Is there a problem when you don't use encryption?
>>>>
>>>> 3.) git bisect might help track it down.
>>>>
>>>> bruno
>>>
>>> OK, I did not a "classic" git-bisect, I created from linux-next
>>> (next-20101202) GIT tree a revert-ath5k patchset (30 in total).
>>>
>>> [1] VERY GOOD: Revertiing all 30 patches
>>>
>>> ...leads to a stable system.
>>>
>>> [2] REDUCED DISCONNECTIONS DROPS: Reverting 0001..0008
>>>
>>> This stabilizes the system, but... listening to a radio
>>> broadcast-stream with VLC is a pain in the ass... permanent audio
>>> dropouts. I had only 2 disconnections in the first 10mins when system
>>> was up (normally I can see disconnects after loggin into my KDE
>>> desktop).
>>>
>>> [3] GOOD AUDIO STREAMING: Reverting 0001..0014
>>>
>>> This is just fine, system like I am used to.
>>>
>>> [4] CONCLUSION
>>>
>>> So I played a bit with my revert-patchset.
>>>
>>> Reverting 0001..0008 + a refreshed v2 of
>>> 0014-Revert-ath5k-Use-turbo-flag-on-DCU.patch (patch attached) is
>>> doing the job here.
>>>
>>> Having a closer look into 0008 (parts of
>>> drivers/net/wireless/ath/ath5k/reset.c):
>>>
>>> $ grep AR5212 patches/revert-wireless-patches/0008-Revert-ath5k-Support-synth-only-channel-change-for-A.patch
>>> -       if (ah->ah_version == AR5K_AR5212)
>>> +                        * On AR5212 TSF is almost preserved across a
>>> -                * On AR5212 TSF is almost preserved across a
>>> +               if (ah->ah_version == AR5K_AR5212) {
>>> -       if (ah->ah_version == AR5K_AR5212 &&
>>>
>>> As I mentionned I have a AR5212 wlan device!
>>> What to do with that parts?
>>> Any idea?
>>>
>>> Kind Regards,
>>> - Sedat -
>>>
>>> P.S.: I have added a list containing all commit-ids (chronological)
>>> and a script how I reverted (documenting for myself).
>>>
>>> $ ls patches/revert-wireless-patches/00*.patch
>>> patches/revert-wireless-patches/0001-Revert-ath5k-Set-turbo-bit-on-rf-bank-2.patch
>>> patches/revert-wireless-patches/0002-Revert-ath5k-Clean-up-turbo-mode-initvals-rfregs.patch
>>> patches/revert-wireless-patches/0003-Revert-ath5k-Cleanup-turbo-channel-flags.patch
>>> patches/revert-wireless-patches/0004-Revert-ath5k-Use-correct-clock-when-setting-ofdm-tim.patch
>>> patches/revert-wireless-patches/0005-Revert-ath5k-Skip-tx-power-setting-on-AR5210-for-now.patch
>>> patches/revert-wireless-patches/0006-Revert-ath5k-Tweak-phy-activate-to-rx-start-delay-ba.patch
>>> patches/revert-wireless-patches/0007-Revert-ath5k-No-need-to-save-restore-staid-flags-on-.patch
>>> patches/revert-wireless-patches/0008-Revert-ath5k-Support-synth-only-channel-change-for-A.patch
>>> patches/revert-wireless-patches/0009-Revert-ath5k-Skip-powertable-setting-when-we-are-on-.patch
>>> patches/revert-wireless-patches/0010-Revert-ath5k-Update-PLL-programming-for-turbo-half-q.patch
>>> patches/revert-wireless-patches/0011-Revert-ath5k-Update-spur-mitigation-filter-for-turbo.patch
>>> patches/revert-wireless-patches/0012-Revert-ath5k-Tweak-power-detector-delays-on-RF5111-R.patch
>>> patches/revert-wireless-patches/0013-Revert-ath5k-Always-set-IFS-intervals-on-reset.patch
>>> patches/revert-wireless-patches/0014-Revert-ath5k-Use-turbo-flag-on-DCU.patch
>>> patches/revert-wireless-patches/0015-Revert-ath5k-Set-all-IFS-intervals-not-just-slot-tim.patch
>>> patches/revert-wireless-patches/0016-Revert-ath5k-Extend-rate_duration.patch
>>> patches/revert-wireless-patches/0017-Revert-ath5k-Extend-get_default_sifs-slot_time.patch
>>> patches/revert-wireless-patches/0018-Revert-ath5k-Move-tx-retries-setting-outside-reset_t.patch
>>> patches/revert-wireless-patches/0019-Revert-ath5k-Increase-PHY-settling-parameters-for-tu.patch
>>> patches/revert-wireless-patches/0020-Revert-ath5k-Small-cleanup-on-tweak_initvals.patch
>>> patches/revert-wireless-patches/0021-Revert-ath5k-Put-core-clock-initialization-on-a-new-.patch
>>> patches/revert-wireless-patches/0022-Revert-ath5k-Add-new-field-on-ath5k_hw-to-track-band.patch
>>> patches/revert-wireless-patches/0023-Revert-ath5k-Use-new-function-to-stop-beacon-queue.patch
>>> patches/revert-wireless-patches/0024-Revert-ath5k-Check-RXE-when-setting-RXDP.patch
>>> patches/revert-wireless-patches/0025-Revert-ath5k-Use-DCU-early-termination-correctly.patch
>>> patches/revert-wireless-patches/0026-Revert-ath5k-Debug-DMA-timeouts.patch
>>> patches/revert-wireless-patches/0027-Revert-ath5k-Use-new-dma_stop-function-on-base.c.patch
>>> patches/revert-wireless-patches/0028-Revert-ath5k-Stop-PCU-on-reset.patch
>>> patches/revert-wireless-patches/0029-Revert-ath5k-Add-new-function-to-stop-rx-tx-DMA.patch
>>> patches/revert-wireless-patches/0030-Revert-ath5k-Reset-cleanup-and-generic-cleanup.patch
>>>
>>
>> OK this doesn't make any sense, based on your logs you have an
>> AR5212+RF5111+RF2111 combination, synth-only channel change (0008) is
>> only executed on AR2413 and AR5413 so you don't even run that code,
>> setting turbo flag on DCU (0014) is also unrelated since we never
>> enable turbo mode and if we did you wouldn't be able to receive
>> anything non-turbo.
>>
>> I am going to test 2 cards like yours a CM6 and an older one from
>> Atheros and come back to you ASAP...
>>
>
> I just reproduced it on a CM6 and a CM9 (AR5212 + RF5112), problem
> occurs when card is idle (no traffic) that's why my automated test
> didn't catch it I can still run iperf after connecting and leave it
> running without problems, when traffic stops it soon gets
> disconnected. I suspect it's something related to IFS timings/ACK
> timeout (0013 on your reverted series), maybe Jonathan Guerin was
> correct about ACK timeout...
>
> I'll try something and come back to you with code ;-)
>
> Thanks for reporting !
>

Nope, it's PHY related and only affects RF5111/RF5112, AR2413 and
above work fine...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
