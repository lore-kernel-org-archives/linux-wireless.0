Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35919 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727547AbeIQNI6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 09:08:58 -0400
Received: by mail-qk1-f194.google.com with SMTP id 93-v6so8522591qks.3
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 00:42:47 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: seth.forshee@canonical.com
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
        Simon Wunderlich <simon.wunderlich@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 1/2] wireless-regdb: Sync FR with ETSI EN 301 893 V2.1.1 (2017-05)
Date: Mon, 17 Sep 2018 09:42:11 +0200
Message-Id: <20180917074212.6739-1-sven.eckelmann@openmesh.com> (sfid-20180917_094254_872675_E52950B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The documents
https://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.01.01_60/en_301893v020101p.pdf
and
https://www.anfr.fr/fileadmin/mediatheque/documents/controle/20171127ANFR_-_ficheRLAN_5GHz.pdf
show that the limits for the 5GHz bands are out of date:

* frequencies don't match the official limits
* 5150 - 5350 MHz is not for outdoor usage
* 5150 - 5250 MHz only usage is allowed to use up to 23 dBm (200 mW) even
  without TPC

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
---
 db.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/db.txt b/db.txt
index bc64628..7f978e1 100644
--- a/db.txt
+++ b/db.txt
@@ -475,9 +475,9 @@ country FM: DFS-FCC
 
 country FR: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
-	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
-	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
-	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
+	(5150 - 5250 @ 80), (23), NO-OUTDOOR, AUTO-BW, wmmrule=ETSI
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW, wmmrule=ETSI
+	(5470 - 5725 @ 160), (27), DFS, wmmrule=ETSI
         # short range devices (ETSI EN 300 440)
 	(5725 - 5875 @ 80), (25 mW)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
-- 
2.11.0
