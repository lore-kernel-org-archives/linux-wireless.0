Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1778 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757560Ab0KUCxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 21:53:20 -0500
Received: from [192.168.1.156] (unknown [192.168.1.156])
	by mail.perches.com (Postfix) with ESMTP id 3B3C424368
	for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 18:53:13 -0800 (PST)
Subject: Stefano Brivio's email address bounces for weeks now.
From: Joe Perches <joe@perches.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-X4cV+9UiDG16/8CZtPhl"
Date: Sat, 20 Nov 2010 18:53:19 -0800
Message-ID: <1290307999.23282.1.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X4cV+9UiDG16/8CZtPhl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Is it just my email server or are you still reachable?

   ----- The following addresses had permanent fatal errors -----
mail@stefanobrivio.net
    (reason: 554 5.7.1 <mail@stefanobrivio.net>: Relay access denied)
    (expanded from: <stefano.brivio@polimi.it>)

   ----- Transcript of session follows -----
... while talking to st3.endoftheinternet.org.:
<<< 421 [XMail 1.26 ESMTP Server] - Server too busy, retry later
... while talking to smtp-avas.seeweb.it.:
>>> DATA
<<< 554 5.7.1 <mail@stefanobrivio.net>: Relay access denied
554 5.0.0 Service unavailable
<<< 554 5.5.1 Error: no valid recipients
email message attachment
-------- Forwarded Message --------
From: Joe Perches <joe@perches.com>
To: Stefano Brivio <stefano.brivio@polimi.it>

--------------------------------------------------------------------

--=-X4cV+9UiDG16/8CZtPhl
Content-Type: message/delivery-status
Content-Transfer-Encoding: 7bit

Reporting-MTA: dns; polimi.it
Received-From-MTA: DNS; mail.perches.com
Arrival-Date: Sun, 21 Nov 2010 03:48:48 +0100

Original-Recipient: rfc822;stefano.brivio@polimi.it
Final-Recipient: RFC822; stefano.brivio@polimi.it
X-Actual-Recipient: RFC822; mail@stefanobrivio.net
Action: failed
Status: 5.7.1
Remote-MTA: DNS; smtp-avas.seeweb.it
Diagnostic-Code: SMTP; 554 5.7.1 <mail@stefanobrivio.net>: Relay access denied
Last-Attempt-Date: Sun, 21 Nov 2010 03:48:54 +0100

--=-X4cV+9UiDG16/8CZtPhl
Content-Type: message/rfc822

Return-Path: <joe@perches.com>
Received: from mail.perches.com (mail.perches.com [173.55.12.10]) by
 polimi.it (8.14.3/8.14.3) with ESMTP id oAL2mlAw010936 for
 <stefano.brivio@polimi.it>; Sun, 21 Nov 2010 03:48:48 +0100
Received: from Joe-Laptop.home (unknown [192.168.1.156]) by
 mail.perches.com (Postfix) with ESMTP id 072B424372; Sat, 20 Nov 2010
 18:40:34 -0800 (PST)
From: Joe Perches <joe@perches.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH 55/62] b43: Use static const
Date: Sat, 20 Nov 2010 18:38:56 -0800
Message-Id: <515c42b1b99e90575869532cfa383cadb7b66515.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
X-PMX-Version: 5.5.9.395186, Antispam-Engine: 2.7.2.376379, Antispam-Data:
 2010.11.21.23914
X-PerlMx-Spam: No virus found, Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1300_1399 0, BODY_SIZE_2000_LESS 0,
 BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NA 0,
 __CP_URI_IN_BODY 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0,
 __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_WWW 0, __URI_NS '
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
   5502	     56	   1336	   6894	   1aee	drivers/net/wireless/b43/phy_common.o.new
   5511	     56	   1336	   6903	   1af7	drivers/net/wireless/b43/phy_common.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/b43/phy_common.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 7b2ea67..fa7f83f 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -427,9 +427,11 @@ void b43_phyop_switch_analog_generic(struct b43_wldev *dev, bool on)
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/Cordic */
 struct b43_c32 b43_cordic(int theta)
 {
-	u32 arctg[] = { 2949120, 1740967, 919879, 466945, 234379, 117304,
-		      58666, 29335, 14668, 7334, 3667, 1833, 917, 458,
-		      229, 115, 57, 29, };
+	static const u32 arctg[] = {
+		2949120, 1740967, 919879, 466945, 234379, 117304,
+		  58666,   29335,  14668,   7334,   3667,   1833,
+		    917,     458,    229,    115,     57,     29,
+	};
 	u8 i;
 	s32 tmp;
 	s8 signx = 1;
-- 
1.7.3.2.245.g03276.dirty


--=-X4cV+9UiDG16/8CZtPhl--

