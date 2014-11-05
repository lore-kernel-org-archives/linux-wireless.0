Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:37866 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaKEGZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 01:25:45 -0500
Date: Wed, 5 Nov 2014 17:25:16 +1100
From: James Cameron <quozl@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	cluo@marvell.com, huxm@marvell.com, yangyang@marvell.com,
	Avinash Patil <patila@marvell.com>
Subject: Re: [Patch v2 3/5] mwifiex: fix out of memory issue observed for USB
 chipsets
Message-ID: <20141105062516.GS1015@us.netrek.org> (sfid-20141105_072605_074101_C9AF019D)
References: <1415187271-17914-1-git-send-email-akarwar@marvell.com>
 <1415187271-17914-3-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1415187271-17914-3-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 05, 2014 at 05:04:29PM +0530, Amitkumar Karwar wrote:
> On some platforms, system goes out of memory during heavy
> Rx traffic with our USB chipsets.
> 
> In case of SDIO/PCIe, after receiving 50 packets in Rx queue
> we stop processing interrupts till packets pending fall below
> low threshold i.e 20. We don't have similar logic for USB,
> so if host platform is slow, we would hit a case where firmware
> keeps on pushing packets at high speed than driver/kernel can
> process.
> 
> We will stop submitting URBs for Rx data when pending packet
> count reaches high threshold and restart them when enough
> packets are consumed to solve the problem.

Other drivers and user activity can deplete memory.  How does this
patch solve the problem when dev_alloc_skb fails?  I'm worried the
underlying issue remains; handling out of memory.

-- 
James Cameron
http://quozl.linux.org.au/
