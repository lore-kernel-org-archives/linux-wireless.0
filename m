Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:35169 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbbEIEig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 00:38:36 -0400
Received: by igbyr2 with SMTP id yr2so36473781igb.0
        for <linux-wireless@vger.kernel.org>; Fri, 08 May 2015 21:38:35 -0700 (PDT)
From: Brent Taylor <motobud@gmail.com>
To: kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
	Brent Taylor <motobud@gmail.com>
Subject: [PATCH] ath6kl: Fix multiple clients associating in AP mode
Date: Fri,  8 May 2015 23:38:27 -0500
Message-Id: <1431146307-6442-1-git-send-email-motobud@gmail.com> (sfid-20150509_063923_031391_59A93160)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When one client is associated and connected to an ar6003 hw version
2.0 with firmware 3.1.1.149, and another client tries to connect, the
first client's MAC address is lost in the station list because the
"aid" is always "1".  The structure "wmi_connect_event" has the "aid"
as the second byte in the message, but it should be the first byte.

This patch has been tested with linux-3.10.40

Signed-off-by: Brent Taylor <motobud@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 19f88b4..05d25a9 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1527,8 +1527,8 @@ struct wmi_connect_event {
 			__le32 nw_type;
 		} sta;
 		struct {
-			u8 phymode;
 			u8 aid;
+			u8 phymode;
 			u8 mac_addr[ETH_ALEN];
 			u8 auth;
 			u8 keymgmt;
-- 
2.4.0

