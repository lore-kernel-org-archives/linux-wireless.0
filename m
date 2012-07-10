Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32229 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2GJKHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 06:07:36 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC] iw: Inform the user when wow enable command with empty args
Date: Tue, 10 Jul 2012 15:37:28 +0530
Message-ID: <1341914848-14604-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120710_120739_415666_00C7194A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Currently when iw phy phyX wow enable is used with empty arguments
is used we would disable WoWLAN in cfg80211/nl80211.
It would be nice to inform the user that he/she did not configure
any triggers.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 wowlan.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/wowlan.c b/wowlan.c
index fa33c1f..6119886 100644
--- a/wowlan.c
+++ b/wowlan.c
@@ -31,6 +31,9 @@ static int handle_wowlan_enable(struct nl80211_state *state, struct nl_cb *cb,
 	if (!wowlan)
 		return -ENOBUFS;
 
+	if (!argc)
+		return 1;
+
 	while (argc) {
 		switch (parse_state) {
 		case PS_REG:
-- 
1.7.0.4

