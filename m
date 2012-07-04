Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64392 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840Ab2GDIpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 04:45:35 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 4/4] Fix print channel number for 60g
Date: Wed, 4 Jul 2012 11:45:11 +0300
Message-ID: <1341391511-11359-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120704_104538_845521_98F6B7A2)
In-Reply-To: <1341391511-11359-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341391511-11359-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
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

