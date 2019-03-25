Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C3E2C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 21:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D546F206DF
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 21:50:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="HYSufA7l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbfCYVux (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:50:53 -0400
Received: from [208.74.158.174] ([208.74.158.174]:49618 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1729478AbfCYVux (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 17:50:53 -0400
Received: from [192.168.43.60] (unknown [172.58.41.68])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 42635137559;
        Mon, 25 Mar 2019 14:50:52 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 42635137559
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1553550652;
        bh=LKvG0E2p1GLJWMW+pmdSxsRdiwrr/I5Uuqt5plubzW8=;
        h=Date:From:To:CC:Subject:References:In-Reply-To:From;
        b=HYSufA7l+UA5N+jUIJzX8RDpf8sZCNrWKTBWzhxrg4LHFKqo7L1HqkBzkMwsWE/uQ
         AHS1ynwG1/YCeYxs/sIsOuLGBZATUBHecL/fnNXtUPwxWsyCttX9LwUl6MzoZ6RKoH
         h7JHzqiCYzFw26zg24IY5Ye7X8fF9CiB3iZXEgzE=
Message-ID: <5C993A2C.8080300@candelatech.com>
Date:   Mon, 25 Mar 2019 13:29:32 -0700
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To:     =?UTF-8?B?TWljaGHFgiBLYXppb3I=?= <kazikcz@gmail.com>
CC:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        =?UTF-8?B?VG9taXNsYXYgUG/FvmVnYQ==?= <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        openwrt-devel@lists.openwrt.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] ath10k: reset chip after supported check
References: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com> <3337086.qEUs9xMCTV@debian64> <fe853ec8-0dca-d931-8632-fbe4df5cfaf8@broadcom.com> <edc38f32-977a-53f5-babd-605775326a20@broadcom.com> <CABvG-CUXHgJ1ZUfsZw6ajzR=4DjnRRNrPmF147mZsoWJBjp-jQ@mail.gmail.com> <c13da25c-9116-9388-8e40-96bac8dca087@candelatech.com> <CABvG-CWP4y4MU1pJB8ZSpLPPYMkQ+=kQt1zRoUJW=0dMLbD5WQ@mail.gmail.com> <f3763b33-7944-81f8-98e1-053e51474a38@candelatech.com> <CABvG-CW2WNpi6Wcan3UMOWKfZLDTgmEzif63Peemnyk+4VtW3Q@mail.gmail.com>
In-Reply-To: <CABvG-CW2WNpi6Wcan3UMOWKfZLDTgmEzif63Peemnyk+4VtW3Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 03/25/2019 02:34 PM, Michał Kazior wrote:
> On Mon, 25 Mar 2019 at 21:23, Ben Greear <greearb@candelatech.com> wrote:
>>
>> On 3/25/19 1:08 PM, Michał Kazior wrote:
>>> On Mon, 25 Mar 2019 at 16:55, Ben Greear <greearb@candelatech.com> wrote:
>>>> On 3/25/19 5:14 AM, Michał Kazior wrote:
>>>>> On Sat, 23 Mar 2019 at 08:20, Arend Van Spriel
>>>>> <arend.vanspriel@broadcom.com> wrote:
>>>>>>
>>>>>> * resending with corrected email address from Kalle
>>>>>> --------------------------------------------------------------------
>>>>>> + Michał
>>>>>
>>>>> Thanks!
>>>>>
>>>>>
>>>>>> On 3/22/2019 8:25 PM, Christian Lamparter wrote:
>>>>>>     > On Friday, March 22, 2019 7:58:40 PM CET Tomislav Požega wrote:
>>>>>>     >> When chip reset is done before the chip is checked if supported
>>>>>>     >> there will be crash. Previous behaviour caused bootloops on
>>>>>>     >> Archer C7 v1 units, this patch allows clean device boot without
>>>>>>     >> excluding ath10k driver.
>>>>>
>>>>> Can you elaborate more a bit? What kind of crashes are you seeing?
>>>>> What does the bootloop look like? Do you have uart connected to
>>>>> diagnose?
>>>>>
>>>>> Didn't C7 v1 have the old QCA9880 hw v1 which isn't really supported
>>>>> by ath10k? I recall the v1 chip was really buggy and required
>>>>> hammering registers sometimes to get things working.
>>>>
>>>> The crash is related to the v1 chip.  Is there a good way to detect
>>>> that this is the chip in question and only apply this work-around
>>>> for the problem chip?
>>>
>>> I don't know of any good way to do that.
>>>
>>> You could consider device-tree but that would be no different from
>>> having a module blacklist in the C7v1 build recipe, or to not build
>>> the module at all. That is unless you actually want to make v1 chip
>>> work with ath10k at which point there's more fun to be had before it
>>> can actually work.
>>
>> I remember v1, and I have no interest in trying to make it work :)
>>
>> If we could blacklist certain pci slots in the ath10k driver, I guess
>> that would work?
>>
>> I think the goal is to not use the v1 chip, but allow users to add a
>> v2 NIC to the platform, so driver still needs to load.
>
> That makes sense, but I don't see how blacklisting pci slots would
> help someone putting v2 nic into C7v1 mobo? Won't the slot be the same
> regardless what nic is put?

I'm not sure about that...maybe let OpenWRT boot by default
assuming the slot is blacklisted, and then disable the blacklist
if known to be a v2 NIC.

If your patch below works, that looks a lot better though.

Hopefully someone with that v1 board can test it.

Thanks,
Ben

>
> The best thing I can come up with is something like this:
>
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -3629,6 +3629,19 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
>                  goto err_deinit_irq;
>          }
>
> +       if (hw_rev == ATH10K_HW_QCA988X) {
> +               /* v1 can crash the system on chip_reset()
> +                * so all we can do is keep our fingers
> +                * crossed v2 never reports 0 without a
> +                * chip_reset()
> +                */
> +               if (ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS) == 0) {
> +                       ath10k_err(ar, "qca9880 v1 is chip not supported");
> +                       ret = -ENOTSUP;
> +                       goto err_free_irq;
> +               }
> +       }
> +
>          ret = ath10k_pci_chip_reset(ar);
>          if (ret) {
>                  ath10k_err(ar, "failed to reset chip: %d\n", ret);
>
> I didn't test it. Someone needs to compile and test and make sure v2
> doesn't regress when fw hangs and cold & warm host cpu resets are
> mixed in.
>
>
> Michał
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

