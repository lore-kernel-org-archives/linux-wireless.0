Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60320 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdJTPG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Oct 2017 11:06:57 -0400
Received: from mail-io0-f199.google.com ([209.85.223.199])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1e5Ysx-0003u3-Rl
        for linux-wireless@vger.kernel.org; Fri, 20 Oct 2017 15:06:55 +0000
Received: by mail-io0-f199.google.com with SMTP id n79so10980869ion.17
        for <linux-wireless@vger.kernel.org>; Fri, 20 Oct 2017 08:06:55 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?=D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9=20=D0=98=D0=B2=D0=B0=D0=BD=D0=BE=D0=B2?=
        <wowz89@mail.ru>
Subject: [PATCH v2] wireless-regdb: Add 5 Ghz rules for Kazakhstan (KZ)
Date: Fri, 20 Oct 2017 10:06:51 -0500
Message-Id: <20171020150651.32424-1-seth.forshee@canonical.com> (sfid-20171020_170702_322683_862C1659)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add rules for 5150-5250 MHz, 5250-5350 MHz, and 5470-5725 Mhz
based on the documents at [1] and [2].

v2: Also add DFS region

[1] http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
[2] http://adilet.zan.kz/rus/docs/P000001379_

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 db.txt | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 9d129f2e542b..10c84ee1ca5d 100644
--- a/db.txt
+++ b/db.txt
@@ -691,8 +691,14 @@ country KY: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
-country KZ:
+# Source:
+# http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
+# http://adilet.zan.kz/rus/docs/P000001379_
+country KZ: DFS-ETSI
 	(2402 - 2482 @ 40), (20)
+	(5150 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
+	(5470 - 5725 @ 80), (20), NO-OUTDOOR, DFS
 
 country LB: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
2.14.1
