Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:43903 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757324AbZAWQEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 11:04:15 -0500
Received: by ey-out-2122.google.com with SMTP id 22so980281eye.37
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 08:04:14 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/3] rt2x00: Restrict firmware file lengths
Date: Fri, 23 Jan 2009 17:03:24 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200901231703.06609.IvDoorn@gmail.com>
In-Reply-To: <200901231703.06609.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901231703.24523.IvDoorn@gmail.com> (sfid-20090123_170420_150203_EC879207)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add extra security to the drivers for firmware loading,
check the firmware file length before uploading it to
the hardware. Incorrect lengths might indicate a firmware
upgrade (which is not yet supported by the driver) or
otherwise incorrect firmware.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    5 +++++
 drivers/net/wireless/rt2x00/rt73usb.c |    5 +++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 3a7ecca..d81a8de 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1199,6 +1199,11 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, const void *data,
 	int i;
 	u32 reg;
 
+	if (len != 8192) {
+		ERROR(rt2x00dev, "Invalid firmware file length (len=%zu)\n", len);
+		return -ENOENT;
+	}
+
 	/*
 	 * Wait for stable hardware.
 	 */
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 60c43c1..f854551 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1085,6 +1085,11 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, const void *data,
 	int status;
 	u32 reg;
 
+	if (len != 2048) {
+		ERROR(rt2x00dev, "Invalid firmware file length (len=%zu)\n", len);
+		return -ENOENT;
+	}
+
 	/*
 	 * Wait for stable hardware.
 	 */
-- 
1.5.6.1

