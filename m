Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33798 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab0IKQTP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:19:15 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 8/8] compat-wireless: add brcm80211 driver
Date: Sat, 11 Sep 2010 18:18:33 +0200
Message-Id: <1284221913-22455-10-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
References: <1284221913-22455-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver was compile tested on kernel 2.6.29 to 2.6.36.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 Makefile                                     |    1 +
 config.mk                                    |    4 ++++
 patches/35-backport-brcm80211-Makefile.patch |   11 +++++++++++
 scripts/admin-update.sh                      |    1 +
 4 files changed, 17 insertions(+), 0 deletions(-)
 create mode 100644 patches/35-backport-brcm80211-Makefile.patch

diff --git a/Makefile b/Makefile
index b590ca2..61adb0d 100644
--- a/Makefile
+++ b/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
 
 ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
 obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/ath6kl/
+obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/brcm80211/
 endif
 
 
diff --git a/config.mk b/config.mk
index f2c62ed..b61c318 100644
--- a/config.mk
+++ b/config.mk
@@ -513,6 +513,10 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
 # CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK is not set
 CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
 CONFIG_ATH6K_LEGACY=m
+
+CONFIG_BRCM80211=m
+CONFIG_BRCM80211_PCI=y
+
 endif #CONFIG_WIRELESS_EXT
 endif #CONFIG_MMC
 
diff --git a/patches/35-backport-brcm80211-Makefile.patch b/patches/35-backport-brcm80211-Makefile.patch
new file mode 100644
index 0000000..2a94756
--- /dev/null
+++ b/patches/35-backport-brcm80211-Makefile.patch
@@ -0,0 +1,11 @@
+--- a/drivers/staging/brcm80211/Makefile
++++ b/drivers/staging/brcm80211/Makefile
+@@ -15,7 +15,7 @@
+ # OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ 
+-EXTRA_CFLAGS := -DBCMDBG -DWLC_HIGH -DSTA -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
++EXTRA_CFLAGS := -DBCMDBG -DWLC_HIGH -DSTA -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -I$(obj)/sys -I$(obj)/phy -I$(obj)/util -I$(obj)/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
+ 
+ PCI_CFLAGS := -DWLC_LOW
+ 
diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
index e000faf..6ef281d 100755
--- a/scripts/admin-update.sh
+++ b/scripts/admin-update.sh
@@ -212,6 +212,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/orinoco"
 
 # Staging drivers
 STAGING_DRIVERS="drivers/staging/ath6kl"
+STAGING_DRIVERS="$STAGING_DRIVERS drivers/staging/brcm80211"
 
 # Ethernet drivers
 DRIVERS="$DRIVERS drivers/net/atl1c"
-- 
1.7.0.4

