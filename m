Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58510 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751219AbeEOTLa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 15:11:30 -0400
Received: from mail-it0-f71.google.com ([209.85.214.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fIfM9-0002IC-Ns
        for linux-wireless@vger.kernel.org; Tue, 15 May 2018 19:11:29 +0000
Received: by mail-it0-f71.google.com with SMTP id o8-v6so3643159itf.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 12:11:29 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Mathieu=20Peyr=C3=A9ga?= <mathieu.peyrega@gmail.com>
Subject: [PATCH] wireless-regdb: Add 5725-5875 MHz rule for France (FR)
Date: Tue, 15 May 2018 14:11:26 -0500
Message-Id: <20180515191126.19189-1-seth.forshee@canonical.com> (sfid-20180515_211135_594923_DA400637)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on [1] and [2], use of short range devices in this range
is now permitted in France. Add a rule for this range, using the
power limit of 25 dBm as specified in these documents and in
ETSI EN 300 440.

[1] https://www.arcep.fr/uploads/tx_gsavis/14-1263.pdf
[2] https://www.arcep.fr/uploads/tx_gsavis/14-1263.pdf

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 db.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db.txt b/db.txt
index fd73049596f2..eeff196e4aac 100644
--- a/db.txt
+++ b/db.txt
@@ -475,6 +475,8 @@ country FR: DFS-ETSI
 	(5170 - 5250 @ 80), (20), AUTO-BW, wmmrule=ETSI
 	(5250 - 5330 @ 80), (20), DFS, AUTO-BW, wmmrule=ETSI
 	(5490 - 5710 @ 160), (27), DFS, wmmrule=ETSI
+        # short range devices (ETSI EN 300 440)
+	(5725 - 5875 @ 80), (25)
 	# 60 GHz band channels 1-4, ref: Etsi En 302 567
 	(57000 - 66000 @ 2160), (40)
 
-- 
2.17.0
