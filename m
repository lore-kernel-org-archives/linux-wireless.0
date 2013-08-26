Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:38995 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751746Ab3HZTRM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 15:17:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Tobias Waldekranz <tobias@waldekranz.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 Aug 2013 12:16:00 -0700
Subject: RE: sd8787 (mwifiex) on big endian system
Message-ID: <477F20668A386D41ADCC57781B1F70430EAF1FEDA0@SC-VEXCH1.marvell.com> (sfid-20130826_211716_573955_471B160A)
References: <20130826102759.GA14350@gmail.com>
In-Reply-To: <20130826102759.GA14350@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tobias,

> As the subject suggests, I am trying to use the SD8787 on a PPC
> system. I have found a few endian related issues (submitted a few
> hours ago), but it is still not working.
> 
> So my first question, has anyone successfully used an mwifiex device
> on a big endian system?

AFAIK, you are probably the first one to try on a big endian system ;)

> 
> Also, I have found that the chip seems to signal interrupts before its
> internal registers are in a consistent state. Specifically, the
> sdio_ireg and wr_bitmask seems to be out of sync. Inserting a small
> delay in mwifiex_interrupt_status (sdio.c), currently 50 us solves the
> problem. Is there some bit that should be polled here to make sure that
> the registers are in a consistent state?

Can you enable dynamic debug and post the logs showing the register mismatch?

Thanks,
Bing
