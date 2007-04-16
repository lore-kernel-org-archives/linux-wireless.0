Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:42026 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753994AbXDPW7E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2007 18:59:04 -0400
Date: Tue, 17 Apr 2007 00:58:27 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Guido Guenther <agx@sigxcpu.org>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	at76c503a-develop@lists.berlios.de
Subject: Re: [at76_usb] kernel panic in update_wstats()
Message-ID: <20070417005827.6f74945a@localhost>
In-Reply-To: <20070416082912.GA19004@bogon.ms20.nix>
References: <20070415205619.6747d9ed@localhost>
	<20070416082912.GA19004@bogon.ms20.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 16 Apr 2007 10:29:12 +0200
Guido Guenther <agx@sigxcpu.org> wrote:

> On Sun, Apr 15, 2007 at 08:56:19PM +0200, Stefano Brivio wrote:
> > I'm using the at76c503a driver (0.14beta1, but it looks almost identical
> > to a76c503a git) on Linux 2.6.18.
> Are you sure you're running a version that has this fix from git:
> 4b50804c047272075f07edb5b62d857e3200d6a0

I missed it, it works now. Thanks Pavel and sorry for the noise. BTW,
stats are still bogus (link, signal, noise level == 0). But I don't think
it makes sense to debug this now, as you will probably have to deal with
mac80211 soon.

I had to make a little patch in order to build the driver on a kernel
version < 2.6.20. I don't think you want to merge this, as you are working
for inclusion into mainline, but in case, here it is:

Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
---
diff --git a/at76_usb.c b/at76_usb.c
index e39e31e..159901b 100644
--- a/at76_usb.c
+++ b/at76_usb.c
@@ -35,6 +35,7 @@
 #include <net/iw_handler.h>
 #include <linux/firmware.h>
 #include <linux/leds.h>
+#include <linux/version.h>
 
 #include "at76_usb.h"
 #include "at76_usb_ids.h"
@@ -5961,7 +5962,12 @@ static struct at76_priv *alloc_new_device(struct usb_device *udev,
 	dev->netdev = netdev;
 
 	init_MUTEX(&dev->sem);
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
+	INIT_WORK(&dev->devent_queue, at76_devent, (void *)&dev->devent_queue);
+#else
 	INIT_WORK(&dev->devent_queue, at76_devent);
+#endif
 
 	dev->open_count = 0;
 


--
Ciao
Stefano
