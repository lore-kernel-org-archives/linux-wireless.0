Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58966 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab2BBKSp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 05:18:45 -0500
Received: by wgbgn7 with SMTP id gn7so7100708wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 02:18:43 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/3] wl12xx: configure arp filtering only after association
Date: Thu,  2 Feb 2012 12:22:11 +0200
Message-Id: <1328178131-28938-4-git-send-email-eliad@wizery.com> (sfid-20120202_111848_989980_FCEADBA6)
In-Reply-To: <1328178131-28938-1-git-send-email-eliad@wizery.com>
References: <1328178131-28938-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have to configure arp filtering only after the role was
started, so move the BSS_CHANGED_ARP_FILTER handling after
the join.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   69 ++++++++++++++++++-----------------
 1 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a50c116..01ab633 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3814,40 +3814,6 @@ sta_not_found:
 	if (ret < 0)
 		goto out;
 
-	if ((changed & BSS_CHANGED_ARP_FILTER) ||
-	    (!is_ibss && (changed & BSS_CHANGED_QOS))) {
-		__be32 addr = bss_conf->arp_addr_list[0];
-		wlvif->sta.qos = bss_conf->qos;
-		WARN_ON(wlvif->bss_type != BSS_TYPE_STA_BSS);
-
-		if (bss_conf->arp_addr_cnt == 1 &&
-		    bss_conf->arp_filter_enabled) {
-			wlvif->ip_addr = addr;
-			/*
-			 * The template should have been configured only upon
-			 * association. however, it seems that the correct ip
-			 * isn't being set (when sending), so we have to
-			 * reconfigure the template upon every ip change.
-			 */
-			ret = wl1271_cmd_build_arp_rsp(wl, wlvif);
-			if (ret < 0) {
-				wl1271_warning("build arp rsp failed: %d", ret);
-				goto out;
-			}
-
-			ret = wl1271_acx_arp_ip_filter(wl, wlvif,
-				(ACX_ARP_FILTER_ARP_FILTERING |
-				 ACX_ARP_FILTER_AUTO_ARP),
-				addr);
-		} else {
-			wlvif->ip_addr = 0;
-			ret = wl1271_acx_arp_ip_filter(wl, wlvif, 0, addr);
-		}
-
-		if (ret < 0)
-			goto out;
-	}
-
 	if (do_join) {
 		ret = wl1271_join(wl, wlvif, set_assoc);
 		if (ret < 0) {
@@ -3914,6 +3880,41 @@ sta_not_found:
 		}
 	}
 
+	/* Handle arp filtering. Done after join. */
+	if ((changed & BSS_CHANGED_ARP_FILTER) ||
+	    (!is_ibss && (changed & BSS_CHANGED_QOS))) {
+		__be32 addr = bss_conf->arp_addr_list[0];
+		wlvif->sta.qos = bss_conf->qos;
+		WARN_ON(wlvif->bss_type != BSS_TYPE_STA_BSS);
+
+		if (bss_conf->arp_addr_cnt == 1 &&
+		    bss_conf->arp_filter_enabled) {
+			wlvif->ip_addr = addr;
+			/*
+			 * The template should have been configured only upon
+			 * association. however, it seems that the correct ip
+			 * isn't being set (when sending), so we have to
+			 * reconfigure the template upon every ip change.
+			 */
+			ret = wl1271_cmd_build_arp_rsp(wl, wlvif);
+			if (ret < 0) {
+				wl1271_warning("build arp rsp failed: %d", ret);
+				goto out;
+			}
+
+			ret = wl1271_acx_arp_ip_filter(wl, wlvif,
+				(ACX_ARP_FILTER_ARP_FILTERING |
+				 ACX_ARP_FILTER_AUTO_ARP),
+				addr);
+		} else {
+			wlvif->ip_addr = 0;
+			ret = wl1271_acx_arp_ip_filter(wl, wlvif, 0, addr);
+		}
+
+		if (ret < 0)
+			goto out;
+	}
+
 out:
 	return;
 }
-- 
1.7.6.401.g6a319

