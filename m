Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59138 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752143AbYFDDKZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 23:10:25 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 09/12] rfkill: add type string helper
Date: Wed,  4 Jun 2008 00:10:14 -0300
Message-Id: <1212549017-30144-10-git-send-email-hmh@hmh.eng.br> (sfid-20080604_051912_428541_09062786)
In-Reply-To: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will need access to the rfkill switch type in string format for more
than just sysfs.  Therefore, move it to a generic helper.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 54bed0e..1130637 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -220,34 +220,31 @@ static ssize_t rfkill_name_show(struct device *dev,
 	return sprintf(buf, "%s\n", rfkill->name);
 }
 
-static ssize_t rfkill_type_show(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
+static const char *rfkill_get_type_str(enum rfkill_type type)
 {
-	struct rfkill *rfkill = to_rfkill(dev);
-	const char *type;
-
-	switch (rfkill->type) {
+	switch (type) {
 	case RFKILL_TYPE_WLAN:
-		type = "wlan";
-		break;
+		return "wlan";
 	case RFKILL_TYPE_BLUETOOTH:
-		type = "bluetooth";
-		break;
+		return "bluetooth";
 	case RFKILL_TYPE_UWB:
-		type = "ultrawideband";
-		break;
+		return "ultrawideband";
 	case RFKILL_TYPE_WIMAX:
-		type = "wimax";
-		break;
+		return "wimax";
 	case RFKILL_TYPE_WWAN:
-		type = "wwan";
-		break;
+		return "wwan";
 	default:
 		BUG();
 	}
+}
+
+static ssize_t rfkill_type_show(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct rfkill *rfkill = to_rfkill(dev);
 
-	return sprintf(buf, "%s\n", type);
+	return sprintf(buf, "%s\n", rfkill_get_type_str(rfkill->type));
 }
 
 static ssize_t rfkill_state_show(struct device *dev,
-- 
1.5.5.3

