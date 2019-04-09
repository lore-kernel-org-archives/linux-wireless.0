Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A2CC10F0E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5B3420833
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 19:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="d5v6FQb3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfDIT7F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 15:59:05 -0400
Received: from 7.mo178.mail-out.ovh.net ([46.105.58.91]:49824 "EHLO
        7.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfDIT7F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 15:59:05 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Apr 2019 15:59:05 EDT
Received: from player735.ha.ovh.net (unknown [10.109.160.244])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id 4CC9F59FE4
        for <linux-wireless@vger.kernel.org>; Tue,  9 Apr 2019 21:39:53 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player735.ha.ovh.net (Postfix) with ESMTPSA id 8273549B9878;
        Tue,  9 Apr 2019 19:39:51 +0000 (UTC)
Subject: Re: [PATCH v2 0/4] Extended Key ID support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1554838790;
        bh=ftBqBSPFRob/UZmhWOEZ3jWRZKhgkrVjGu7bX9rnBPQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=d5v6FQb3cKfB8pYeIpOywNHMB5dmJSa6Qnr7Pn1vPc1zNxvpx0JQkpSugfh91454Y
         9laZsM9rrMhZDeKUu9YzPlKpH462Tl9ShcyKok02nnwbViw+PJMzkFfh9pzX14/yVj
         tA/XjhPrfsA3Sid5Gzk3o0seL+YswmPtf6y5yA0k=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190319203410.25145-1-alexander@wetzel-home.de>
 <98e1f8942056486669c6295323ef09763fd2ec0a.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <e8ad598e-a2c4-45be-6923-11fccf80d296@wetzel-home.de>
Date:   Tue, 9 Apr 2019 21:39:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <98e1f8942056486669c6295323ef09763fd2ec0a.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17656643816126291143
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudehgddugedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 08.04.19 um 21:57 schrieb Johannes Berg:
> On Tue, 2019-03-19 at 21:34 +0100, Alexander Wetzel wrote:
>> This patch series adds support for IEEE 802.11-2016 Extended Key ID
>> support. Compared to the last RFC there are again quite some API
>> changes, but also some bug fixes. (The bug fixes I remember are outlined
>> in the different patches.)
> 
> FWIW, I've applied the first two patches here.
> 
> I'd really like you to continue with only that for now, and (try to) get
> hostapd/wpa_supplicant changes upstream, perhaps with corresponding
> hwsim tests. That way, we can see this working live.

That's splendid:-)
I'll try to get the hostapd/wpa_supplicant patches finalized in the next 
weeks. Hopefully I have something to submit here once the Extended Key 
ID API is in mainline immediately.

But if you or someone else want to run some tests prior to that.
I've updated the patches available here with the ones I'm currently 
using: https://www.awhome.eu/index.php/s/AJJXBLsZmzHdxpX

They are fully functional and I'm using them on my main AP and 
workstation for months now.
They are on top of the current hostapd HEAD and should not cause any 
regressions. They are also comparable simple to port between versions. 
The code we touch here has not been changed in any relevant way since I 
started working on the patches. Just really copy nl80211_copy.h from the 
kernel...

A sad side note:
I'm pretty sure I've already found one broken Wlan implementation: 
Samsung Galaxy Tap S3
This device seems to just copy the RSN Capability (bit) from the AP and 
then fails when the AP rekeys the connection and starts using keyid 1...
But it's probably a Samsung specific bug, other Android devices - 
including a Google Pixel 3 - don't "lie" in the RSN and are using 
"legacy" key installs as they should.

> 
> We briefly discussed this at the wireless workshop, and the general
> feeling seems to have been that the compat mode is probably not really
> worthwhile, but I haven't quite made up my mind on that.

I would like to be able to support Extended Key ID for the the Atheros 
cards < ath10k... Maybe that gets the attention of someone who can fix 
the ath10k firmware to also support it, hopefully in NATIVE mode:-)
But I see that the COMPAT mode may not be worth the added complexity in 
the long term.

Which reminds me:
One potential follow up on the COMPAT code would be seamless Rx during 
rekey even when not using Extended Key ID. It would need some slight of 
hand but I think it's possible. Basically we just would have to try the 
second key also if the first one did not decode the MPTU. So far I've 
shelved any plans into that direction as too complex for too little 
gain. And after all people should just start using Extended Key ID 
instead. After all that's the point of having standards...

> Still, having tests and being able to check it out would help a lot,
> also as part of perhaps building a case for compat mode.

Besides some review of the patches with my improved 802.11/code 
understanding the only thing missing in the current 
wpa_supplicant/hostapd patches *are* the test cases.

The existing rekey tests are already working fine with Extended Key ID. 
Separating Extended Key ID rekey from "legacy" rekeys tests is probably 
half of the work here...
With the patches you merged and the linked hostapd/wpa_supplicant 
patches any (WPA2) rekey test will use Extended Key ID. (They won't test 
any of the really interesting code pathes in the kernel, trough. No 
A-MPDU, no TX-Pull and of course no HW crypto or RX/TX fast path if I 
remember it right.)

Thanks,
Alexander
