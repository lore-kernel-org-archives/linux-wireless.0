Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7682CC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 15:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 465BC20896
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 15:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="BPh/f0ab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbfCYPzw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 11:55:52 -0400
Received: from [208.74.158.174] ([208.74.158.174]:60684 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1729665AbfCYPzu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 11:55:50 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 39F65137559;
        Mon, 25 Mar 2019 08:55:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 39F65137559
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1553529350;
        bh=UgN9RNpDxVGGimGToxMWAVPTX3zgTHlPxKcc+wLw7Hs=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BPh/f0abeR6HxT2ZBCobkSDOGADu4cz1EZwVyDZmCInIzz3Ow86dwcFOFUmUnqeeo
         V53gEdBT0PoKIeDmW7ebQeQpsy7JCSojawCnvFY9Hi8/3UHoSVA6+82nGF/gXlU/pN
         qSvmW8Uh1ZvhC16WvJflBPRCYATdfvpQ6dC82/do=
Subject: Re: [PATCH] ath10k: reset chip after supported check
To:     =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        =?UTF-8?Q?Tomislav_Po=c5=beega?= <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        openwrt-devel@lists.openwrt.org, Kalle Valo <kvalo@codeaurora.org>
References: <1553281120-22139-1-git-send-email-pozega.tomislav@gmail.com>
 <3337086.qEUs9xMCTV@debian64>
 <fe853ec8-0dca-d931-8632-fbe4df5cfaf8@broadcom.com>
 <edc38f32-977a-53f5-babd-605775326a20@broadcom.com>
 <CABvG-CUXHgJ1ZUfsZw6ajzR=4DjnRRNrPmF147mZsoWJBjp-jQ@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <c13da25c-9116-9388-8e40-96bac8dca087@candelatech.com>
Date:   Mon, 25 Mar 2019 08:55:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CABvG-CUXHgJ1ZUfsZw6ajzR=4DjnRRNrPmF147mZsoWJBjp-jQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/25/19 5:14 AM, Michał Kazior wrote:
> On Sat, 23 Mar 2019 at 08:20, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>>
>> * resending with corrected email address from Kalle
>> --------------------------------------------------------------------
>> + Michał
> 
> Thanks!
> 
> 
>> On 3/22/2019 8:25 PM, Christian Lamparter wrote:
>>   > On Friday, March 22, 2019 7:58:40 PM CET Tomislav Požega wrote:
>>   >> When chip reset is done before the chip is checked if supported
>>   >> there will be crash. Previous behaviour caused bootloops on
>>   >> Archer C7 v1 units, this patch allows clean device boot without
>>   >> excluding ath10k driver.
> 
> Can you elaborate more a bit? What kind of crashes are you seeing?
> What does the bootloop look like? Do you have uart connected to
> diagnose?
> 
> Didn't C7 v1 have the old QCA9880 hw v1 which isn't really supported
> by ath10k? I recall the v1 chip was really buggy and required
> hammering registers sometimes to get things working.

The crash is related to the v1 chip.  Is there a good way to detect
that this is the chip in question and only apply this work-around
for the problem chip?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

