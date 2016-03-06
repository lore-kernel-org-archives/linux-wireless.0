Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:33432 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbcCFW2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2016 17:28:05 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>, Luca Coelho <luca@coelho.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Gottlieb, Matti" <matti.gottlieb@intel.com>
Subject: Re: [PATCH 2/2] iwlwifi: mvm: Fix paging memory leak
Date: Sun, 6 Mar 2016 13:49:20 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA59578@hasmsx107.ger.corp.intel.com> (sfid-20160306_232810_951864_0EE07469)
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA41983@hasmsx107.ger.corp.intel.com>
 <1456433829-20285-2-git-send-email-emmanuel.grumbach@intel.com>
 <87povaw7jc.fsf@kamboji.qca.qualcomm.com>
 <1457120732.28365.166.camel@coelho.fi>
 <878u1vx185.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/06/2016 02:04 PM, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
>
>> On Fri, 2016-03-04 at 18:07 +0200, Kalle Valo wrote:
>>> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
>>>
>>>> From: Matti Gottlieb <matti.gottlieb@intel.com>
>>>>
>>>> If the opmode is stopped and started again we did not free
>>>> the paging buffers. Fix that.
>>>> In addition when freeing the firmware's paging download
>>>> buffer, set the pointer to NULL.
>>>>
>>>> Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
>>>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>>
>>> Nitpicking while writing the pull request for Dave:
>>>
>>> What does "opmode is stopped" mean? Important bug fixes should have a
>>> clear bug description from user's point of view. Using driver internal
>>> jargon is gibberish to most people.
>>
>> I agree that there could be a bit more high-level description here, but
>> I also think it's good to keep a bit more details about what is
>> happening internally, so that developers understand too. ;)
>
> Sure, feel free to write as much as you want and in such detail as you
> think is necessary :) Just having a clear summary without internal
> jargon helps people outside of iwlwifi.
>
> BTW, the other iwlwifi fix had a bit similar problem:
>
> https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=fb896c44f88a75843a072cd6961b1615732f7811
>
> What does "non-sta" mean in this context? Is it the AP or what? Or
> something not part of the current BSS? I guess I might find a definition
> from the spec or from iwlwifi sources but I really should not be forced
> to do that.

non-sta in that context means an skb sent without a valid ieee80211_sta 
buffer. Which basically means that it is a non-data frame or a multicast 
frame.

>
>> Do you think it would be acceptable to keep the commit log most as it
>> is, but start with something like "Some paging buffers were not freed
>> when the driver is restarted."? I don't mean to change this commit
>> itself, but just so that we know how to please you (and users) while
>> still keeping the details as part of the commit logs... ;)
>
> That sounds good to me. What I'm after is that someone like Dave or
> Linus can understand from the commit log what kind of bug this patch is
> fixing, without looking into source or checking mailing lists. This is
> especially more important in the later stages of the cycle.
>
>>> I investigated this myself and apparently "opmode" is stopped when the
>>> module is unloaded or the PCI device is removed. So just say that in the
>>> commit log and everyone understand much better.
>>
>> Our driver is divided roughly into two layers: the bus layer (called
>> transport) and the protocol layer (called opmode).  The name comes from
>> the difference between the two opmodes that we currently have.  One
>> supports only a single operating channel (dvm) and the other supports
>> multiple operating channels (mvm).
>>
>> Hope this clarifies a bit. :)
>
> It did, thanks.
>
