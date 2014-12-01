Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:35714 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbaLAPxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 10:53:48 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so14400476wgg.21
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 07:53:47 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 2/4] iw: print new RRF_ regulatory flags
Date: Mon,  1 Dec 2014 17:53:42 +0200
Message-Id: <1417449224-10293-2-git-send-email-arik@wizery.com> (sfid-20141201_165352_129558_E7D3E484)
In-Reply-To: <1417449224-10293-1-git-send-email-arik@wizery.com>
References: <1417449224-10293-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These were added to cfg80211 recently

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v2: remove XXX from title, apparently the ML doesn't like them :)

 reg.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/reg.c b/reg.c
index e1bb0d2..9af8e7e 100644
--- a/reg.c
+++ b/reg.c
@@ -199,6 +199,12 @@ static int print_reg_handler(struct nl_msg *msg, void *arg)
 		PARSE_FLAG(NL80211_RRF_NO_OUTDOOR, "NO-OUTDOOR");
 		PARSE_FLAG(NL80211_RRF_DFS, "DFS");
 		PARSE_FLAG(NL80211_RRF_PTP_ONLY, "PTP-ONLY");
+		PARSE_FLAG(NL80211_RRF_AUTO_BW, "AUTO-BW");
+		PARSE_FLAG(NL80211_RRF_GO_CONCURRENT, "GO-CONCURRENT");
+		PARSE_FLAG(NL80211_RRF_NO_HT40MINUS, "NO-HT40MINUS");
+		PARSE_FLAG(NL80211_RRF_NO_HT40PLUS, "NO-HT40PLUS");
+		PARSE_FLAG(NL80211_RRF_NO_80MHZ, "NO-80MHZ");
+		PARSE_FLAG(NL80211_RRF_NO_160MHZ, "NO-160MHZ");
 
 		/* Kernels that support NO_IR always turn on both flags */
 		if ((flags & NL80211_RRF_NO_IR) && (flags & __NL80211_RRF_NO_IBSS)) {
-- 
1.9.1

