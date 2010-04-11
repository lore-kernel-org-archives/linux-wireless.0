Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36790 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab0DKFq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 01:46:58 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 10 Apr 2010 22:46:58 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19393.25118.429074.497553@gargle.gargle.HOWL>
Date: Sun, 11 Apr 2010 11:16:06 +0530
To: "tom.leiming@gmail.com" <tom.leiming@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH 3/3] ath9k-htc: pass cacheline aligned buffer to usb hcd in register out path
In-Reply-To: <1270911923-5783-1-git-send-email-tom.leiming@gmail.com>
References: <1270911923-5783-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tom.leiming@gmail.com wrote:
> This patch copies skb->data of register out command to kmalloced buffer,
> which is cacheline aligned(dma safe) and passed into usb hcd. Since the
> data in register out command is not very much, we can ignore the
> performance loss caused by the copy.

The skb for every frame sent out through the REG_OUT pipe is allocated
using dev_alloc_skb(). So again, am not sure about your cacheline argument.

And the extra memcpy would certainly cause a performance loss, since we
already do a memcpy once to copy the data in ath9k_wmi_cmd().

Are you having DMA issues with the driver ?
If so, on which architecture ?

Sujith
