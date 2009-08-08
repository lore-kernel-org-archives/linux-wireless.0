Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53686 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934068AbZHHMie (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 08:38:34 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5/7] [compat-2.6] Remove wext building
Date: Sat,  8 Aug 2009 14:38:14 +0200
Message-Id: <1249735096-27071-5-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
References: <1249735096-27071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wext can not be build as a module. We do not need to build it,
so remove it from the Makefile.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/patches/99-change-makefiles.patch |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/compat/patches/99-change-makefiles.patch b/compat/patches/99-change-makefiles.patch
index 19e5d1d..b5a0f10 100644
--- a/compat/patches/99-change-makefiles.patch
+++ b/compat/patches/99-change-makefiles.patch
@@ -84,3 +84,10 @@ only the wireless stuff.
  obj-$(CONFIG_LIBERTAS)		+= libertas/
  
  obj-$(CONFIG_LIBERTAS_THINFIRM)	+= libertas_tf/
+--- a/net/wireless/Makefile
++++ b/net/wireless/Makefile
+@@ -1,4 +1,3 @@
+-obj-$(CONFIG_WIRELESS_EXT) += wext.o
+ obj-$(CONFIG_CFG80211) += cfg80211.o
+ obj-$(CONFIG_LIB80211) += lib80211.o
+ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib80211_crypt_wep.o
-- 
1.6.2.1

