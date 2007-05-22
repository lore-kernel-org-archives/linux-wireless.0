Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:56578 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbXEVXl2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 19:41:28 -0400
Message-ID: <46537FA4.2040907@garzik.org>
Date: Tue, 22 May 2007 19:41:24 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <200705162151.32910.flamingice@sourmilk.net> <46534172.5040106@linux.intel.com> <46537603.6040208@garzik.org> <4653654F.1060708@linux.intel.com>
In-Reply-To: <4653654F.1060708@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Ketrenos wrote:
> Jeff Garzik wrote:
>> James Ketrenos wrote:
>>> That said -- if the driver can execute in parallel to the stack for 
>>> some operations, shouldn't they remain on their own workqueues so the 
>>> work can be divided up vs. having *everything* routed through one 
>>> singlethread workqueue?
>>
>> Just because it -can-, does not mean it should.
>>
>> Unless there is a -proven- need for the operations to be parallel, you 
>> should avoid the burden of such complexity.
> 
> There is no additional complexity by having the driver create its own 
> workqueue; it just calls create_workqueue during probe and 
> destroy_workqueue during remove.

That is obviously false.  Ignoring the additional code and memory usage, 
you must additionally evaluate the potential for deadlocks and races.

And then there is the Linus mantra:  do what you must, and no more.  No 
need for additional workqueues has been demonstrated.  (which I noticed 
your response completely skipped -- an implicit admission of lack of need)

	Jeff



