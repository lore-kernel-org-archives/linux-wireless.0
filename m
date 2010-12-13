Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:57689 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757177Ab0LMWBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 17:01:44 -0500
Date: Tue, 14 Dec 2010 00:01:39 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iw: Show dropped Deauth/Disassoc notifications
Message-ID: <20101213220139.GB24752@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

diff --git a/event.c b/event.c
index 6f3faa2..7e4f122 100644
--- a/event.c
+++ b/event.c
@@ -300,6 +300,16 @@ static int print_event(struct nl_msg *msg, void *arg)
 		print_frame(args, tb[NL80211_ATTR_FRAME]);
 		printf("\n");
 		break;
+	case NL80211_CMD_UNPROT_DEAUTHENTICATE:
+		printf("unprotected deauth dropped");
+		print_frame(args, tb[NL80211_ATTR_FRAME]);
+		printf("\n");
+		break;
+	case NL80211_CMD_UNPROT_DISASSOCIATE:
+		printf("unprotected disassoc dropped");
+		print_frame(args, tb[NL80211_ATTR_FRAME]);
+		printf("\n");
+		break;
 	case NL80211_CMD_CONNECT:
 		status = 0;
 		if (!tb[NL80211_ATTR_STATUS_CODE])
diff --git a/nl80211.h b/nl80211.h
index c08709f..f6a96b1 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -389,6 +389,13 @@
  *
  * @NL80211_CMD_SET_WDS_PEER: Set the MAC address of the peer on a WDS interface.
  *
+ * @NL80211_CMD_UNPROT_DEAUTHENTICATE: Unprotected deauthentication frame
+ *	notification. This event is used to indicate that an unprotected
+ *	deauthentication frame was dropped when MFP is in use.
+ * @NL80211_CMD_UNPROT_DISASSOCIATE: Unprotected disassociation frame
+ *	notification. This event is used to indicate that an unprotected
+ *	disassociation frame was dropped when MFP is in use.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -493,6 +500,11 @@ enum nl80211_commands {
 	NL80211_CMD_SET_CHANNEL,
 	NL80211_CMD_SET_WDS_PEER,
 
+	NL80211_CMD_FRAME_WAIT_CANCEL,
+
+	NL80211_CMD_UNPROT_DEAUTHENTICATE,
+	NL80211_CMD_UNPROT_DISASSOCIATE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */

-- 
Jouni Malinen                                            PGP id EFC895FA
