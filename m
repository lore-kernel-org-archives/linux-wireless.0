Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51319 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760035Ab2CTODv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:03:51 -0400
Received: by dajr28 with SMTP id r28so68669daj.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2012 07:03:50 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Youngsin Lee <youngsin@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>,
	Senthil Kumar Balasubramanian <senthilb@qca.qualcomm.com>,
	Vipin Mehta <vipimeht@qca.qualcomm.com>,
	yahuan@qca.qualcomm.com, jjan@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, henrykim@qualcomm.com,
	jouni@qca.qualcomm.com, athiruve@qca.qualcomm.com,
	cjkim@qualcomm.com, philipk@qca.qualcomm.com,
	sunnykim@qualcomm.com, sskwak@qualcomm.com, kkim@qualcomm.com,
	mattbyun@qualcomm.com, ryanlee@qualcomm.com, simbap@qualcomm.com,
	krislee@qualcomm.com, conner@qualcomm.com, hojinkim@qualcomm.com,
	honglee@qualcomm.com, johnwkim@qualcomm.com
Subject: [PATCH v2] cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB
Date: Tue, 20 Mar 2012 07:03:45 -0700
Message-Id: <1332252225-17531-1-git-send-email-mcgrof@frijolero.org> (sfid-20120320_150354_733228_D17D57D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

It has happened twice now where elaborate troubleshooting has
undergone on systems where CONFIG_CFG80211_INTERNAL_REGDB [0]
has been set but yet net/wireless/db.txt was not updated.

Despite the documentation on this it seems system integrators could
use some more help with this, so throw out a kernel warning at boot time
when their database is empty.

This does mean that the error-prone system integrator won't likely
realize the issue until they boot the machine but -- it does not seem
to make sense to enable a build bug breaking random build testing.

[0] http://wireless.kernel.org/en/developers/Regulatory/CRDA#CONFIG_CFG80211_INTERNAL_REGDB

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Youngsin Lee <youngsin@qualcomm.com>
Cc: Raja Mani <rmani@qca.qualcomm.com>
Cc: Senthil Kumar Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Vipin Mehta <vipimeht@qca.qualcomm.com>
Cc: yahuan@qca.qualcomm.com
Cc: jjan@qca.qualcomm.com
Cc: vthiagar@qca.qualcomm.com
Cc: henrykim@qualcomm.com
Cc: jouni@qca.qualcomm.com
Cc: athiruve@qca.qualcomm.com
Cc: cjkim@qualcomm.com
Cc: philipk@qca.qualcomm.com
Cc: sunnykim@qualcomm.com
Cc: sskwak@qualcomm.com
Cc: kkim@qualcomm.com
Cc: mattbyun@qualcomm.com
Cc: ryanlee@qualcomm.com
Cc: simbap@qualcomm.com
Cc: krislee@qualcomm.com
Cc: conner@qualcomm.com
Cc: hojinkim@qualcomm.com
Cc: honglee@qualcomm.com
Cc: johnwkim@qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---
 net/wireless/reg.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e9a0ac8..7b613c4 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -388,7 +388,15 @@ static void reg_regdb_query(const char *alpha2)
 
 	schedule_work(&reg_regdb_work);
 }
+
+/* Feel free to add any other sanity checks here */
+static void reg_regdb_size_check(void)
+{
+	/* We should ideally BUILD_BUG_ON() but then random builds would fail */
+	WARN_ONCE(!reg_regdb_size, "db.txt is empty, you should update it...");
+}
 #else
+static inline void reg_regdb_size_check(void) {}
 static inline void reg_regdb_query(const char *alpha2) {}
 #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
 
@@ -2367,6 +2375,7 @@ void /* __init_or_exit */ regulatory_exit(void)
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
 
+	reg_regdb_size_check();
 	reset_regdomains(true);
 
 	dev_set_uevent_suppress(&reg_pdev->dev, true);
-- 
1.7.10.rc1.22.gf5241

