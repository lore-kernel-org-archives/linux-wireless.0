Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43571 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab2GELgo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 07:36:44 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v1 4/4] Fix print channel number for 60g
Date: Thu, 5 Jul 2012 14:36:21 +0300
Message-ID: <1341488181-12542-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120705_133719_250793_CE70C7F0)
In-Reply-To: <1341488181-12542-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341488181-12542-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

    Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 util.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/util.c b/util.c
index 26d27c3..20d3d06 100644
--- a/util.c
+++ b/util.c
@@ -269,7 +269,13 @@ int ieee80211_frequency_to_channel(int freq)
 		return (freq - 2407) / 5;
 
 	/* FIXME: dot11ChannelStartingFactor (802.11-2007 17.3.8.3.2) */
-	return freq/5 - 1000;
+	if (freq < 45000)
+		return freq/5 - 1000;
+
+	if (freq >= 58320 && freq <= 64800)
+		return (freq - 56160) / 2160;
+
+    return 0;
 }
 
 void print_ssid_escaped(const uint8_t len, const uint8_t *data)
-- 
1.7.9.5

