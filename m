Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:58938 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbYFVPi6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2008 11:38:58 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 09/12] rfkill: add type string helper
Date: Sun, 22 Jun 2008 12:38:45 -0300
Message-Id: <1214149128-5913-10-git-send-email-hmh@hmh.eng.br> (sfid-20080622_173910_444752_5C1C6467)
In-Reply-To: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br>
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br>
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
index a561e35..3c77734 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -224,34 +224,31 @@ static ssize_t rfkill_name_show(struct device *dev,
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
1.5.5.4

