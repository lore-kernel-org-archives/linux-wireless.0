Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hiems2.ing.unibs.it ([192.167.23.204]:59830 "EHLO
	hiems2.ing.unibs.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0JHQbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 12:31:46 -0400
From: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Content-Type: text/plain; charset=us-ascii
Date: Fri, 8 Oct 2010 18:31:42 +0200
Subject: Questions on carl9170 architecture
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>
Message-Id: <3E9EF80F-15AF-4B40-AA26-C97A1E01D897@ing.unibs.it>
Mime-Version: 1.0 (Apple Message framework v1081)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christian,

I have tried carl9170 for a while, everything is ok: what a great work! I have not noticed any problem so far, it seems almost stable.

I'm digging into carl9170 source code to understand how it works and what one can build starting from it. There are however a few points that I didn't understand, would you mind helping me?

- how are handled acknowledgments? I don't see anything that schedules ack transmission when a packet that need ack is received. Is that accomplished internally by the hw? If yes, do you know if it can be disabled and replaced with new code so that it is the firmware to control ack transmission? For instance, a number of techniques have been recently proposed to estimate the channel condition when receiving corrupted frames: it could be interesting to send back a "special-ack" when a packet is received corrupted to help the transmitter understanding how to best retransmit the packet. Obviously this should be done within a SIFS from the reception of the packet;

- to which precision is it possible to drive packet transmission? e.g., is it possible to start sending a packet a chosen interval after the previous?

- is it possible to send packet independently of CCA, e.g., starting sending a packet even if the channel is busy?

- is it possible to build a packet internally and decide to send it independently of the host?

- is it possible to modify packets sent by the host before they leave the adapter?

Sorry to bother you with so many questions.

Kind regards,
-Francesco Gringoli


Informativa sulla privacy: http://help.ing.unibs.it/privacy.php


