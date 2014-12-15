Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:36973 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaLOPCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 10:02:40 -0500
Received: by mail-wg0-f46.google.com with SMTP id x13so14986616wgg.33
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 07:02:39 -0800 (PST)
From: Krzysztof Konopko <kris@konagma.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, kris@konagma.com
Subject: [PATCH] staging: rtl8723au: Fix sparse warnings
Date: Mon, 15 Dec 2014 16:02:14 +0100
Message-Id: <1418655734-32475-1-git-send-email-kris@konagma.com> (sfid-20141215_160301_107762_ACD95B7C)
In-Reply-To: <1418452981.29082.7.camel@perches.com>
References: <1418452981.29082.7.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some struct fields in wifi.h are meant to be __le16 but were declared as
unsigned short.  This was reported by sparse:

  rtw_wlan_util.c:538:24: warning: cast to restricted __le16
  rtw_wlan_util.c:1544:29: warning: cast to restricted __le16
  rtw_wlan_util.c:1546:25: warning: cast to restricted __le16

This patch updates the types of the fields in `AC_param` and
`ADDBA_request` structs to be consistent with relevant structs in
include/linux/ieee80211.h.

Signed-off-by: Krzysztof Konopko <kris@konagma.com>
---
 drivers/staging/rtl8723au/include/wifi.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8723au/include/wifi.h b/drivers/staging/rtl8723au/include/wifi.h
index fd3da3b..25d573c 100644
--- a/drivers/staging/rtl8723au/include/wifi.h
+++ b/drivers/staging/rtl8723au/include/wifi.h
@@ -26,9 +26,9 @@
 ------------------------------------------------------------------------------*/
 
 struct AC_param {
-	unsigned char		ACI_AIFSN;
-	unsigned char		CW;
-	unsigned short	TXOP_limit;
+	u8			ACI_AIFSN;
+	u8			CW;
+	__le16			TXOP_limit;
 }  __packed;
 
 struct WMM_para_element {
@@ -38,10 +38,10 @@ struct WMM_para_element {
 }  __packed;
 
 struct ADDBA_request {
-	unsigned char		dialog_token;
-	unsigned short	BA_para_set;
-	unsigned short	BA_timeout_value;
-	unsigned short	BA_starting_seqctrl;
+	u8		dialog_token;
+	__le16		BA_para_set;
+	__le16		BA_timeout_value;
+	__le16		BA_starting_seqctrl;
 }  __packed;
 
 
-- 
2.1.3

