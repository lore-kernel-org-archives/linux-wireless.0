Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:33753 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbbEEXtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 19:49:25 -0400
Received: by iecrt8 with SMTP id rt8so2278726iec.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 May 2015 16:49:24 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 5 May 2015 18:49:24 -0500
Message-ID: <CAP+RiCDFH-=MqRZLtrjUEyShgw5V2KV-6FnMWe2crB1QqJyh2Q@mail.gmail.com> (sfid-20150506_014929_663593_CEED4B6F)
Subject: [PATCH 1/1] ath6kl: Fix multiple clients associating in AP mode
From: Brent Taylor <motobud@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath6kl@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When one client is associated and connected to an ar6003 hw version
2.0 with firmware 3.1.1.149, and another client tries to connect, the
first client's MAC address is lost in the station list because the
"aid" is always "1".  The structure "wmi_connect_event" has the "aid"
as the second byte in the message, but it should be the first byte.

This patch has been tested with linux-3.10.40, and should apply
cleanly to linux-4.1-rc1

Signed-off-by: Brent Taylor <motobud@gmail.com>

--- a/drivers/net/wireless/ath/ath6kl/wmi.h     2015-05-05
18:30:14.767029624 -0500
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h     2015-05-05
18:30:21.359031473 -0500
@@ -1527,8 +1527,8 @@ struct wmi_connect_event {
                        __le32 nw_type;
                } sta;
                struct {
-                       u8 phymode;
                        u8 aid;
+                       u8 phymode;
                        u8 mac_addr[ETH_ALEN];
                        u8 auth;
                        u8 keymgmt;
