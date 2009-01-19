Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7961 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794AbZASDQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 22:16:07 -0500
Subject: Re: [Orinoco-devel] [PATCH] [2.6.29-rc2] orinoco: use GFP_ATOMIC
 in kmalloc in orinoco_ioctl_set_genie
From: Pavel Roskin <proski@gnu.org>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <200901171822.45476.arvidjaar@mail.ru>
References: <200901171822.45476.arvidjaar@mail.ru>
Content-Type: text/plain
Date: Sun, 18 Jan 2009 22:16:04 -0500
Message-Id: <1232334964.5609.37.camel@dv> (sfid-20090119_041612_303213_03AB2DEC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-01-17 at 18:22 +0300, Andrey Borzenkov wrote:
> Subject: [PATCH] [2.6.29-rc2] orinoco: use GFP_ATOMIC in kmalloc in 
> orinoco_ioctl_set_genie
> From: Andrey Borzenkov <arvidjaar@mail.ru>
> 
> kmalloc is called with interrupt disabled and may not sleep. This
> fixes this BUG:

Please move kmalloc before the lock.  I don't see any reason to allocate
memory with irqs disabled.  The contention happens later, when
priv->wpa_ie is freed and assigned a new value.

-- 
Regards,
Pavel Roskin
