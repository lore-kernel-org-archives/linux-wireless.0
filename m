Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:54448 "HELO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S932358Ab2C1SiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 14:38:24 -0400
From: Kiran Divekar <dkiran@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] libertas: fix signedness bug in lbs_auth_to_authtype()
Date: Wed, 28 Mar 2012 11:38:01 -0700
Message-Id: <1332959881-31278-1-git-send-email-dkiran@marvell.com> (sfid-20120328_203827_575040_F9B09BC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Return type for lbs_auth_to_authtype() is changed from "u8" to
"int" to return negative error code correctly.
Also an error check is added in connect handler for invalid auth
type.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/libertas/cfg.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index 3fa1ece..2fa879b 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -103,7 +103,7 @@ static const u32 cipher_suites[] = {
  * Convert NL80211's auth_type to the one from Libertas, see chapter 5.9.1
  * in the firmware spec
  */
-static u8 lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
+static int lbs_auth_to_authtype(enum nl80211_auth_type auth_type)
 {
 	int ret = -ENOTSUPP;
 
@@ -1411,7 +1411,12 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
 		goto done;
 	}
 
-	lbs_set_authtype(priv, sme);
+	ret = lbs_set_authtype(priv, sme);
+	if (ret == -ENOTSUPP) {
+		wiphy_err(wiphy, "unsupported authtype 0x%x\n", sme->auth_type);
+		goto done;
+	}
+
 	lbs_set_radio(priv, preamble, 1);
 
 	/* Do the actual association */
-- 
1.7.0.2

