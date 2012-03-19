Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54046 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637Ab2CSVfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 17:35:10 -0400
Received: by obbeh20 with SMTP id eh20so1167654obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 14:35:09 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
To: sfr@canb.auug.org.au, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
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
Subject: [PATCH] cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB
Date: Mon, 19 Mar 2012 14:35:01 -0700
Message-Id: <1332192901-2500-1-git-send-email-mcgrof@frijolero.org> (sfid-20120319_223516_781886_87D088F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

It has happened twice now where elaborate troubleshooting has
undergone on systems where CONFIG_CFG80211_INTERNAL_REGDB [0]
has been set but yet net/wireless/db.txt was not updated.

Despite the documentation on this it seems system integrators could
use some more help with this, so throw out a kernel warning at boot time
when their database is empty, and if they enabled cfg80211 regulatory
debugging (CONFIG_CFG80211_REG_DEBUG), simply fail at build time. If
they didn't enable cfg80211 regulatory debugging then we'll just warn
at boot time. This does mean that the error-prone system integrator
won't likely realize the issue until they boot the machine but -- it
does not seem to make sense to enable a build bug unless someone
really is debugging.

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

Stephen, John, not sure what is best to address this since I know we shouldn't
be failing to build kernels easily. This will only fail to build if both
CONFIG_CFG80211_REG_DEBUG and CONFIG_CFG80211_INTERNAL_REGDB are enabled.
We could get rid of the build bug check completely but this just means
system integrators will likley fail to fix the issue early. Experience
shows this is a common issue so far and a lot of time is going into debugging
this. I'd like to avoid this in the future. Let me know what you guys think.

 net/wireless/reg.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e9a0ac8..85f51b3 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -388,7 +388,18 @@ static void reg_regdb_query(const char *alpha2)
 
 	schedule_work(&reg_regdb_work);
 }
+
+/* Feel free to add any other sanity checks here */
+static void reg_regdb_size_check(void)
+{
+#ifdef CONFIG_CFG80211_REG_DEBUG
+	BUILD_BUG_ON(!reg_regdb_size);
+#else
+	WARN_ONCE(!reg_regdb_size, "db.txt is empty, you should update it...");
+#endif
+}
 #else
+static inline void reg_regdb_size_check(void) {}
 static inline void reg_regdb_query(const char *alpha2) {}
 #endif /* CONFIG_CFG80211_INTERNAL_REGDB */
 
@@ -2367,6 +2378,7 @@ void /* __init_or_exit */ regulatory_exit(void)
 	mutex_lock(&cfg80211_mutex);
 	mutex_lock(&reg_mutex);
 
+	reg_regdb_size_check();
 	reset_regdomains(true);
 
 	dev_set_uevent_suppress(&reg_pdev->dev, true);
-- 
1.7.10.rc1.22.gf5241

