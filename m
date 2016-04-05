Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:35896 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbcDEUCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 16:02:17 -0400
Received: by mail-lf0-f65.google.com with SMTP id p81so2378403lfb.3
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 13:02:16 -0700 (PDT)
From: per.forlin@gmail.com
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, brudley@broadcom.com, frankyl@broadcom.com,
	meuleman@broadcom.com, Per Forlin <per.forlin@gmail.com>
Subject: [PATCH v2] brcmfmac: Don't increase 8021x_cnt for dropped packets
Date: Tue,  5 Apr 2016 22:01:47 +0200
Message-Id: <1459886507-26249-1-git-send-email-per.forlin@gmail.com> (sfid-20160405_220221_233417_F0D2E065)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Per Forlin <per.forlin@gmail.com>

The pend_8021x_cnt gets into a state where it's not being decreased.
When the brcmf_netdev_wait_pend8021x is called it will timeout
because there are no pending packets to be consumed. There is no
easy way of getting out of this state once it has happened.
Preventing the counter from being increased in case of dropped
packets seem like a reasonable solution.

Log showing overflow txq and increased cnt:

// Extra debug prints
brcmfmac: [brcmf_netdev_wait_pend8021x] pend_8021x_cnt == 0
brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 1
brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 2

brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!
brcmfmac: brcmf_sdio_bus_txdata: out of bus->txq !!!

// Extra debug prints
brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 3
brcmfmac: [brcmf_netdev_start_xmit] pend_8021x_cnt == 4
brcmfmac: [brcmf_netdev_wait_pend8021x] pend_8021x_cnt == 4

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

Signed-off-by: Per Forlin <per.forlin@gmail.com>
---
I came across this bug in an older kernel but it seems relevant
for the latest kernel as well. I'm not familiar with the code
but I can reproduce the issue and verify a fix for it.
With this patch I no longer get stuck with a pend8021_cnt > 0.

Change log:
 v2 - Add variable to know whether the counter is increased or not

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ed9998b..de80ad8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -196,6 +196,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct ethhdr *eh = (struct ethhdr *)(skb->data);
+	bool pend_8021x_cnt_increased = false;
 
 	brcmf_dbg(DATA, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
 
@@ -233,14 +234,18 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	if (eh->h_proto == htons(ETH_P_PAE))
+	if (eh->h_proto == htons(ETH_P_PAE)) {
 		atomic_inc(&ifp->pend_8021x_cnt);
+		pend_8021x_cnt_increased = true;
+	}
 
 	ret = brcmf_fws_process_skb(ifp, skb);
 
 done:
 	if (ret) {
 		ifp->stats.tx_dropped++;
+		if (pend_8021x_cnt_increased)
+			atomic_dec(&ifp->pend_8021x_cnt);
 	} else {
 		ifp->stats.tx_packets++;
 		ifp->stats.tx_bytes += skb->len;
-- 
2.1.4

