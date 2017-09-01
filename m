Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:28317 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdIAGov (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 02:44:51 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20170901064450epoutp0150cc22a7adcf823eb7320dd0be48899e~gKdmnhOab1723017230epoutp01n
        for <linux-wireless@vger.kernel.org>; Fri,  1 Sep 2017 06:44:50 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH] iw: Null check before accessing n_mcs variable
Reply-To: amit.khatri@samsung.com
From: Amit Khatri <amit.khatri@samsung.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Nitin Jhanwar <nitin.j@samsung.com>
Message-ID: <20170901061008epcms5p5fdd787910f9698c511e01a134afe90ea@epcms5p5> (sfid-20170901_084455_772384_82CA09A1)
Date: Fri, 01 Sep 2017 06:10:08 +0000
Content-Type: text/plain; charset="utf-8"
References: <CGME20170901061008epcms5p5fdd787910f9698c511e01a134afe90ea@epcms5p5>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Khatri <amit.khatri@samsung.com>
Date: Thu, 24 Aug 2017 00:16:26 -0700
Subject: [PATCH] iw: Null check before accessing n_mcs variable

If all cases will fail n_mcs variable fail to get any assignement
and remain NULL. so better to check NULL before dereference.
Signed-off-by: Amit Khatri <amit.khatri@samsung.com>
---
 bitrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/bitrate.c b/bitrate.c
index 4a026a4..3e58337 100644
--- a/bitrate.c
+++ b/bitrate.c
@@ -185,7 +185,8 @@ static int handle_bitrates(struct nl80211_state *state,
 				return 1;
 			if (tmpl < 0 || tmpl > 255)
 				return 1;
-			mcs[(*n_mcs)++] = tmpl;
+			if(n_mcs!=NULL)
+				mcs[(*n_mcs)++] = tmpl;
 			break;
 		case S_VHT:
 			if (*vht_argc >= VHT_ARGC_MAX)
-- 
1.7.9.5
