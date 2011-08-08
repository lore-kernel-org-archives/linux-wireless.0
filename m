Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1790 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab1HHN7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:33 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 55/82] staging: brcm80211: fixed checkpatch warnings
 for brcmutil dir
Date: Mon, 8 Aug 2011 15:58:39 +0200
Message-ID: <1312811946-16713-56-git-send-email-arend@broadcom.com> (sfid-20110808_160059_430924_A607F038)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Most of them being 'line longer than 80 chars' type of warning.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmutil/utils.c |    9 ++++++---
 drivers/staging/brcm80211/brcmutil/wifi.c  |   23 +++++++++++++++--------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index 4b08157..7b4d658 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -489,8 +489,8 @@ static const u8 crc8_table[256] = {
 };
 
 u8 brcmu_crc8(u8 *pdata,	/* pointer to array of data to process */
-			 uint nbytes,	/* number of input data bytes to process */
-			 u8 crc	/* either CRC8_INIT_VALUE or previous return value */
+	      uint nbytes,	/* number of input data bytes to process */
+	      u8 crc	/* either CRC8_INIT_VALUE or previous return value */
 	) {
 	/* loop over the buffer data */
 	while (nbytes-- > 0)
@@ -586,7 +586,10 @@ brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags, char *buf,
 }
 EXPORT_SYMBOL(brcmu_format_flags);
 
-/* print bytes formatted as hex to a string. return the resulting string length */
+/*
+ * print bytes formatted as hex to a string. return the resulting
+ * string length
+ */
 int brcmu_format_hex(char *str, const void *bytes, int len)
 {
 	int i;
diff --git a/drivers/staging/brcm80211/brcmutil/wifi.c b/drivers/staging/brcm80211/brcmutil/wifi.c
index 1bce888..636515c 100644
--- a/drivers/staging/brcm80211/brcmutil/wifi.c
+++ b/drivers/staging/brcm80211/brcmutil/wifi.c
@@ -43,9 +43,9 @@ bool brcmu_chspec_malformed(u16 chanspec)
 EXPORT_SYMBOL(brcmu_chspec_malformed);
 
 /*
- * This function returns the channel number that control traffic is being sent on, for legacy
- * channels this is just the channel number, for 40MHZ channels it is the upper or lowre 20MHZ
- * sideband depending on the chanspec selected
+ * This function returns the channel number that control traffic is being sent
+ * on, for legacy channels this is just the channel number, for 40MHZ channels
+ * it is the upper or lower 20MHZ sideband depending on the chanspec selected.
  */
 u8 brcmu_chspec_ctlchan(u16 chspec)
 {
@@ -55,15 +55,22 @@ u8 brcmu_chspec_ctlchan(u16 chspec)
 	if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_NONE) {
 		return CHSPEC_CHANNEL(chspec);
 	} else {
-		/* we only support 40MHZ with sidebands */
-		/* chanspec channel holds the centre frequency, use that and the
-		 * side band information to reconstruct the control channel number
+		/*
+		 * we only support 40MHZ with sidebands. chanspec channel holds
+		 * the centre frequency, use that and the side band information
+		 * to reconstruct the control channel number
 		 */
 		if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_UPPER)
-			/* control chan is the upper 20 MHZ SB of the 40MHZ channel */
+			/*
+			 * control chan is the upper 20 MHZ SB of the
+			 * 40MHZ channel
+			 */
 			ctl_chan = UPPER_20_SB(CHSPEC_CHANNEL(chspec));
 		else
-			/* control chan is the lower 20 MHZ SB of the 40MHZ channel */
+			/*
+			 * control chan is the lower 20 MHZ SB of the
+			 * 40MHZ channel
+			 */
 			ctl_chan = LOWER_20_SB(CHSPEC_CHANNEL(chspec));
 	}
 
-- 
1.7.4.1


