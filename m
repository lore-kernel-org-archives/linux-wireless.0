Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3981 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbXJZVH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 17:07:28 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: more endianness breakage
Date: Fri, 26 Oct 2007 17:04:28 -0400
Message-Id: <11934326811535-git-send-email-linville@tuxdriver.com> (sfid-20071026_220731_104300_C876AB57)
In-Reply-To: <11934326803330-git-send-email-linville@tuxdriver.com>
References: <11934326793639-git-send-email-linville@tuxdriver.com>
 <11934326801557-git-send-email-linville@tuxdriver.com>
 <11934326803769-git-send-email-linville@tuxdriver.com>
 <11934326803330-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Al Viro <viro@ftp.linux.org.uk>

	domain->header.len is le16 and has just been assigned
cpu_to_le16(arithmetical expression).  And all fields of adapter->logmsg
are __le32; not a single 16-bit among them...
	That's incremental to the previous one

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/11d.c  |    2 +-
 drivers/net/wireless/libertas/wext.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/11d.c b/drivers/net/wireless/libertas/11d.c
index 4cf0ff7..0560270 100644
--- a/drivers/net/wireless/libertas/11d.c
+++ b/drivers/net/wireless/libertas/11d.c
@@ -562,7 +562,7 @@ int libertas_cmd_802_11d_domain_info(wlan_private * priv,
 		       nr_subband * sizeof(struct ieeetypes_subbandset));
 
 		cmd->size = cpu_to_le16(sizeof(pdomaininfo->action) +
-					     domain->header.len +
+					     le16_to_cpu(domain->header.len) +
 					     sizeof(struct mrvlietypesheader) +
 					     S_DS_GEN);
 	} else {
diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index 2fcc3bf..873c405 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -973,7 +973,7 @@ static struct iw_statistics *wlan_get_wireless_stats(struct net_device *dev)
 	/* Quality by TX errors */
 	priv->wstats.discard.retries = priv->stats.tx_errors;
 
-	tx_retries = le16_to_cpu(adapter->logmsg.retry);
+	tx_retries = le32_to_cpu(adapter->logmsg.retry);
 
 	if (tx_retries > 75)
 		tx_qual = (90 - tx_retries) * POOR / 15;
@@ -989,10 +989,10 @@ static struct iw_statistics *wlan_get_wireless_stats(struct net_device *dev)
 		    (PERFECT - VERY_GOOD) / 50 + VERY_GOOD;
 	quality = min(quality, tx_qual);
 
-	priv->wstats.discard.code = le16_to_cpu(adapter->logmsg.wepundecryptable);
-	priv->wstats.discard.fragment = le16_to_cpu(adapter->logmsg.rxfrag);
+	priv->wstats.discard.code = le32_to_cpu(adapter->logmsg.wepundecryptable);
+	priv->wstats.discard.fragment = le32_to_cpu(adapter->logmsg.rxfrag);
 	priv->wstats.discard.retries = tx_retries;
-	priv->wstats.discard.misc = le16_to_cpu(adapter->logmsg.ackfailure);
+	priv->wstats.discard.misc = le32_to_cpu(adapter->logmsg.ackfailure);
 
 	/* Calculate quality */
 	priv->wstats.qual.qual = max(quality, (u32)100);
-- 
1.5.2.4

