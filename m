Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab3JYKl1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Oct 2013 06:41:27 -0400
Date: Fri, 25 Oct 2013 12:37:54 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Dietmar Rudolph <dietmar@crlf.de>
Subject: [PATCH] iwl3945: do not print RFKILL message
Message-ID: <20131025103751.GB16384@redhat.com> (sfid-20131025_124130_652554_7E7D6F5E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can mess logs if user space try to open device again and again if
RFKILL switch is on. Do not print message and return ERFKILL error
instead to indicate where the problem is.

Note that iwl4965 handle this problem differently, it allows to open
device when radio is disabled.

Reported-by: Dietmar Rudolph <dietmar@crlf.de>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index dea3b50..f7c2145 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -2396,8 +2396,7 @@ __il3945_up(struct il_priv *il)
 		clear_bit(S_RFKILL, &il->status);
 	else {
 		set_bit(S_RFKILL, &il->status);
-		IL_WARN("Radio disabled by HW RF Kill switch\n");
-		return -ENODEV;
+		return -ERFKILL;
 	}
 
 	_il_wr(il, CSR_INT, 0xFFFFFFFF);
-- 
1.8.3.1

