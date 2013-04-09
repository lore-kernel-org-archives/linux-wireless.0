Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:44814 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933489Ab3DIFxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 01:53:14 -0400
Received: by mail-da0-f53.google.com with SMTP id n34so2914630dal.26
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 22:53:14 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com
Cc: qca_vkondrat@qca.qualcomm.com, yunsenw@qca.qualcomm.com,
	kandala@qca.qualcomm.com, wireless-regdb@lists.infradead.org,
	green@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/3] wireless-regdb: enable VHT80 when world roaming
Date: Mon,  8 Apr 2013 22:52:57 -0700
Message-Id: <1365486778-2336-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20130409_075317_848942_E9B19BCC)
In-Reply-To: <1365486778-2336-1-git-send-email-mcgrof@do-not-panic.com>
References: <1365486778-2336-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>

For VHT, the wider bandwidths (up to 160 MHz) need
to be allowed. Since world roaming only covers the
case of connecting to an AP, it can be opened up
there, we will rely on the AP to know the local
regulations.

Based on a patch by Johannes Berg for upstream Linux.

Cc: Yunsen Wang <yunsenw@qca.qualcomm.com>
Cc: Michael Green <green@qca.qualcomm.com>
Cc: wireless-regdb@lists.infradead.org
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 db.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/db.txt b/db.txt
index 2d09a3c..ae0f83d 100644
--- a/db.txt
+++ b/db.txt
@@ -6,10 +6,10 @@ country 00:
 	# Channel 14. Only JP enables this and for 802.11b only
 	(2474 - 2494 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS, NO-OFDM
 	# Channel 36 - 48
-	(5170 - 5250 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+	(5170 - 5250 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
 	# NB: 5260 MHz - 5700 MHz requies DFS
 	# Channel 149 - 165
-	(5735 - 5835 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS
+	(5735 - 5835 @ 80), (3, 20), PASSIVE-SCAN, NO-IBSS
 
 
 country AD:
-- 
1.7.10.4

