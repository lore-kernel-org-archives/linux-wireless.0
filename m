Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59452 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbZGaUiZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 16:38:25 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: Re: [PATCH] remove wrong probe_resp_plcp write
Date: Fri, 31 Jul 2009 22:38:14 +0200
Cc: gregor kowski <gregor.kowski@gmail.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <83a869cd0907311335h3065547aqc736573a663b6d42@mail.gmail.com>
In-Reply-To: <83a869cd0907311335h3065547aqc736573a663b6d42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907312238.15705.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 July 2009 22:35:49 gregor kowski wrote:
> The tkip hw support uncovered a bug in b43_write_probe_resp_template : it is
> writing at the wrong shm offset, it is in the B43_SHM_SH_TKIPTSCTTAK zone. This
> patch comments these writes.
> 
> Signed-off-by: Gregor Kowski <gregor.kowski@gmail.com>

Signed-off-by: Michael Buesch <mb@bu3sch.de>

> 
> Index: linux-2.6/drivers/net/wireless/b43/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/b43/main.c	2009-07-31
> 20:32:21.000000000 +0000
> +++ linux-2.6/drivers/net/wireless/b43/main.c	2009-07-31
> 20:32:28.000000000 +0000
> @@ -1505,10 +1505,13 @@
>  	/* Looks like PLCP headers plus packet timings are stored for
>  	 * all possible basic rates
>  	 */
> +	/* FIXME this is the wrong offset : it goes in tkip rx phase1 shm */
> +#if 0
>  	b43_write_probe_resp_plcp(dev, 0x31A, size, &b43_b_ratetable[0]);
>  	b43_write_probe_resp_plcp(dev, 0x32C, size, &b43_b_ratetable[1]);
>  	b43_write_probe_resp_plcp(dev, 0x33E, size, &b43_b_ratetable[2]);
>  	b43_write_probe_resp_plcp(dev, 0x350, size, &b43_b_ratetable[3]);
> +#endif
> 
>  	size = min((size_t) size, 0x200 - sizeof(struct b43_plcp_hdr6));
>  	b43_write_template_common(dev, probe_resp_data,
> 
> 



-- 
Greetings, Michael.
