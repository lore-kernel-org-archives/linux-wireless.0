Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50270 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab0DLH2P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 03:28:15 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 00:28:15 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19394.52061.869979.530453@gargle.gargle.HOWL>
Date: Mon, 12 Apr 2010 12:57:25 +0530
To: "tom.leiming@gmail.com" <tom.leiming@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH 3/3] ath9k-htc: pass cacheline aligned buffer to usb hcd in
 register out path
In-Reply-To: <1270911923-5783-1-git-send-email-tom.leiming@gmail.com>
References: <1270911923-5783-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tom.leiming@gmail.com wrote:
> This patch copies skb->data of register out command to kmalloced buffer,
> which is cacheline aligned(dma safe) and passed into usb hcd. Since the
> data in register out command is not very much, we can ignore the
> performance loss caused by the copy.

Actually, the current code is correct, though a bit sub-optimal.
The inital dev_alloc_skb() in ath9k_wmi_cmd() allocates a headroom
for WMI header + HTC header. The headers are then pushed as the packet
moves down through HTC. Finally, skb->data is passed to submit_urb().

To take care of cacheline alignment, you can just replace the dev_alloc_skb()
with alloc_skb(). A patch is welcome. :-)

Sujith
