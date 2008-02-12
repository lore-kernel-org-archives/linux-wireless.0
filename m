Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50260 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755159AbYBLNDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2008 08:03:11 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] p54: use IEEE 802.11e defaults for initialization
Date: Tue, 12 Feb 2008 14:02:06 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1202658578.11481.4.camel@johannes.berg> <200802111952.30964.chunkeey@web.de> <1202815900.8931.1.camel@johannes.berg>
In-Reply-To: <1202815900.8931.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_OjZsHYV+/GAMDYa"
Message-Id: <200802121402.06985.chunkeey@web.de> (sfid-20080212_130324_477716_80698D5C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_OjZsHYV+/GAMDYa
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This trival one-liner changes the QoS initialization values to match IEEE 
802.11e defaults.

Signed-off-by: Christian Lamparter <chunkeey@web.de>

---
Johannes:
Which tree do you want? I made two versions. 
1. ...-2.6.24.2.diff will be fine for the mainline and the everything branch.
2. ...-txoppatch.diff is made for "[PATCH v2] mac80211: give burst time in 
txop rather than 0.1msec units" (with some offset?!)

--Boundary-00=_OjZsHYV+/GAMDYa
Content-Type: text/x-diff;
  charset="utf-8";
  name="p54-ieee-qos-values-against-2.6.24.2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-ieee-qos-values-against-2.6.24.2.diff"

--- linux-2.6.24.2/drivers/net/wireless/p54common.c.orig	2008-02-12 13:22:26.803058257 +0100
+++ linux-2.6.24.2/drivers/net/wireless/p54common.c	2008-02-12 13:24:21.096297635 +0100
@@ -742,7 +742,7 @@ static void p54_init_vdcf(struct ieee802
 
 	P54_SET_QUEUE(vdcf->queue[0], 0x0002, 0x0003, 0x0007, 0x000f);
 	P54_SET_QUEUE(vdcf->queue[1], 0x0002, 0x0007, 0x000f, 0x001e);
-	P54_SET_QUEUE(vdcf->queue[2], 0x0002, 0x000f, 0x03ff, 0x0014);
+	P54_SET_QUEUE(vdcf->queue[2], 0x0003, 0x000f, 0x03ff, 0x0000);
 	P54_SET_QUEUE(vdcf->queue[3], 0x0007, 0x000f, 0x03ff, 0x0000);
 }
 

--Boundary-00=_OjZsHYV+/GAMDYa
Content-Type: text/x-diff;
  charset="utf-8";
  name="p54-ieee-qos-values-against-txoppatch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54-ieee-qos-values-against-txoppatch.diff"

--- everything/drivers/net/wireless/p54common.c.orig	2008-02-12 13:37:48.723005027 +0100
+++ everythinh/drivers/net/wireless/p54common.c	2008-02-12 13:38:09.200480691 +0100
@@ -740,15 +740,9 @@ static void p54_init_vdcf(struct ieee802
 
 	vdcf = (struct p54_tx_control_vdcf *) hdr->data;
 
-	/*
-	 * FIXME: The default values in the spec (IEEE 802.11
-	 *	  7.3.2.19 Table 37) are 47, 94, 0, 0, why use
-	 *	  47, 94, 63, 0 here? Also, the default AIFS
-	 *	  values (second parameter) are 2, 2, 3, 7...
-	 */
 	P54_SET_QUEUE(vdcf->queue[0], 0x0002, 0x0003, 0x0007, 47);
 	P54_SET_QUEUE(vdcf->queue[1], 0x0002, 0x0007, 0x000f, 94);
-	P54_SET_QUEUE(vdcf->queue[2], 0x0002, 0x000f, 0x03ff, 63);
+	P54_SET_QUEUE(vdcf->queue[2], 0x0003, 0x000f, 0x03ff, 0);
 	P54_SET_QUEUE(vdcf->queue[3], 0x0007, 0x000f, 0x03ff, 0);
 }
 

--Boundary-00=_OjZsHYV+/GAMDYa--
