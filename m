Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:56672 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab1BNPjx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 10:39:53 -0500
Message-ID: <4D594CC4.9020906@neratec.com>
Date: Mon, 14 Feb 2011 16:39:48 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Review of moving all DFS parameters to userspace
References: <AANLkTimSV7rHhdjWqfV5ujW6dd==BusmeC8fJOXGxfaT@mail.gmail.com> <20110201173247.GE2560@tuxdriver.com>
In-Reply-To: <20110201173247.GE2560@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2011 06:32 PM, John W. Linville wrote:
> On Tue, Feb 01, 2011 at 08:38:05AM -0800, Luis R. Rodriguez wrote:
>> I though we had reviewed the possibility of moving DFS parameters to
>> userspace but it seems that's not the case. We now at least know we
>> can keep the DFS regions: US, JP, ETSI, the next step is to determine
>> if the DFS parameters for these regions will come from userspace or
>> kernelspace. I'm inclined to support starting off with moving this to
>> kernelspace just to let us move forward with this support, and once in
>> kernel, review the possibility to move this out to userspace.
>>
>> Thoughts?
> 
> Seems like a reasonable approach for the short term...better than
> locking-in userland ABI...
> 
> John

Sorry, I was not aware that the userspace DFS approach was already discussed 
and rejected. I missed two IRC meetings in January and reading [1] sounded 
to me that potential approaches are still evaluated.

Anyhow, I meanwhile posted both approaches (kernel vs. userspace) that are 
equivalent from functional point, assuming that a HW independent pattern 
matching is what we need to implement for DFS radar detection.

This in fact is still an open issue: Atheros claimed that detection is 
HW-dependent while we have got up and (maybe not-so-perfectly ;)) running 
HW-independen radar pattern detection. We are still waiting to get Atheros' 
pattern detector source code to evaluate detection performance and finally 
prove the benefit of a HW dependent implementation.

Until then (and since the DFS activities degraded lastly) we will continue 
fine-tuning our detectors based on the proposed design and move to the 
finally chosen architecture as soon as an agreement is reached.



Cheers
Zefir



[1] http://linuxwireless.org/en/developers/DFS/#DFS_events
