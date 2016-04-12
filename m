Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bes.se.axis.com ([195.60.68.10]:48322 "EHLO bes.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbcDMMmu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2016 08:42:50 -0400
From: per.forlin@gmail.com
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, Per Forlin <per.forlin@gmail.com>
Subject: [PATCH v3] brcmfmac: Decrease 8021x_cnt for dropped packets
Date: Tue, 12 Apr 2016 21:17:00 +0200
Message-Id: <1460488620-44991-1-git-send-email-per.forlin@gmail.com> (sfid-20160413_144253_991314_1755346B)
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

Overloading a WLAN interface is not an unlikely scenario.
In case of packet overload the error print "out of bus->txq"
is very verbose. To reduce SPAM degrade it to a debug print.

Signed-off-by: Per Forlin <per.forlin@gmail.com>
---
Change log:
 v2 - Add variable to know whether the counter is increased or not
 v3 - txfinalize should decrease the counter. Fix skb header offset

drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 5 +++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 67401ca..2c1bc0d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -332,8 +332,9 @@ brcmf_proto_bcdc_txdata(struct brcmf_pub *drvr, int ifidx, u8 offset,
 	int res;
 	brcmf_proto_bcdc_hdrpush(drvr, ifidx, offset, pktbuf);
 	res = brcmf_bus_txdata(drvr->bus_if, pktbuf);
-	if (res < 0)
-		brcmf_proto_bcdc_hdrpull(drvr, ifidx, offset, pktbuf);
+	if (res < 0) {
+		brcmf_proto_bcdc_hdrpull(drvr, false, &ifidx, pktbuf);
+	}
 	return res;
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

