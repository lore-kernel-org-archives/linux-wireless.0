Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:35812 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756173AbXEWTpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2007 15:45:25 -0400
Message-ID: <46548538.9080002@linux.intel.com>
Date: Wed, 23 May 2007 11:17:28 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com> <46537603.6040208@garzik.org> <4653654F.1060708@linux.intel.com> <46537FA4.2040907@garzik.org> <46537536.8070500@linux.intel.com> <465391A5.4090608@garzik.org>
In-Reply-To: <465391A5.4090608@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> James Ketrenos wrote:
>> Jeff Garzik wrote:
>>> James Ketrenos wrote:
>>>> Jeff Garzik wrote:
>>>>> James Ketrenos wrote:
>>>>>> That said -- if the driver can execute in parallel to the stack 
>>>>>> for some operations, shouldn't they remain on their own workqueues 
>>>>>> so the work can be divided up vs. having *everything* routed 
>>>>>> through one singlethread workqueue?
>>>>>
>>>>> Just because it -can-, does not mean it should.
>>>>>
>>>>> Unless there is a -proven- need for the operations to be parallel, 
>>>>> you should avoid the burden of such complexity.
>>>>
>>>> There is no additional complexity by having the driver create its 
>>>> own workqueue; it just calls create_workqueue during probe and 
>>>> destroy_workqueue during remove.
>>>
>>> That is obviously false.  Ignoring the additional code and memory 
>>> usage, you must additionally evaluate the potential for deadlocks and 
>>> races.
>>
>> So you're saying that by using mac80211's workqueue a driver no longer 
>> has to worry about any deadlocks or race conditions?  That is 
>> obviously false.
> 
> Don't be dense.  If two operations are guaranteed to go down the same 
> pipeline, then there is a clear sequence guarantee that is not present 
> if operations are [needlessly] parallel.

Being on ifsta->work doesn't guarantee any sequence--it just means ieee80211_sta_work can't process management frames at the same time the driver is doing things on that workqueue.  ieee80211_sta_work does make some driver callbacks, however those callbacks are also be made from ioctls and cfg80211.  Additionally there is other work that ieee80211_sta_work does that does not make any callbacks or state transitions into the driver.

There is no guarantee that driver callbacks from mac80211 will not occur in parallel or in different contexts. 

The driver has to protect access to memory shared across those contexts regardless of which workqueue it happens to use. 

>> I didn't say we can't use mac80211's workqueue if it was 
>> created/destroyed during alloc/free vs. hw register. I asked a 
>> question about if work can execute in parallel, shouldn't we let it
> 
> Without justification for the additional complexity, the answer is no.

Can you show me how the complexity is reduced?

    "Ignoring the additional code and memory usage, you must additionally evaluate the potential for deadlocks and races."

Given the API mac80211 exposes, and how the stack operates, I don't see how using ifsta->work as the workqueue allows the driver to no longer evaluate the potential for deadlocks and races.

The second argument you made:

    "And then there is the Linus mantra:  do what you must, and no more.  No need for additional workqueues has been demonstrated."

To make the most use of the processing and power resources available, you must execute in parallel.

I haven't seen a need, or benefit, to serialize unrelated work onto a single workqueue.

James
