Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD77C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 15:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5C1820666
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 15:23:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5C1820666
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=candelatech.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbeI1VrU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 17:47:20 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:53580 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbeI1VrU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 17:47:20 -0400
Received: from [192.168.1.47] (unknown [50.34.223.145])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 18EBB40A539;
        Fri, 28 Sep 2018 08:23:00 -0700 (PDT)
Subject: Re: Problem with sending pkt on a monitor port
To:     Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <76ce3d16-dbea-e882-63e7-2337fbc269c6@candelatech.com>
 <1537389335.10305.92.camel@sipsolutions.net>
 <d6f99a05-77a3-f18a-4e7a-083062119ce4@candelatech.com>
 <1537428695.3874.1.camel@sipsolutions.net>
 <6ac68a4c-04a3-ce6e-232e-3ebb6100ee29@candelatech.com>
 <1538118875.14416.53.camel@sipsolutions.net>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <e8be6dbc-7062-3e5a-0303-e68c988e4a9a@candelatech.com>
Date:   Fri, 28 Sep 2018 08:22:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1538118875.14416.53.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 09/28/2018 12:14 AM, Johannes Berg wrote:
> Sorry, I'm a bit behind things ...
>
>>> It's actually created by mac80211, but only once, and not directly
>>> mapped to each vif seen by userspace - it's an internal construction.
>>
>> I'm not sure it matters, but ath10k firmware can also create a monitor vdev
>> itself for certain reasons.  (Maybe offchannel tx on some FW, but I haven't looked at
>> that code lately).
>
> Yeah and I think it may actually do for active monitor, but I believe
> those get their own MAC address anyway? That might get used in the end
> as the vif to the driver too.

The monitor port has the same mac as the wlanX in ath10k, ie the 'radio's mac'.

>>> However, thinking about it, that also breaks userspace in other ways -
>>> for example if you do injection this way you actually get encryption and
>>> other nice things if you use the local address that matches an existing
>>> interface.
>>
>> I'm not entirely sure of a useful use-case for this feature in user-space.
>
> Which feature?

radio-tap send on a monitor vdev.

>
> At least ancient versions of hostapd would rely on this, but clearly
> that's no longer super relevant. I don't know if anyone else relies on
> it, but in a way that is the problem. If I knew, then I could think
> about alternatives or how to keep that working if we change anything
> here.
>
>> I am using it just to test sending some test frames to debug some firmware
>> features.  I think another user sent hand-crafted specialized beacons in this manner
>> using my 10.1 ath10k firmware & driver.  For whatever reason, I didn't realize monitor
>> vdevs were not directly used when I added that support..maybe I just got lucky
>> before I had to dig closely.
>
> They may be used if they were active monitor? I don't know ath10k well.
> But then they shouldn't have had the same MAC address to start with,
> IIRC.

The code I quoted at the first of this thread make sure the monitor vdev is
not used if possible.  But, maybe the driver has or had some ways to force certain
frames out the monitor port.  That is my recollection.  I added code to the firmware
to allow this to work, including bug fixes to crashes, so I am pretty sure there is *some*
way for that tx path to happen, at least in wave-1 firmware.

>> If I make the code in my original email be skipped, so that sdata remains the
>> monitor vdev, then it fails a check later in that method because there is no
>> chanctxt for the monitor sdata object.
>>
>> I guess that changing the source MAC to something unique would cause the same
>> issue and no frame would be sent towards the driver.
>
> Hmm. This *should* work in one way or the other? But again, maybe ath10k
> has something special here?
>
> You skipped *just* that loop?

Yes...because the monitor vdev chanctx was null and that method checks a bit later for it.

Maybe there is a way to create/configure the monitor vdev so that it has
a chanctx?

Thanks,
Ben

>
> johannes
>

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
