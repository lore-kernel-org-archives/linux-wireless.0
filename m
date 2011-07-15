Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1673 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564Ab1GOXGs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 19:06:48 -0400
Subject: [PATCH 4/4] ath9k: use ath_opmode_to_string()
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Fri, 15 Jul 2011 19:06:46 -0400
Message-ID: <20110715230646.4461.64616.stgit@mj.roinet.com> (sfid-20110716_010651_147317_51062BBE)
In-Reply-To: <20110715230627.4461.85730.stgit@mj.roinet.com>
References: <20110715230627.4461.85730.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath9k/debug.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 22d3a26..d1eb896 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -749,7 +749,6 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	char *buf;
 	unsigned int len = 0, size = 8000;
 	ssize_t retval = 0;
-	const char *tmp;
 	unsigned int reg;
 	struct ath9k_vif_iter_data iter_data;
 
@@ -759,31 +758,14 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 	if (buf == NULL)
 		return -ENOMEM;
 
-	switch (sc->sc_ah->opmode) {
-	case  NL80211_IFTYPE_ADHOC:
-		tmp = "ADHOC";
-		break;
-	case  NL80211_IFTYPE_MESH_POINT:
-		tmp = "MESH";
-		break;
-	case  NL80211_IFTYPE_AP:
-		tmp = "AP";
-		break;
-	case  NL80211_IFTYPE_STATION:
-		tmp = "STATION";
-		break;
-	default:
-		tmp = "???";
-		break;
-	}
-
 	ath9k_ps_wakeup(sc);
 	len += snprintf(buf + len, size - len,
 			"curbssid: %pM\n"
 			"OP-Mode: %s(%i)\n"
 			"Beacon-Timer-Register: 0x%x\n",
 			common->curbssid,
-			tmp, (int)(sc->sc_ah->opmode),
+			ath_opmode_to_string(sc->sc_ah->opmode),
+			(int)(sc->sc_ah->opmode),
 			REG_READ(ah, AR_BEACON_PERIOD));
 
 	reg = REG_READ(ah, AR_TIMER_MODE);
