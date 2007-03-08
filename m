Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2118 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbXCHEC0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 23:02:26 -0500
Date: Wed, 7 Mar 2007 22:32:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream' branch of wireless-2.6
Message-ID: <20070308033226.GB19886@tuxdriver.com>
References: <20070308033022.GA19886@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070308033022.GA19886@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit 9b73d945c4269f61d2ecf0555150b577a965bc99:
  John W. Linville (1):
        Merge branch 'upstream-fixes' into upstream

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream

Andrew Morton (1):
      ipw2200: fix ieee80211_get_geo typo

Jouni Malinen (1):
      hostap: Add D-Link DWL-650 Rev. P1 product id

Sam Ravnborg (1):
      bcm43xx: do not rebuild when kernel version changes

 drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c |    4 ++--
 drivers/net/wireless/hostap/hostap_cs.c        |    5 +++++
 drivers/net/wireless/ipw2200.c                 |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c b/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
index c947025..d2df6a0 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_ethtool.c
@@ -32,7 +32,7 @@
 #include <linux/netdevice.h>
 #include <linux/pci.h>
 #include <linux/string.h>
-#include <linux/utsrelease.h>
+#include <linux/utsname.h>
 
 
 static void bcm43xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
@@ -40,7 +40,7 @@ static void bcm43xx_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *
 	struct bcm43xx_private *bcm = bcm43xx_priv(dev);
 
 	strncpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
-	strncpy(info->version, UTS_RELEASE, sizeof(info->version));
+	strncpy(info->version, utsname()->release, sizeof(info->version));
 	strncpy(info->bus_info, pci_name(bcm->pci_dev), ETHTOOL_BUSINFO_LEN);
 }
 
diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index 8d8f4b9..534da85 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -848,6 +848,11 @@ static struct pcmcia_device_id hostap_cs_ids[] = {
 		"Intersil", "PRISM 2_5 PCMCIA ADAPTER",	"ISL37300P",
 		"Eval-RevA",
 		0x4b801a17, 0x6345a0bf, 0xc9049a39, 0xc23adc0e),
+	/* D-Link DWL-650 Rev. P1; manfid 0x000b, 0x7110 */
+	PCMCIA_DEVICE_PROD_ID1234(
+		"D-Link", "DWL-650 Wireless PC Card RevP", "ISL37101P-10",
+		"A3",
+		0x1a424a1c, 0x6ea57632, 0xdd97a26b, 0x56b21f52),
 	PCMCIA_DEVICE_PROD_ID123(
 		"Addtron", "AWP-100 Wireless PCMCIA", "Version 01.02",
 		0xe6ec52ce, 0x08649af2, 0x4b74baa0),
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 99c517a..4372438 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -1852,7 +1852,7 @@ static ssize_t show_channels(struct device *d,
 			     char *buf)
 {
 	struct ipw_priv *priv = dev_get_drvdata(d);
-	const struct ieee80211_geo *geo = ipw_get_geo(priv->ieee);
+	const struct ieee80211_geo *geo = ieee80211_get_geo(priv->ieee);
 	int len = 0, i;
 
 	len = sprintf(&buf[len],
-- 
John W. Linville
linville@tuxdriver.com
