Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbXLJRld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 12:41:33 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 48/48] libertas: kill (IS,SET,UNSET)_MESH_FRAME.
Message-Id: <E1J1kps-0006nz-ML@shinybook.infradead.org> (sfid-20071210_174136_576605_2CCB83FA)
Date: Mon, 10 Dec 2007 10:46:24 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Mon, 10 Dec 2007 00:51:35 -0500

No need for these any more. We've collapsed all the unneeded nests of
functions which needed to keep track of which device the skb belonged to.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/defs.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index 8242384..04db6af 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -257,10 +257,6 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 
 #define	MAX_LEDS			8
 
-#define IS_MESH_FRAME(x) (x->cb[6])
-#define SET_MESH_FRAME(x) (x->cb[6]=1)
-#define UNSET_MESH_FRAME(x) (x->cb[6]=0)
-
 /** Global Variable Declaration */
 extern const char lbs_driver_version[];
 extern u16 lbs_region_code_to_index[MRVDRV_MAX_REGION_CODE];
-- 
1.5.3.4

