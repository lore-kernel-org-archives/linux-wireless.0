Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:59681 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaBPX0L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 18:26:11 -0500
Date: Mon, 17 Feb 2014 10:25:53 +1100
From: James Cameron <quozl@laptop.org>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, T Gillett <tgillett@gmail.com>
Subject: [PATCH] libertas: fix scan result loss if SSID IE len 0
Message-ID: <20140216232553.GA2991@us.netrek.org> (sfid-20140217_002620_150866_B9213E85)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Scan results from Marvell 8388 and 8686 have probe responses from
hidden APs and OLPC XO-1 mesh with a zero length SSID IE.

Bug in lbs_ret_scan discarded any remaining BSS in scan response,
leading to user not seeing APs in dense environments.

With LBS_DEB_SCAN, dmesg shows

libertas scan: scan response: 5 BSSs (419 bytes); resp size 474 bytes
libertas scan: scan: 00:1a:2b:84:de:e8, capa 0401, chan  1, qz, -51 dBm
libertas scan: scan: 5c:63:bf:d8:eb:0c, capa 0411, chan  1, qw129, -23 dBm
libertas scan: scan response: invalid IE fmt

With LBS_DEB_HEX, dmesg shows valid BSS in scan response were not
processed.

Change is to ignore zero length IE and continue processing.

Fixes OLPC 12757, http://dev.laptop.org/ticket/12757

Signed-off-by: James Cameron <quozl@laptop.org>
Reported-by: T Gillett <tgillett@gmail.com>
Tested-by: T Gillett <tgillett@gmail.com>
CC: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 32f7500..cb6d189 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -621,7 +621,7 @@ static int lbs_ret_scan(struct lbs_private *priv, unsigned long dummy,
 			id = *pos++;
 			elen = *pos++;
 			left -= 2;
-			if (elen > left || elen == 0) {
+			if (elen > left) {
 				lbs_deb_scan("scan response: invalid IE fmt\n");
 				goto done;
 			}
-- 
1.8.1.2


-- 
James Cameron
http://quozl.linux.org.au/
