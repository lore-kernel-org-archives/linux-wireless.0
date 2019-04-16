Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3F1C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 21:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9563B2075B
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 21:32:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="dz7RCOik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfDPVcx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 17:32:53 -0400
Received: from 12.mo7.mail-out.ovh.net ([178.33.107.167]:52919 "EHLO
        12.mo7.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbfDPVcx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 17:32:53 -0400
Received: from player690.ha.ovh.net (unknown [10.108.42.176])
        by mo7.mail-out.ovh.net (Postfix) with ESMTP id 77CBE10CE29
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2019 23:32:50 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player690.ha.ovh.net (Postfix) with ESMTPSA id B7D924BA2D54;
        Tue, 16 Apr 2019 21:32:48 +0000 (UTC)
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1555450367;
        bh=evOzPAXlAaOSE+SFD85b/BTMIUlbR4MbihYcau610uI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dz7RCOikaBhA6iXEZv/D5RrjFE2+q73Vcem8ncB6oxHSYhc9b7VqUNeFTLumaNVL6
         KdlG9tU4Zldxzf9WzZlQNJOmsY8dBmic2ROitlghQdGI4MQF8TClDgFoCl0salRLUB
         tEux86W289nH+dcL2SuQRBeiotp7coWTf2gxYtJs=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-8-alexander@wetzel-home.de>
 <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
 <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
 <69e6577f90d99289acaa9853fe236e6f15f9e774.camel@sipsolutions.net>
 <14c9d8f7-7cf6-d7e1-a1c0-9f1a10920d4e@wetzel-home.de>
 <ed6e95dad39ef0ac98c62e3acd3f78fd7b3a6d2b.camel@sipsolutions.net>
 <185ea9a2-f3c6-04a5-000b-44191da5a0ee@wetzel-home.de>
 <0de9d60ffef574b34e9a76ad2cea68fab49aac0f.camel@sipsolutions.net>
 <45ae97d6-3357-64ac-0a40-9ae3ea4a8ed2@wetzel-home.de>
 <84694a97bf884985afd49d93e28b309a92801916.camel@sipsolutions.net>
 <577d4307-27ca-c5f5-8814-bbef515559e3@wetzel-home.de>
 <91d60fa7ba614c96fe2814375a28802e9165218b.camel@sipsolutions.net>
 <7338263c-9e01-1559-888f-adcb4b7c8ca1@wetzel-home.de>
 <08b4769ff83eb9b098fee8915ca25666f29512c7.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <51a0897b-c4a5-8988-eec5-33be8cab67f3@wetzel-home.de>
Date:   Tue, 16 Apr 2019 23:32:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <08b4769ff83eb9b098fee8915ca25666f29512c7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 5332824910267817159
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrfedugdduieefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 16.04.19 um 21:11 schrieb Johannes Berg:
> On Tue, 2019-04-16 at 20:28 +0200, Alexander Wetzel wrote:
> 
>> They can enable the mode when a key with IEEE80211_KEY_FLAG_NO_AUTO_TX
>> set
> 
> This I agree with.
> 
>> and quiet it again as soon as they get a MPDU using the new KeyID.
> 
> This isn't true, afaict. You need to be sure that no MPDUs remain using
> the old key ID, not just that the new key ID showed up.
> 

Hm, you are right. There is no grantee that after the first frame with 
the new keyID all frames after that will also use the new keyID when 
using different priority classes, I assume..
But each TID should have a clean cut over, shouldn't it?

But then that would only help us with cards able to control the A-MPDU 
size per TID...
Short of sending a dummy MPDU to each TID from mac80211 as key border 
and the driver waiting for all of them I can't think of anything right 
now. I really hope we can find something better...

>> Since switching back to normal doesn't have to be done immediately a
>> asyc call from Tx path or even a worker should do the job just fine.
> 
> Sure.
> 
>> Btw:
>> This also means we'll have to update the merged mac80211 Extended Key ID
>> support: We can only enable it for cards without HW crypto when they do
>> not set AMPDU_AGGREGATION. With the updated userspace these cards will
>> start using Extended Key ID with the already merged patches.
> 
> I was going to say this is fine, but no, of course not ... we shouldn't
> use different key id in the same A-MPDU.
> 
> That said, I'd be very surprised if there are any such drivers, except
> in corner cases (like loading some drivers like ath9k or iwlwifi with
> swcrypto=1 or so)
>

These should be no problem. The drivers still implement set_key and 
mac80211 will not enable Extended Key ID for them. Enabling Extended Key 
ID with SW crypto for drivers implementing set_key is only possible by 
patching either mac80211 or the driver.

Btw:
That was the main use case I added the mac80211 module parameter 
ieee80211_extended_key_id for. But looks like that was of too little use 
and cut out.

>> Of those only hwsim and brcmsmac seems to support AMPDU and only
>> brcmsmac relly needs the fix to not lose some packets when rekeying.
> 
> I can't believe that brcmsmac has no HW crypto support?

I've just greped the drivers, brcmsmac has ampdu_action in its 
implementation of struct ieee80211_ops but no set_key.
So it really looks like SW crypto only to me...

> 
> Anyway, a patch - even if it serves mostly as documentation - would be
> most welcome.

I'll prepare something. Looks really trivial to fix that.

>> I assume we still have to wait till the API is in mainline (probably
>> 5.2) to ask hostapd/wpa_supplicant to merge the patches?
> 
> No, mac80211-next is (usually?) good enough.

Good to know:-)

Alexander
