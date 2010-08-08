Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from defg500.nifty.com ([202.248.238.127]:19710 "EHLO
	defg500.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626Ab0HHNVK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Aug 2010 09:21:10 -0400
Message-ID: <103911.103501281272851252.komurojun-mbn@nifty.com>
Date: Sun, 8 Aug 2010 22:07:31 +0900 (JST)
From: Komuro <komurojun-mbn@nifty.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: [PATCH 11/18] pcmcia: do not use io_req_t when calling pcmcia_request_io()
Cc: linux-pcmcia@lists.infradead.org, alsa-devel@alsa-project.org,
	Michael Buesch <mb@bu3sch.de>, netdev@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	laforge@gnumonks.org, linux-ide@vger.kernel.org,
	linux-mtd@lists.infradead.org,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	linux-serial@vger.kernel.org
In-Reply-To: <1281046014-7585-11-git-send-email-linux@dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
References: <1281046014-7585-11-git-send-email-linux@dominikbrodowski.net>
 <20100805220511.GA7040@comet.dominikbrodowski.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> 
>-    link->io.IOAddrLines =10;
>-    link->io.Attributes1 = IO_DATA_PATH_WIDTH_16;
>+    link->resource[0]->flags |= IO_DATA_PATH_WIDTH_16;

link->io_lines should be set here?



>@@ -840,14 +839,15 @@ xirc2ps_config(struct pcmcia_device * link)
> 	}
> 	printk(KNOT_XIRC "no ports available\n");
>     } else {
>-	link->io.NumPorts1 = 16;
>+	link->io_lines = 10;
>+	link->resource[0]->end = 16;

Best Regards
Komuro

