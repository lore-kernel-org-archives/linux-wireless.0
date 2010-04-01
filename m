Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25255 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab0DAIiu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 04:38:50 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] wl1271: added missing command header in wl1271_cmd_disconnect
Date: Thu,  1 Apr 2010 11:38:18 +0300
Message-Id: <1270111104-29549-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
References: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The command header was missing in the wl1271_cmd_disconnect structure.  It
was working fine by sheer luck, because the parameters are not critical and
because our wl1271_cmd_send() function was overwriting the rx_config_options
with the actual header.

This patch adds the header to the command structure.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_cmd.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index e1131bc..d61f339 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -518,6 +518,8 @@ enum wl1271_disconnect_type {
 };
 
 struct wl1271_cmd_disconnect {
+	struct wl1271_cmd_header header;
+
 	__le32 rx_config_options;
 	__le32 rx_filter_options;
 
-- 
1.6.3.3

