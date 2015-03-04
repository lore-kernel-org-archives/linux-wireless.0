Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52284 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317AbbCDHKF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 02:10:05 -0500
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@qti.qualcomm.com>,
	<vthiagar@qti.qualcomm.com>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH v2] iw: display allowable channel bandwidth information
Date: Wed, 4 Mar 2015 12:34:46 +0530
Message-ID: <1425452686-28196-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20150304_081014_990237_B13D235C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We already have allowable channel bandwidth information at userspace.
Display this information with 'iw list'. Excerpt of iw list command

Frequencies:
	* 5180 MHz [36] (17.0 dBm)
	  (10MHZ, 20MHZ, HT40+, VHT80, VHT160)
	* 5200 MHz [40] (17.0 dBm)
	  (10MHZ, 20MHZ, HT40-, HT40+, VHT80, VHT160)

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
v2:
	Display channel bw information in separate line (Johannes)
	Updated commit log to reflect above change.
 info.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/info.c b/info.c
index 1df503f..728cb87 100644
--- a/info.c
+++ b/info.c
@@ -189,6 +189,31 @@ next:
 						printf(")");
 					printf("\n");
 
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_DISABLED]) {
+						open = 0;
+						printf("\t\t\t ");
+						if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_10MHZ])
+							print_flag("10MHz", &open);
+
+						if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_20MHZ])
+							print_flag("20MHz", &open);
+
+						if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_HT40_MINUS])
+							print_flag("HT40-", &open);
+
+						if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_HT40_PLUS])
+							print_flag("HT40+", &open);
+
+						if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_80MHZ])
+							print_flag("VHT80", &open);
+
+						if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_160MHZ])
+							print_flag("VHT160", &open);
+						if (open)
+							printf(")");
+						printf("\n");
+					}
+
 					if (!tb_freq[NL80211_FREQUENCY_ATTR_DISABLED] && tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]) {
 						enum nl80211_dfs_state state = nla_get_u32(tb_freq[NL80211_FREQUENCY_ATTR_DFS_STATE]);
 						unsigned long time;
-- 
1.9.1

