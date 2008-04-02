Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:14205 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbYDBOhu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 10:37:50 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: [PATCH] libertas: fix mode initialization problem
Date: Wed, 2 Apr 2008 16:34:51 +0200
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804021634.51406.hs4233@mail.mn-solutions.de> (sfid-20080402_153815_241727_F640A003)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After moving lbs_find_best_network_ssid() from scan.c to assoc.c gcc was
able to deduce that new_mode might stay uninitialized.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:29:48.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/assoc.c	2008-04-02 14:31:10.000000000 +0200
@@ -1021,7 +1021,7 @@ void lbs_association_worker(struct work_
 	}
 
 	if (find_any_ssid) {
-		u8 new_mode;
+		u8 new_mode = assoc_req->mode;
 
 		ret = lbs_find_best_network_ssid(priv, assoc_req->ssid,
 				&assoc_req->ssid_len, assoc_req->mode, &new_mode);
