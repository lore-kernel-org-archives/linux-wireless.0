Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:62863 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966090AbXEWAUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 20:20:00 -0400
Message-ID: <46537536.8070500@linux.intel.com>
Date: Tue, 22 May 2007 15:56:54 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com> <46537603.6040208@garzik.org> <4653654F.1060708@linux.intel.com> <46537FA4.2040907@garzik.org>
In-Reply-To: <46537FA4.2040907@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> James Ketrenos wrote:
>> Jeff Garzik wrote:
>>> James Ketrenos wrote:
>>>> That said -- if the driver can execute in parallel to the stack for 
>>>> some operations, shouldn't they remain on their own workqueues so 
>>>> the work can be divided up vs. having *everything* routed through 
>>>> one singlethread workqueue?
>>>
>>> Just because it -can-, does not mean it should.
>>>
>>> Unless there is a -proven- need for the operations to be parallel, 
>>> you should avoid the burden of such complexity.
>>
>> There is no additional complexity by having the driver create its own 
>> workqueue; it just calls create_workqueue during probe and 
>> destroy_workqueue during remove.
> 
> That is obviously false.  Ignoring the additional code and memory usage, 
> you must additionally evaluate the potential for deadlocks and races.

So you're saying that by using mac80211's workqueue a driver no longer has to worry about any deadlocks or race conditions?  That is obviously false.

> And then there is the Linus mantra:  do what you must, and no more.  No 
> need for additional workqueues has been demonstrated.  (which I noticed 
> your response completely skipped -- an implicit admission of lack of need)

Funny.  I noticed you completely deleted the part of my original email that listed one reason why we can't just use mac80211's workqueue currently:

"We need to have a workqueue for initializing the adapter and uCode before we call ieee80211_register_hw.  If ieee80211_alloc_hw created the workqueue, that would work for us (assuming there aren't going to be any side effects from us flushing the workqueue before we call ieee80211_free_hw/ieee80211_unregister_hw) "

I didn't say we can't use mac80211's workqueue if it was created/destroyed during alloc/free vs. hw register.  

I asked a question about if work can execute in parallel, shouldn't we let it -- and you came back saying I have to prove a need to execute in parallel.  I get your point -- Linux isn't about innovation, discussion, or putting code out and having it evolve and stand the test of time.  Its about doing exhaustive experimentation in house, putting together a thesis, and then submitting it to the mailing list.  I'll do my best to follow that model moving forward.

Thanks,
James

> 
>     Jeff
> 
