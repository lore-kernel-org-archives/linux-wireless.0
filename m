Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:63188 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754030AbXDMPEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2007 11:04:35 -0400
Message-ID: <461F9C58.6050106@lwfinger.net>
Date: Fri, 13 Apr 2007 10:06:00 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Fix machine checks on PPC with rev  1 PHYs
References: <461d0815.ip3FDr8RDQXyCT4U%Larry.Finger@lwfinger.net> <20070413113638.10db9767@localhost>
In-Reply-To: <20070413113638.10db9767@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> On Wed, 11 Apr 2007 11:08:53 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> On PPC architecture with phy->rev == 1, machine checks occur during
>> initialization of the "Extended G PHY registers". This problem was
>> also seen on bcm43xx-softmac, and was fixed by conditionally skipping
>> over certain reads/writes of these registers.  The same solution has been
>> applied here with testing by David Woodhouse.  Note: These modifications
>> are not found in the specifications, but are needed for PPC.
> 
> I don't think this patch has to be reverted, but I still think that it's
> better to notice the reverse engineers team about failing operations
> and understand the real problem rather than hiding it. Which works in some
> cases, but sometimes just hide other bugs.
> 
> I'm almost done with rewriting the whole A/G/N setup and init routines,
> following the new v4 specs. This issue could even be related.

I agree that it would be better if we could follow the specs and not have the machine check problem. 
My impression is that early versions of the bcm43xx driver did not have this difficulty, but that it 
appeared after a relatively recent change in the G init specs. BTW, these were the changes that 
greatly improved performance, particularly on the phy->rev = 8 devices. Perhaps the Broadcom 
software abandoned/ignored the phy->rev = 1 units running on PPC hardware, which seems to be the 
only combination that shows the problem. I don't know about MIPS hardware, but the problem is not 
seen on x86 architecture.

I look forward to your rewrite of the setup and init routines. Perhaps they will even let my 4311 
work with mac80211, but I will be very surprised if the PPC machine check problem goes away.

Larry
