Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42040 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755885AbZLBWiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 17:38:22 -0500
Subject: Re: [PATCH] lib80211: make crypt modules configurable by user
From: Daniel Ritz <daniel.ritz@gmx.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1259711943.32171.134.camel@johannes.local>
References: <1259711174.13720.17.camel@MacRitz2>
	 <1259711943.32171.134.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Dec 2009 23:38:26 +0100
Message-ID: <1259793506.2107.57.camel@MacRitz2>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-12-02 at 00:59 +0100, Johannes Berg wrote:
> On Wed, 2009-12-02 at 00:46 +0100, Daniel Ritz wrote:
> > Make the crypt modules configurable by user. Normally drivers select them
> > when needed, but out-of-tree drivers can't do that. Having a minimal
> > kernel with just the things required won't select any of those modules,
> > resulting in the external driver to be close to useless (ie. it can scan
> > the networks, but cannot join a single one).
> 
> So ... what makes you think anyone cares about out of tree drivers?

hmm...dunno. nothing i guess :)

> 
> From my POV a clear NACK on this, since it makes the kernel
> configuration more complex for no useful reason.

ok. but looking at it again, there are some minor problems that have
nothing to do with out-of-tree-drivers:
- it's possible for the user to compile-in lib80211, but not the crypt
  modules
- the crypt modules depend on crypto API and modules, but it's the WLAN
  drivers that select them. duplicated selects for each driver.

so how about the following?
- allow the user to compile-in the crypto modules as well
- select the dependencies in the crypt modules, not the drivers

rgds
-daniel


diff --git a/drivers/net/wireless/hostap/Kconfig b/drivers/net/wireless/hostap/Kconfig
index c15db22..33b1080 100644
--- a/drivers/net/wireless/hostap/Kconfig
+++ b/drivers/net/wireless/hostap/Kconfig
@@ -2,13 +2,6 @@ config HOSTAP
 	tristate "IEEE 802.11 for Host AP (Prism2/2.5/3 and WEP/TKIP/CCMP)"
 	depends on WLAN_80211
 	select WIRELESS_EXT
-	select CRYPTO
-	select CRYPTO_ARC4
-	select CRYPTO_ECB
-	select CRYPTO_AES
-	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
-	select CRC32
 	select LIB80211
 	select LIB80211_CRYPT_WEP
 	select LIB80211_CRYPT_TKIP
diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index a813138..3846b2b 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -152,13 +152,6 @@ config LIBIPW
 	tristate
 	depends on PCI && WLAN_80211 && CFG80211
 	select WIRELESS_EXT
-	select CRYPTO
-	select CRYPTO_ARC4
-	select CRYPTO_ECB
-	select CRYPTO_AES
-	select CRYPTO_MICHAEL_MIC
-	select CRYPTO_ECB
-	select CRC32
 	select LIB80211
 	select LIB80211_CRYPT_WEP
 	select LIB80211_CRYPT_TKIP
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index abf7ca3..01b704c 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -127,13 +127,36 @@ config LIB80211
 	  you want this built into your kernel.
 
 config LIB80211_CRYPT_WEP
-	tristate
+	tristate "lib80211 WEP support"
+	depends on LIB80211
+	select CRYPTO
+	select CRYPTO_ARC4
+	select CRYPTO_ECB
+	select CRC32
+	help
+	  Drivers should select this themselves if needed.  Say Y if
+	  you want this built into your kernel.
 
 config LIB80211_CRYPT_CCMP
-	tristate
+	tristate "lib80211 CCMP support"
+	depends on LIB80211
+	select CRYPTO
+	select CRYPTO_AES
+	help
+	  Drivers should select this themselves if needed.  Say Y if
+	  you want this built into your kernel.
 
 config LIB80211_CRYPT_TKIP
-	tristate
+	tristate "lib80211 TKIP support"
+	depends on LIB80211
+	select CRYPTO
+	select CRYPTO_ARC4
+	select CRYPTO_ECB
+	select CRYPTO_MICHAEL_MIC
+	select CRC32
+	help
+	  Drivers should select this themselves if needed.  Say Y if
+	  you want this built into your kernel.
 
 config LIB80211_DEBUG
 	bool "lib80211 debugging messages"




