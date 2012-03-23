Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38192 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539Ab2CWOXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 10:23:38 -0400
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
	honglee@qualcomm.com, johnwkim@qualcomm.com,
	jinyong@qca.qualcomm.com, stable@vger.kernel.org
Subject: [PATCH v4] cfg80211: warn if db.txt is empty with CONFIG_CFG80211_INTERNAL_REGDB
Date: Fri, 23 Mar 2012 07:23:31 -0700
Message-Id: <1332512611-25241-1-git-send-email-mcgrof@frijolero.org> (sfid-20120323_152359_111254_90029085)
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
Cc: jinyong@qca.qualcomm.com
Cc: stable@vger.kernel.org
Signed-off-by: Luis R. Rodriguez <mcgrof@frijolero.org>
---

This v4 Cc's stable.

 net/wireless/reg.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e9a0ac8..15f3474 100644
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
 
@@ -2322,6 +2330,8 @@ int __init regulatory_init(void)
 	spin_lock_init(&reg_requests_lock);
 	spin_lock_init(&reg_pending_beacons_lock);
 
+	reg_regdb_size_check();
+
 	cfg80211_regdomain = cfg80211_world_regdom;
 
 	user_alpha2[0] = '9';
-- 
1.7.10.rc1.22.gf5241

