Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56965 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762796AbXLMG7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 01:59:33 -0500
Subject: [PATCH 72/48] libertas: endianness fixes for get_channel/set_channel
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i2u-0005so-Ho@shinybook.infradead.org> (sfid-20071213_070633_509700_3A3275AD)
Date: Thu, 13 Dec 2007 01:59:48 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Tue, 11 Dec 2007 17:35:51 -0500

Signed-off-by: Dan Williams <dcbw@redhat.com>
Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/cmd.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 32f9f88..0f07c2a 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -831,8 +831,8 @@ int lbs_get_channel(struct lbs_private *priv)
 	if (ret)
 		goto out;
 
-	lbs_deb_cmd("current radio channel is %d\n", cmd.channel);
-	ret = (int) cmd.channel;
+	ret = le16_to_cpu(cmd.channel);
+	lbs_deb_cmd("current radio channel is %d\n", ret);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
@@ -863,8 +863,9 @@ int lbs_set_channel(struct lbs_private *priv, u8 channel)
 	if (ret)
 		goto out;
 
-	priv->curbssparams.channel = cmd.channel;
-	lbs_deb_cmd("channel switch from %d to %d\n", old_channel, cmd.channel);
+	priv->curbssparams.channel = (uint8_t) le16_to_cpu(cmd.channel);
+	lbs_deb_cmd("channel switch from %d to %d\n", old_channel,
+		priv->curbssparams.channel);
 
 out:
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
-- 
1.5.3.4

