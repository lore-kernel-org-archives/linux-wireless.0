Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33352 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab2JaXo0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 19:44:26 -0400
Message-ID: <5091B7CC.8030003@candelatech.com> (sfid-20121101_004441_253435_FBD14E7C)
Date: Wed, 31 Oct 2012 16:44:12 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WARNING in agg-tx.c (3.5.7+, not tainted)
References: <509173D0.9010701@candelatech.com>   (sfid-20121031_195414_905498_198D44C4) <1351710647.6281.10.camel@jlt4.sipsolutions.net>  <5091798A.7010104@candelatech.com> <1351711256.5419.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1351711256.5419.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2012 12:20 PM, Johannes Berg wrote:
> On Wed, 2012-10-31 at 12:18 -0700, Ben Greear wrote:
>
>>>> 	mutex_lock(&sta->ampdu_mlme.mtx);
>>>> 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
>>>>
>>>> 	if (WARN_ON(!tid_tx)) {
>>>> #ifdef CONFIG_MAC80211_HT_DEBUG
>>>> 		printk(KERN_DEBUG "addBA was not requested!\n");
>>>> #endif
>>>
>>> Hm should probably be a WARN(), but ...
>>>
>>> >From the backtrace it looks like maybe you were tearing down the
>>> interface? So maybe it's possible that you were remove it or something,
>>> and the driver had just accepted the session? Hmm.
>>
>> I've got 400 interfaces churning, some being reset due to lack of
>> fast enough DHCP response, etc.  Could easily be related to that
>> drv-remove-interface bug as well..
>
> I didn't even think of that, but yeah, that seems possible.
>
>> it is much more easily reproduced
>> in this scenario.  Will re-run some tests with your suggested patch
>> applied...
>
> Ok cool.

Unfortunately, it still happens even with the other patch applied.

I have only seen it once in several hours of testing, and it doesn't
seem to cause any lasting harm.

But, I have at least some sort of test case for it, so
if you have a suggested patch, I'll be happy to test it.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

