Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:65407 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZFCTsH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2009 15:48:07 -0400
Received: by bwz9 with SMTP id 9so240616bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2009 12:48:08 -0700 (PDT)
Message-ID: <4A26CBD3.8050009@gmail.com>
Date: Wed, 03 Jun 2009 20:15:31 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <samuel@sortiz.org>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] cfg80211: fix Kconfig for users of cfg80211
References: <1244046631.4862.34.camel@johannes.local>
In-Reply-To: <1244046631.4862.34.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>  * iwm doesn't depend on cfg80211 or wireless extensions
>  * rndis wlan selects cfg80211 - needs to depend
>  * mac80211 selects cfg80211 - needs to depend

Hmm. Consider:

1. User using a rndis_wlan device on old kernel with cfg80211 unselected.
2. Upgrades kernel with make old_config

Result: the rndis_wlan driver is no longer configured to build.

I don't think it's a big issue, as you can reconfigure and rebuild as
soon as you realise. But you may have to 'realise' without google access.

The only reason I'm thinking of this is because orinoco may be in the
same boat shortly. Ditto other wireless drivers as they get converted.
So I had a play with Kconfig. How about something like the patch below
instead?

cfg80211 should just get autoselected in the most appropriate mode, and
drivers get the same restrictions as cfg80211. The option setting
appears to work fine, but I haven't done any build testing.

It might be possible to chain things like this, so mac80211 could be
done in the same way. But I guess we wouldn't want too much of this
going on...



Dave.

---
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index a67d292..9038bd6 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -333,11 +333,12 @@ config USB_ZD1201
 config USB_NET_RNDIS_WLAN
        tristate "Wireless RNDIS USB support"
        depends on USB && WLAN_80211 && EXPERIMENTAL
+       depends on CFG80211_AS_MODULE
        select USB_USBNET
        select USB_NET_CDCETHER
        select USB_NET_RNDIS_HOST
        select WIRELESS_EXT
-       select CFG80211
+       select CFG80211_USED
        ---help---
          This is a driver for wireless RNDIS devices.
          These are USB based adapters found in devices such as:
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 9cbf545..2de2bd8 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -1,12 +1,14 @@
+# If cfg80211 has to be configured as a module, so do we
 config MAC80211
        tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
+       depends on CFG80211_AS_MODULE
        select CRYPTO
        select CRYPTO_ECB
        select CRYPTO_ARC4
        select CRYPTO_AES
        select CRC32
        select WIRELESS_EXT
-       select CFG80211
+       select CFG80211_USED
        ---help---
          This option enables the hardware independent IEEE 802.11
          networking stack.
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 4428dd5..d3f08c4 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,6 +1,23 @@
-config CFG80211
-       tristate "Improved wireless configuration API"
+# Selected by drivers which use cfg80211
+config CFG80211_USED
+       tristate
+
+# Is cfg80211 restricted to being a module by its dependencies?
+# Drivers must depend on this so they inherit the restriction.
+#
+# Careful: m means that CFG80211 is restricted to being a module
+#          Both n and y mean there is no restriction
+config CFG80211_AS_MODULE
+       tristate
        depends on RFKILL || !RFKILL
+       default y
+
+# Avoid presenting a UI option so we inherit the value of CFG80211_USED
+# If one driver is set to m, and another to y, CFG80211_USED will be y.
+config CFG80211
+       tristate
+       depends on CFG80211_AS_MODULE
+       default CFG80211_USED

 config CFG80211_REG_DEBUG
        bool "cfg80211 regulatory debugging"

