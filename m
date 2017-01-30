Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58403 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752756AbdA3MMV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jan 2017 07:12:21 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Seth Forshee <seth.forshee@canonical.com>
CC: <wireless-regdb@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: Remove DFS requirement for India (IN)
Date: Mon, 30 Jan 2017 14:08:32 +0200
Message-ID: <1485778112-11236-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20170130_131226_217671_B75829F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "Indoor Use of low power wireless equipment in the frequency band 5
GHz (Exemption from Licensing Requirement) Rules, 2005" notification by
Ministry of Communications and Information Technology (Wireless Planning
and Coordination Wing) (New Delhi, the 28th January 2005) does not
mandate use of DFS, so remove the DFS flag from the 5250-5330 MHz band
in India.

In addition, increase the TX power limit to 23 dBm to match the 200 mW
maximum mentioned in the same notification. Also use the exact ranges
from that notification and enable use of 160 MHz channels in the
5150-5350 MHz band.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 db.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/db.txt b/db.txt
index 7964cfb..05108e0 100644
--- a/db.txt
+++ b/db.txt
@@ -580,11 +580,10 @@ country IL: DFS-ETSI
 	(5150 - 5250 @ 80), (200 mW), NO-OUTDOOR, AUTO-BW
 	(5250 - 5350 @ 80), (200 mW), NO-OUTDOOR, DFS, AUTO-BW
 
-country IN: DFS-JP
+country IN:
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
-	(5735 - 5835 @ 80), (20)
+	(5150 - 5350 @ 160), (23)
+	(5725 - 5875 @ 80), (23)
 
 country IR: DFS-JP
 	(2402 - 2482 @ 40), (20)
-- 
2.7.4
