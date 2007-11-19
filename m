Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:11602 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754579AbXKSQGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 11:06:30 -0500
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] Remove ieee80211softmac
Message-Id: <20071119160626.ED6F19D4B5A@zog.reactivated.net> (sfid-20071119_160648_711962_71ECD4D0)
Date: Mon, 19 Nov 2007 16:06:26 +0000 (GMT)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the port of zd1211rw and the removal of bcm43xx, there are no
remaining softmac users. Remove it.

Signed-off-by: Daniel Drake <dsd@gentoo.org>
---

In addition to applying this patch, please also run:
  git rm -r net/ieee80211/softmac
  git rm include/net/ieee80211softmac*

 MAINTAINERS            |    6 ------
 net/ieee80211/Kconfig  |    1 -
 net/ieee80211/Makefile |    1 -
 3 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 18b7c8e..e8f02ea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3479,12 +3479,6 @@ M:	mhoffman@lightlink.com
 L:	lm-sensors@lm-sensors.org
 S:	Maintained
 
-SOFTMAC LAYER (IEEE 802.11)
-P:	Daniel Drake
-M:	dsd@gentoo.org
-L:	linux-wireless@vger.kernel.org
-S:	Obsolete
-
 SOFTWARE RAID (Multiple Disks) SUPPORT
 P:	Ingo Molnar
 M:	mingo@redhat.com
diff --git a/net/ieee80211/Kconfig b/net/ieee80211/Kconfig
index 1438ade..3db9b33 100644
--- a/net/ieee80211/Kconfig
+++ b/net/ieee80211/Kconfig
@@ -70,4 +70,3 @@ config IEEE80211_CRYPT_TKIP
 	This can be compiled as a module and it will be called
 	"ieee80211_crypt_tkip".
 
-source "net/ieee80211/softmac/Kconfig"
diff --git a/net/ieee80211/Makefile b/net/ieee80211/Makefile
index 796a7c7..f988417 100644
--- a/net/ieee80211/Makefile
+++ b/net/ieee80211/Makefile
@@ -10,4 +10,3 @@ ieee80211-objs := \
 	ieee80211_wx.o \
 	ieee80211_geo.o
 
-obj-$(CONFIG_IEEE80211_SOFTMAC) += softmac/
-- 
1.5.3.4

