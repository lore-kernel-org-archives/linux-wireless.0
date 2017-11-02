Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:45185 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbdKBLuJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 07:50:09 -0400
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20171102115007epoutp035b2c62f3f8d7589549b3117fedd511bc~zQn21OlTG1312213122epoutp03G
        for <linux-wireless@vger.kernel.org>; Thu,  2 Nov 2017 11:50:07 +0000 (GMT)
Mime-Version: 1.0
Subject: [PATCH] IW: Zero or Uninitialized value of keylen passing
Reply-To: amit.khatri@samsung.com
From: Amit Khatri <amit.khatri@samsung.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Nitin Jhanwar <nitin.j@samsung.com>,
        AMIT KUMAR JAISWAL <amit.jaiswal@samsung.com>
Message-ID: <20171102112839epcms5p42b2f4fa5e261fb5ec26237a17fe08655@epcms5p4> (sfid-20171102_125013_399693_C9F0EC07)
Date: Thu, 02 Nov 2017 11:28:39 +0000
Content-Type: text/plain; charset="utf-8"
References: <CGME20171102112839epcms5p42b2f4fa5e261fb5ec26237a17fe08655@epcms5p4>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From b755c8ee282abbd0008e9e7241c457662c90f2c3 Mon Sep 17 00:00:00 2001
From: Amit Khatri <amit.khatri@samsung.com>
Date: Thu, 2 Nov 2017 15:55:16 +0530
Subject: [PATCH] IW: Zero or Uninitialized value of keylen passing

In case of hexadeciaml keydata, keylen is not gettig updated
and passing in NLA_PUT(msg, NL80211_KEY_DATA, keylen, keydata)
as zero (becasue of local variable).

This patch initilalize keylen variable in case of hexkey data.

Signed-off-by: Amit Khatri <amit.khatri@samsung.com>
---
 util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/util.c b/util.c
index 25d909a..1ec0791 100644
--- a/util.c
+++ b/util.c
@@ -427,12 +427,14 @@ int parse_keys(struct nl_msg *msg, char **argv, int argc)
 		switch (strlen(keydata)) {
 		case 10:
 			keydata = hex2bin(keydata, keybuf);
+			keylen = 5;
 		case 5:
 			NLA_PUT_U32(msg, NL80211_KEY_CIPHER, 0x000FAC01);
 			keylen = 5;
 			break;
 		case 26:
 			keydata = hex2bin(keydata, keybuf);
+			keylen = 13;
 		case 13:
 			NLA_PUT_U32(msg, NL80211_KEY_CIPHER, 0x000FAC05);
 			keylen = 13;
-- 
2.7.4
