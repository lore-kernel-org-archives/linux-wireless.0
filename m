Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:59813 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZIXSJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 14:09:35 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI9PRD010729
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 21:09:30 +0300
Received: from [127.0.1.1] (essapo-nirac25264.europe.nokia.com [10.162.252.64])
	by mgw-da02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n8OI9Jh9003457
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2009 21:09:20 +0300
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH 2/2] iw: print firmware and hardware version
To: linux-wireless@vger.kernel.org
Date: Thu, 24 Sep 2009 11:09:25 -0700
Message-ID: <20090924180925.14692.47279.stgit@tikku>
In-Reply-To: <20090924180048.14503.9579.stgit@tikku>
References: <20090924180048.14503.9579.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

struct wiphy now contains firmware and hardware version, print that
information to the user.
---

 info.c    |   15 +++++++++++++++
 nl80211.h |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/info.c b/info.c
index 7bca69d..ae3ed54 100644
--- a/info.c
+++ b/info.c
@@ -66,6 +66,7 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 	struct nlattr *nl_freq;
 	struct nlattr *nl_rate;
 	struct nlattr *nl_mode;
+	const char *str;
 	int bandidx = 1;
 	int rem_band, rem_freq, rem_rate, rem_mode;
 	int open;
@@ -263,6 +264,20 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			printf("\tRTS threshold: %d\n", rts);
 	}
 
+	if (tb_msg[NL80211_ATTR_FW_VERSION]) {
+		str = nla_get_string(tb_msg[NL80211_ATTR_FW_VERSION]);
+		if (strlen(str) == 0)
+			str = "<unknown>";
+		printf("\tFirmware version: %s\n", str);
+	}
+
+	if (tb_msg[NL80211_ATTR_HW_VERSION]) {
+		str = nla_get_string(tb_msg[NL80211_ATTR_HW_VERSION]);
+		if (strlen(str) == 0)
+			str = "<unknown>";
+		printf("\tHardware version: %s\n", str);
+	}
+
 	if (!tb_msg[NL80211_ATTR_SUPPORTED_IFTYPES])
 		return NL_SKIP;
 
diff --git a/nl80211.h b/nl80211.h
index a8d71ed..6d6651f 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -714,6 +714,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PID,
 
+	NL80211_ATTR_FW_VERSION,
+	NL80211_ATTR_HW_VERSION,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,

