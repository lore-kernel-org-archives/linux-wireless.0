Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57325 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbXEWA6V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 20:58:21 -0400
Message-ID: <465391A5.4090608@garzik.org>
Date: Tue, 22 May 2007 20:58:13 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com> <46537603.6040208@garzik.org> <4653654F.1060708@linux.intel.com> <46537FA4.2040907@garzik.org> <46537536.8070500@linux.intel.com>
In-Reply-To: <46537536.8070500@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Ketrenos wrote:
> Jeff Garzik wrote:
>> James Ketrenos wrote:
>>> Jeff Garzik wrote:
>>>> James Ketrenos wrote:
>>>>> That said -- if the driver can execute in parallel to the stack for 
>>>>> some operations, shouldn't they remain on their own workqueues so 
>>>>> the work can be divided up vs. having *everything* routed through 
>>>>> one singlethread workqueue?
>>>>
>>>> Just because it -can-, does not mean it should.
>>>>
>>>> Unless there is a -proven- need for the operations to be parallel, 
>>>> you should avoid the burden of such complexity.
>>>
>>> There is no additional complexity by having the driver create its own 
>>> workqueue; it just calls create_workqueue during probe and 
>>> destroy_workqueue during remove.
>>
>> That is obviously false.  Ignoring the additional code and memory 
>> usage, you must additionally evaluate the potential for deadlocks and 
>> races.
> 
> So you're saying that by using mac80211's workqueue a driver no longer 
> has to worry about any deadlocks or race conditions?  That is obviously 
> false.

Don't be dense.  If two operations are guaranteed to go down the same 
pipeline, then there is a clear sequence guarantee that is not present 
if operations are [needlessly] parallel.



> I didn't say we can't use mac80211's workqueue if it was 
> created/destroyed during alloc/free vs. hw register. 
> I asked a question about if work can execute in parallel, shouldn't we 
> let it

Without justification for the additional complexity, the answer is no.

	Jeff


