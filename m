Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:56265 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab1FHLyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 07:54:36 -0400
Subject: [PATCH 2/5] ath6kl: testmode support
To: gregkh@suse.de
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Wed, 08 Jun 2011 14:54:30 +0300
Message-ID: <20110608115430.32208.81891.stgit@localhost6.localdomain6> (sfid-20110608_135438_223329_2E459800)
In-Reply-To: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add testmode support for running low level hardware tests. The testmode
is enabled by setting testmode module parameter to 1.

For now only a simple command passing is supported. More advanced
support will be implemented later.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/staging/ath6kl/os/linux/cfg80211.c |   58 ++++++++++++++++++++++++++++
 1 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 77dfb40..a0c0819 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -24,6 +24,7 @@
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
+#include <net/netlink.h>
 
 #include "ar6000_drv.h"
 
@@ -1452,6 +1453,62 @@ ar6k_cfg80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
     return 0;
 }
 
+#ifdef CONFIG_NL80211_TESTMODE
+enum ar6k_testmode_attr {
+	__AR6K_TM_ATTR_INVALID	= 0,
+	AR6K_TM_ATTR_CMD	= 1,
+	AR6K_TM_ATTR_DATA	= 2,
+
+	/* keep last */
+	__AR6K_TM_ATTR_AFTER_LAST,
+	AR6K_TM_ATTR_MAX	= __AR6K_TM_ATTR_AFTER_LAST - 1
+};
+
+enum ar6k_testmode_cmd {
+	AR6K_TM_CMD_TCMD		= 0,
+};
+
+#define AR6K_TM_DATA_MAX_LEN 5000
+
+static const struct nla_policy ar6k_testmode_policy[AR6K_TM_ATTR_MAX + 1] = {
+	[AR6K_TM_ATTR_CMD] = { .type = NLA_U32 },
+	[AR6K_TM_ATTR_DATA] = { .type = NLA_BINARY,
+				.len = AR6K_TM_DATA_MAX_LEN },
+};
+
+static int ar6k_testmode_cmd(struct wiphy *wiphy, void *data, int len)
+{
+	struct ar6_softc *ar = wiphy_priv(wiphy);
+	struct nlattr *tb[AR6K_TM_ATTR_MAX + 1];
+	int err, buf_len;
+	void *buf;
+
+	err = nla_parse(tb, AR6K_TM_ATTR_MAX, data, len,
+			ar6k_testmode_policy);
+	if (err)
+		return err;
+
+	if (!tb[AR6K_TM_ATTR_CMD])
+		return -EINVAL;
+
+	switch (nla_get_u32(tb[AR6K_TM_ATTR_CMD])) {
+	case AR6K_TM_CMD_TCMD:
+		if (!tb[AR6K_TM_ATTR_DATA])
+			return -EINVAL;
+
+		buf = nla_data(tb[AR6K_TM_ATTR_DATA]);
+		buf_len = nla_len(tb[AR6K_TM_ATTR_DATA]);
+
+		wmi_test_cmd(ar->arWmi, buf, buf_len);
+
+		return 0;
+
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+#endif
 
 static const
 u32 cipher_suites[] = {
@@ -1627,6 +1684,7 @@ cfg80211_ops ar6k_cfg80211_ops = {
     .join_ibss = ar6k_cfg80211_join_ibss,
     .leave_ibss = ar6k_cfg80211_leave_ibss,
     .get_station = ar6k_get_station,
+    CFG80211_TESTMODE_CMD(ar6k_testmode_cmd)
 };
 
 struct wireless_dev *

