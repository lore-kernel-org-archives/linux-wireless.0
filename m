Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab1ASWev (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 17:34:51 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so1417828fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 14:34:50 -0800 (PST)
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [RFT 1/8] staging: brcm80211: Remove unused ETHER_<foo> macros.
Date: Wed, 19 Jan 2011 23:35:25 +0100
Message-Id: <1295476532-21130-2-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/staging/brcm80211/include/proto/ethernet.h |   21 --------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/brcm80211/include/proto/ethernet.h b/drivers/staging/brcm80211/include/proto/ethernet.h
index 567407d..106a8bf 100644
--- a/drivers/staging/brcm80211/include/proto/ethernet.h
+++ b/drivers/staging/brcm80211/include/proto/ethernet.h
@@ -34,18 +34,6 @@
 #define ETHER_SRC_OFFSET	(1 * ETH_ALEN)
 #define ETHER_TYPE_OFFSET	(2 * ETH_ALEN)
 
-#define	ETHER_IS_VALID_LEN(foo)	\
-	((foo) >= ETHER_MIN_LEN && (foo) <= ETHER_MAX_LEN)
-
-#define ETHER_FILL_MCAST_ADDR_FROM_IP(ea, mgrp_ip) {		\
-		((u8 *)ea)[0] = 0x01;			\
-		((u8 *)ea)[1] = 0x00;			\
-		((u8 *)ea)[2] = 0x5e;			\
-		((u8 *)ea)[3] = ((mgrp_ip) >> 16) & 0x7f;	\
-		((u8 *)ea)[4] = ((mgrp_ip) >>  8) & 0xff;	\
-		((u8 *)ea)[5] = ((mgrp_ip) >>  0) & 0xff;	\
-}
-
 BWL_PRE_PACKED_STRUCT struct ether_header {
 	u8 ether_dhost[ETH_ALEN];
 	u8 ether_shost[ETH_ALEN];
@@ -56,17 +44,8 @@ BWL_PRE_PACKED_STRUCT struct ether_addr {
 	u8 octet[ETH_ALEN];
 } BWL_POST_PACKED_STRUCT;
 
-#define ETHER_SET_UNICAST(ea)	(((u8 *)(ea))[0] = (((u8 *)(ea))[0] & ~1))
-
 static const struct ether_addr ether_bcast = { {255, 255, 255, 255, 255, 255} };
 
-#define ETHER_MOVE_HDR(d, s) \
-do { \
-	struct ether_header t; \
-	t = *(struct ether_header *)(s); \
-	*(struct ether_header *)(d) = t; \
-} while (0)
-
 #include <packed_section_end.h>
 
 #endif				/* _NET_ETHERNET_H_ */
-- 
1.5.6.5

