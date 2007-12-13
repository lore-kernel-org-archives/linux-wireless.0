Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56847 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762750AbXLMG73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:29 -0500
Subject: [PATCH 66/48] libertas: fix debug output in lbs_cmd_copyback() function.
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2m-0005sI-32@shinybook.infradead.org> (sfid-20071213_070635_121081_411B9866)
Date: Thu, 13 Dec 2007 01:59:40 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 15:22:27 -0500

Bad dcbw. Always test on big-endian, or at least use sparse.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 79a8d0d..eeb09e0 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -2023,7 +2023,7 @@ void lbs_ps_confirm_sleep(struct lbs_private *priv, u16 psmode)
  *  @return 	   	0 on success, error on failure
  */
 int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
-			struct cmd_header *resp)
+		     struct cmd_header *resp)
 {
 	struct cmd_header *buf = (void *)extra;
 	uint16_t copy_len;
@@ -2032,8 +2032,8 @@ int lbs_cmd_copyback(struct lbs_private *priv, unsigned long extra,
 
 	copy_len = min(le16_to_cpu(buf->size), le16_to_cpu(resp->size));
 	lbs_deb_cmd("Copying back %u bytes; command response was %u bytes, "
-		    "copy back buffer was %u bytes", copy_len, resp->size,
-		    buf->size);
+		    "copy back buffer was %u bytes\n", copy_len,
+		    le16_to_cpu(resp->size), le16_to_cpu(buf->size));
 	memcpy(buf, resp, copy_len);
 
 	lbs_deb_leave(LBS_DEB_CMD);
-- 
1.5.3.4

