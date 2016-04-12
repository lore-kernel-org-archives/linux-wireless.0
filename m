Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35663 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965592AbcDLUtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 16:49:12 -0400
Received: by mail-lf0-f68.google.com with SMTP id o124so4354183lfb.2
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2016 13:49:11 -0700 (PDT)
From: per.forlin@gmail.com
To: linux-wireless@vger.kernel.org
Cc: arend@broadcom.com, Per Forlin <per.forlin@gmail.com>
Subject: [PATCH v3] brcmfmac: Decrease 8021x_cnt for dropped packets
Date: Tue, 12 Apr 2016 22:48:38 +0200
Message-Id: <1460494118-2764-1-git-send-email-per.forlin@gmail.com> (sfid-20160412_225006_216935_58FF44C4)
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

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c | 6 +++++-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 6af658e..508b287 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -329,8 +329,12 @@ static int
 brcmf_proto_bcdc_txdata(struct brcmf_pub *drvr, int ifidx, u8 offset,
 			struct sk_buff *pktbuf)
 {
+	int res;
 	brcmf_proto_bcdc_hdrpush(drvr, ifidx, offset, pktbuf);
-	return brcmf_bus_txdata(drvr->bus_if, pktbuf);
+	res = brcmf_bus_txdata(drvr->bus_if, pktbuf);
+	if (res < 0)
+		brcmf_proto_bcdc_hdrpull(drvr, false, &ifidx, pktbuf);
+	return res;
 }
 
 static void
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

