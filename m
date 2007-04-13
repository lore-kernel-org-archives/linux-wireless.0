Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:49472 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbXDMBUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 21:20:51 -0400
Message-ID: <461EDB39.6080806@lwfinger.net>
Date: Thu, 12 Apr 2007 20:22:01 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev  1 PHYs
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net> <20070413000950.GC3470@tuxdriver.com>
In-Reply-To: <20070413000950.GC3470@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Apr 11, 2007 at 11:08:53AM -0500, Larry Finger wrote:
>> On PPC architecture with phy->rev == 1, machine checks occur during
>> initialization of the "Extended G PHY registers". This problem was
>> also seen on bcm43xx-softmac, and was fixed by conditionally skipping
>> over certain reads/writes of these registers.  The same solution has been
>> applied here with testing by David Woodhouse.  Note: These modifications
>> are not found in the specifications, but are needed for PPC.
> 
> I added this patch to the Fedora rawhide kernels, but our Fedora QA
> lead reports that he still has this crash:
> 
> 	http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233011
> 
> I had diagnosed this to be the same crash as this patch was supposed
> to address.  Was I in error?
> 
> He also reports that the problem still occurs on my FC7 test kernels,
> which are very close to the current rawhide kernels but with the most
> recent round of wireless-dev updates added.

I suspect the machine check is from the same kind of problem; however, the soft lockup is different. 
It is always possible that it changes the behavior. There is also the different program flow in 
mac80211. I just put in the ones that failed in softmac.

Your tester needs to get a copy of David's hack that prints out the address of the offending 
register. That is the only way to tell what is happening. Once we know the address, then it will be 
a matter of getting printk's into the code to tell which one is failing.

Larry
