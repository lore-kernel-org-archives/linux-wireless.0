Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:36939 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbZD3H6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 03:58:54 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi: remove EXPORT_SYMBOL for static symbol
CC: linux-kernel@vger.kernel.org, netdev@vget.kernel.org
Date: Thu, 30 Apr 2009 09:58:50 +0200
Message-ID: <m24ow6vah1.fsf@igel.home> (sfid-20090430_095859_848503_CEFFB30C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It does not make sense to apply EXPORT_SYMBOL to a static symbol.  Fixes
this build error:

drivers/net/wireless/iwlwifi/iwl3945-base.c:1697: error: __ksymtab_iwl3945_rx_queue_reset causes a section type conflict

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
This obsoletes 6269b731560d69c5eaa929909891edec39496d71, which was
misattributed as a compiler bug.
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 -
 1 file changed, 1 deletion(-)

--- linux-2.6.30-rc4.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-30 08:59:41.000000000 +0200
+++ linux-2.6.30-rc4/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-04-30 09:34:14.000000000 +0200
@@ -1745,7 +1745,6 @@ static void iwl3945_rx_queue_free(struct
 	rxq->bd = NULL;
 	rxq->rb_stts  = NULL;
 }
-EXPORT_SYMBOL(iwl3945_rx_queue_free);
 
 
 /* Convert linear signal-to-noise ratio into dB */

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
