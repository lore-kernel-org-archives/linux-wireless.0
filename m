Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51415 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759779Ab2JaTSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 15:18:39 -0400
Message-ID: <5091798A.7010104@candelatech.com> (sfid-20121031_201842_591882_F6A88DFD)
Date: Wed, 31 Oct 2012 12:18:34 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WARNING in agg-tx.c (3.5.7+, not tainted)
References: <509173D0.9010701@candelatech.com>  (sfid-20121031_195414_905498_198D44C4) <1351710647.6281.10.camel@jlt4.sipsolutions.net>
In-Reply-To: <1351710647.6281.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2012 12:10 PM, Johannes Berg wrote:
> On Wed, 2012-10-31 at 11:54 -0700, Ben Greear wrote:
>> While trying to debug another kernel splat, I saw this one.  System was
>> in process of creating and getting DHCP for 400 virtual stations.
>>
>> Code in question:
>>
>>
>>
>> 	mutex_lock(&sta->ampdu_mlme.mtx);
>> 	tid_tx = rcu_dereference_protected_tid_tx(sta, tid);
>>
>> 	if (WARN_ON(!tid_tx)) {
>> #ifdef CONFIG_MAC80211_HT_DEBUG
>> 		printk(KERN_DEBUG "addBA was not requested!\n");
>> #endif
>
> Hm should probably be a WARN(), but ...
>
>>From the backtrace it looks like maybe you were tearing down the
> interface? So maybe it's possible that you were remove it or something,
> and the driver had just accepted the session? Hmm.

I've got 400 interfaces churning, some being reset due to lack of
fast enough DHCP response, etc.  Could easily be related to that
drv-remove-interface bug as well..it is much more easily reproduced
in this scenario.  Will re-run some tests with your suggested patch
applied...

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

