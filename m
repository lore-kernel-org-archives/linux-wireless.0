Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57506 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759573AbXLMG7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:50 -0500
Subject: [PATCH 83/48] libertas: add debugging output to lbs_mesh_config()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i36-0005th-HN@shinybook.infradead.org> (sfid-20071213_070016_580994_14BA0B3F)
Date: Thu, 13 Dec 2007 02:00:00 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 11 Dec 2007 22:52:03 -0500

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 01d2349..1cb42dc 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1106,7 +1106,9 @@ int lbs_mesh_config(struct lbs_private *priv, int enable)
 		cmd.length = cpu_to_le16(priv->mesh_ssid_len);
 		memcpy(cmd.data, priv->mesh_ssid, priv->mesh_ssid_len);
 	}
-
+	lbs_deb_cmd("mesh config channel %d SSID %s\n",
+		    priv->curbssparams.channel,
+		    escape_essid(priv->mesh_ssid, priv->mesh_ssid_len));
 	return lbs_cmd_with_response(priv, CMD_MESH_CONFIG, cmd);
 }
 
-- 
1.5.3.4

