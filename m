Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:47151 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbXCNPcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2007 11:32:17 -0400
Date: Wed, 14 Mar 2007 10:32:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linux-wireless@vger.kernel.org
Cc: Bcm43xx-dev@lists.berlios.de
Message-ID: <45f81577.+/XXKWDXwOzyP+DA%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During testing of bcm43xx interference mitigation, two problems were
discovered:

(1) When the MANUALWLAN mode was set, routines _stack_save and _stack_restore
    generated assertions that were traced to saving ILT registers with addresses
    > 0xFFF. This problem was fixed by adding one bit to the field used for
    the offset, and subtracting one bit from the space used for the id.
(2) In MANUALWLAN mode, the IRQ XMIT errors are generated. The cause of these
    errors has not yet been located. Any suggestions on debugging this problem
    would be greatly appreciated.

Larry


Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -882,10 +882,10 @@ static void _stack_save(u32 *_stackptr, 
 {
 	u32 *stackptr = &(_stackptr[*stackidx]);
 
-	assert((offset & 0xF000) == 0x0000);
-	assert((id & 0xF0) == 0x00);
+	assert((offset & 0xE000) == 0x0000);
+	assert((id & 0xF8) == 0x00);
 	*stackptr = offset;
-	*stackptr |= ((u32)id) << 12;
+	*stackptr |= ((u32)id) << 13;
 	*stackptr |= ((u32)value) << 16;
 	(*stackidx)++;
 	assert(*stackidx < BCM43xx_INTERFSTACK_SIZE);
@@ -896,12 +896,12 @@ static u16 _stack_restore(u32 *stackptr,
 {
 	size_t i;
 
-	assert((offset & 0xF000) == 0x0000);
-	assert((id & 0xF0) == 0x00);
+	assert((offset & 0xE000) == 0x0000);
+	assert((id & 0xF8) == 0x00);
 	for (i = 0; i < BCM43xx_INTERFSTACK_SIZE; i++, stackptr++) {
-		if ((*stackptr & 0x00000FFF) != offset)
+		if ((*stackptr & 0x00001FFF) != offset)
 			continue;
-		if (((*stackptr & 0x0000F000) >> 12) != id)
+		if (((*stackptr & 0x00007000) >> 13) != id)
 			continue;
 		return ((*stackptr & 0xFFFF0000) >> 16);
 	}
