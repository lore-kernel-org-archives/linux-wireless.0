Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55887 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbZHNMaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 08:30:16 -0400
Date: Fri, 14 Aug 2009 08:27:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH -stable] rt2x00: fix memory corruption in rf cache, add
	a sanity check
Message-ID: <20090814122732.GC2650@tuxdriver.com>
References: <1250247548-3429-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250247548-3429-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 12:59:08PM +0200, Stanislaw Gruszka wrote:
> From: Pavel Roskin <proski@gnu.org>
> 
> Change rt2x00_rf_read() and rt2x00_rf_write() to subtract 1 from the rf
> register number.  This is needed because the rf registers are enumerated
> starting with one.  The size of the rf register cache is just enough to
> hold all registers, so writing to the highest register was corrupting
> memory.  Add a check to make sure that the rf register number is valid.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> I think nobody send this patch against stable yet. I have problem with
> rt73usb memory corruption on 2.6.30, this patch solve it. Not sure if 
> patch is also useful for 2.6.27. 

Thanks for pointing this out, I missed the memory corruption comment.

Since this hasn't gone to Linus yet, I don't think the stable guys
will take it.  I'll add a "Cc: stable@kernel.org" when I send it to
Dave/Linus so that the stable guys will see it automatically.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
