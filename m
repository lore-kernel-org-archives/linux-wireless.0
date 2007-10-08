Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7885 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbXJHKT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 06:19:58 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH, take 2] libertas: fix "warning: Using plain integer as NULL pointer" sparse warnings
Date: Mon, 8 Oct 2007 12:20:04 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710081220.05125.hs4233@mail.mn-solutions.de> (sfid-20071008_112006_725651_D2C2534C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes three "warning: Using plain integer as NULL pointer"
sparse warnings.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--

Used the idea from johill.

Index: libertas-2.6/drivers/net/wireless/libertas/scan.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/scan.c	2007-10-08 12:40:31.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/scan.c	2007-10-08 13:18:50.000000000 +0200
@@ -578,7 +578,7 @@ static int wlan_scan_channel_list(wlan_p
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	if (pscancfgout == 0 || pchantlvout == 0 || pscanchanlist == 0) {
+	if (!pscancfgout || !pchantlvout || !pscanchanlist) {
 		lbs_deb_scan("Scan: Null detect: %p, %p, %p\n",
 		       pscancfgout, pchantlvout, pscanchanlist);
 		return -1;
