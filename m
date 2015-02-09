Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62314 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbbBIHhU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 02:37:20 -0500
From: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@qti.qualcomm.com>,
	<vthiagar@qti.qualcomm.com>,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: [PATCH] iw: display allowable channel bandwidth information
Date: Mon, 9 Feb 2015 13:06:58 +0530
Message-ID: <1423467418-3912-1-git-send-email-arnagara@qti.qualcomm.com> (sfid-20150209_083724_711771_6B5F6C04)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We already have allowable channel bandwidth information at userspace.
Display this information with 'iw list'. Excerpt of iw list command

Frequencies:
	* 5180 MHz [36] (17.0 dBm) (HT40+, VHT80, VHT160)
	* 5200 MHz [40] (17.0 * dBm) (HT40-, HT40+, VHT80, VHT160)

Signed-off-by: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
---
 info.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/info.c b/info.c
index 6e21e45..84db716 100644
--- a/info.c
+++ b/info.c
@@ -173,6 +173,18 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 						goto next;
 					}
 
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_HT40_MINUS])
+						print_flag("HT40-", &open);
+
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_HT40_PLUS])
+						print_flag("HT40+", &open);
+
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_80MHZ])
+						print_flag("VHT80", &open);
+
+					if (!tb_freq[NL80211_FREQUENCY_ATTR_NO_160MHZ])
+						print_flag("VHT160", &open);
+
 					/* If both flags are set assume an new kernel */
 					if (tb_freq[NL80211_FREQUENCY_ATTR_NO_IR] && tb_freq[__NL80211_FREQUENCY_ATTR_NO_IBSS]) {
 						print_flag("no IR", &open);
-- 
1.9.1

