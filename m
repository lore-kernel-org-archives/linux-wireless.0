Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50660 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYKUBPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 20:15:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 17:15:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<linux-kernel@vger.kernel.org>, <alistair@devzero.co.uk>,
	<zenczykowski@gmail.com>, <Bennyam.Malavazi@atheros.com>,
	<Vinod.Nagarajan@Atheros.com>, <kevin@atheros.com>
Subject: [PATCH 2/2] ath9k: correct expected max RX buffer size
Date: Thu, 20 Nov 2008 17:15:11 -0800
Message-ID: <1227230113-6068-1-git-send-email-lrodriguez@atheros.com> (sfid-20081121_021521_607111_414E5A1E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series corrects our inconsist use of DMA. I'm pretty
certain about these patches now, I've tested them myself and got
one lock up but it was only after doing some really crazy things
to my machine I rather not share in public (and unable to get a
trace). The beacon patches should be correct as previous to this
we were pci_map_single()'ing more data than we told hardware it
can get from us on TX. Regular TX is fine as we always tell it to
use the skb->len and also account for the 4 byte padding it always
adds.

Additionally we now have one user which reports it fixed the issue
for him, but this time on a MacBook pro v2 (what is it with those
things?!).

Unfortunately I cannot find a solution to having the kernel give us
8KB instead of 4KB which is all we need for our buffers. The reason
for askign at least for ~3849 bytes (before the encryption overhead)
is we _can_ expect a max AMSDU of size 3849. If someone finds a clever
solution to this please let me know.

Many thanks to Benny and Maciej for helping to review this issue.

  Luis
