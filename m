Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:36704 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752668AbdKHNgr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 08:36:47 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 2/7] brcmfmac: disable packet filtering in promiscuous mode
Date: Wed,  8 Nov 2017 14:36:32 +0100
Message-Id: <1510148197-17851-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171108_143701_705190_608BF1FF)
In-Reply-To: <1510148197-17851-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1510148197-17851-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

Disable arp and nd offload to allow all packets sending to host.

Reported-by: Phil Elwell <phil@raspberrypi.org>
Tested-by: Phil Elwell <phil@raspberrypi.org>
Reviewed-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 41 ----------------------
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 38 ++++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  1 +
 3 files changed, 39 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 4bfd43a..051d51d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -472,47 +472,6 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 	return err;
 }
 
-static s32
-brcmf_configure_arp_nd_offload(struct brcmf_if *ifp, bool enable)
-{
-	s32 err;
-	u32 mode;
-
-	if (enable)
-		mode = BRCMF_ARP_OL_AGENT | BRCMF_ARP_OL_PEER_AUTO_REPLY;
-	else
-		mode = 0;
-
-	/* Try to set and enable ARP offload feature, this may fail, then it  */
-	/* is simply not supported and err 0 will be returned                 */
-	err = brcmf_fil_iovar_int_set(ifp, "arp_ol", mode);
-	if (err) {
-		brcmf_dbg(TRACE, "failed to set ARP offload mode to 0x%x, err = %d\n",
-			  mode, err);
-		err = 0;
-	} else {
-		err = brcmf_fil_iovar_int_set(ifp, "arpoe", enable);
-		if (err) {
-			brcmf_dbg(TRACE, "failed to configure (%d) ARP offload err = %d\n",
-				  enable, err);
-			err = 0;
-		} else
-			brcmf_dbg(TRACE, "successfully configured (%d) ARP offload to 0x%x\n",
-				  enable, mode);
-	}
-
-	err = brcmf_fil_iovar_int_set(ifp, "ndoe", enable);
-	if (err) {
-		brcmf_dbg(TRACE, "failed to configure (%d) ND offload err = %d\n",
-			  enable, err);
-		err = 0;
-	} else
-		brcmf_dbg(TRACE, "successfully configured (%d) ND offload to 0x%x\n",
-			  enable, mode);
-
-	return err;
-}
-
 static void
 brcmf_cfg80211_update_proto_addr_mode(struct wireless_dev *wdev)
 {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 5cc3a07..9c7536d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -71,6 +71,43 @@ struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx)
 	return ifp;
 }
 
+void brcmf_configure_arp_nd_offload(struct brcmf_if *ifp, bool enable)
+{
+	s32 err;
+	u32 mode;
+
+	if (enable)
+		mode = BRCMF_ARP_OL_AGENT | BRCMF_ARP_OL_PEER_AUTO_REPLY;
+	else
+		mode = 0;
+
+	/* Try to set and enable ARP offload feature, this may fail, then it  */
+	/* is simply not supported and err 0 will be returned                 */
+	err = brcmf_fil_iovar_int_set(ifp, "arp_ol", mode);
+	if (err) {
+		brcmf_dbg(TRACE, "failed to set ARP offload mode to 0x%x, err = %d\n",
+			  mode, err);
+	} else {
+		err = brcmf_fil_iovar_int_set(ifp, "arpoe", enable);
+		if (err) {
+			brcmf_dbg(TRACE, "failed to configure (%d) ARP offload err = %d\n",
+				  enable, err);
+		} else {
+			brcmf_dbg(TRACE, "successfully configured (%d) ARP offload to 0x%x\n",
+				  enable, mode);
+		}
+	}
+
+	err = brcmf_fil_iovar_int_set(ifp, "ndoe", enable);
+	if (err) {
+		brcmf_dbg(TRACE, "failed to configure (%d) ND offload err = %d\n",
+			  enable, err);
+	} else {
+		brcmf_dbg(TRACE, "successfully configured (%d) ND offload to 0x%x\n",
+			  enable, mode);
+	}
+}
+
 static void _brcmf_set_multicast_list(struct work_struct *work)
 {
 	struct brcmf_if *ifp;
@@ -134,6 +171,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	if (err < 0)
 		brcmf_err("Setting BRCMF_C_SET_PROMISC failed, %d\n",
 			  err);
+	brcmf_configure_arp_nd_offload(ifp, !cmd_value);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index a4dd313..1708571 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -203,6 +203,7 @@ struct brcmf_if {
 /* Return pointer to interface name */
 char *brcmf_ifname(struct brcmf_if *ifp);
 struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx);
+void brcmf_configure_arp_nd_offload(struct brcmf_if *ifp, bool enable);
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 			      bool is_p2pdev, const char *name, u8 *mac_addr);
-- 
1.9.1
