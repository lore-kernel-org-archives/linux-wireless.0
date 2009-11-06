Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39512 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758465AbZKFP4E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 10:56:04 -0500
Received: by ewy3 with SMTP id 3so1164637ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 07:56:08 -0800 (PST)
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [PATCH] SSB: fix 32 bit PCMCIA access.
To: linux-wireless@vger.kernel.org
Date: Fri, 06 Nov 2009 16:56:05 +0100
Message-ID: <20091106155605.20585.15955.stgit@srv002.fuzzey.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scan function was using 32 bit access which does not
work on 16bit CF cards.

This patch corrects this by doing two 16 bit reads like
ssb_pcmcia_read32 already does (unfortunately we don't
have a struct ssb_device to use that directly).

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/ssb/scan.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/ssb/scan.c b/drivers/ssb/scan.c
index b74212d..6721fa8 100644
--- a/drivers/ssb/scan.c
+++ b/drivers/ssb/scan.c
@@ -162,6 +162,9 @@ static u8 chipid_to_nrcores(u16 chipid)
 static u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx,
 		       u16 offset)
 {
+	unsigned long flags;
+	u32 lo, hi;
+
 	switch (bus->bustype) {
 	case SSB_BUSTYPE_SSB:
 		offset += current_coreidx * SSB_CORE_SIZE;
@@ -174,7 +177,11 @@ static u32 scan_read32(struct ssb_bus *bus, u8 current_coreidx,
 			offset -= 0x800;
 		} else
 			ssb_pcmcia_switch_segment(bus, 0);
-		break;
+		spin_lock_irqsave(&bus->bar_lock, flags);
+		lo = readw(bus->mmio + offset);
+		hi = readw(bus->mmio + offset + 2);
+		spin_unlock_irqrestore(&bus->bar_lock, flags);
+		return lo | (hi << 16);
 	case SSB_BUSTYPE_SDIO:
 		offset += current_coreidx * SSB_CORE_SIZE;
 		return ssb_sdio_scan_read32(bus, offset);

