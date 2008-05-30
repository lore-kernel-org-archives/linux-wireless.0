Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21779 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYE3Mx3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2008 08:53:29 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: fix command size for CMD_802_11_SUBSCRIBE_EVENT
Date: Fri, 30 May 2008 14:53:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805301453.22880.hs4233@mail.mn-solutions.de> (sfid-20080530_145334_923133_E4F28378)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The size was two small by two bytes.

Signed-off-by: Holger Schurig

---

Before:

libertas cmd: DNLD_CMD: command 0x0075, seq 136, size 16
libertas DNLD_CMD: 75 00 10 00 88 00 00 00 01 00 08 00 04 01 02 00
libertas cmd: CMD_RESP: response 0x8075, seq 136, size 16
libertas CMD_RESP: 75 80 10 00 88 00 00 00 01 00 08 00 04 01 02 00

The value & frequency where missing.


After:

libertas cmd: DNLD_CMD: command 0x0075, seq 32, size 18
libertas DNLD_CMD: 75 00 12 00 20 00 00 00 01 00 08 00 04 01 02 00
libertas DNLD_CMD: 64 00
libertas cmd: CMD_RESP: response 0x8075, seq 32, size 18
libertas CMD_RESP: 75 80 12 00 20 00 00 00 01 00 08 00 04 01 02 00
libertas CMD_RESP: 64 00

Now value (100) and frequency (0) are there.


Index: wireless-testing/drivers/net/wireless/libertas/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/debugfs.c	2008-05-30 13:43:15.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/debugfs.c	2008-05-30 13:45:04.000000000 +0200
@@ -312,8 +312,8 @@ static ssize_t lbs_threshold_write(uint1
 	if (tlv_type != TLV_TYPE_BCNMISS)
 		tlv->freq = freq;
 
-	/* The command header, the event mask, and the one TLV */
-	events->hdr.size = cpu_to_le16(sizeof(events->hdr) + 2 + sizeof(*tlv));
+	/* The command header, the action, the event mask, and one TLV */
+	events->hdr.size = cpu_to_le16(sizeof(events->hdr) + 4 + sizeof(*tlv));
 
 	ret = lbs_cmd_with_response(priv, CMD_802_11_SUBSCRIBE_EVENT, events);
 
