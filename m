Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:43319 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730AbZJIHL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 03:11:58 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] libertas: depend on CONFIG_CFG80211
Date: Fri, 9 Oct 2009 09:10:34 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910090910.34988.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

Fixes bug noted by Stephen Rothwell:

> On Wed, 7 Oct 2009 17:35:17 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20091006:
> 
> 
> drivers/built-in.o: In function `lbs_cfg_free':
> (.text+0x3479e0): undefined reference to `wiphy_unregister'
> drivers/built-in.o: In function `lbs_cfg_free':
> (.text+0x3479e7): undefined reference to `wiphy_free'
> drivers/built-in.o: In function `lbs_cfg_register':
> (.text+0x347a52): undefined reference to `wiphy_register'
> drivers/built-in.o: In function `lbs_cfg_alloc':
> (.text+0x347acf): undefined reference to `wiphy_new'

Index: linux-wl/drivers/net/wireless/libertas/Kconfig
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/Kconfig	2009-10-09 08:00:03.000000000 +0200
+++ linux-wl/drivers/net/wireless/libertas/Kconfig	2009-10-09 08:00:27.000000000 +0200
@@ -1,6 +1,6 @@
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
-	depends on WLAN_80211
+	depends on WLAN_80211 && CFG80211
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select LIB80211

-- 
http://www.holgerschurig.de
