Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:29940 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268Ab1CKC4D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 21:56:03 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 18:55:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <gregkh@suse.de>
CC: <devel@linuxdriverproject.org>, <linux-wireless@vger.kernel.org>,
	<vmehta@atheros.com>, <naveen.singh@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/20] ath6kl: s|A_MEMCMP|memcmp|g
Date: Thu, 10 Mar 2011 18:55:30 -0800
Message-ID: <1299812147-12069-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
References: <1299812147-12069-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for i in $(find ./drivers/staging/ath6kl/ -name \*.[ch]) ; do \
        sed -r -i -e "s/A_MEMCMP/memcmp/g" $i; done

Cc: Naveen Singh <naveen.singh@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/staging/ath6kl/miscdrv/common_drv.c        |    4 ++--
 drivers/staging/ath6kl/os/linux/ar6000_drv.c       |    6 +++---
 drivers/staging/ath6kl/os/linux/cfg80211.c         |    8 ++++----
 .../staging/ath6kl/os/linux/include/osapi_linux.h  |    2 --
 drivers/staging/ath6kl/os/linux/ioctl.c            |    6 +++---
 drivers/staging/ath6kl/os/linux/wireless_ext.c     |    8 ++++----
 drivers/staging/ath6kl/wlan/include/ieee80211.h    |    2 +-
 drivers/staging/ath6kl/wlan/src/wlan_node.c        |    8 ++++----
 8 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/ath6kl/miscdrv/common_drv.c b/drivers/staging/ath6kl/miscdrv/common_drv.c
index 7a77290..a01f5d7 100644
--- a/drivers/staging/ath6kl/miscdrv/common_drv.c
+++ b/drivers/staging/ath6kl/miscdrv/common_drv.c
@@ -877,7 +877,7 @@ static ATH_DEBUG_MODULE_DBG_INFO *FindModule(char *module_name)
 
     while (pInfo != NULL) {
             /* TODO: need to use something other than strlen */
-        if (A_MEMCMP(pInfo->ModuleName,module_name,strlen(module_name)) == 0) {
+        if (memcmp(pInfo->ModuleName,module_name,strlen(module_name)) == 0) {
             break;
         }
         pInfo = pInfo->pNext;
@@ -916,7 +916,7 @@ void a_dump_module_debug_info_by_name(char *module_name)
         return;
     }
 
-    if (A_MEMCMP(module_name,"all",3) == 0) {
+    if (memcmp(module_name,"all",3) == 0) {
             /* dump all */
         while (pInfo != NULL) {
             a_dump_module_debug_info(pInfo);
diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 2111e99..e8277ff 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -4291,7 +4291,7 @@ ar6000_connect_event(AR_SOFTC_T *ar, u16 channel, u8 *bssid,
 
     if(ar->arNetworkType & AP_NETWORK) {
         struct net_device *dev = ar->arNetDev;
-        if(A_MEMCMP(dev->dev_addr, bssid, ATH_MAC_LEN)==0) {
+        if(memcmp(dev->dev_addr, bssid, ATH_MAC_LEN)==0) {
             ar->arACS = channel;
             ik = &ar->ap_mode_bkey;
 
@@ -4605,7 +4605,7 @@ u8 remove_sta(AR_SOFTC_T *ar, u8 *mac, u16 reason)
         }
     } else {
         for(i=0; i < AP_MAX_NUM_STA; i++) {
-            if(A_MEMCMP(ar->sta_list[i].mac, mac, ATH_MAC_LEN)==0) {
+            if(memcmp(ar->sta_list[i].mac, mac, ATH_MAC_LEN)==0) {
                 A_PRINTF("DEL STA %2.2x:%2.2x:%2.2x:%2.2x:%2.2x:%2.2x "
                 " aid=%d REASON=%d\n", mac[0], mac[1], mac[2],
                  mac[3], mac[4], mac[5], ar->sta_list[i].aid, reason);
@@ -6281,7 +6281,7 @@ ap_set_wapi_key(struct ar6_softc *ar, void *ikey)
     KEY_USAGE   keyUsage = 0;
     int    status;
 
-    if (A_MEMCMP(ik->ik_macaddr, bcast_mac, IEEE80211_ADDR_LEN) == 0) {
+    if (memcmp(ik->ik_macaddr, bcast_mac, IEEE80211_ADDR_LEN) == 0) {
         keyUsage = GROUP_USAGE;
     } else {
         keyUsage = PAIRWISE_USAGE;
diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index 415b253..2edac07 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -305,7 +305,7 @@ ar6k_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
     if(ar->arConnected == true &&
        ar->arSsidLen == sme->ssid_len &&
-       !A_MEMCMP(ar->arSsid, sme->ssid, ar->arSsidLen)) {
+       !memcmp(ar->arSsid, sme->ssid, ar->arSsidLen)) {
         reconnect_flag = true;
         status = wmi_reconnect_cmd(ar->arWmi,
                                    ar->arReqBssid,
@@ -318,7 +318,7 @@ ar6k_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
         }
         return 0;
     } else if(ar->arSsidLen == sme->ssid_len &&
-              !A_MEMCMP(ar->arSsid, sme->ssid, ar->arSsidLen)) {
+              !memcmp(ar->arSsid, sme->ssid, ar->arSsidLen)) {
 	    ar6000_disconnect(ar);
     }
 
@@ -332,7 +332,7 @@ ar6k_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
     A_MEMZERO(ar->arReqBssid, sizeof(ar->arReqBssid));
     if(sme->bssid){
-        if(A_MEMCMP(&sme->bssid, bcast_mac, AR6000_ETH_ADDR_LEN)) {
+        if(memcmp(&sme->bssid, bcast_mac, AR6000_ETH_ADDR_LEN)) {
             memcpy(ar->arReqBssid, sme->bssid, sizeof(ar->arReqBssid));
         }
     }
@@ -1321,7 +1321,7 @@ ar6k_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
     A_MEMZERO(ar->arReqBssid, sizeof(ar->arReqBssid));
     if(ibss_param->bssid) {
-        if(A_MEMCMP(&ibss_param->bssid, bcast_mac, AR6000_ETH_ADDR_LEN)) {
+        if(memcmp(&ibss_param->bssid, bcast_mac, AR6000_ETH_ADDR_LEN)) {
             memcpy(ar->arReqBssid, ibss_param->bssid, sizeof(ar->arReqBssid));
         }
     }
diff --git a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
index cdb4195..53b500c 100644
--- a/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
+++ b/drivers/staging/ath6kl/os/linux/include/osapi_linux.h
@@ -77,7 +77,6 @@
 #define A_CPU2BE32(x)      htonl(x)
 
 #define A_MEMZERO(addr, len)            memset(addr, 0, len)
-#define A_MEMCMP(addr1, addr2, len)     memcmp((addr1), (addr2), (len))
 #define A_MALLOC(size)                  kmalloc((size), GFP_KERNEL)
 #define A_MALLOC_NOWAIT(size)           kmalloc((size), GFP_ATOMIC)
 #define A_FREE(addr)                    kfree(addr)
@@ -364,7 +363,6 @@ static inline void *A_ALIGN_TO_CACHE_LINE(void *ptr) {
 #define POSTPACK                __ATTRIB_PACK
 
 #define A_MEMZERO(addr, len)            memset((addr), 0, (len))
-#define A_MEMCMP(addr1, addr2, len)     memcmp((addr1), (addr2), (len))
 #define A_MALLOC(size)                  malloc(size)
 #define A_FREE(addr)                    free(addr)
 
diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index 9a7f920..a95b743 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -555,7 +555,7 @@ ar6000_ioctl_set_badAp(struct net_device *dev, struct ifreq *rq)
         return -EIO;
     }
 
-    if (A_MEMCMP(cmd.bssid, null_mac, AR6000_ETH_ADDR_LEN) == 0) {
+    if (memcmp(cmd.bssid, null_mac, AR6000_ETH_ADDR_LEN) == 0) {
         /*
          * This is a delete badAP.
          */
@@ -3127,7 +3127,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                                       sizeof(adhocBssid)))
             {
                 ret = -EFAULT;
-            } else if (A_MEMCMP(adhocBssid.bssid, bcast_mac,
+            } else if (memcmp(adhocBssid.bssid, bcast_mac,
                                 AR6000_ETH_ADDR_LEN) == 0)
             {
                 ret = -EFAULT;
@@ -4714,7 +4714,7 @@ u8 mac_cmp_wild(u8 *mac, u8 *new_mac, u8 wild, u8 new_wild)
         if((wild & 1<<i) && (new_wild & 1<<i)) continue;
         if(mac[i] != new_mac[i]) return 1;
     }
-    if((A_MEMCMP(new_mac, null_mac, 6)==0) && new_wild &&
+    if((memcmp(new_mac, null_mac, 6)==0) && new_wild &&
         (wild != new_wild)) {
         return 1;
     }
diff --git a/drivers/staging/ath6kl/os/linux/wireless_ext.c b/drivers/staging/ath6kl/os/linux/wireless_ext.c
index 8262fde..824f1be 100644
--- a/drivers/staging/ath6kl/os/linux/wireless_ext.c
+++ b/drivers/staging/ath6kl/os/linux/wireless_ext.c
@@ -504,7 +504,7 @@ ar6000_ioctl_siwessid(struct net_device *dev,
 
     if (ar->arNextMode == AP_NETWORK) {
         /* SSID change for AP network - Will take effect on commit */
-        if(A_MEMCMP(ar->arSsid,ssid,32) != 0) {
+        if(memcmp(ar->arSsid,ssid,32) != 0) {
              ar->arSsidLen = data->length - 1;
             memcpy(ar->arSsid, ssid, ar->arSsidLen);
             ar->ap_profile_flag = 1; /* There is a change in profile */
@@ -581,7 +581,7 @@ ar6000_ioctl_siwessid(struct net_device *dev,
         (!data->flags)))
     {
         if ((!data->flags) ||
-            (A_MEMCMP(ar->arSsid, ssid, ar->arSsidLen) != 0) ||
+            (memcmp(ar->arSsid, ssid, ar->arSsidLen) != 0) ||
             (ar->arSsidLen != (data->length - 1)))
         {
             /*
@@ -1618,7 +1618,7 @@ static int ar6000_set_wapi_key(struct net_device *dev,
     keyLen = erq->length - sizeof(struct iw_encode_ext);
     memcpy(wapiKeyRsc, ext->tx_seq, sizeof(wapiKeyRsc));
 
-    if (A_MEMCMP(ext->addr.sa_data, broadcastMac, sizeof(broadcastMac)) == 0) {
+    if (memcmp(ext->addr.sa_data, broadcastMac, sizeof(broadcastMac)) == 0) {
         keyUsage |= GROUP_USAGE;
         PN = (u32 *)wapiKeyRsc;
         for (i = 0; i < 4; i++) {
@@ -2315,7 +2315,7 @@ ar6000_ioctl_siwap(struct net_device *dev,
         return -EIO;
     }
 
-    if (A_MEMCMP(&ap_addr->sa_data, bcast_mac, AR6000_ETH_ADDR_LEN) == 0) {
+    if (memcmp(&ap_addr->sa_data, bcast_mac, AR6000_ETH_ADDR_LEN) == 0) {
         A_MEMZERO(ar->arReqBssid, sizeof(ar->arReqBssid));
     } else {
         memcpy(ar->arReqBssid, &ap_addr->sa_data,  sizeof(ar->arReqBssid));
diff --git a/drivers/staging/ath6kl/wlan/include/ieee80211.h b/drivers/staging/ath6kl/wlan/include/ieee80211.h
index dfad19a..532ab0e 100644
--- a/drivers/staging/ath6kl/wlan/include/ieee80211.h
+++ b/drivers/staging/ath6kl/wlan/include/ieee80211.h
@@ -68,7 +68,7 @@
 
 
 #define IEEE80211_ADDR_EQ(addr1, addr2)     \
-    (A_MEMCMP(addr1, addr2, IEEE80211_ADDR_LEN) == 0)
+    (memcmp(addr1, addr2, IEEE80211_ADDR_LEN) == 0)
 
 #define IEEE80211_ADDR_COPY(dst,src)    memcpy(dst,src,IEEE80211_ADDR_LEN)
 
diff --git a/drivers/staging/ath6kl/wlan/src/wlan_node.c b/drivers/staging/ath6kl/wlan/src/wlan_node.c
index c99a330..0edf9c1 100644
--- a/drivers/staging/ath6kl/wlan/src/wlan_node.c
+++ b/drivers/staging/ath6kl/wlan/src/wlan_node.c
@@ -334,7 +334,7 @@ wlan_refresh_inactive_nodes (struct ieee80211_node_table *nt)
     while (bss != NULL)
     {
         nextBss = bss->ni_list_next;
-        if (A_MEMCMP(myBssid, bss->ni_macaddr, sizeof(myBssid)) != 0)
+        if (memcmp(myBssid, bss->ni_macaddr, sizeof(myBssid)) != 0)
         {
                /*
                 * free up all but the current bss - if set
@@ -357,7 +357,7 @@ wlan_refresh_inactive_nodes (struct ieee80211_node_table *nt)
     while (bss != NULL)
     {
         nextBss = bss->ni_list_next;
-        if (A_MEMCMP(myBssid, bss->ni_macaddr, sizeof(myBssid)) != 0)
+        if (memcmp(myBssid, bss->ni_macaddr, sizeof(myBssid)) != 0)
         {
 
             if (((now - bss->ni_tstamp) > timeoutValue)  || --bss->ni_actcnt == 0)
@@ -391,7 +391,7 @@ wlan_node_timeout (A_ATH_TIMER arg)
     while (bss != NULL)
     {
         nextBss = bss->ni_list_next;
-        if (A_MEMCMP(myBssid, bss->ni_macaddr, sizeof(myBssid)) != 0)
+        if (memcmp(myBssid, bss->ni_macaddr, sizeof(myBssid)) != 0)
         {
 
             if ((now - bss->ni_tstamp) > timeoutValue)
@@ -539,7 +539,7 @@ wlan_node_remove(struct ieee80211_node_table *nt, u8 *bssid)
     {
         nextBss = bss->ni_list_next;
 
-        if (A_MEMCMP(bssid, bss->ni_macaddr, 6) == 0)
+        if (memcmp(bssid, bss->ni_macaddr, 6) == 0)
         {
             wlan_node_remove_core (nt, bss);
             IEEE80211_NODE_UNLOCK(nt);
-- 
1.7.4.15.g7811d

