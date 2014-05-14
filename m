Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:43804 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaENE1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 00:27:19 -0400
Date: Wed, 14 May 2014 14:26:54 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Subject: Re: mwifiex: no wr_port available
Message-ID: <20140514042654.GQ12785@us.netrek.org> (sfid-20140514_062723_289454_A0BF90F1)
References: <20140507120634.GM17490@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70D87C4D@SC-VEXCH1.marvell.com>
 <20140514031804.GN12785@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70D87C6F@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70D87C6F@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2014 at 08:54:53PM -0700, Bing Zhao wrote:
> Hi James,
> [...]
> > You may be interested that rd_port also has possible leak when skb
> > cannot be allocated.  See mwifiex_process_int_status:
> > 
> > 		skb = dev_alloc_skb(rx_len);
> > 		if (!skb)
> > 			return -1;
> > 
> > We have a hack in OLPC production arm-3.5 kernel which restores
> > rd_port bit, restores int_status.
> > 
> > http://dev.laptop.org/git/olpc-kernel/commit/?h=arm-3.5&id=59fcaf10cce5bbdc370ec1c262b12aeb66ed1dca
> 
> The rd_port/int_status change looks correct. But what issue did you
> encounter prior to applying the change "cache the read bitmap at the
> time of the interrupt rather than when the interrupt status bits are
> handled"?

No specific issue, instead ensuring that all effects are rolled back.
The effects of a call to mwifiex_process_int_status that returned -1
due to dev_alloc_skb fail were:

- change to curr_rd_port,

- bits cleared in mp_rd_bitmap,

So both effects were rolled back.  Perhaps not needed?

I'm not recommending this as the right solution, because the patch
caused CPU loop during memory exhaustion, the interrupt came
back immediately.  I added a hack to reduce impact of that:

http://dev.laptop.org/git/olpc-kernel/commit/?h=arm-3.5&id=491188ebd4721f3c8804b7fa626e63d6fdd2ed09

I did not have the experience to find out _why_ we could not
dev_alloc_skb, but at least was able to let the driver continue rather
than timeout.

-- 
James Cameron
http://quozl.linux.org.au/
