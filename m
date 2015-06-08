Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33238 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbbFHAnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 20:43:18 -0400
From: David Decotigny <ddecotig@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	David Decotigny <ddecotig@gmail.com>
Subject: [PATCH v2 2/2] staging: rtl8723au: core: remove redundant endianness conversion
Date: Sun,  7 Jun 2015 17:43:02 -0700
Message-Id: <1433724182-657-3-git-send-email-ddecotig@gmail.com> (sfid-20150608_024345_711150_76BA0418)
In-Reply-To: <1433724182-657-1-git-send-email-ddecotig@gmail.com>
References: <1433724182-657-1-git-send-email-ddecotig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Source and destination have the same little-endian annotation: this
patch removes incorrect byte-swap on non-LE cpus.

This addresses the following sparse warning:
drivers/staging/rtl8723au/core/rtw_mlme_ext.c:3911:56: warning: incorrect type in argument 1 (different base types)
drivers/staging/rtl8723au/core/rtw_mlme_ext.c:3911:56:    expected unsigned short [unsigned] [usertype] val
drivers/staging/rtl8723au/core/rtw_mlme_ext.c:3911:56:    got restricted __le16 [usertype] BA_timeout_value

Signed-off-by: David Decotigny <ddecotig@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
index 7c3b5dd..142f214 100644
--- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
@@ -3906,8 +3906,8 @@ void issue_action_BA23a(struct rtw_adapter *padapter,
 		put_unaligned_le16(BA_para_set,
 				   &mgmt->u.action.u.addba_resp.capab);
 
-		put_unaligned_le16(pmlmeinfo->ADDBA_req.BA_timeout_value,
-				   &mgmt->u.action.u.addba_resp.timeout);
+		mgmt->u.action.u.addba_resp.timeout
+			= pmlmeinfo->ADDBA_req.BA_timeout_value;
 
 		pattrib->pktlen += 8;
 		break;
-- 
2.2.0.rc0.207.ga3a616c

