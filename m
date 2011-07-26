Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32729 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab1GZWwh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 18:52:37 -0400
Subject: [PATCH 1/3] pcmcia: add PCMCIA_DEVICE_MANF_CARD_PROD_ID3
To: linux-pcmcia@lists.infradead.org, linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 26 Jul 2011 18:52:35 -0400
Message-ID: <20110726225235.29951.70265.stgit@mj.roinet.com> (sfid-20110727_005244_312876_900A8D47)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed to match wireless cards with Intersil firmware that have
ID 0x0156:0x0002 and the third ID "Version 01.02".  Such cards are
currently matched by orinoco_cs, which doesn't support WPA.  They should
be matched by hostap_cs.

The first and the second product ID vary widely, so there are few users
with some particular IDs.  Of those, very few can submit a patch for
hostap_cs or write a useful bugreport.  It's still important to support
their hardware properly.

With PCMCIA_DEVICE_MANF_CARD_PROD_ID3, it should be possible to cover
the remaining Intersil based designs that kept the numeric ID and the
"version" of the reference design.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 include/pcmcia/device_id.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/pcmcia/device_id.h b/include/pcmcia/device_id.h
index 63e5b8f..00dbfac 100644
--- a/include/pcmcia/device_id.h
+++ b/include/pcmcia/device_id.h
@@ -95,6 +95,15 @@
 	.prod_id = { (v1), NULL, NULL, NULL }, \
 	.prod_id_hash = { (vh1), 0, 0, 0 }, }
 
+#define PCMCIA_DEVICE_MANF_CARD_PROD_ID3(manf, card, v3, vh3) { \
+	.match_flags = PCMCIA_DEV_ID_MATCH_MANF_ID| \
+			PCMCIA_DEV_ID_MATCH_CARD_ID| \
+			PCMCIA_DEV_ID_MATCH_PROD_ID3, \
+	.manf_id = (manf), \
+	.card_id = (card), \
+	.prod_id = { NULL, NULL, (v3), NULL }, \
+	.prod_id_hash = { 0, 0, (vh3), 0 }, }
+
 
 /* multi-function devices */
 
