Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46928 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbZAZXSO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 18:18:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 15:18:14 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless-regdb: correct allowed width for JP
Date: Mon, 26 Jan 2009 15:17:34 -0800
Message-ID: <1233011854-31346-1-git-send-email-lrodriguez@atheros.com> (sfid-20090127_001818_215249_C578EDAC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is bogus to have

end_freq - start_freq < max_width

I have tested this.

Reported-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 db.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 91df808..89a9d52 100644
--- a/db.txt
+++ b/db.txt
@@ -295,8 +295,8 @@ country JM:
 
 country JP:
 	(2402 - 2472 @ 40), (N/A, 20)
-	(2457 - 2482 @ 40), (N/A, 20)
-	(2474 - 2494 @ 40), (N/A, 20), NO-OFDM
+	(2457 - 2482 @ 20), (N/A, 20)
+	(2474 - 2494 @ 20), (N/A, 20), NO-OFDM
 	(4910 - 4930 @ 10), (N/A, 23)
 	(4910 - 4990 @ 40), (N/A, 23)
 	(4930 - 4950 @ 10), (N/A, 23)
-- 
1.6.1.rc3.51.g5832d

