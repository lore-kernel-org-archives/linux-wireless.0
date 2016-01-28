Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:57368 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbcA1V5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 16:57:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Jouni Malinen <j@w1.fi>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] hostap: avoid uninitialized variable use in hfa384x_get_rid
Date: Thu, 28 Jan 2016 22:57:07 +0100
Message-ID: <2640544.07pTZp3kGe@wuerfel> (sfid-20160128_225755_060779_E4605B2A)
In-Reply-To: <20160127192612.GD10826@n2100.arm.linux.org.uk>
References: <1453902342-3420391-1-git-send-email-arnd@arndb.de> <20160127192612.GD10826@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 27 January 2016 19:26:13 Russell King - ARM Linux wrote:
> On Wed, Jan 27, 2016 at 02:45:26PM +0100, Arnd Bergmann wrote:
> So, why give the compiler a hard time as you're doing, why make the code
> harder to read.  What's wrong with:
> 
>         spin_lock_bh(&local->baplock);
> 
>         res = hfa384x_setup_bap(dev, BAP0, rid, 0);
>         if (res)
>                 goto unlock;
> 
>         res = hfa384x_from_bap(dev, BAP0, &rec, sizeof(rec));
>         if (res)
>                 goto unlock;
> 
>         if (le16_to_cpu(rec.len) == 0) {
>                 /* RID not available */
>                 res = -ENODATA;
>                 goto unlock;
>         }
> 
>         rlen = (le16_to_cpu(rec.len) - 1) * 2;
>         if (exact_len && rlen != len) {
>                 printk(KERN_DEBUG "%s: hfa384x_get_rid - RID len mismatch: rid=0x%04x, len=%d (expected %d)\n",
>                        dev->name, rid, rlen, len);
>                 res = -ENODATA;
>                 goto unlock;
>         }
> 
>         res = hfa384x_from_bap(dev, BAP0, buf, len);
> unlock:
>         spin_unlock_bh(&local->baplock);
> 
> ?
> 

Good idea, I'll send a new version.

	Arnd
