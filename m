Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:32861 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbcC3VFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 17:05:07 -0400
Received: by mail-lb0-f172.google.com with SMTP id u8so39940508lbk.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Mar 2016 14:05:07 -0700 (PDT)
From: per.forlin@gmail.com
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, zajec5@gmail.com,
	Per Forlin <per.forlin@gmail.com>
Subject: [PATCH] brcmfmac: Don't increase 8021x_cnt for dropped packets
Date: Wed, 30 Mar 2016 23:04:33 +0200
Message-Id: <1459371873-3939-1-git-send-email-per.forlin@gmail.com> (sfid-20160330_230513_600738_A465508D)
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
This patch seems to work for my use case but I need to run some more
tests to know for sure.

drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index ed9998b..8b1e30c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -241,7 +241,8 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 done:
 	if (ret) {
 		ifp->stats.tx_dropped++;
+		if (eh->h_proto == htons(ETH_P_PAE))
+			atomic_dec(&ifp->pend_8021x_cnt);
 	} else {
 		ifp->stats.tx_packets++;
 		ifp->stats.tx_bytes += skb->len;
-- 
2.1.4

