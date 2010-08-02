Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep16.mx.upcmail.net ([62.179.121.36]:64121 "EHLO
	fep16.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0HBGkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 02:40:36 -0400
Date: Mon, 2 Aug 2010 08:40:55 +0200
From: Andreas Feuersinger <andreas.feuersinger@spintower.eu>
To: "Gabay, Benzy" <benzyg@ti.com>
Cc: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: MX27 libertas_sdio SDIO Interrupts vs available bitrate
Message-ID: <20100802084055.096a0059@speedy>
In-Reply-To: <676FD6AA0F002F49B89E70F0C5EFD22C1311499C43@dlee04.ent.ti.com>
References: <20100729124604.79f88553@speedy>
	<676FD6AA0F002F49B89E70F0C5EFD22C1311499C43@dlee04.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Benzy Gabay,

On Fri, 30 Jul 2010 15:08:06 -0500
"Gabay, Benzy" <benzyg@ti.com> wrote:
> > I figured, it does not make any difference wheter I use DMA for data
> > transfer or not (odd?)
> If interrupts are not handled in MMC level and you are disabling DMA
> operation how then will the transfer completion is handled in that
> case?
> 

PIO transfer is used in function mxcmci_cmd_done. A while loop cycles
and calls readl until the buffer is read.
Afterwards CRC checks and stuff is done.

Enabling DMA exits prior that code section calling mxc_dma_enable.
