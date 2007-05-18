Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:11112 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbXERWKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 18:10:31 -0400
Date: Fri, 18 May 2007 15:13:35 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Message-Id: <20070518151335.a3a756da.randy.dunlap@oracle.com>
In-Reply-To: <464E0DB5.5010802@linux.intel.com>
References: <464B7B7C.5080800@linux.intel.com>
	<20070516203505.556df4f9.randy.dunlap@oracle.com>
	<464E0DB5.5010802@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 18 May 2007 13:33:57 -0700 James Ketrenos wrote:

> > 2.  Use of bitfields:  bitfields are not (guaranteed to be) portable
> > across a wire interface to some other CPU architecture.
> > Are all bitfield uses always local to the running driver?
> > They should be.
> 
> The bitfields are between the hw/ucode (__le) and the driver.  Are you saying the bitfields won't be compatible if the driver is compiled and running on big endian?  Shouldn't le16_to_cpu() fix that?  I just noticed the types in iwl-4965-hw.h weren't endian specific; I've updated that (u16, u32, u64 -> __le16, __le32, __le64)


I'm just saying that something like
	struct bits {
		u32	priority :4;
		u32	flags :12;
		u32	direction :1;
		u32	status :15;
	};
when built on x86[-64] and then sent over a network connection
to a big-endian machine won't necessarily be looked at correctly
on the receiving machine.  There is no guarantee of bitfield order
from one platform to another.

> > 3.  What are all of those "volatile" C keywords doing in struct
> > iwl_shared?
> > See http://lwn.net/Articles/232961/ : "The trouble with volatile"
> 
> If a reference shared through memory mapped IO with a device that can change the value at any time, doesn't it need to be volatile?  'struct iwl_shared' is allocated with pci_alloc_consistent and the physical address is provided to the hardware for it to update whenever it sees fit.

That's a good question.  You probably know as much about it as I do.

Does the driver access those mmIO regions by something direct like
	*mmio =
or does the driver use some kind of access routines to read/write
the mmIO regions, such as readb()/writeb()?

If the former, then I expect that those should be changed/fixed,
but I'd prefer to have Jeff G. answer that if he would.


> > 4.  Don't list the parameters like this:
> 
> Lindent == bad.  I've fixed the instances of this munging I've come across.

Indeed.  Too bad.

> > 8.  Too many BUG_ON()s.  Try to recover or return -ERRORs instead.
> 
> I pulled out two that shouldn't have been there.
> 
> The rest are currently there map to bugs which are easily introduced through code changes but which may not cause an immediately visible bug at run-time.  Typically they are placed where an eventual printk() at that location during debugging of a user bug resulted in the critical "ah-ha!" that led to fixing it.  I've added comments to the BUG_ON's that didn't have comments already.
> 
> I suppose we could try and introduce a new driver recovery mechanism that, upon detection, throws a stack trace and then shuts down the driver (vs. throwing a kernel OOPs) requiring user space to unload and reload the driver.  That would still be a sucky situation, but at least it wouldn't cause a system failure requiring a reboot...  does such a mechanism already exist?

You can call dump_stack() or use WARN_ON(), but you'll have roll your
own shut-down-the-driver methods AFAIK.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
