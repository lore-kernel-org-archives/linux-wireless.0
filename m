Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:55569 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757959Ab0KROD6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 09:03:58 -0500
Date: Thu, 18 Nov 2010 15:03:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-wireless@vger.kernel.org
cc: Stefano Brivio <stefano.brivio@polimi.it>
Subject: b43 SDIO on an embedded system in PIO and DMA modes
Message-ID: <Pine.LNX.4.64.1011181402350.2381@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stefano, all

I am using an b43-compatible SDIO card in an embedded system. It works, 
when the SD host controller is used in PIO mode, but fails, if it is used 
in DMA mode, whereas I can use normal SD cards in both modes. Now details:

The card is an "SD-Link11g" from "C-guys, Inc.", Taiwan. Chip ID 
14e4:4318.

The system is an SuperH sh7724 based "ecovec" board with an SDHI 
controller, using the tmio_mmc SD host driver in 
drivers/mmc/host/tmio_mmc.c with the drivers/mfd/sh_mobile_sdhi.c MFD 
glue. Recently I have extended the tmio driver to also work in DMA mode, 
using the SH dmaengine driver drivers/dma/shdma.c. This works with normal 
SD cards. SDIO is used so far with polled interrupts.

The problem: in DMA mode the initialisation is performed without any 
visible problems. The card is recognised, the frmware is loaded. When the 
wpa-supplicant is started, authentication seems to perform correctly too, 
but association fails. On the low mmc level I see a number of packets 
being exchanged, the last successful packet is reading of 4 bytes from 
address 0, using command 53, which returns the same 4 bytes as always - 
all seems good so far. After it a write is attempted of 72 bytes, which 
are split into two packets of 64 and 8 bytes respectively. As the first 
packet is scheduled, DMA transfers it into the SDHI FIFO and calls the 
completion method, but already in that completion method I see status bit 
"busy" set in SDHI. Normally after such a bit is set, the currently 
running execution completes and a completion interrupt is generated. 
However, in this case no interrupt is coming, the busy bit remains set and 
no further operation is possible.

It is always exactly the same packet shortly after the beginning of the 
association process.

I so far have exhausted my creativity, debugging the SDHI controller. In 
principle I can see two possible reasons for this problem: either the SDHI 
controller hangs, or the card. Since the controller doesn't care what data 
and to what addresses is transferred, and it has successfully transferred 
a fair amount of data before this point, I think, it is likely, that it is 
the card, that is hanging. Therefore my question: how can I debug this 
problem at the card level?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
