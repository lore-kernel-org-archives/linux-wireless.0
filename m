Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40525 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376Ab0J1Ot2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 10:49:28 -0400
Message-ID: <4CC98D85.20703@lwfinger.net>
Date: Thu, 28 Oct 2010 09:49:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arnd Hannemann <arnd@arndnet.de>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: b43 sdio: WARNING: at drivers/mmc/core/core.c:237 mmc_wait_for_cmd
References: <4CC874F4.5050908@arndnet.de> <4CC8CAAE.3040100@lwfinger.net> <4CC98892.7080000@arndnet.de>
In-Reply-To: <4CC98892.7080000@arndnet.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/28/2010 09:28 AM, Arnd Hannemann wrote:
> Hi,
\> [ 1364.620044] b43-phy1 debug: Removing Interface type 2
> [ 1364.621812] b43-phy1 debug: Wireless interface stopped
> [ 1372.440297] b43-sdio: before ssb_bus_unregister, claimed is 0
> [ 1372.440345] b43-sdio: before sdio_disable_func, claimed is 0
> [ 1372.440351] ------------[ cut here ]------------
> [ 1372.440367] WARNING: at drivers/mmc/core/core.c:237 mmc_wait_for_cmd+0x88/0x90()

Please try the patch below. It claims the device before the sdio_disable_func(()
call and releases it afterwords.

Larry


Index: wireless-testing/drivers/net/wireless/b43/sdio.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/sdio.c
+++ wireless-testing/drivers/net/wireless/b43/sdio.c
@@ -175,7 +175,9 @@ static void b43_sdio_remove(struct sdio_
 	struct b43_sdio *sdio = sdio_get_drvdata(func);

 	ssb_bus_unregister(&sdio->ssb);
+	sdio_claim_host(func);
 	sdio_disable_func(func);
+	sdio_release_host(func);
 	kfree(sdio);
 	sdio_set_drvdata(func, NULL);
 }
