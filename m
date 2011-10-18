Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64623 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab1JRJSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 05:18:38 -0400
Received: by wyg36 with SMTP id 36so357056wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 02:18:37 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 2/2] iw: show STA flags in station dump
Date: Tue, 18 Oct 2011 11:18:27 +0200
Message-Id: <1318929507-11447-2-git-send-email-helmut.schaa@googlemail.com> (sfid-20111018_111848_048103_D9D1A1B9)
In-Reply-To: <1318929507-11447-1-git-send-email-helmut.schaa@googlemail.com>
References: <1318929507-11447-1-git-send-email-helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

Couldn't come up with a nice/short wording for "Managment frame
protection" and "Wireless Multimedia Extension" so I just used MFP
and WME/WMM instead.

 station.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/station.c b/station.c
index 6581d50..26a2b7c 100644
--- a/station.c
+++ b/station.c
@@ -37,6 +37,7 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 	struct nlattr *sinfo[NL80211_STA_INFO_MAX + 1];
 	struct nlattr *rinfo[NL80211_RATE_INFO_MAX + 1];
 	char mac_addr[20], state_name[10], dev[20];
+	struct nl80211_sta_flag_update *sta_flags;
 	static struct nla_policy stats_policy[NL80211_STA_INFO_MAX + 1] = {
 		[NL80211_STA_INFO_INACTIVE_TIME] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_RX_BYTES] = { .type = NLA_U32 },
@@ -50,6 +51,8 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		[NL80211_STA_INFO_PLINK_STATE] = { .type = NLA_U8 },
 		[NL80211_STA_INFO_TX_RETRIES] = { .type = NLA_U32 },
 		[NL80211_STA_INFO_TX_FAILED] = { .type = NLA_U32 },
+		[NL80211_STA_INFO_STA_FLAGS] =
+			{ .minlen = sizeof(struct nl80211_sta_flag_update) },
 	};
 
 	static struct nla_policy rate_policy[NL80211_RATE_INFO_MAX + 1] = {
@@ -167,6 +170,51 @@ static int print_sta_handler(struct nl_msg *msg, void *arg)
 		printf("\n\tmesh plink:\t%s", state_name);
 	}
 
+	if (sinfo[NL80211_STA_INFO_STA_FLAGS]) {
+		sta_flags = (struct nl80211_sta_flag_update *)
+			    nla_data(sinfo[NL80211_STA_INFO_STA_FLAGS]);
+
+		if (sta_flags->mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
+			printf("\n\tauthorized:\t");
+			if (sta_flags->set & BIT(NL80211_STA_FLAG_AUTHORIZED))
+				printf("yes");
+			else
+				printf("no");
+		}
+
+		if (sta_flags->mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
+			printf("\n\tauthenticated:\t");
+			if (sta_flags->set & BIT(NL80211_STA_FLAG_AUTHENTICATED))
+				printf("yes");
+			else
+				printf("no");
+		}
+
+		if (sta_flags->mask & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE)) {
+			printf("\n\tpreamble:\t");
+			if (sta_flags->set & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE))
+				printf("short");
+			else
+				printf("long");
+		}
+
+		if (sta_flags->mask & BIT(NL80211_STA_FLAG_WME)) {
+			printf("\n\tWMM/WME:\t");
+			if (sta_flags->set & BIT(NL80211_STA_FLAG_WME))
+				printf("yes");
+			else
+				printf("no");
+		}
+
+		if (sta_flags->mask & BIT(NL80211_STA_FLAG_MFP)) {
+			printf("\n\tMFP:\t\t");
+			if (sta_flags->set & BIT(NL80211_STA_FLAG_MFP))
+				printf("yes");
+			else
+				printf("no");
+		}
+	}
+
 	printf("\n");
 	return NL_SKIP;
 }
-- 
1.7.3.4

