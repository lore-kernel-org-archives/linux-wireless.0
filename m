Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0F7C64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 17:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B092C21473
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 17:08:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B092C21473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbeJEADH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 20:03:07 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:55832 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbeJEADH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 20:03:07 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id B29BF409E08;
        Thu,  4 Oct 2018 10:08:55 -0700 (PDT)
Subject: Re: ath9k and 16 VAP interfaces?
To:     michael-dev <michael-dev@fami-braun.de>
References: <8ecda6f3-68ab-5752-c8de-4086d21ba309@candelatech.com>
 <EB834EF3-21B2-4E6F-BEA8-1411407310F0@fami-braun.de>
 <0896f150-13f8-daae-c956-f60a2f7feeaf@neratec.com>
 <b3a42b0c-4e8a-b1fe-56eb-74eb7e71deaf@candelatech.com>
 <e44c3cf1714d33417fd70bc58610dd40@fami-braun.de>
Cc:     Matthias May <matthias.may@neratec.com>,
        linux-wireless@vger.kernel.org
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <fb92cc77-d39c-a547-f2b8-ad10f39a5070@candelatech.com>
Date:   Thu, 4 Oct 2018 10:08:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.0
MIME-Version: 1.0
In-Reply-To: <e44c3cf1714d33417fd70bc58610dd40@fami-braun.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I'm finally getting around to trying this.

One thing, the second patch won't compile due to missing ath9k_set_moredata method.

I see it is implemented here:

http://git.fem.tu-ilmenau.de/?p=fem-wlan.git;a=blob;f=package/kernel/mac80211/patches/310-ath9k-fix-moredata-bit-in-PS-buffered-frame-release.patch;h=b2a74ccbacb29115bede4806006f3265f54cb31c;hb=refs/heads/femwlan_stage2.kernel4.9

I guess I should apply this one...maybe more?

Any idea if any of these patches should be submitted upstream?

Thanks,
Ben

On 08/05/2018 11:18 AM, michael-dev wrote:
> Hi,
>
> I'm using [1]. I was seeing some trouble with powersave + broadcasts, so I added [2], so that the queue would get empty faster.
>
> Regards,
> M. Braun
>
>
> [1]
> http://git.fem.tu-ilmenau.de/?p=fem-wlan.git;a=blob;f=package/kernel/mac80211/patches/911-more-ap-interfaces.patch;h=873a6cb7bdb8a7462ffd07c1a50fc87c580f223d;hb=refs/heads/femwlan_stage2.kernel4.9
>
> [2]
> http://git.fem.tu-ilmenau.de/?p=fem-wlan.git;a=blob;f=package/kernel/mac80211/patches/915-use-more-time-for-multicast.patch;h=05d7fb6c2567e1abdef63a4d01f02df7f8501630;hb=refs/heads/femwlan_stage2.kernel4.9
>
> Am 30.07.2018 16:34, schrieb Ben Greear:
>> On 07/30/2018 04:13 AM, Matthias May wrote:
>>> On 30/07/18 11:40, michael-dev@fami-braun.de wrote:
>>>> Do you mean AP interfaces as required for multiple BSS/SSIDs?
>>>>
>>>> I'm running a patched ath9k to have hostapd run >8 BSS on a single radio.
>>>> It works fine since years.
>>
>> Yes, I'd love to see any patches you can share on this as well.
>>
>> Thanks,
>> Ben
>>
>>>>
>>>> Regards,
>>>> M. Braun
>>>>
>>>>
>>>> Am 27. Juli 2018 15:35:28 MESZ schrieb Ben Greear <greearb@candelatech.com>:
>>>>> Hello,
>>>>>
>>>>> Has anyone tried making ath9k able to support 16 vAP interfaces on a
>>>>> single
>>>>> radio?  I seem to recall that there were limitations regarding beacon
>>>>> timers and such, and that is why the current limit is 8?
>>>>>
>>>>> Thanks,
>>>>> Ben
>>>>>
>>>>> --
>>>>> Ben Greear <greearb@candelatech.com>
>>>>> Candela Technologies Inc  http://www.candelatech.com
>>>>
>>>
>>> Are these patches available somewhere?
>>> I'm interested to play with them :)
>>>
>>> BR
>>> Matthias
>>>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

