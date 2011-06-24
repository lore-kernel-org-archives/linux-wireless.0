Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:41586 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab1FXJNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 05:13:32 -0400
Message-ID: <4E045317.4040208@marvell.com> (sfid-20110624_111337_056595_9F35C57E)
Date: Fri, 24 Jun 2011 14:34:23 +0530
From: yogeshp <yogeshp@marvell.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom reservation
References: <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>	 <1308590980.4322.19.camel@jlt3.sipsolutions.net>	 <20110621130305.GB32464@hertz.marvell.com>	 <1308663814.4276.3.camel@jlt3.sipsolutions.net>	 <20110621141017.GC32464@hertz.marvell.com>	 <1308667215.4276.7.camel@jlt3.sipsolutions.net>	 <20110621163351.GD32464@hertz.marvell.com>	 <20110622071743.GA4087@hertz.marvell.com>	 <20110622123118.GA4800@hertz.marvell.com>	 <1308746965.29571.1.camel@jlt3.sipsolutions.net>	 <20110622125853.GA4982@hertz.marvell.com> <1308748326.29571.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1308748326.29571.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 22 June 2011 06:42 PM, Johannes Berg wrote:
> On Wed, 2011-06-22 at 18:28 +0530, Yogesh Ashok Powar wrote:
>> On Wed, Jun 22, 2011 at 05:49:25AM -0700, Johannes Berg wrote:
>>> On Wed, 2011-06-22 at 18:01 +0530, Yogesh Ashok Powar wrote:
>>>>> Will work on some other logic.
>>>>
>>>> Following is the complete V2-patch
>>>>
>>>> v2 changes: a) Moved counter++ before __ieee80211_key_replace in
>>>> 		key_link()
>>>> 	    b) Moved crypto_tx_tailroom_needed_cnt to sdata resolve
>>>> 	        issue with multiple sdata instances in hw reset.
>>>
>>> Looks good. Now I'm just worried about memory and compiler barriers that
>>> may be needed so the counter update doesn't move after anything else...
>>> Hmm.
>>
>> I some how feel that synchronize_net may be replaced with
>> synchronize_rcu and still the race wont happen.
>>
>> So the new logic would be 
>> - counter++		<-- Here keys are not added or deleted
>> 			    so rcu readers wont have problem
>> 			    with extra space allocated.
>>
>> - synchronize_rcu	<-- This will flush existing readers. Again
>> 			    new readers will have no problem with extra
>> 			    space allocated.
>>
>> Let me know your opinion on this.
> 
> It doesn't really matter -- synchronize_net() is exactly the same as
> synchronize_rcu().
> 
> What I'm worried about is that there's no memory barrier after the
> counter update, so how do we know it cannot happen after
> synchronize_rcu()? I think we need something like rcu_assign_pointer()
> but I don't see rcu_assign_index() (any more?)

Hi Johannes,
 Andreas has tested the current implementation on his setup and haven't
seen any WARN_ONs being hit. Should I send the final patch? 

Thanks
Yogesh

