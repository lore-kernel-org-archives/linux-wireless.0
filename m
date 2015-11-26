Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43880 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbbKZNBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 08:01:11 -0500
Date: Thu, 26 Nov 2015 16:00:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: (bug report) b43: impossible conditions in debugfs
Message-ID: <20151126130033.GG7289@mwanda> (sfid-20151126_140115_788902_996D534E)
References: <20151126115924.GI10556@mwanda>
 <20151126133241.5bc5a793@wiggum>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20151126133241.5bc5a793@wiggum>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 26, 2015 at 01:32:41PM +0100, Michael Büsch wrote:
> > See also:
> > drivers/net/wireless/broadcom/b43/debugfs.c:346 mmio32write__write_file() warn: impossible condition '(mask > 4294967295) => (0-u32max > u32max)'
> > drivers/net/wireless/broadcom/b43/debugfs.c:346 mmio32write__write_file() warn: impossible condition '(set > 4294967295) => (0-u32max > u32max)'
> 
> 
> 
> Sure. These are intentional.
> The compiler will optimize this out.

Hm...  We try to ignore when people do intentional comparisons with zero
like this:

	if (unsigned_var < 0 || unsigned_var >= 10)
		return -EINVAL;

Because they are obviously harmless and they don't hurt readability.
Also Linus doesn't like removing these.

But what's the point of this?  I have seen these before when I was
checking ide_set_disk_chs() for underflows.  I also reported another one
recently that was exactly the same as this and the guy changed it from
if (x > UINT_MAX) to if (!(x < UINT_MAX))...  I don't get it.

regards,
dan carpenter


