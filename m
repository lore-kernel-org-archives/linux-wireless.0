Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54013 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103AbaDIB3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 21:29:04 -0400
Received: by mail-pa0-f50.google.com with SMTP id kq14so1801116pab.23
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 18:29:04 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 7/8] mac80211: remove unnecessary include clauses
Date: Wed,  9 Apr 2014 09:28:12 +0800
Message-Id: <2dbd379b526c343788b9477a398466717005edea.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032912_451469_617061D3)
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/aes_ccm.c                     |  5 -----
 net/mac80211/aes_cmac.c                    | 11 -----------
 net/mac80211/agg-rx.c                      |  5 -----
 net/mac80211/agg-tx.c                      |  5 -----
 net/mac80211/cfg.c                         | 10 ----------
 net/mac80211/chan.c                        |  5 +----
 net/mac80211/debugfs.c                     |  4 +---
 net/mac80211/debugfs_key.c                 |  3 ---
 net/mac80211/debugfs_netdev.c              | 13 +------------
 net/mac80211/debugfs_sta.c                 |  4 ----
 net/mac80211/driver-ops.h                  |  2 --
 net/mac80211/event.c                       |  2 +-
 net/mac80211/ht.c                          |  4 ----
 net/mac80211/ibss.c                        | 11 -----------
 net/mac80211/ieee80211_i.h                 | 14 +-------------
 net/mac80211/iface.c                       | 10 ++--------
 net/mac80211/key.c                         | 10 +---------
 net/mac80211/key.h                         |  2 --
 net/mac80211/led.c                         |  4 ----
 net/mac80211/led.h                         |  3 +--
 net/mac80211/main.c                        | 14 --------------
 net/mac80211/mesh.c                        |  3 ---
 net/mac80211/mesh.h                        |  3 +--
 net/mac80211/mesh_hwmp.c                   |  3 ---
 net/mac80211/mesh_pathtbl.c                |  8 --------
 net/mac80211/mesh_plink.c                  |  5 +----
 net/mac80211/mesh_ps.c                     |  1 -
 net/mac80211/mesh_sync.c                   |  1 -
 net/mac80211/michael.c                     |  4 +---
 net/mac80211/mlme.c                        | 13 -------------
 net/mac80211/offchannel.c                  |  4 +---
 net/mac80211/pm.c                          |  4 ----
 net/mac80211/rate.c                        |  5 +----
 net/mac80211/rate.h                        |  6 ------
 net/mac80211/rc80211_minstrel.c            |  9 +--------
 net/mac80211/rc80211_minstrel_debugfs.c    |  9 ++-------
 net/mac80211/rc80211_minstrel_ht.c         |  8 +-------
 net/mac80211/rc80211_minstrel_ht_debugfs.c |  8 ++------
 net/mac80211/rc80211_pid_algo.c            |  7 -------
 net/mac80211/rc80211_pid_debugfs.c         |  9 ---------
 net/mac80211/rx.c                          | 14 --------------
 net/mac80211/scan.c                        |  8 --------
 net/mac80211/spectmgmt.c                   |  5 -----
 net/mac80211/sta_info.c                    | 15 ---------------
 net/mac80211/sta_info.h                    |  5 +----
 net/mac80211/status.c                      |  7 -------
 net/mac80211/tkip.c                        | 10 +---------
 net/mac80211/tkip.h                        |  2 --
 net/mac80211/trace.c                       |  4 ----
 net/mac80211/trace.h                       |  2 +-
 net/mac80211/tx.c                          | 16 ----------------
 net/mac80211/util.c                        | 13 -------------
 net/mac80211/vht.c                         |  5 -----
 net/mac80211/wep.c                         | 15 +--------------
 net/mac80211/wep.h                         |  3 ---
 net/mac80211/wme.c                         | 10 ----------
 net/mac80211/wme.h                         |  1 -
 net/mac80211/wpa.c                         |  9 ---------
 net/mac80211/wpa.h                         |  2 --
 59 files changed, 24 insertions(+), 373 deletions(-)

diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index ec24378..0baa18ab 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -9,13 +9,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/crypto.h>
-#include <linux/err.h>
 #include <crypto/aes.h>
 
-#include <net/mac80211.h>
 #include "key.h"
 #include "aes_ccm.h"
 
diff --git a/net/mac80211/aes_cmac.c b/net/mac80211/aes_cmac.c
index 9b9009f..5cc25c2 100644
--- a/net/mac80211/aes_cmac.c
+++ b/net/mac80211/aes_cmac.c
@@ -7,14 +7,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/crypto.h>
-#include <linux/export.h>
-#include <linux/err.h>
 #include <crypto/aes.h>
 
-#include <net/mac80211.h>
 #include "key.h"
 #include "aes_cmac.h"
 
@@ -22,7 +16,6 @@
 #define CMAC_TLEN 8 /* CMAC TLen = 64 bits (8 octets) */
 #define AAD_LEN 20
 
-
 static void gf_mulx(u8 *pad)
 {
 	int i, carry;
@@ -35,7 +28,6 @@ static void gf_mulx(u8 *pad)
 		pad[AES_BLOCK_SIZE - 1] ^= 0x87;
 }
 
-
 static void aes_128_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
 				const u8 *addr[], const size_t *len, u8 *mac)
 {
@@ -91,7 +83,6 @@ static void aes_128_cmac_vector(struct crypto_cipher *tfm, size_t num_elem,
 	memcpy(mac, pad, CMAC_TLEN);
 }
 
-
 void ieee80211_aes_cmac(struct crypto_cipher *tfm, const u8 *aad,
 			const u8 *data, size_t data_len, u8 *mic)
 {
@@ -110,7 +101,6 @@ void ieee80211_aes_cmac(struct crypto_cipher *tfm, const u8 *aad,
 	aes_128_cmac_vector(tfm, 3, addr, len, mic);
 }
 
-
 struct crypto_cipher *ieee80211_aes_cmac_key_setup(const u8 key[])
 {
 	struct crypto_cipher *tfm;
@@ -122,7 +112,6 @@ struct crypto_cipher *ieee80211_aes_cmac_key_setup(const u8 key[])
 	return tfm;
 }
 
-
 void ieee80211_aes_cmac_key_free(struct crypto_cipher *tfm)
 {
 	crypto_free_cipher(tfm);
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 31bf258..d9cf88b 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -36,11 +36,6 @@
  * call must not fail.
  */
 
-#include <linux/ieee80211.h>
-#include <linux/slab.h>
-#include <linux/export.h>
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
 #include "driver-ops.h"
 
 static void ieee80211_free_tid_rx(struct rcu_head *h)
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index ce9633a..da44fb7 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -13,11 +13,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/ieee80211.h>
-#include <linux/slab.h>
-#include <linux/export.h>
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
 #include "driver-ops.h"
 #include "wme.h"
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aa39381..debf07f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -6,16 +6,6 @@
  * This file is GPLv2 as found in COPYING.
  */
 
-#include <linux/ieee80211.h>
-#include <linux/nl80211.h>
-#include <linux/rtnetlink.h>
-#include <linux/slab.h>
-#include <net/net_namespace.h>
-#include <linux/rcupdate.h>
-#include <linux/if_ether.h>
-#include <net/cfg80211.h>
-#include "ieee80211_i.h"
-#include "driver-ops.h"
 #include "cfg.h"
 #include "rate.h"
 #include "mesh.h"
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 122033d..f0be1c4d 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -2,11 +2,8 @@
  * mac80211 - channel management
  */
 
-#include <linux/nl80211.h>
-#include <linux/export.h>
 #include <linux/rtnetlink.h>
-#include <net/cfg80211.h>
-#include "ieee80211_i.h"
+
 #include "driver-ops.h"
 
 static enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 0e963bc1..83f483d 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -8,10 +8,8 @@
  *
  */
 
-#include <linux/debugfs.h>
 #include <linux/rtnetlink.h>
-#include "ieee80211_i.h"
-#include "driver-ops.h"
+
 #include "rate.h"
 #include "debugfs.h"
 
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 1521cab..129072e 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -8,10 +8,7 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/kobject.h>
-#include <linux/slab.h>
 #include "ieee80211_i.h"
-#include "key.h"
 #include "debugfs.h"
 #include "debugfs_key.h"
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 40a6489..037471b 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -7,22 +7,11 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/if.h>
-#include <linux/if_ether.h>
-#include <linux/interrupt.h>
-#include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
-#include <linux/slab.h>
-#include <linux/notifier.h>
-#include <net/mac80211.h>
-#include <net/cfg80211.h>
-#include "ieee80211_i.h"
+
 #include "rate.h"
 #include "debugfs.h"
 #include "debugfs_netdev.h"
-#include "driver-ops.h"
 
 static ssize_t ieee80211_if_read(
 	struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 2ecb4de..eb4e5f3 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -8,12 +8,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/debugfs.h>
-#include <linux/ieee80211.h>
-#include "ieee80211_i.h"
 #include "debugfs.h"
 #include "debugfs_sta.h"
-#include "sta_info.h"
 #include "driver-ops.h"
 
 /* sta attributtes */
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5331582..ead6394 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1,8 +1,6 @@
 #ifndef __MAC80211_DRIVER_OPS
 #define __MAC80211_DRIVER_OPS
 
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
 #include "trace.h"
 
 static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/event.c b/net/mac80211/event.c
index 01ae759..269bc2f 100644
--- a/net/mac80211/event.c
+++ b/net/mac80211/event.c
@@ -7,7 +7,7 @@
  *
  * mac80211 - events
  */
-#include <net/cfg80211.h>
+
 #include "ieee80211_i.h"
 
 /*
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index c150b68..80186e7 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -13,10 +13,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/ieee80211.h>
-#include <linux/export.h>
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
 #include "rate.h"
 
 static void __check_htcap_disable(struct ieee80211_ht_cap *ht_capa,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ff4d415..20e1a2f 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -12,17 +12,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/delay.h>
-#include <linux/slab.h>
-#include <linux/if_ether.h>
-#include <linux/skbuff.h>
-#include <linux/if_arp.h>
-#include <linux/etherdevice.h>
-#include <linux/rtnetlink.h>
-#include <net/mac80211.h>
-
-#include "ieee80211_i.h"
-#include "driver-ops.h"
 #include "rate.h"
 
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3b73c3e..86dcf23 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -12,23 +12,11 @@
 #ifndef IEEE80211_I_H
 #define IEEE80211_I_H
 
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/if_ether.h>
 #include <linux/interrupt.h>
-#include <linux/list.h>
-#include <linux/netdevice.h>
-#include <linux/skbuff.h>
-#include <linux/workqueue.h>
-#include <linux/types.h>
-#include <linux/spinlock.h>
-#include <linux/etherdevice.h>
 #include <linux/leds.h>
 #include <linux/idr.h>
 #include <net/ieee80211_radiotap.h>
-#include <net/cfg80211.h>
-#include <net/mac80211.h>
-#include "key.h"
+
 #include "sta_info.h"
 #include "debug.h"
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 359e14b..6a4f2b2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -10,19 +10,13 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/slab.h>
-#include <linux/kernel.h>
+
 #include <linux/if_arp.h>
-#include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
-#include <net/mac80211.h>
-#include <net/ieee80211_radiotap.h>
-#include "ieee80211_i.h"
-#include "sta_info.h"
+
 #include "debugfs_netdev.h"
 #include "mesh.h"
 #include "led.h"
-#include "driver-ops.h"
 #include "wme.h"
 #include "rate.h"
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 6ff65a1..4977f9d 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -9,16 +9,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/if_ether.h>
-#include <linux/etherdevice.h>
-#include <linux/list.h>
-#include <linux/rcupdate.h>
 #include <linux/rtnetlink.h>
-#include <linux/slab.h>
-#include <linux/export.h>
-#include <net/mac80211.h>
-#include <asm/unaligned.h>
-#include "ieee80211_i.h"
+
 #include "driver-ops.h"
 #include "debugfs_key.h"
 #include "aes_ccm.h"
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 19db686..d9dcb4f 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -10,8 +10,6 @@
 #ifndef IEEE80211_KEY_H
 #define IEEE80211_KEY_H
 
-#include <linux/types.h>
-#include <linux/list.h>
 #include <linux/crypto.h>
 #include <linux/rcupdate.h>
 #include <net/mac80211.h>
diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index e2b8364..85ae58e 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -6,10 +6,6 @@
  * published by the Free Software Foundation.
  */
 
-/* just for IFNAMSIZ */
-#include <linux/if.h>
-#include <linux/slab.h>
-#include <linux/export.h>
 #include "led.h"
 
 #define MAC80211_BLINK_DELAY 50 /* ms */
diff --git a/net/mac80211/led.h b/net/mac80211/led.h
index 89f4344..67f2c14 100644
--- a/net/mac80211/led.h
+++ b/net/mac80211/led.h
@@ -6,9 +6,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/list.h>
-#include <linux/spinlock.h>
 #include <linux/leds.h>
+
 #include "ieee80211_i.h"
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b055f6a5..1a0b206 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -8,25 +8,11 @@
  * published by the Free Software Foundation.
  */
 
-#include <net/mac80211.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-#include <linux/etherdevice.h>
-#include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
-#include <linux/bitmap.h>
-#include <linux/pm_qos.h>
 #include <linux/inetdevice.h>
-#include <net/net_namespace.h>
-#include <net/cfg80211.h>
 #include <net/addrconf.h>
 
-#include "ieee80211_i.h"
-#include "driver-ops.h"
 #include "rate.h"
 #include "mesh.h"
 #include "wep.h"
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9d29237..9692866 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -8,9 +8,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/slab.h>
-#include <asm/unaligned.h>
-#include "ieee80211_i.h"
 #include "mesh.h"
 #include "driver-ops.h"
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index f39a19f..aeb5f06 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -11,10 +11,9 @@
 #ifndef IEEE80211S_H
 #define IEEE80211S_H
 
-#include <linux/types.h>
 #include <linux/jhash.h>
-#include "ieee80211_i.h"
 
+#include "ieee80211_i.h"
 
 /* Data structures */
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index f951468..188e8a0 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -7,9 +7,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/slab.h>
-#include <linux/etherdevice.h>
-#include <asm/unaligned.h>
 #include "wme.h"
 #include "mesh.h"
 
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 7d050ed..a4db8c3 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -7,15 +7,7 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/etherdevice.h>
-#include <linux/list.h>
-#include <linux/random.h>
-#include <linux/slab.h>
-#include <linux/spinlock.h>
-#include <linux/string.h>
-#include <net/mac80211.h>
 #include "wme.h"
-#include "ieee80211_i.h"
 #include "mesh.h"
 
 /* There will be initially 2^INIT_PATHS_SIZE_ORDER buckets */
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index e8f60aa..280c066 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -6,10 +6,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/gfp.h>
-#include <linux/kernel.h>
-#include <linux/random.h>
-#include "ieee80211_i.h"
+
 #include "rate.h"
 #include "mesh.h"
 
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
index 2802f9d..502814e 100644
--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -10,7 +10,6 @@
 #include "mesh.h"
 #include "wme.h"
 
-
 /* mesh PS management */
 
 /**
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 2bc5dc2..b320d97 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -8,7 +8,6 @@
  * published by the Free Software Foundation.
  */
 
-#include "ieee80211_i.h"
 #include "mesh.h"
 #include "driver-ops.h"
 
diff --git a/net/mac80211/michael.c b/net/mac80211/michael.c
index 408649bd..9aa3df7 100644
--- a/net/mac80211/michael.c
+++ b/net/mac80211/michael.c
@@ -6,9 +6,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/types.h>
-#include <linux/bitops.h>
-#include <linux/ieee80211.h>
+
 #include <asm/unaligned.h>
 
 #include "michael.h"
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bbc2175..6181685 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -11,22 +11,9 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/delay.h>
-#include <linux/if_ether.h>
-#include <linux/skbuff.h>
-#include <linux/if_arp.h>
-#include <linux/etherdevice.h>
 #include <linux/moduleparam.h>
-#include <linux/rtnetlink.h>
-#include <linux/pm_qos.h>
 #include <linux/crc32.h>
-#include <linux/slab.h>
-#include <linux/export.h>
-#include <net/mac80211.h>
-#include <asm/unaligned.h>
 
-#include "ieee80211_i.h"
-#include "driver-ops.h"
 #include "rate.h"
 #include "led.h"
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 6fb3855..66c16bc 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -12,9 +12,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/export.h>
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
+
 #include "driver-ops.h"
 
 /*
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index d478b88..8a1284f 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -1,7 +1,3 @@
-#include <net/mac80211.h>
-#include <net/rtnetlink.h>
-
-#include "ieee80211_i.h"
 #include "mesh.h"
 #include "driver-ops.h"
 #include "led.h"
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 8fdadfd..1dd6d18 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -8,13 +8,10 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/kernel.h>
 #include <linux/rtnetlink.h>
 #include <linux/module.h>
-#include <linux/slab.h>
+
 #include "rate.h"
-#include "ieee80211_i.h"
-#include "debugfs.h"
 
 struct rate_control_alg {
 	struct list_head list;
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 9aa2a11..cfdfac5 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -11,12 +11,6 @@
 #ifndef IEEE80211_RATE_H
 #define IEEE80211_RATE_H
 
-#include <linux/netdevice.h>
-#include <linux/skbuff.h>
-#include <linux/types.h>
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
-#include "sta_info.h"
 #include "driver-ops.h"
 
 struct rate_control_ref {
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 26fd94f..3117694 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -44,14 +44,7 @@
  *   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
  *   THE POSSIBILITY OF SUCH DAMAGES.
  */
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/skbuff.h>
-#include <linux/debugfs.h>
-#include <linux/random.h>
-#include <linux/ieee80211.h>
-#include <linux/slab.h>
-#include <net/mac80211.h>
+
 #include "rate.h"
 #include "rc80211_minstrel.h"
 
diff --git a/net/mac80211/rc80211_minstrel_debugfs.c b/net/mac80211/rc80211_minstrel_debugfs.c
index fd0b9ca..a0162c3 100644
--- a/net/mac80211/rc80211_minstrel_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_debugfs.c
@@ -44,14 +44,9 @@
  *   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
  *   THE POSSIBILITY OF SUCH DAMAGES.
  */
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/skbuff.h>
-#include <linux/debugfs.h>
-#include <linux/ieee80211.h>
-#include <linux/slab.h>
-#include <linux/export.h>
+
 #include <net/mac80211.h>
+
 #include "rc80211_minstrel.h"
 
 int
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index bccaf85..08e7823 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -5,13 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/skbuff.h>
-#include <linux/debugfs.h>
-#include <linux/random.h>
-#include <linux/ieee80211.h>
-#include <net/mac80211.h>
+
 #include "rate.h"
 #include "rc80211_minstrel.h"
 #include "rc80211_minstrel_ht.h"
diff --git a/net/mac80211/rc80211_minstrel_ht_debugfs.c b/net/mac80211/rc80211_minstrel_ht_debugfs.c
index 3e7d793..9d757a5 100644
--- a/net/mac80211/rc80211_minstrel_ht_debugfs.c
+++ b/net/mac80211/rc80211_minstrel_ht_debugfs.c
@@ -5,13 +5,9 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/skbuff.h>
-#include <linux/debugfs.h>
-#include <linux/ieee80211.h>
-#include <linux/export.h>
+
 #include <net/mac80211.h>
+
 #include "rc80211_minstrel.h"
 #include "rc80211_minstrel_ht.h"
 
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index d0da2a7..2ce284d 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -9,17 +9,10 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/skbuff.h>
-#include <linux/debugfs.h>
-#include <linux/slab.h>
-#include <net/mac80211.h>
 #include "rate.h"
 #include "mesh.h"
 #include "rc80211_pid.h"
 
-
 /* This is an implementation of a TX rate control algorithm that uses a PID
  * controller. Given a target failed frames rate, the controller decides about
  * TX rate changes to meet the target failed frames rate.
diff --git a/net/mac80211/rc80211_pid_debugfs.c b/net/mac80211/rc80211_pid_debugfs.c
index 6ff1346..ba55647 100644
--- a/net/mac80211/rc80211_pid_debugfs.c
+++ b/net/mac80211/rc80211_pid_debugfs.c
@@ -6,18 +6,9 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/sched.h>
-#include <linux/spinlock.h>
 #include <linux/poll.h>
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/skbuff.h>
-#include <linux/slab.h>
-#include <linux/export.h>
 
-#include <net/mac80211.h>
 #include "rate.h"
-
 #include "rc80211_pid.h"
 
 static void rate_control_pid_event(struct rc_pid_event_buffer *buf,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ac83228..e04c98d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -9,20 +9,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/jiffies.h>
-#include <linux/slab.h>
-#include <linux/kernel.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/rcupdate.h>
-#include <linux/export.h>
-#include <net/mac80211.h>
-#include <net/ieee80211_radiotap.h>
-#include <asm/unaligned.h>
-
-#include "ieee80211_i.h"
-#include "driver-ops.h"
 #include "led.h"
 #include "mesh.h"
 #include "wep.h"
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 28185c8..1d606f8 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -12,16 +12,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/if_arp.h>
-#include <linux/etherdevice.h>
-#include <linux/rtnetlink.h>
-#include <linux/pm_qos.h>
 #include <net/sch_generic.h>
-#include <linux/slab.h>
-#include <linux/export.h>
-#include <net/mac80211.h>
 
-#include "ieee80211_i.h"
 #include "driver-ops.h"
 #include "mesh.h"
 
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 6ab0090..44291a7 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -14,11 +14,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/ieee80211.h>
-#include <net/cfg80211.h>
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
-#include "sta_info.h"
 #include "wme.h"
 
 int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index decd30c..0b31ef3 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -7,22 +7,7 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/etherdevice.h>
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-#include <linux/if_arp.h>
-#include <linux/timer.h>
-#include <linux/rtnetlink.h>
-
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
-#include "driver-ops.h"
 #include "rate.h"
-#include "sta_info.h"
 #include "debugfs_sta.h"
 #include "mesh.h"
 #include "wme.h"
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index d4d85de..29b7a2f 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -9,12 +9,9 @@
 #ifndef STA_INFO_H
 #define STA_INFO_H
 
-#include <linux/list.h>
-#include <linux/types.h>
-#include <linux/if_ether.h>
-#include <linux/workqueue.h>
 #include <linux/average.h>
 #include <linux/etherdevice.h>
+
 #include "key.h"
 
 /**
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e6e574a..afe53bc 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -9,18 +9,11 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/export.h>
-#include <linux/etherdevice.h>
-#include <linux/time.h>
-#include <net/mac80211.h>
-#include <asm/unaligned.h>
-#include "ieee80211_i.h"
 #include "rate.h"
 #include "mesh.h"
 #include "led.h"
 #include "wme.h"
 
-
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 				 struct sk_buff *skb)
 {
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 0ae2077..256f319 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -6,16 +6,8 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
-#include <linux/kernel.h>
-#include <linux/bitops.h>
-#include <linux/types.h>
-#include <linux/netdevice.h>
-#include <linux/export.h>
-#include <asm/unaligned.h>
-
-#include <net/mac80211.h>
+
 #include "driver-ops.h"
-#include "key.h"
 #include "tkip.h"
 #include "wep.h"
 
diff --git a/net/mac80211/tkip.h b/net/mac80211/tkip.h
index e3ecb65..e314846 100644
--- a/net/mac80211/tkip.h
+++ b/net/mac80211/tkip.h
@@ -9,8 +9,6 @@
 #ifndef TKIP_H
 #define TKIP_H
 
-#include <linux/types.h>
-#include <linux/crypto.h>
 #include "key.h"
 
 u8 *ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key);
diff --git a/net/mac80211/trace.c b/net/mac80211/trace.c
index 386e45d..73aa416 100644
--- a/net/mac80211/trace.c
+++ b/net/mac80211/trace.c
@@ -1,9 +1,5 @@
-/* bug in tracepoint.h, it should include this */
-#include <linux/module.h>
-
 /* sparse isn't too happy with all macros... */
 #ifndef __CHECKER__
-#include <net/cfg80211.h>
 #include "driver-ops.h"
 #include "debug.h"
 #define CREATE_TRACE_POINTS
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a0b0aea..085c680 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2,7 +2,7 @@
 #define __MAC80211_DRIVER_TRACE
 
 #include <linux/tracepoint.h>
-#include <net/mac80211.h>
+
 #include "ieee80211_i.h"
 
 #undef TRACE_SYSTEM
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 6200b07..b94444d 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -12,22 +12,6 @@
  * Transmit and frame generation functions.
  */
 
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-#include <linux/etherdevice.h>
-#include <linux/bitmap.h>
-#include <linux/rcupdate.h>
-#include <linux/export.h>
-#include <linux/time.h>
-#include <net/net_namespace.h>
-#include <net/ieee80211_radiotap.h>
-#include <net/cfg80211.h>
-#include <net/mac80211.h>
-#include <asm/unaligned.h>
-
-#include "ieee80211_i.h"
-#include "driver-ops.h"
 #include "led.h"
 #include "mesh.h"
 #include "wep.h"
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 639bc13..00b5e88 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -11,22 +11,9 @@
  * utilities for mac80211
  */
 
-#include <net/mac80211.h>
-#include <linux/netdevice.h>
-#include <linux/export.h>
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-#include <linux/etherdevice.h>
-#include <linux/if_arp.h>
-#include <linux/bitmap.h>
 #include <linux/crc32.h>
-#include <net/net_namespace.h>
-#include <net/cfg80211.h>
 #include <net/rtnetlink.h>
 
-#include "ieee80211_i.h"
-#include "driver-ops.h"
 #include "rate.h"
 #include "mesh.h"
 #include "wme.h"
diff --git a/net/mac80211/vht.c b/net/mac80211/vht.c
index e9e36a2..7139caf 100644
--- a/net/mac80211/vht.c
+++ b/net/mac80211/vht.c
@@ -6,13 +6,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/ieee80211.h>
-#include <linux/export.h>
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
 #include "rate.h"
 
-
 static void __check_vhtcap_disable(struct ieee80211_sub_if_data *sdata,
 				   struct ieee80211_sta_vht_cap *vht_cap,
 				   u32 flag)
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 6ee2b58..be6f8ce 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -8,22 +8,9 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/random.h>
-#include <linux/compiler.h>
 #include <linux/crc32.h>
-#include <linux/crypto.h>
-#include <linux/err.h>
-#include <linux/mm.h>
-#include <linux/scatterlist.h>
-#include <linux/slab.h>
-#include <asm/unaligned.h>
-
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
-#include "wep.h"
 
+#include "wep.h"
 
 int ieee80211_wep_init(struct ieee80211_local *local)
 {
diff --git a/net/mac80211/wep.h b/net/mac80211/wep.h
index 9615749..2a0370d 100644
--- a/net/mac80211/wep.h
+++ b/net/mac80211/wep.h
@@ -11,10 +11,7 @@
 #ifndef WEP_H
 #define WEP_H
 
-#include <linux/skbuff.h>
-#include <linux/types.h>
 #include "ieee80211_i.h"
-#include "key.h"
 
 int ieee80211_wep_init(struct ieee80211_local *local);
 void ieee80211_wep_free(struct ieee80211_local *local);
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 21211c6..89371ee 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -6,16 +6,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/netdevice.h>
-#include <linux/skbuff.h>
-#include <linux/module.h>
-#include <linux/if_arp.h>
-#include <linux/types.h>
-#include <net/ip.h>
-#include <net/pkt_sched.h>
-
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
 #include "wme.h"
 
 /* Default mapping in classifier to work with default
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 7fea4bb..4a3b759 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -10,7 +10,6 @@
 #ifndef _WME_H
 #define _WME_H
 
-#include <linux/netdevice.h>
 #include "ieee80211_i.h"
 
 extern const int ieee802_1d_to_ac[8];
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index b8600e3..3910fb9 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -7,17 +7,8 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/skbuff.h>
-#include <linux/compiler.h>
-#include <linux/ieee80211.h>
-#include <linux/gfp.h>
-#include <asm/unaligned.h>
-#include <net/mac80211.h>
 #include <crypto/aes.h>
 
-#include "ieee80211_i.h"
 #include "michael.h"
 #include "tkip.h"
 #include "aes_ccm.h"
diff --git a/net/mac80211/wpa.h b/net/mac80211/wpa.h
index 62e5a12..30ecd66 100644
--- a/net/mac80211/wpa.h
+++ b/net/mac80211/wpa.h
@@ -9,8 +9,6 @@
 #ifndef WPA_H
 #define WPA_H
 
-#include <linux/skbuff.h>
-#include <linux/types.h>
 #include "ieee80211_i.h"
 
 ieee80211_tx_result
-- 
1.9.0

