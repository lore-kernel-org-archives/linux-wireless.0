Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60466 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbYAMV3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 16:29:47 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH] b43: rfkill use after free
Date: Sun, 13 Jan 2008 22:28:27 +0100
Cc: bcm43xx-dev@lists.berlios.de, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <1200259252.4393.22.camel@localhost.localdomain>
In-Reply-To: <1200259252.4393.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200801132228.28234.mb@bu3sch.de> (sfid-20080113_213011_363169_4CC115F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 13 January 2008 22:20:52 Eric Paris wrote:
> inside b43_rfkill_exit() we call rfkill_unregister() which puts the last
> reference and frees the rfkill struct.  Then just 3 lines later the code
> explicitly calls rfkill_free() on the struct we already freed.  This
> showed up as slub corruption (what should have been 6b was showing up as
> 6a) since the rfkill_free had dec'ed the are that should have been the
> use counter.
> 
> stop using the already freed rfkill struct.
> 
> =============================================================================
> BUG kmalloc-1024 (Not tainted): Poison overwritten
> -----------------------------------------------------------------------------
> 
> INFO: 0xf40b89e8-0xf40b89e8. First byte 0x6a instead of 0x6b
> INFO: Allocated in rfkill_allocate+0x1b/0x8b [rfkill] age=231032011 cpu=0 pid=2403
> INFO: Freed in rfkill_release+0xd/0x19 [rfkill] age=366 cpu=0 pid=2403
> INFO: Slab 0xc1b62840 used=6 fp=0xf40b8860 flags=0x400040c3
> INFO: Object 0xf40b8860 @offset=2144 fp=0x00000000
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> ---
> 
>  drivers/net/wireless/b43/rfkill.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
> index 98cf70c..a19be53 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -195,6 +195,5 @@ void b43_rfkill_exit(struct b43_wldev *dev)
>  	rfkill_unregister(rfk->rfkill);
>  	input_free_polled_device(rfk->poll_dev);
>  	rfk->poll_dev = NULL;
> -	rfkill_free(rfk->rfkill);
>  	rfk->rfkill = NULL;
>  }
> 
> 
> 
> 

NACK.
Better patch available from Stefano.

-- 
Greetings Michael.
