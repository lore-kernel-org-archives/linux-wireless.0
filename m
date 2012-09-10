Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3842 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab2IJNXX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 09:23:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/10] brcmfmac: Add extra data support to firmware
 event queueing.
Date: Mon, 10 Sep 2012 15:16:50 +0200
Message-ID: <1347283018-24223-3-git-send-email-arend@broadcom.com> (sfid-20120910_152326_777304_E9AAAEF7)
In-Reply-To: <1347283018-24223-1-git-send-email-arend@broadcom.com>
References: <1347283018-24223-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Firmware events can contain extra data. This patch adds support to
copy this data when it exists.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    2 ++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 37f5708..9e2fb5b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -140,6 +140,8 @@ struct brcmf_event_msg {
 	__be32 datalen;
 	u8 addr[ETH_ALEN];
 	char ifname[IFNAMSIZ];
+	u8 ifidx;
+	u8 bsscfgidx;
 } __packed;
 
 struct brcm_ethhdr {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index a6b382b..6383052 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3321,18 +3321,28 @@ static struct brcmf_cfg80211_event_q *brcmf_deq_event(
 
 static s32
 brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
-		const struct brcmf_event_msg *msg)
+		const struct brcmf_event_msg *msg, void *data)
 {
 	struct brcmf_cfg80211_event_q *e;
 	s32 err = 0;
 	ulong flags;
+	u32 data_len;
+	u32 total_len;
 
-	e = kzalloc(sizeof(struct brcmf_cfg80211_event_q), GFP_ATOMIC);
+	total_len = sizeof(struct brcmf_cfg80211_event_q);
+	if (data)
+		data_len += be32_to_cpu(msg->datalen);
+	else
+		data_len = 0;
+	total_len += data_len;
+	e = kzalloc(total_len, GFP_ATOMIC);
 	if (!e)
 		return -ENOMEM;
 
 	e->etype = event;
 	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
+	if (data)
+		memcpy(&e->edata, data, data_len);
 
 	spin_lock_irqsave(&cfg_priv->evt_q_lock, flags);
 	list_add_tail(&e->evt_q_list, &cfg_priv->evt_q_list);
@@ -3501,7 +3511,7 @@ brcmf_cfg80211_event(struct net_device *ndev,
 	u32 event_type = be32_to_cpu(e->event_type);
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 
-	if (!brcmf_enq_event(cfg_priv, event_type, e))
+	if (!brcmf_enq_event(cfg_priv, event_type, e, data))
 		schedule_work(&cfg_priv->event_work);
 }
 
-- 
1.7.9.5


