Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:33977 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbbF3IWD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 04:22:03 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] staging: wilc1000: fix build failure
Date: Tue, 30 Jun 2015 13:51:51 +0530
Message-Id: <1435652511-19232-1-git-send-email-sudipm.mukherjee@gmail.com> (sfid-20150630_102238_877607_90D2D1DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 80279fb7ba5b ("cfg80211: properly send
NL80211_ATTR_DISCONNECTED_BY_AP in disconnect") has changed the api of
cfg80211_disconnected() and caused a build failure.
Add the extra argument as false since it appears from the code that the
disconnection is not locally generated.
And incase of doubt we can use false as that is the default behaviour.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 92064db..f7f5faf 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -675,7 +675,8 @@ static void CfgConnectResult(tenuConnDisconnEvent enuConnDisconnEvent,
 			pstrDisconnectNotifInfo->u16reason = 1;
 		}
 		cfg80211_disconnected(dev, pstrDisconnectNotifInfo->u16reason, pstrDisconnectNotifInfo->ie,
-				      pstrDisconnectNotifInfo->ie_len, GFP_KERNEL);
+				      pstrDisconnectNotifInfo->ie_len, false,
+				      GFP_KERNEL);
 
 	}
 
-- 
1.8.1.2

