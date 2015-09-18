Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:18360 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbbIRUI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 15/16] brcmfmac: Fix TDLS setup by properly handling p2p noif.
Date: Fri, 18 Sep 2015 22:08:18 +0200
Message-ID: <1442606899-31872-16-git-send-email-arend@broadcom.com> (sfid-20150918_220843_286997_0740767A)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

There is a workaround needed for p2p device setup which breaks tdls
functionality. This patch fixes that by properly signalling fweh that
p2p device setup is ongoing.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c | 17 +++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h |  3 +++
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c  |  8 +++++++-
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index dc34d3a..81542e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -188,11 +188,13 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 
 	/* The P2P Device interface event must not be ignored contrary to what
 	 * firmware tells us. Older firmware uses p2p noif, with sta role.
-	 * This should be accepted.
+	 * This should be accepted when p2pdev_setup is ongoing. TDLS setup will
+	 * use the same ifevent and should be ignored.
 	 */
 	is_p2pdev = ((ifevent->flags & BRCMF_E_IF_FLAG_NOIF) &&
 		     (ifevent->role == BRCMF_E_IF_ROLE_P2P_CLIENT ||
-		      ifevent->role == BRCMF_E_IF_ROLE_STA));
+		      ((ifevent->role == BRCMF_E_IF_ROLE_STA) &&
+		       (drvr->fweh.p2pdev_setup_ongoing))));
 	if (!is_p2pdev && (ifevent->flags & BRCMF_E_IF_FLAG_NOIF)) {
 		brcmf_dbg(EVENT, "event can be ignored\n");
 		return;
@@ -316,6 +318,17 @@ event_free:
 }
 
 /**
+ * brcmf_fweh_p2pdev_setup() - P2P device setup ongoing (or not).
+ *
+ * @ifp: ifp on which setup is taking place or finished.
+ * @ongoing: p2p device setup in progress (or not).
+ */
+void brcmf_fweh_p2pdev_setup(struct brcmf_if *ifp, bool ongoing)
+{
+	ifp->drvr->fweh.p2pdev_setup_ongoing = ongoing;
+}
+
+/**
  * brcmf_fweh_attach() - initialize firmware event handling.
  *
  * @drvr: driver information object.
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index 1326898..d9a9428 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -230,12 +230,14 @@ typedef int (*brcmf_fweh_handler_t)(struct brcmf_if *ifp,
 /**
  * struct brcmf_fweh_info - firmware event handling information.
  *
+ * @p2pdev_setup_ongoing: P2P device creation in progress.
  * @event_work: event worker.
  * @evt_q_lock: lock for event queue protection.
  * @event_q: event queue.
  * @evt_handler: registered event handlers.
  */
 struct brcmf_fweh_info {
+	bool p2pdev_setup_ongoing;
 	struct work_struct event_work;
 	spinlock_t evt_q_lock;
 	struct list_head event_q;
@@ -255,6 +257,7 @@ void brcmf_fweh_unregister(struct brcmf_pub *drvr,
 int brcmf_fweh_activate_events(struct brcmf_if *ifp);
 void brcmf_fweh_process_event(struct brcmf_pub *drvr,
 			      struct brcmf_event *event_packet);
+void brcmf_fweh_p2pdev_setup(struct brcmf_if *ifp, bool ongoing);
 
 static inline void brcmf_fweh_process_skb(struct brcmf_pub *drvr,
 					  struct sk_buff *skb)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index fda726c..37a8c352 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -2084,11 +2084,13 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
 
 	brcmf_cfg80211_arm_vif_event(p2p->cfg, p2p_vif);
+	brcmf_fweh_p2pdev_setup(pri_ifp, true);
 
 	/* Initialize P2P Discovery in the firmware */
 	err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
 	if (err < 0) {
 		brcmf_err("set p2p_disc error\n");
+		brcmf_fweh_p2pdev_setup(pri_ifp, false);
 		brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
 		goto fail;
 	}
@@ -2097,6 +2099,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	err = brcmf_cfg80211_wait_vif_event_timeout(p2p->cfg, BRCMF_E_IF_ADD,
 						    msecs_to_jiffies(1500));
 	brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
+	brcmf_fweh_p2pdev_setup(pri_ifp, false);
 	if (!err) {
 		brcmf_err("timeout occurred\n");
 		err = -EIO;
@@ -2396,6 +2399,8 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced)
 		memcpy(p2p_ifp->mac_addr, p2p->dev_addr, ETH_ALEN);
 		brcmf_p2p_set_firmware(pri_ifp, p2p->dev_addr);
 
+		brcmf_fweh_p2pdev_setup(pri_ifp, true);
+
 		/* Initialize P2P Discovery in the firmware */
 		err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
 		if (err < 0) {
@@ -2422,8 +2427,9 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced)
 		INIT_WORK(&p2p->afx_hdl.afx_work, brcmf_p2p_afx_handler);
 		init_completion(&p2p->afx_hdl.act_frm_scan);
 		init_completion(&p2p->wait_next_af);
-	}
 exit:
+		brcmf_fweh_p2pdev_setup(pri_ifp, false);
+	}
 	return err;
 }
 
-- 
1.9.1

