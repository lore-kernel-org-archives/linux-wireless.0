Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33538 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbbK0Vjk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 16:39:40 -0500
Received: by igcmv3 with SMTP id mv3so37940949igc.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 13:39:39 -0800 (PST)
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
	Andi Kleen <andi@firstfloor.org>,
	Peter Hurley <peter@hurleysoftware.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 04/19] NFC: nci: Remove dead code
Date: Fri, 27 Nov 2015 16:39:01 -0500
Message-Id: <1448660356-6328-5-git-send-email-peter@hurleysoftware.com> (sfid-20151127_224238_151862_7019587C)
In-Reply-To: <1448660356-6328-1-git-send-email-peter@hurleysoftware.com>
References: <1448660356-6328-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The N_NCI ldisc does not define a flush_buffer() ldisc method, so
the check when opening the ldisc is always false.

Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <linux-wireless@vger.kernel.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 net/nfc/nci/uart.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index 21d8875..c468eab 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -171,14 +171,7 @@ static int nci_uart_tty_open(struct tty_struct *tty)
 	tty->disc_data = NULL;
 	tty->receive_room = 65536;
 
-	/* Flush any pending characters in the driver and line discipline. */
-
-	/* FIXME: why is this needed. Note don't use ldisc_ref here as the
-	 * open path is before the ldisc is referencable.
-	 */
-
-	if (tty->ldisc->ops->flush_buffer)
-		tty->ldisc->ops->flush_buffer(tty);
+	/* Flush any pending characters in the driver */
 	tty_driver_flush_buffer(tty);
 
 	return 0;
-- 
2.6.3

