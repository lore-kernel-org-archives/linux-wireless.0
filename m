Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:44569 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaJ1OAj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 10:00:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 13/16] brcmfmac: (clean) Rename files wl_cfg80211 to cfg80211
Date: Tue, 28 Oct 2014 14:56:16 +0100
Message-ID: <1414504579-12562-14-git-send-email-arend@broadcom.com> (sfid-20141028_150048_770758_671BED39)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile                 | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/btcoex.c                 | 2 +-
 .../wireless/brcm80211/brcmfmac/{wl_cfg80211.c => cfg80211.c}    | 5 +++--
 .../wireless/brcm80211/brcmfmac/{wl_cfg80211.h => cfg80211.h}    | 9 +++++----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c              | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c               | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c                    | 2 +-
 drivers/net/wireless/brcm80211/brcmfmac/vendor.c                 | 2 +-
 8 files changed, 14 insertions(+), 12 deletions(-)
 rename drivers/net/wireless/brcm80211/brcmfmac/{wl_cfg80211.c => cfg80211.c} (99%)
 rename drivers/net/wireless/brcm80211/brcmfmac/{wl_cfg80211.h => cfg80211.h} (98%)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index f6e35c9..35b680550 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -23,7 +23,7 @@ ccflags-y += -D__CHECK_ENDIAN__
 
 obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
 brcmfmac-objs += \
-		wl_cfg80211.o \
+		cfg80211.o \
 		chip.o \
 		fwil.o \
 		fweh.o \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
index a2f7e2c..e324414 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/btcoex.c
@@ -26,7 +26,7 @@
 #include "fwil_types.h"
 #include "btcoex.h"
 #include "p2p.h"
-#include "wl_cfg80211.h"
+#include "cfg80211.h"
 
 /* T1 start SCO/eSCO priority suppression */
 #define BRCMF_BTCOEX_OPPR_WIN_TIME   2000
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
similarity index 99%
rename from drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
rename to drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index 2560dff..0390e57 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -32,7 +32,7 @@
 #include "fwil_types.h"
 #include "p2p.h"
 #include "btcoex.h"
-#include "wl_cfg80211.h"
+#include "cfg80211.h"
 #include "feature.h"
 #include "fwil.h"
 #include "proto.h"
@@ -5657,7 +5657,8 @@ enum nl80211_iftype brcmf_cfg80211_get_iftype(struct brcmf_if *ifp)
 	return wdev->iftype;
 }
 
-bool brcmf_get_vif_state_any(struct brcmf_cfg80211_info *cfg, unsigned long state)
+bool brcmf_get_vif_state_any(struct brcmf_cfg80211_info *cfg,
+			     unsigned long state)
 {
 	struct brcmf_cfg80211_vif *vif;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
similarity index 98%
rename from drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
rename to drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
index 6abf94e..2a5b22c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.h
@@ -14,8 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _wl_cfg80211_h_
-#define _wl_cfg80211_h_
+#ifndef BRCMFMAC_CFG80211_H
+#define BRCMFMAC_CFG80211_H
 
 /* for brcmu_d11inf */
 #include <brcmu_d11.h>
@@ -480,7 +480,8 @@ const struct brcmf_tlv *
 brcmf_parse_tlvs(const void *buf, int buflen, uint key);
 u16 channel_to_chanspec(struct brcmu_d11inf *d11inf,
 			struct ieee80211_channel *ch);
-bool brcmf_get_vif_state_any(struct brcmf_cfg80211_info *cfg, unsigned long state);
+bool brcmf_get_vif_state_any(struct brcmf_cfg80211_info *cfg,
+			     unsigned long state);
 void brcmf_cfg80211_arm_vif_event(struct brcmf_cfg80211_info *cfg,
 				  struct brcmf_cfg80211_vif *vif);
 bool brcmf_cfg80211_vif_event_armed(struct brcmf_cfg80211_info *cfg);
@@ -493,4 +494,4 @@ void brcmf_set_mpc(struct brcmf_if *ndev, int mpc);
 void brcmf_abort_scanning(struct brcmf_cfg80211_info *cfg);
 void brcmf_cfg80211_free_netdev(struct net_device *ndev);
 
-#endif				/* _wl_cfg80211_h_ */
+#endif /* BRCMFMAC_CFG80211_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 8dbf2c1..53650b9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -27,7 +27,7 @@
 #include "debug.h"
 #include "fwil_types.h"
 #include "p2p.h"
-#include "wl_cfg80211.h"
+#include "cfg80211.h"
 #include "fwil.h"
 #include "fwsignal.h"
 #include "feature.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index dbd52cc..6d33331 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -34,7 +34,7 @@
 #include "fweh.h"
 #include "fwsignal.h"
 #include "p2p.h"
-#include "wl_cfg80211.h"
+#include "cfg80211.h"
 #include "proto.h"
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index 7459c25..ae504b4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -26,7 +26,7 @@
 #include "fwil.h"
 #include "fwil_types.h"
 #include "p2p.h"
-#include "wl_cfg80211.h"
+#include "cfg80211.h"
 
 /* parameters used for p2p escan */
 #define P2PAPI_SCAN_NPROBES 1
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
index f204c83..b86a083 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/vendor.c
@@ -23,7 +23,7 @@
 #include "dhd.h"
 #include "p2p.h"
 #include "debug.h"
-#include "wl_cfg80211.h"
+#include "cfg80211.h"
 #include "vendor.h"
 #include "fwil.h"
 
-- 
1.9.1

