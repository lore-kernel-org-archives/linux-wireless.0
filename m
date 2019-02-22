Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9567FC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 21:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F1B7206BB
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 21:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="BzmqMsk8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfBVVar (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 16:30:47 -0500
Received: from 10.mo68.mail-out.ovh.net ([46.105.79.203]:51589 "EHLO
        10.mo68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbfBVVar (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 16:30:47 -0500
X-Greylist: delayed 1799 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2019 16:30:45 EST
Received: from player737.ha.ovh.net (unknown [10.109.143.201])
        by mo68.mail-out.ovh.net (Postfix) with ESMTP id 13F6C113CA2
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2019 21:50:49 +0100 (CET)
Received: from awhome.eu (p57B7E5A0.dip0.t-ipconnect.de [87.183.229.160])
        (Authenticated sender: postmaster@awhome.eu)
        by player737.ha.ovh.net (Postfix) with ESMTPSA id 94EBF31F0A16;
        Fri, 22 Feb 2019 20:50:48 +0000 (UTC)
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550868647;
        bh=wgVH4k1fMxfxfSZ/EGnABo8ptcYTF0Tb9qCP4vFFpDo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=BzmqMsk8hkBsRRr+VAe5sfjc7CEF0M9KdmXtwc7+oPXs1YL5ZQDgMOziJQAOUCRac
         Apdhv0Cn0AJ5Hn0WFOeaWvw7xmQgQSVs4vgzH8aDyicF2Jo9yohVQIEzc0t9+7Ub1A
         492jn07XrJfoR+PGWpuCtjcxBBVExQfPTwwNjcLQ=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-8-alexander@wetzel-home.de>
 <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
Date:   Fri, 22 Feb 2019 21:50:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6965098300401327303
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddruddtgddugeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



Am 15.02.19 um 12:52 schrieb Johannes Berg:
> On Sun, 2019-02-10 at 22:06 +0100, Alexander Wetzel wrote:
>> This is not ready for merge and has known issues.
>> The patch is only for discussions to sort out how to handle it correctly!
>>
>> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
>> ---
>>
>> iwlwifi intel cards had two big surprises:
>>
>> Assuming I did not make some stupid errors it looks like my old
>> "Intel Corporation Centrino Ultimate-N 6300 (rev 3e)" using ucode
>> 9.221.4.1 build 25532 is perfectly fine with two keys uploaded to
>> harware and honoring the keyid in the MPDUs. For a card launched 2011
>> that's a pleasant surprise:-)
> 
> :-)
> 
>> A much shorter test with a modern "Intel Corporation Wireless 8265 /
>> 8175 (rev 78)" using ucode version 36.e91976c0.0 shows what seems to be
>> MPDUs decoded with the wrong key at each rekey and therefore a candidate
>> for the COMPAT support only..
>> So the bad news seems to be, that the modern card dropped the support.
> 
> Probably just a firmware bug.
> 
>> It also seems to force us to add some per-card or per-firmware depending
>> check to decide which card can use the Native Extended Key ID support
>> and use the Compat mode for the rest.
>> Is there any way to find out which cards/firmware can be used with
>> Extended Key ID?
> 
> No, but if you have a good test case we can check out what the firmware
> bug is and fix it. Perhaps not for all, but for the future at least.
> Maybe we can still figure out where it was introduced and thus see where
> it's good to use native mode.

I'll verify if can reproduce the scrambled packets and will provide a 
capture if so. Assuming that confirms the initial finding I'll be able 
to reproduce that at will within minutes with access to a test system 
having a mvm card. (I have some plans which will improve access, but 
looks like that will take some time and efforts.)

For now I handle that as low prio till we have generic Extended Key ID 
support merged and I've had some time to improve my test setup and 
hopefully have better access to a mvm card for testing.

> 
>> I also have tested patch for iwldvm using the Compat mode and I think
>> mvm cards will also work with that.
> 
> No they don't, no firmware is available for that.

So far I only looked at the dvm part of iwlwifi with only minutes spend 
on mvm to port the NATIVE solution from dvm.

Are you saying that mvm cards can't seamless switch a RX/TX key to TX 
only one? mvm seems to support SW crypto as needed and switching RX/TX 
to TX keys is the only other requirement for COMPAT mode.

Alexander
