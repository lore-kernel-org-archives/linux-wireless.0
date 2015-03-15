Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64722 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbbCOOAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2015 10:00:55 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 4/7] wil6210: Prefer ether_addr_copy() over memcpy()
Date: Sun, 15 Mar 2015 16:00:21 +0200
Message-Id: <1426428024-4538-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150315_150103_640362_788C49B4)
In-Reply-To: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1426428024-4538-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix checkpatch warning:
WARNING: Prefer ether_addr_copy() over memcpy() if the
Ethernet addresses are __aligned(2)

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  7 ++++---
 drivers/net/wireless/ath/wil6210/wmi.c      | 11 ++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 5db6a6d..c9f362c 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/etherdevice.h>
 #include "wil6210.h"
 #include "wmi.h"
 
@@ -217,7 +218,7 @@ static int wil_cfg80211_dump_station(struct wiphy *wiphy,
 	if (cid < 0)
 		return -ENOENT;
 
-	memcpy(mac, wil->sta[cid].addr, ETH_ALEN);
+	ether_addr_copy(mac, wil->sta[cid].addr);
 	wil_dbg_misc(wil, "%s(%pM) CID %d\n", __func__, mac, cid);
 
 	rc = wil_cid_fill_sinfo(wil, cid, sinfo);
@@ -478,8 +479,8 @@ static int wil_cfg80211_connect(struct wiphy *wiphy,
 	}
 	conn.channel = ch - 1;
 
-	memcpy(conn.bssid, bss->bssid, ETH_ALEN);
-	memcpy(conn.dst_mac, bss->bssid, ETH_ALEN);
+	ether_addr_copy(conn.bssid, bss->bssid);
+	ether_addr_copy(conn.dst_mac, bss->bssid);
 
 	set_bit(wil_status_fwconnecting, wil->status);
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 8c18a46..9fe2085 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -466,7 +466,7 @@ static void wmi_evt_connect(struct wil6210_priv *wil, int id, void *d, int len)
 
 	/* FIXME FW can transmit only ucast frames to peer */
 	/* FIXME real ring_id instead of hard coded 0 */
-	memcpy(wil->sta[evt->cid].addr, evt->bssid, ETH_ALEN);
+	ether_addr_copy(wil->sta[evt->cid].addr, evt->bssid);
 	wil->sta[evt->cid].status = wil_sta_conn_pending;
 
 	wil->pending_connect_cid = evt->cid;
@@ -524,8 +524,8 @@ static void wmi_evt_eapol_rx(struct wil6210_priv *wil, int id,
 	}
 
 	eth = (struct ethhdr *)skb_put(skb, ETH_HLEN);
-	memcpy(eth->h_dest, ndev->dev_addr, ETH_ALEN);
-	memcpy(eth->h_source, evt->src_mac, ETH_ALEN);
+	ether_addr_copy(eth->h_dest, ndev->dev_addr);
+	ether_addr_copy(eth->h_source, evt->src_mac);
 	eth->h_proto = cpu_to_be16(ETH_P_PAE);
 	memcpy(skb_put(skb, eapol_len), evt->eapol, eapol_len);
 	skb->protocol = eth_type_trans(skb, ndev);
@@ -851,7 +851,7 @@ int wmi_set_mac_address(struct wil6210_priv *wil, void *addr)
 {
 	struct wmi_set_mac_address_cmd cmd;
 
-	memcpy(cmd.mac, addr, ETH_ALEN);
+	ether_addr_copy(cmd.mac, addr);
 
 	wil_dbg_wmi(wil, "Set MAC %pM\n", addr);
 
@@ -1162,7 +1162,8 @@ int wmi_disconnect_sta(struct wil6210_priv *wil, const u8 *mac, u16 reason)
 	struct wmi_disconnect_sta_cmd cmd = {
 		.disconnect_reason = cpu_to_le16(reason),
 	};
-	memcpy(cmd.dst_mac, mac, ETH_ALEN);
+
+	ether_addr_copy(cmd.dst_mac, mac);
 
 	wil_dbg_wmi(wil, "%s(%pM, reason %d)\n", __func__, mac, reason);
 
-- 
2.1.0

