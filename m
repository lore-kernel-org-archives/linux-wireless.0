Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3108 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab1JUNzd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 09:55:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/17] brcm80211: smac: rename buffer endianess
 conversion functions
Date: Fri, 21 Oct 2011 15:55:14 +0200
Message-ID: <1319205319-16891-13-git-send-email-arend@broadcom.com> (sfid-20111021_155539_732616_55494E90)
In-Reply-To: <1319205319-16891-1-git-send-email-arend@broadcom.com>
References: <1319205319-16891-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions ltoh16_buf() and htol16_buf() have been renamed
to le16_to_cpu_buf() and cpu_to_le16_buf() for more clarity
what it does.

Reported-by: Joe Perches <joe@perches.com>
Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/srom.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index 66aa0e7..8f1cf2f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -617,14 +617,14 @@ static uint mask_width(u16 mask)
 	return 0;
 }
 
-static inline void ltoh16_buf(u16 *buf, unsigned int size)
+static inline void le16_to_cpu_buf(u16 *buf, unsigned int size)
 {
 	size /= 2;
 	while (size--)
 		*(buf + size) = le16_to_cpu(*(__le16 *)(buf + size));
 }
 
-static inline void htol16_buf(u16 *buf, unsigned int size)
+static inline void cpu_to_le16_buf(u16 *buf, unsigned int size)
 {
 	size /= 2;
 	while (size--)
@@ -807,7 +807,7 @@ sprom_read_pci(struct si_pub *sih, u8 __iomem *sprom, uint wordoff,
 		err = -EIO;
 	else
 		/* now correct the endianness of the byte array */
-		ltoh16_buf(buf, nbytes);
+		le16_to_cpu_buf(buf, nbytes);
 
 	return err;
 }
@@ -837,13 +837,13 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 		return -ENODATA;
 
 	/* fixup the endianness so crc8 will pass */
-	htol16_buf(buf, bufsz);
+	cpu_to_le16_buf(buf, bufsz);
 	if (crc8(brcms_srom_crc8_table, (u8 *) buf, SROM4_WORDS * 2,
 		 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(brcms_srom_crc8_table))
 		err = -EIO;
 
 	/* now correct the endianness of the byte array */
-	ltoh16_buf(buf, bufsz);
+	le16_to_cpu_buf(buf, bufsz);
 
 	return err;
 }
-- 
1.7.4.1


