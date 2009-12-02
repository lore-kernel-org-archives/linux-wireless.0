Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65310 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbZLBOaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 09:30:19 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so217224bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 06:30:25 -0800 (PST)
Message-Id: <20091202142951.863122781@gmail.com>
References: <20091202142555.654873300@gmail.com>
Date: Wed, 02 Dec 2009 15:26:04 +0100
From: Holger Schurig <holgerschurig@googlemail.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 09/10] libertas: remove priv->ratebitmap
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Used to be a write-only-variable :-)

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>


--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -176,7 +176,6 @@ struct lbs_private {
 	struct assoc_request * pending_assoc_req;
 	struct assoc_request * in_progress_assoc_req;
 	uint16_t enablehwauto;
-	uint16_t ratebitmap;
 
 	/* ADHOC */
 	u16 beacon_period;
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -390,10 +390,8 @@ int lbs_cmd_802_11_rate_adapt_rateset(st
 	cmd.enablehwauto = cpu_to_le16(priv->enablehwauto);
 	cmd.bitmap = lbs_rate_to_fw_bitmap(priv->cur_rate, priv->enablehwauto);
 	ret = lbs_cmd_with_response(priv, CMD_802_11_RATE_ADAPT_RATESET, &cmd);
-	if (!ret && cmd_action == CMD_ACT_GET) {
-		priv->ratebitmap = le16_to_cpu(cmd.bitmap);
+	if (!ret && cmd_action == CMD_ACT_GET)
 		priv->enablehwauto = le16_to_cpu(cmd.enablehwauto);
-	}
 
 	lbs_deb_leave_args(LBS_DEB_CMD, "ret %d", ret);
 	return ret;

-- 
