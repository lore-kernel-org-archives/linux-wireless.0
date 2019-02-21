Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A446DC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 23:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2448D2070D
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 23:12:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="tIxy9Kqo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbfBUXMH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 18:12:07 -0500
Received: from 6.mo4.mail-out.ovh.net ([188.165.36.253]:56996 "EHLO
        6.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfBUXMG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 18:12:06 -0500
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2019 18:12:05 EST
Received: from player693.ha.ovh.net (unknown [10.109.160.153])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 56D0D1D78D0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 21:44:10 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player693.ha.ovh.net (Postfix) with ESMTPSA id 1CF8A2F15CD0;
        Thu, 21 Feb 2019 20:44:09 +0000 (UTC)
Subject: Re: [RFC PATCH v3 00/12] Draft for Extended Key ID support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550781846;
        bh=EMMqUaCZETodvnOTtvKTpuFZ4JZ8HyLyrQkipBlue2s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=tIxy9Kqo1mgqV0PUD2qvQ0jLx68YXFuuBgv3LpoY4eQSYZCESbc0nULTnga3KappB
         IwO7c2HZoSKOnACo/+N170D5GOM8hoYSFBf6TBPdLpKWsDmruIrC06IPLcRjUkXCuf
         p9RoTPJ7AZmgpXXfRCSqgcRHQlVp2L9c6TQPlEIs=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <67c355e3b3078b55267c075d48b48bcb42435b11.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <40ef7f07-987b-405b-f0c8-d4ec320fc928@wetzel-home.de>
Date:   Thu, 21 Feb 2019 21:44:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <67c355e3b3078b55267c075d48b48bcb42435b11.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 980095871891938503
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrtdekgddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



Am 15.02.19 um 12:10 schrieb Johannes Berg:
> On Sun, 2019-02-10 at 22:06 +0100, Alexander Wetzel wrote:
>>
>> The driver patches are - with the exception of the hwsim patch -
>> definitely not ready for merge and mostly here to illustrate how the
>> different APIs can be used and to start some discussions how to handle HW
>> specific challenges. Of course if someone wants to play with Extended Key
>> ID they also should be useful... (I can provide updated mostly working
>> hostapd/wpa_supplicant patches if someone is interested.
> 
> Of course :-)

I've just upload my current hostapd patches here:
https://www.awhome.eu/index.php/s/FZx68eGMGbwf6EK

These are slightly updated versions of the patches I send to the hostapd 
mailing list used in my tests. I'm using them since months in mixed 
environments with and without Extennded Key ID support.
Once the nl80211 API stabilizes I'll plan to polish them, fill in the 
known gaps and try to get them merged.

> 
> Some tests for the hwsim tests there would also be nice, that's the
> easiest way to see something working - if you have them.

I did run the the existing PTK tests but proper tests for Extended Key 
ID are the biggest open topic. I suspect proper tests will the most 
complicated open task here.

The others are:
- No support for Extended Key ID in mesh mode
- Update to new kernel API (the one we extended for Extended KEY ID) 
needs some more work.
- Make sure we do not install the keys twice when repeating either EAPOL 
3 or 4 (I think one of them was ok, but I did not look at that for 
ages... It's still working fine, mac80211 detects a duplicate key 
install and just reports success.)

Alexander
