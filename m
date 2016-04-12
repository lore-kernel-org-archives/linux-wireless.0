Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35086 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061AbcDLV4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 17:56:25 -0400
Received: by mail-lf0-f65.google.com with SMTP id o124so4561441lfb.2
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2016 14:56:24 -0700 (PDT)
From: per.forlin@gmail.com
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, Per Forlin <per.forlin@gmail.com>
Subject: [PATCH v4] brcmfmac: Decrease 8021x_cnt for dropped packets
Date: Tue, 12 Apr 2016 23:55:40 +0200
Message-Id: <1460498140-18874-1-git-send-email-per.forlin@gmail.com> (sfid-20160412_235629_630486_43C051E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Per Forlin <per.forlin@gmail.com>

This patch resolves an issue where pend_8021x_cnt was not decreased
on txfinalize. This caused brcmf_netdev_wait_pend8021x to timeout
because the counter indicated pending packets.

WARNING: at .../brcmfmac/core.c:1289 brcmf_netdev_wait_pend8021x
  (warn_slowpath_common)
  (warn_slowpath_null)
  (brcmf_netdev_wait_pend8021x [brcmfmac])
  (send_key_to_dongle [brcmfmac])
  (brcmf_cfg80211_del_key [brcmfmac])
  (nl80211_del_key [cfg80211])
  (genl_rcv_msg)
  (netlink_rcv_skb)
  (genl_rcv)
  (netlink_unicast)
  (netlink_sendmsg)
  (sock_sendmsg)
  (___sys_sendmsg)
  (__sys_sendmsg)
  (SyS_sendmsg)

The solution is to pull back the header offset in case
of an error in txdata(), which may happen in case of
packet overload in brcmf_sdio_bus_txdata.

Overloading an WLAN interface is not an unlikely scenario.
In case of packet overload the error print "out of bus->txq"
is very verbose. To reduce SPAM degrade it to a debug print.

Signed-off-by: Per Forlin <per.forlin@gmail.com>
---
Change log:
 v2 - Add variable to know whether the counter is increased or not
 v3 - txfinalize should decrease the counter. Adjust skb header offset
 v4 - Fix build error

drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c     | 4 ++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 4 +++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c     | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ed9998b..f342f7c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -541,6 +541,9 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 	struct ethhdr *eh;
 	u16 type;
 
+	if (!ifp)
+		goto free;
+
 	eh = (struct ethhdr *)(txp->data);
 	type = ntohs(eh->h_proto);
 
@@ -553,6 +556,7 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 	if (!success)
 		ifp->stats.tx_errors++;
 
+free:
 	brcmu_pkt_buf_free_skb(txp);
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index f82c9ab..98cb83f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1899,8 +1899,10 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	if (fws->avoid_queueing) {
 		rc = brcmf_proto_txdata(drvr, ifp->ifidx, 0, skb);
-		if (rc < 0)
+		if (rc < 0) {
+			(void)brcmf_proto_hdrpull(drvr, false, skb, &ifp);
 			brcmf_txfinalize(ifp, skb, false);
+		}
 		return rc;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index a14d9d9d..485e2ad 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2721,7 +2721,7 @@ static int brcmf_sdio_bus_txdata(struct device *dev, struct sk_buff *pkt)
 	*(u16 *)(pkt->cb) = 0;
 	if (!brcmf_sdio_prec_enq(&bus->txq, pkt, prec)) {
 		skb_pull(pkt, bus->tx_hdrlen);
-		brcmf_err("out of bus->txq !!!\n");
+		brcmf_dbg(INFO, "out of bus->txq !!!\n");
 		ret = -ENOSR;
 	} else {
 		ret = 0;
-- 
2.1.4

