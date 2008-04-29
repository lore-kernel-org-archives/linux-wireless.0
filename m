Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:12364 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbYD2IKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 04:10:55 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: fix use-before-check violation
Date: Tue, 29 Apr 2008 10:07:56 +0200
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804291007.56406.hs4233@mail.mn-solutions.de> (sfid-20080429_101059_433377_43835568)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[PATCH] fix use-before-check violation

According to Coverity (kudo's to Adrian Bunk), we had one use-before-check
bug in libe libertas driver. This patch fixes this issue.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/scan.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/scan.c	2008-04-29 09:07:19.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/scan.c	2008-04-29 09:07:39.000000000 +0200
@@ -298,7 +298,8 @@ static int lbs_do_scan(struct lbs_privat
 	uint8_t *tlv;	/* pointer into our current, growing TLV storage area */
 
 	lbs_deb_enter_args(LBS_DEB_SCAN, "bsstype %d, chanlist[].chan %d, chan_count %d",
-			   bsstype, chan_list[0].channumber, chan_count);
+		bsstype, chan_list ? chan_list[0].channumber : -1,
+		chan_count);
 
 	/* create the fixed part for scan command */
 	scan_cmd = kzalloc(MAX_SCAN_CFG_ALLOC, GFP_KERNEL);
