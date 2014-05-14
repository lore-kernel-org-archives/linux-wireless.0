Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3970 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbaENEza convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 00:55:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: "quozl@laptop.org" <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 13 May 2014 21:55:10 -0700
Subject: RE: mwifiex: no wr_port available
Message-ID: <477F20668A386D41ADCC57781B1F70430F70D87C85@SC-VEXCH1.marvell.com> (sfid-20140514_065534_989091_989610A2)
References: <20140507120634.GM17490@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70D87C4D@SC-VEXCH1.marvell.com>
 <20140514031804.GN12785@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70D87C6F@SC-VEXCH1.marvell.com>
 <20140514042654.GQ12785@us.netrek.org>
In-Reply-To: <20140514042654.GQ12785@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> > > You may be interested that rd_port also has possible leak when skb
> > > cannot be allocated.  See mwifiex_process_int_status:
> > >
> > > 		skb = dev_alloc_skb(rx_len);
> > > 		if (!skb)
> > > 			return -1;
> > >
> > > We have a hack in OLPC production arm-3.5 kernel which restores
> > > rd_port bit, restores int_status.
> > >
> > > http://dev.laptop.org/git/olpc-kernel/commit/?h=arm-
> 3.5&id=59fcaf10cce5bbdc370ec1c262b12aeb66ed1dca
> >
> > The rd_port/int_status change looks correct. But what issue did you
> > encounter prior to applying the change "cache the read bitmap at the
> > time of the interrupt rather than when the interrupt status bits are
> > handled"?
> 
> No specific issue, instead ensuring that all effects are rolled back.
> The effects of a call to mwifiex_process_int_status that returned -1
> due to dev_alloc_skb fail were:
> 
> - change to curr_rd_port,
> 
> - bits cleared in mp_rd_bitmap,
> 
> So both effects were rolled back.  Perhaps not needed?

It's probably not needed. Anyway you don't have to remove it as it doesn't seem to hurt.

> 
> I'm not recommending this as the right solution, because the patch
> caused CPU loop during memory exhaustion, the interrupt came
> back immediately.  I added a hack to reduce impact of that:
> 
> http://dev.laptop.org/git/olpc-kernel/commit/?h=arm-3.5&id=491188ebd4721f3c8804b7fa626e63d6fdd2ed09
> 
> I did not have the experience to find out _why_ we could not
> dev_alloc_skb, but at least was able to let the driver continue rather
> than timeout.

On some system, once dev_alloc_skb fails it may always fail no matter how many times you try unless you reboot.
So we should allow the failure of dev_alloc_skb for that reason. If your system works this way it's fine. But you can probably consider put a limit on dev_alloc_skb attempts.

Thanks,
Bing


