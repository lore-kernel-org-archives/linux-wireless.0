Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53628 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab2JAHrL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 03:47:11 -0400
Received: by iagy32 with SMTP id y32so321049iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2012 00:47:11 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Oct 2012 09:47:11 +0200
Message-ID: <CAHc5FiVdRsAQoOQNUo2ErKP_rHbi8jwyno-A59huBf6okaa8KA@mail.gmail.com> (sfid-20121001_094715_681099_DFDC3A5F)
Subject: [PATCH] wireless-regdb: Update regulations for Ukraine
From: Mykyta Iziumtsev <mykyta.iziumtsev@gmail.com>
To: linville@tuxdriver.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	pchernyshev@gmail.com, andrew.bordunov@gmail.com
Content-Type: text/plain; charset=KOI8-U
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 5GHz band and mark 2.4GHz and 5GHz as NO-OUTDOOR according to
"Р╕шення про затвердження Перел╕ку рад╕оелектронних засоб╕в
та випром╕нювальних пристро╖в, для експлуатац╕╖ яких не потр╕бн╕
дозволи на експлуатац╕ю" from 27 May 2010.

Ref: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874

Update rules as follows as lowest common denominator:
        (2400 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
        (5150 - 5350 @ 40), (N/A, 20), NO-OUTDOOR

All WiFi equipment can be classified as either Client, Master,
or Access Terminal. Client maps to STA or P2P-Client,
Master -- to AP, IBSS/Mesh node or P2P-GO, and Access Terminal
can be either Client or Master, but there is additional requirement
that it should be deactivated on request from authorities.
But at the same time Access Terminal can be used outdoor.
For Master device there is requirement for indoor-only usage.
Further, WiFi equipment is divided by 802.11n capability criteria.

802.11bg/802.11a Client and Master
2400-2483,5 100 mW for DSSS/OFDM and 500 mW for FHSS
5150-5350 200 mW

802.11bg/80211a Access Terminal
2400-2483,5 100 mW
5150-5350 200 mW
5470-5670 1 W
5725-5850 2 W

802.11bgn/802.11an Client, Master or Access Terminal
2400-2483,5 100 mW
5150-5350 100 mW
5470-5670 100 mW
5725-5850 100 mW

Signed-off-by: Mykyta Iziumtsev <mykyta.iziumtsev@gmail.com>
Signed-off-by: Pavel Chernyshev <pchernyshev@gmail.com>
Signed-off-by: Andrew Bordunov <andrew.bordunov@gmail.com>
---
 db.txt |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 4c54543..08c6c89 100644
--- a/db.txt
+++ b/db.txt
@@ -653,7 +653,8 @@ country TR: DFS-ETSI
 	(5250 - 5330 @ 20), (N/A, 20), DFS

 country UA:
-	(2402 - 2482 @ 40), (N/A, 20)
+	(2400 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
+	(5150 - 5350 @ 40), (N/A, 20), NO-OUTDOOR

 country US: DFS-FCC
 	(2402 - 2472 @ 40), (3, 27)
-- 
1.7.10
