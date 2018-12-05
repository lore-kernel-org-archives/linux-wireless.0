Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3602FC04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 19:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80402208E7
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 19:17:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="EoKz7Jfk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 80402208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbeLETR2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 14:17:28 -0500
Received: from 2.mo69.mail-out.ovh.net ([178.33.251.80]:39024 "EHLO
        2.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbeLETR2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 14:17:28 -0500
Received: from player795.ha.ovh.net (unknown [10.109.143.238])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 5C7913305E
        for <linux-wireless@vger.kernel.org>; Wed,  5 Dec 2018 20:17:25 +0100 (CET)
Received: from awhome.eu (p57B7EDEA.dip0.t-ipconnect.de [87.183.237.234])
        (Authenticated sender: postmaster@awhome.eu)
        by player795.ha.ovh.net (Postfix) with ESMTPSA id 2D4D6804FA0;
        Wed,  5 Dec 2018 19:17:24 +0000 (UTC)
Subject: Re: [RFC PATCH v2 0/2] Extended Key ID support for linux
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1544036797;
        bh=UkIcbG9oHY1mEfds0JGybtdDR/qLfbrK1xjrU0XqGNw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=EoKz7JfkrGmP78NEfeoI3EBC3QdeSbjNsCvzRvjkC7rPFIhL1ymq8DuWhZV+QyrpY
         H1CqLqep9l1Xwrr7D6ZAFs/s1vc98qLqU1BkrqqVi6VIQF4y5S2Pj/TWT4l4kMbFuG
         8MVhcJ4Gq35dBaQ6Pm6o7zfEyNKBFfVifyFKKsaI=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20181111110235.14213-1-alexander@wetzel-home.de>
 <6102d09bb53a59b2789e31d84ffdda45165a895c.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <f20cc734-c861-289c-c041-3fc99f1a5015@wetzel-home.de>
Date:   Wed, 5 Dec 2018 20:06:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <6102d09bb53a59b2789e31d84ffdda45165a895c.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2613495161956867271
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedrudefhedguddvgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Hi,
> 
> Sorry for the delay.
> No problem. That's hardly urgent:-)

> On Sun, 2018-11-11 at 12:02 +0100, Alexander Wetzel wrote:
>> IEEE 802.11-2012 added support for Extended Key ID, allowing pairwise
>> keys to also use keyID 1 and moving group keys to IDs 2 and 3.
> 
> Where do you read this? I've always been under the impression that
> individually and group addressed frames use key IDs from different
> "namespaces", so to speak, where PTK/STK can use 0 (0 or 1 with
> "Extended Key ID" support) and GTK can use 0-3.
> 
> In fact, the per-frame pseudocode in 802.11-2016 12.9.2.6 clearly
> states:
> 
> if MPDU has individual RA then
> 	lookup pairwise key using Key ID from MPDU
> else
> 	lookup group key using Key ID from MPDU
> endif
> 
> If it weren't different namespaces, you'd not have to differentiate
> here.
> 

I was indeed struggling to understand what the intend of the standard is 
here. I may well be wrong, but the note in "12.6.1.1.10 Mesh GTKSA" 
tipped the scales to assume keyIDs are within one namespace only.

"Since Key ID 0 is reserved for individually addressed frame 
transmission, there are at most three available Key IDs (only two if 
extended Key IDs for individually addressed frames are in use), and the 
different MGTKs would contend for the single remaining Key ID upon 
rollover."

I got the impression Extended Key IDs were  added without updating all 
sections which should get updates. But the pattern is suspect, even the 
igtk numbers fit into the pattern:

  PTK 0 & 1
  GTK 1 & 2 & 3
iGTK 4 & 5

That may well be utterly wrong... Any idea how can we sort that out?

>> Support for Extended Key ID is basically completed and confirmed working
>> with both hwsim and "on the air" with ath9k/iwldvm using software
>> encryption and those patches here.
> 
> :)
> 
>> Prior to propose this patch for merging I would like to get Extended
>> Key ID working with HW encryption for at least some devices, but after
>> experimenting with ath9k and to a lesser extend with ath10k it's now
>> clear that this will be an per-driver effort and it may well turn out to
>> be impossible without firmware updates.
> 
> Indeed. I think there might be some support with iwlwifi firmware, at
> least newer versions? I can check later.
>
>> So I've decided to continue working on the HW support for now but also
>> ask you for feedback for what I got so far.
> 
> Sounds good.
> 

I think I've solved the HW support issue, it looks like we'll be able to 
support Extended Key IDs with minimal changes to the drivers in a 
compatibility mode. It's basically working with iwldvm and ath9k but 
needs some more work.

Alexander
