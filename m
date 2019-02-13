Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6C8C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 00:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 739B7218FF
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 00:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="BvRJOu2E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404619AbfBNAHk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 19:07:40 -0500
Received: from 5.mo173.mail-out.ovh.net ([46.105.40.148]:32929 "EHLO
        5.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404614AbfBNAHk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 19:07:40 -0500
X-Greylist: delayed 1799 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2019 19:07:39 EST
Received: from player761.ha.ovh.net (unknown [10.109.143.246])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id BF064ECBBF
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 00:29:03 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player761.ha.ovh.net (Postfix) with ESMTPSA id 534712B48472;
        Wed, 13 Feb 2019 23:29:01 +0000 (UTC)
Subject: Re: [RFC PATCH v3 09/12] ath: Basic Extended Key ID support
 (COMPAT+NATIVE)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550099739;
        bh=ReYCvH/uDF9ZviSbRMuYewHQaYRMsPGyLm3EPZ1cRSg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=BvRJOu2EjGNnQ2/9vbW5eyrGb/E5AYLNVox7RIbifopu6u4axccnrYwTsncdr3CxL
         JCOH4fbyG4QHi7RXJ+hx5D76qZ/KY8RHMepOT8Zlh5tHHuUBq/GMA8gyKV19GshiH7
         cxFKJfTJO2ByWn5tkxVpAJeF2NCu2bESCd0rfcDg=
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-10-alexander@wetzel-home.de>
 <87r2ccq78j.fsf@purkki.adurom.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <750c25be-478e-4be4-6118-f272825ea50c@wetzel-home.de>
Date:   Thu, 14 Feb 2019 00:15:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <87r2ccq78j.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12123408725449317400
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleeggddvlecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> 
>> Extend the shared ath key cache code to support Extended Key ID.
>>
>> The key cache code has to accept unicast keys to use key idx 1 and allow
>> drivers to enable/disable hardware Rx decryption for a key independent
>> from Tx.
>>
>> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
>> ---
>>
>> I know this is the wrong audience to discuss ath drivers.
> 
> I think this is the right forum. Do note that somewhere in this patch
You are of course right. I mixed that up somehow.

We can of course also discuss the ath patches any time :-)
My initial plan was, to get the nl80211/mac80211 API finalized and then 
get them reviewed together with another planned fix after some more 
polishing.

At this stage they are just a POC and not ready for merge. They work 
with ath9k in AP (vlan) mode and I believe managed mode should either 
work or need some trivial fix only. (There even seems to be a chance 
that managed mode could allow the usage of the NATIVE Extended Key ID 
mode, but so far I could not tested that.)

> (in the cover letter) you mentioned "all ath drivers" but AFAICS this
> patch only changes functionality for ath5k, ath9k and ath9k_htc. All the
> rest like wil6210, ath6kl and ath10k are unaffected.
> 
You are right, I should have used "shared ath key cache code" in the 
Cover Letter, as in the patch itself. This is not (yet) an attempt to 
implement Extended Key ID for anything else than ath9k AP mode. So any 
driver not using ath_key_config() won't be affected at all.

Now I believe it's possible for all Atheros drivers but the ath10k to 
get support. As long as a card can work with SW crypto we only need a 
way to disable Rx HW crypto for a running key without impact for ongoing Tx.
But the initial results when trying my hand at ath10k are strongly 
indicating the best we can hope there is SW encryption only with CT 
firmware... or maybe a firmware update.

While the API itself is perfectly able to handle NATIVE mode the keyid 
is not handled correctly. Installing a second key switches TX to the new 
key and overwrites the keyid in the MPDU mac80211 prepared. (I could not 
even get the card to properly make an RX/TX key to an TX only key, that 
caused clear text packets when changing the key and it looks like that 
SW crypto is only possible - with nonfree CT - when not using HW crypto 
for TX at all. With those limitations I shelved any plans for ath10k.)

One of my next planned steps is now to either get another ath9k card or 
get another driver working in AP mode to test ath9k also in managed 
mode. Of course I also have to get sniffing working properly, all cards 
tried so far have issues and it also looks like I have to update 
wireshark for serious testing. So I guess driver support will still take 
some time and efforts when we got the generic issues sorted out.

I can also try my hand at porting the other Atheros drives, but without 
someone being able to confirm it works I'm not planning that at the moment.

Alexander





