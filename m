Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:39147 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbYG0Mrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 08:47:40 -0400
Received: by ik-out-1112.google.com with SMTP id c28so3595934ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 05:47:39 -0700 (PDT)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/3] rt2x00: rt61pci needs another millisecond after firmware upload
Date: Sun, 27 Jul 2008 15:06:50 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200807271505.38116.IvDoorn@gmail.com> <200807271506.05316.IvDoorn@gmail.com> <200807271506.21999.IvDoorn@gmail.com>
In-Reply-To: <200807271506.21999.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807271506.50591.IvDoorn@gmail.com> (sfid-20080727_144748_420098_7AEAFDFB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After the hardware has indicated the firmware upload has completed
and the device is ready, we should wait another millisecond to
make sure the device is really ready to continue.

Without this timout, bringing the interface down and up again will
fail due to incorrect register initialization.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index ce772cc..4ee7bae 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1004,6 +1004,11 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 	}
 
 	/*
+	 * Hardware needs another millisecond before it is ready.
+	 */
+	msleep(1);
+
+	/*
 	 * Reset MAC and BBP registers.
 	 */
 	reg = 0;
-- 
1.5.6.1

