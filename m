Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.infineon.com ([217.10.60.23]:48001 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYGHKyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 06:54:01 -0400
From: <Friedrich.Beckmann@infineon.com>
To: <linux-wireless@vger.kernel.org>
Date: Tue, 8 Jul 2008 12:44:08 +0200
Subject: RE: SDIO network card design - Packet Aggregation and Interrupt Load
Message-ID: <8469FC7DDCBE054D9653D8506E1FF0F001D43A8C70@mucse406.eu.infineon.com> (sfid-20080708_125407_136148_2B821EE8)
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

i have a question regarding the design of a network card
which is attached via SDIO. SDIO transfers are handled by
a SDIO host controller in the system which can do DMA from
the host memory to the device. The end of such a transfer
can be indicated via an interrupt. The transfer has to be
triggered by the cpu. So there is no DMA ring like in
standard ethernet cards.

The default way of operation would be to transfer each
packet with one DMA transfer. Such a transfer takes
between 10=B5s and 180=B5s depending on the packet length.
Each transfer requires cpu activity to be triggered.
My fear is that there is a high system load due to interrupts.

Question 1:
Do you have measurement data regarding the cost of
an interrupt? I did some google search and found different
numbers. On an ARM OMAP platform Francis David [1] claims
cost due to interrupt of ~200=B5s/interrupt.
Dan Tsafir [2] did measurements resulting in overheads
of 5-15=B5s/interrupt for different intel architectures.

Question 2:
Do you think it it would be worth to have a packet
aggregation mode, where a number of packets are transfered
in one DMA transfer? That would reduce the number of required cpu
interactions. As only SDIO SDMA transfers [3] are assumed,
it would however involve packet copying.

Question 3:
Regarding driver design, do you think that polling the
DMA host controller would be an efficient way? Polling done
in the NAPI poll routine, waiting for DMA transfers to finish?

Comments are welcome!

Regards

=46riedrich

References:
[1] http://choices.cs.uiuc.edu/contextswitching.pdf
[2] http://www.cs.huji.ac.il/~feit/exp/expcs07/papers/140.pdf
[3] http://www.sdcard.org/about/host_controller/simple_spec









--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
