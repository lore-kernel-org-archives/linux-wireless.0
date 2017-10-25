Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snoopy.schmut.com ([185.37.248.246]:60550 "EHLO
        snoopy.schmut.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751998AbdJYHIZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 03:08:25 -0400
Subject: Re: iwlwifi crash with hostapd
To: linux-wireless@vger.kernel.org
References: <6e51916a-6178-5620-8f45-54705c1b4d98@schmut.com>
 <20171012212454.GB4362@us.netrek.org>
 <b985bbb0-ec49-0506-871e-b65837b05be2@schmut.com>
 <20171016033727.GB13209@us.netrek.org>
 <2f83cea3-1760-1557-c0ff-0d40ab20f9e8@schmut.com>
 <20171017233558.GD6841@us.netrek.org> <20171018213337.GA5595@us.netrek.org>
 <bc6a9aa0-8f13-4e8e-0c40-c19246ad2934@schmut.com>
 <20171019205933.GB7281@us.netrek.org>
 <8b961054-0b13-771b-387e-b47837c493ca@schmut.com>
 <20171024210157.GA19317@us.netrek.org>
From: Mario Theodoridis <mario@schmut.com>
Message-ID: <cd09974a-fb0d-2e38-95ce-31dcb6ed10d3@schmut.com> (sfid-20171025_090842_260400_1714A4B1)
Date: Wed, 25 Oct 2017 09:08:17 +0200
MIME-Version: 1.0
In-Reply-To: <20171024210157.GA19317@us.netrek.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24/10/17 23:01, James Cameron wrote:
> Summary: WARN_ON(iwl_mvm_is_dqa_supported(mvm)) in
> iwl_mvm_rx_tx_cmd_single with v4.13, but code is since changed.
> 
> On Tue, Oct 24, 2017 at 09:56:31PM +0200, Mario Theodoridis wrote:
>> Sorry for skipping the list one the last one.
> 
> Sorry, that was my fault.  It was a private message you replied to.
> 
>> On 19.10.2017 22:59, James Cameron wrote:
>> [...]
> 
> You didn't say virtualbox was essential for reproducing the problem,
> so I'm continuing to exclude it from thought.  If it is essential for
> reproducing, then you might contact them.
> 
> Please do make sure you can exclude virtualbox as a cause.

Let me clarify the virtualbox thing. The machine in question is a VM 
host. It hosts several machines, one of which is my mail server, and 
another (openbsd) which acts as a gateway to the internet for all machines.
If i run this machine without virtualbox, then my entire network 
topology is off-line. While one could argue, that this is bad design, 
the alternative would be to use openbsd as a virtual host, but i haven't 
seen many tutorials on that. I also would like to run just one machine 
24/7 to keep a tap on the electricity consumption.

This machine also bridges several interfaces and acts as a hotspot for 
my wlan.

So i don't know whether virtualbox is responsible, but not running 
virtualbox is simply not an option.

>> This one pretty quickly loads my syslog with new error stacks. I
>> haven't tested actual behavior yet, but the logs don't look so hot.
> 
> Do connections frequently keep dying as before?
> 
>> I ran another wireless-info (attached) and appended some of the
>> syslog stuff to it.
> 
> Thanks, you identified a line of code and cause; a WARN_ON in
> iwl_mvm_rx_tx_cmd_single;
> 
> 		case TX_STATUS_FAIL_DEST_PS:
> 			/* In DQA, the FW should have stopped the queue and not
> 			 * return this status
> 			 */
> 			WARN_ON(iwl_mvm_is_dqa_supported(mvm));
> 			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
> 			break;
> 
> But it is only a warning.  If connections aren't dying, it may not be
> important to you.
> 
> Please check you are using the most recent linux-firmware?

I'm running
ii  linux-firmware   1.169         all
from artful.
No difference to the xenial version.

> 
>>> Several methods, though by far the most common seems to be personal
>>> experience with offsets.
>>>
>>> When you don't have that personal experience, the methods are;
>>>
>>> 1.  using GDB against the .o file,
>>>
>>> 2.  using binutils objdump to disassemble .o file or vmlinuz,
>>>
>>> 3.  using GCC to generate assembly listings,
>>>
>>> See https://wiki.ubuntu.com/Kernel/KernelDebuggingTricks right down
>>> the end of page for the GDB method.
>>
>> I have gotten around to that part, yet, as i was busy with the
>> above, but it seems later versions have issues, too.
> 
> However, you're still testing old source code.
> 
> Several changes made since are worth testing, please either
> cherry-pick the patches or test a 4.14 rc kernel, and without
> involving dkms or virtualbox.

Then i'd have to patch those files so they build for 4.14 first.
I've seen patches, but still need to figure out how to get them applied 
in the build process.

-- 
Mit freundlichen Grüßen/Best Regards

Mario Theodoridis
