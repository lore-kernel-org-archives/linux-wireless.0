Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4622 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/19] brcm80211: smac: fix endianess issue for OTP
 memory access
Date: Thu, 10 Nov 2011 20:30:16 +0100
Message-ID: <1320953434-16859-3-git-send-email-arend@broadcom.com> (sfid-20111110_203102_747210_B1789189)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes issue when using OTP memory. It was introduced by
following commit:

commit 028f78d43d80dcb8b1142ea38606067151dd3d51
Author: Arend van Spriel <arend@broadcom.com>
Date:   Fri Oct 21 16:16:35 2011 +0200

    brcm80211: smac: change buffer endianess convert function interface

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/srom.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index 0539a6a..3a9b81d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -835,6 +835,8 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint nwords)
 		 */
 		return -ENODATA;
 
+	/* fixup the endianness so crc8 will pass */
+	cpu_to_le16_buf(buf, sz);
 	if (crc8(brcms_srom_crc8_table, (u8 *) buf, sz * 2,
 		 CRC8_INIT_VALUE) != CRC8_GOOD_VALUE(brcms_srom_crc8_table))
 		err = -EIO;
-- 
1.7.5.4


