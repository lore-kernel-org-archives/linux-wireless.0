Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:45065 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2LDW7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 17:59:01 -0500
Received: by mail-ie0-f173.google.com with SMTP id e13so8676020iej.18
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2012 14:59:01 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 4 Dec 2012 23:27:55 +0100
Message-ID: <CAHc5FiWpUBUDh=8tDaaLRh9fHXT-k3EBj+KdoOGoR=BhYhzrVQ@mail.gmail.com> (sfid-20121204_235907_210565_7685AA22)
Subject: [PATCH v2] wireless-regdb: Update regulations for Ukraine
From: Mykyta Iziumtsev <mykyta.iziumtsev@gmail.com>
To: wireless-regdb@lists.infradead.org,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Pavel Chernyshev <pchernyshev@gmail.com>,
	Andrew Bordunov <andrew.bordunov@gmail.com>
Content-Type: text/plain; charset=KOI8-U
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add 5GHz band and mark 2.4GHz and 5GHz as NO-OUTDOOR according to
"Р╕шення про затвердження Перел╕ку рад╕оелектронних засоб╕в
та випром╕нювальних пристро╖в, для експлуатац╕╖ яких не потр╕бн╕
дозволи на експлуатац╕ю" from 27 May 2010.

Ref:
* #914 / 06 Sep 2007: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
* #1174 / 23 Oct 2008: http://www.nkrz.gov.ua/uk/activities/ruling/1225269361
(appendix 8)

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
 db.txt | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/db.txt b/db.txt
index 4c54543..30d0791 100644
--- a/db.txt
+++ b/db.txt
@@ -652,8 +652,16 @@ country TR: DFS-ETSI
 	(5170 - 5250 @ 20), (N/A, 20)
 	(5250 - 5330 @ 20), (N/A, 20), DFS

+# Source:
+# #914 / 06 Sep 2007: http://www.ucrf.gov.ua/uk/doc/nkrz/1196068874
+# #1174 / 23 Oct 2008: http://www.nkrz.gov.ua/uk/activities/ruling/1225269361
+# (appendix 8)
+# Listed 5GHz range is a lowest common denominator for all related
+# rules in the referenced laws. Such a range is used because of
+# disputable definitions there.
 country UA:
-	(2402 - 2482 @ 40), (N/A, 20)
+	(2400 - 2483.5 @ 40), (N/A, 20), NO-OUTDOOR
+	(5150 - 5350 @ 40), (N/A, 20), NO-OUTDOOR

 country US: DFS-FCC
 	(2402 - 2472 @ 40), (3, 27)
-- 
1.7.11.7
