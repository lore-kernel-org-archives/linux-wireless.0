Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45255 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753139AbdJSVii (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2017 17:38:38 -0400
Received: from mail-it0-f72.google.com ([209.85.214.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1e5IWT-0007XO-Gk
        for linux-wireless@vger.kernel.org; Thu, 19 Oct 2017 21:38:37 +0000
Received: by mail-it0-f72.google.com with SMTP id p138so8628908itp.12
        for <linux-wireless@vger.kernel.org>; Thu, 19 Oct 2017 14:38:37 -0700 (PDT)
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?=D0=90=D0=BD=D0=B4=D1=80=D0=B5=D0=B9=20=D0=98=D0=B2=D0=B0=D0=BD=D0=BE=D0=B2?=
        <wowz89@mail.ru>
Subject: [PATCH] wireless-regdb: Add 5 Ghz rules for Kazakhstan (KZ)
Date: Thu, 19 Oct 2017 16:38:34 -0500
Message-Id: <20171019213834.23127-1-seth.forshee@canonical.com> (sfid-20171019_233841_226525_31783EB1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add rules for 5150-5250 MHz, 5250-5350 MHz, and 5470-5725 Mhz
based on the documents at [1] and [2].

[1] http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
[2] http://adilet.zan.kz/rus/docs/P000001379_

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 db.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/db.txt b/db.txt
index e48f9a619651..96d8fda44284 100644
--- a/db.txt
+++ b/db.txt
@@ -689,8 +689,14 @@ country KY: DFS-FCC
 	(5490 - 5730 @ 160), (24), DFS
 	(5735 - 5835 @ 80), (30)
 
+# Source:
+# http://mic.gov.kz/sites/default/files/pages/pravila_prisvoeniya_polos_chastot_no34.pdf
+# http://adilet.zan.kz/rus/docs/P000001379_
 country KZ:
 	(2402 - 2482 @ 40), (20)
+	(5150 - 5250 @ 80), (20), NO-OUTDOOR, AUTO-BW
+	(5250 - 5350 @ 80), (20), NO-OUTDOOR, DFS, AUTO-BW
+	(5470 - 5725 @ 80), (20), NO-OUTDOOR, DFS
 
 country LB: DFS-FCC
 	(2402 - 2482 @ 40), (20)
-- 
2.14.1
