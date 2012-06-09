Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19033 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523Ab2FIAvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 20:51:18 -0400
Cc: <linux-wireless@vger.kernel.org>, <me@bobcopeland.com>,
	<mickflemm@gmail.com>, <kvalo@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
Subject: [RFC 1/3] cfg80211: add CONFIG_CFG80211_EXPERT
Date: Fri, 8 Jun 2012 17:51:08 -0700
Message-ID: <1339203070-17979-2-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120609_025353_610629_3DA43BAA)
In-Reply-To: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

This adds CONFIG_CFG80211_EXPERT which can be used for
non-standard settings that are typically used for device
certification testing or research purposes. We'd use
CONFIG_EXPERT alone but it seems that most standard Linux
distributions are enabling CONFIG_EXPERT already. This
allows us to define wireless specific kernel features
under a flag that is intended by design to be disabled by
standard Linux distributions.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/Kconfig |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 4d2b1ec..3cc5293 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -74,6 +74,15 @@ config CFG80211_REG_DEBUG
 
 	  If unsure, say N.
 
+config CFG80211_EXPERT
+	bool "cfg80211 expert mode"
+	depends on CFG80211 && EXPERT
+	default n
+	---help---
+	  You should disable this unless you are doing some wireless
+	  certification testing in a controlled environment or working with
+	  wireless research in a controlled environment.
+
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
-- 
1.7.10.rc1.22.gf5241

