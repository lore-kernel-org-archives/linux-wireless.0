Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33270 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752595AbcITLRF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 07:17:05 -0400
Received: by mail-lf0-f66.google.com with SMTP id l131so761226lfl.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 04:17:03 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: brcmf_txfinalize misses 802.1x packet leading to infinite WARNINGs
Date: Tue, 20 Sep 2016 13:16:04 +0200
Message-Id: <20160920111604.32716-1-zajec5@gmail.com> (sfid-20160920_131710_831379_C07BC609)
In-Reply-To: <b4df2418354fdf7eb585a898bf12b19f@mail.gmail.com>
References: <b4df2418354fdf7eb585a898bf12b19f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hante,

I hit this problem again and I'm afraid it's getting even more complex. Last
time you were suspecting flowring deletion but it didn't make much sense to me.
It was because I didn't see brcmf_flowring_delete anywhere in my log.

Well, today it was different. I saw brcmf_flowring_delete which makes me wonder
if there is more than 1 source of this problem.

Good news is that today I got few extra debugging messages. Bad news is I was
experimenting with MAX_WAIT_FOR_8021X_TX. I added brcmf_netdev_wait_pend8021x to
the brcmf_cfg80211_get_station and I was running
while [ 1 ]; do iw dev wlan1-1 station get 88:53:2e:50:50:00 > /dev/null; done

I hope this log may be a bit helpful anyway.

So this time brcmf_flowring_delete was called indeed and I think there was a
race in brcmfmac code. It seems brcmu_pkt_buf_free_skb was called twice for the
same skb!

For the first time it was called from brcmf_flowring_delete. We called
dev_kfree_skb_any for that skb which means we shouldn't access it anymore.

For the second time it (brcmu_pkt_buf_free_skb) was call from brcmf_txfinalize.
Unfortunately when brcmf_txfinalize was analyzing that skb (that was already
freed and invalid) it didn't contain ETH_P_PAE in the ethhdr anymore so
atomic_dec(&ifp->pend_8021x_cnt);
wasn't called.

So my guess is that:
1) We should fix brcmf_flowring_delete to use brcmf_txfinalize
2) We should avoid freeing the same skb twice

[  167.596719] brcmfmac: [brcmf_cfg80211_del_key -> __send_key_to_dongle] ifp:c64c6480 brcmf_ifname(ifp):wlan1-1
[  167.611257] brcmfmac: CONSOLE: 026896.770 wl0: Proxy STA 78:d6:f0:9b:ba:bc link is already gone !!??
[  167.623375] brcmfmac: [brcmf_flowring_delete -> __brcmu_pkt_buf_free_skb] [ifp:  (null)] Freeing skb:c7240240 skb->dev:c64c6000 skb->dev->name:wlan1-1
[  167.640721] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c64c6480] ***BUG*** skb:c7240240 skb->dev:c64c6000 skb->dev->name:wlan1-1
[  167.654247] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c64c6480] Original data: 78 d6 f0 9b ba bc  92 8d 78 66 3a 57  88 8e
[  167.658643] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  167.680249] brcmfmac: [__brcmf_txfinalize -> __brcmu_pkt_buf_free_skb] [ifp:c64c6480]  Current data: 88 53 2e 50 50 00  ba 87 01 e2 06 f8  08 00
[  167.693239] ------------[ cut here ]------------
[  167.697893] WARNING: CPU: 0 PID: 616 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:73 __brcmu_pkt_buf_free_skb+0x1a0/0x2f8 [brcmfmac]()
[  167.713587] Modules linked in: pppoe ppp_async iptable_nat brcmfmac pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4 ipt_REJECT ipt_MASQUERADE cfg80211 xt_time xt_tcpudp xt_state xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack xt_commed
[  167.785932] CPU: 0 PID: 616 Comm: irq/33-brcmf_pc Not tainted 4.4.21 #0
[  167.792560] Hardware name: BCM5301X
[  167.796050] Backtrace: 
[  167.798525] [<c001708c>] (dump_backtrace) from [<c0017288>] (show_stack+0x18/0x1c)
[  167.806112]  r7:00000049 r6:bf1d1255 r5:60000013 r4:00000000
[  167.811831] [<c0017270>] (show_stack) from [<c017d038>] (dump_stack+0x84/0xa4)
[  167.819069] [<c017cfb4>] (dump_stack) from [<c0021490>] (warn_slowpath_common+0x8c/0xb8)
[  167.827175]  r5:00000009 r4:00000000
[  167.830774] [<c0021404>] (warn_slowpath_common) from [<c0021560>] (warn_slowpath_null+0x24/0x2c)
[  167.839579]  r8:c64c653c r7:bf1c9f39 r6:c64c6480 r5:c7240240 r4:c69571c0
[  167.846357] [<c002153c>] (warn_slowpath_null) from [<bf1bd670>] (__brcmu_pkt_buf_free_skb+0x1a0/0x2f8 [brcmfmac])
[  167.856658] [<bf1bd4d0>] (__brcmu_pkt_buf_free_skb [brcmfmac]) from [<bf1bdfac>] (__brcmf_txfinalize+0x184/0x1b4 [brcmfmac])
[  167.867893]  r8:cacd1720 r7:c723d180 r6:c7240240 r5:00000001 r4:c64c6480
[  167.874665] [<bf1bde28>] (__brcmf_txfinalize [brcmfmac]) from [<bf1c378c>] (brcmf_msgbuf_txdata+0x508/0x6b0 [brcmfmac])
[  167.885466]  r10:c7240240 r9:cacd1720 r8:cacd1720 r7:c723d180 r6:00000003 r5:00000001
[  167.893352]  r4:c6801c00
[  167.895912] [<bf1c33cc>] (brcmf_msgbuf_txdata [brcmfmac]) from [<bf1c3970>] (brcmf_proto_msgbuf_rx_trigger+0x3c/0xd0 [brcmfmac])
[  167.907496]  r10:00000000 r9:c0493882 r8:c68005e4 r7:c0057d98 r6:c78850c0 r5:00010000
[  167.915382]  r4:c6801c00
[  167.917941] [<bf1c3934>] (brcmf_proto_msgbuf_rx_trigger [brcmfmac]) from [<bf1c800c>] (brcmf_pcie_isr_thread+0x1c4/0x238 [brcmfmac])
[  167.929874]  r7:c0057d98 r6:c78850c0 r5:00010000 r4:c6970800
[  167.935587] [<bf1c7e48>] (brcmf_pcie_isr_thread [brcmfmac]) from [<c0057dbc>] (irq_thread_fn+0x24/0x3c)
[  167.945002]  r9:c0493882 r8:c68005e4 r7:c0057d98 r6:c78850c0 r5:c68005c0 r4:c68005c0
[  167.952803] [<c0057d98>] (irq_thread_fn) from [<c00580a0>] (irq_thread+0xf8/0x1e4)
[  167.960381]  r7:c0057d98 r6:c73f6000 r5:c68005c0 r4:c78850c0
[  167.966089] [<c0057fa8>] (irq_thread) from [<c00394c4>] (kthread+0xe0/0xf4)
[  167.973064]  r10:00000000 r9:00000000 r8:00000000 r7:c0057fa8 r6:c68005c0 r5:00000000
[  167.980948]  r4:c6800b80
[  167.983497] [<c00393e4>] (kthread) from [<c00097b8>] (ret_from_fork+0x14/0x3c)
[  167.990732]  r7:00000000 r6:00000000 r5:c00393e4 r4:c6800b80
[  167.996449] ---[ end trace 47c5009c15f68c3e ]---
[  168.001094] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.008509] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:c64c6000 skb->dev->name:wlan1-1
[  168.038638] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.051812] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.059240] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:c64c6000 skb->dev->name:wlan1-1
[  168.079296] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.092313] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.099740] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:c64c6000 skb->dev->name:wlan1-1
[  168.128800] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.141983] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.149416] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:  (null) skb->dev->name:---
[  168.169281] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.182302] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.189732] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:  (null) skb->dev->name:---
[  168.218759] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.231926] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.239354] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:  (null) skb->dev->name:---
[  168.259276] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.272305] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.279732] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:  (null) skb->dev->name:---
[  168.308693] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.321854] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.329292] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:  (null) skb->dev->name:---
[  168.349262] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.362273] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.369708] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:  (null) skb->dev->name:---
[  168.398634] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.411800] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.419232] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:  (null) skb->dev->name:---
[  168.439270] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.452280] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.459704] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:  (null) skb->dev->name:---
[  168.488634] brcmfmac: [brcmf_netdev_wait_pend8021x] ***TIMEOUT WARNING*** ifp:c64c6480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):1
[  168.501817] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
[  168.509246] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c7240240 skb->dev:  (null) skb->dev->name:---
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 104 ++++++++++++++++++++-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  18 +++-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |   2 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |  30 +++++-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  21 +++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   3 +
 .../wireless/broadcom/brcm80211/brcmutil/utils.c   |   2 +-
 .../broadcom/brcm80211/include/brcmu_utils.h       |   2 +-
 9 files changed, 178 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 201a980..47d82f2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -464,11 +464,12 @@ static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 }
 
 static int
-send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
+__send_key_to_dongle(const char *c0, struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 {
 	int err;
 	struct brcmf_wsec_key_le key_le;
 
+	pr_info("[%s -> %s] ifp:%p brcmf_ifname(ifp):%s\n", c0, __func__, ifp, brcmf_ifname(ifp));
 	convert_key_from_CPU(key, &key_le);
 
 	brcmf_netdev_wait_pend8021x(ifp);
@@ -480,6 +481,7 @@ send_key_to_dongle(struct brcmf_if *ifp, struct brcmf_wsec_key *key)
 		brcmf_err("wsec_key error (%d)\n", err);
 	return err;
 }
+#define send_key_to_dongle(ifp, key)	__send_key_to_dongle(__func__, ifp, key)
 
 static s32
 brcmf_configure_arp_nd_offload(struct brcmf_if *ifp, bool enable)
@@ -2610,6 +2612,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	int rssi;
 	u32 i;
 
+	brcmf_netdev_wait_pend8021x(ifp);
+
 	brcmf_dbg(TRACE, "Enter, MAC %pM\n", mac);
 	if (!check_vif_up(ifp->vif))
 		return -EIO;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 8d16f02..346d39a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -38,7 +38,52 @@
 #include "pcie.h"
 #include "common.h"
 
-#define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(950)
+#include <linux/sched.h>
+
+static size_t print_time(u64 ts, char *buf)
+{
+	unsigned long rem_nsec;
+
+	rem_nsec = do_div(ts, 1000000000);
+
+	if (!buf)
+		return snprintf(NULL, 0, "[%5lu.000000]", (unsigned long)ts);
+
+	return sprintf(buf, "[%5lu.%06lu]",
+		       (unsigned long)ts, rem_nsec / 1000);
+}
+
+/* Free the driver packet. Free the tag if present */
+void __brcmu_pkt_buf_free_skb(const char *c0, struct brcmf_if *ifp, struct sk_buff *skb)
+{
+	if (!skb)
+		return;
+
+	if (ifp) {
+		struct pend_skb *e;
+
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+			if (e->skb == skb) {
+				pr_info("[%s -> %s] [ifp:%p] ***BUG*** skb:%p skb->dev:%p skb->dev->name:%s\n", c0, __func__, ifp, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+				pr_info("[%s -> %s] [ifp:%p] Original data: %02x %02x %02x %02x %02x %02x  %02x %02x %02x %02x %02x %02x  %02x %02x\n", c0, __func__, ifp,
+					e->data[0x00], e->data[0x01], e->data[0x02], e->data[0x03], e->data[0x04], e->data[0x05], e->data[0x06], e->data[0x07], e->data[0x08], e->data[0x09], e->data[0x0a], e->data[0x0b], e->data[0x0c], e->data[0x0d]);
+				pr_info("[%s -> %s] [ifp:%p]  Current data: %02x %02x %02x %02x %02x %02x  %02x %02x %02x %02x %02x %02x  %02x %02x\n", c0, __func__, ifp,
+					skb->data[0x00], skb->data[0x01], skb->data[0x02], skb->data[0x03], skb->data[0x04], skb->data[0x05], skb->data[0x06], skb->data[0x07], skb->data[0x08], skb->data[0x09], skb->data[0x0a], skb->data[0x0b], skb->data[0x0c], skb->data[0x0d]);
+				WARN_ON(1);
+				break;
+			}
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	} else if (strcmp(c0, "brcmf_msgbuf_query_dcmd")) {
+		pr_info("[%s -> %s] [ifp:%p] Freeing skb:%p skb->dev:%p skb->dev->name:%s\n", c0, __func__, ifp, skb, skb->dev, skb->dev ? skb->dev->name : "---");
+	}
+
+	WARN_ON(skb->next);
+	dev_kfree_skb_any(skb);
+}
+
+#define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(10)
 
 #define BRCMF_BSSIDX_INVALID			-1
 
@@ -247,8 +292,19 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	if (eh->h_proto == htons(ETH_P_PAE))
+	if (eh->h_proto == htons(ETH_P_PAE)) {
+		struct pend_skb *e;
+
+		e = kzalloc(sizeof(*e), GFP_KERNEL);
+		e->skb = skb;
+		memcpy(e->data, skb->data, 14);
+		e->start_time = local_clock();
+
 		atomic_inc(&ifp->pend_8021x_cnt);
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_add_tail(&e->list, &ifp->pend_8021x_skbs);
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	}
 
 	ret = brcmf_fws_process_skb(ifp, skb);
 
@@ -333,7 +389,7 @@ static int brcmf_rx_hdrpull(struct brcmf_pub *drvr, struct sk_buff *skb,
 	if (ret || !(*ifp) || !(*ifp)->ndev) {
 		if (ret != -ENODATA && *ifp)
 			(*ifp)->stats.rx_errors++;
-		brcmu_pkt_buf_free_skb(skb);
+		__brcmu_pkt_buf_free_skb(__func__, *ifp, skb);
 		return -ENODATA;
 	}
 
@@ -378,7 +434,7 @@ void brcmf_rx_event(struct device *dev, struct sk_buff *skb)
 	brcmu_pkt_buf_free_skb(skb);
 }
 
-void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
+void __brcmf_txfinalize(const char *c0, struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 {
 	struct ethhdr *eh;
 	u16 type;
@@ -387,7 +443,30 @@ void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success)
 	type = ntohs(eh->h_proto);
 
 	if (type == ETH_P_PAE) {
+		struct pend_skb *e, *tmp;
+
 		atomic_dec(&ifp->pend_8021x_cnt);
+		mutex_lock(&ifp->pend_8021x_mutex);
+		list_for_each_entry_safe(e, tmp, &ifp->pend_8021x_skbs, list) {
+			if (e->skb == txp) {
+				if (e->timedout) {
+					char start[32], commit[32];
+
+					print_time(e->start_time, start);
+					print_time(e->commit_time, commit);
+
+					pr_info("[%s -> %s] Finally finalizing skb:%p skb->dev:%p skb->dev->name:%s (start_time:%s; commit_time:%s)\n",
+						c0, __func__,
+						e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---",
+						start, commit);
+				}
+
+				list_del(&e->list);
+				kfree(e);
+				break;
+			}
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
 		if (waitqueue_active(&ifp->pend_8021x_wait))
 			wake_up(&ifp->pend_8021x_wait);
 	}
@@ -476,6 +555,8 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	}
 
 	atomic_set(&ifp->pend_8021x_cnt, 0);
+	INIT_LIST_HEAD(&ifp->pend_8021x_skbs);
+	mutex_init(&ifp->pend_8021x_mutex);
 
 	/* Get current TOE mode from dongle */
 	if (brcmf_fil_iovar_int_get(ifp, "toe_ol", &toe_ol) >= 0
@@ -1169,7 +1250,20 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 				 !brcmf_get_pend_8021x_cnt(ifp),
 				 MAX_WAIT_FOR_8021X_TX);
 
-	WARN_ON(!err);
+	//WARN_ON(!err);
+	if (!err)
+		pr_info("[%s] ***TIMEOUT WARNING*** ifp:%p brcmf_ifname(ifp):%s brcmf_get_pend_8021x_cnt(ifp):%d\n", __func__, ifp, brcmf_ifname(ifp), brcmf_get_pend_8021x_cnt(ifp));
+	if (!list_empty(&ifp->pend_8021x_skbs)) {
+		struct pend_skb *e;
+
+		mutex_lock(&ifp->pend_8021x_mutex);
+		pr_info("[%s] List of pending 802.1x skbs:\n", __func__);
+		list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+			e->timedout = true;
+			pr_info("[%s] skb:%p skb->dev:%p skb->dev->name:%s\n", __func__, e->skb, e->skb->dev, e->skb->dev ? e->skb->dev->name : "---");
+		}
+		mutex_unlock(&ifp->pend_8021x_mutex);
+	}
 
 	return !err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
index 8fa34ca..0ee20d4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.h
@@ -50,6 +50,9 @@
 
 #define NDOL_MAX_ENTRIES	8
 
+void __brcmu_pkt_buf_free_skb(const char *c0, struct brcmf_if *ifp, struct sk_buff *skb);
+#define brcmu_pkt_buf_free_skb(skb)	__brcmu_pkt_buf_free_skb(__func__, ifp, skb)
+
 /**
  * struct brcmf_ampdu_rx_reorder - AMPDU receive reorder info
  *
@@ -169,6 +172,15 @@ enum brcmf_netif_stop_reason {
 	BRCMF_NETIF_STOP_REASON_DISCONNECTED = BIT(2)
 };
 
+struct pend_skb {
+	struct sk_buff *skb;
+	u8 data[14];
+	u64 start_time;
+	u64 commit_time;
+	bool timedout;
+	struct list_head list;
+};
+
 /**
  * struct brcmf_if - interface control information.
  *
@@ -203,6 +215,9 @@ struct brcmf_if {
 	u8 netif_stop;
 	spinlock_t netif_stop_lock;
 	atomic_t pend_8021x_cnt;
+	struct list_head pend_8021x_skbs;
+	struct mutex pend_8021x_mutex;
+	bool pend_8021x_ready;
 	wait_queue_head_t pend_8021x_wait;
 	struct in6_addr ipv6_addr_tbl[NDOL_MAX_ENTRIES];
 	u8 ipv6addr_idx;
@@ -219,7 +234,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked);
 void brcmf_txflowblock_if(struct brcmf_if *ifp,
 			  enum brcmf_netif_stop_reason reason, bool state);
-void brcmf_txfinalize(struct brcmf_if *ifp, struct sk_buff *txp, bool success);
+void __brcmf_txfinalize(const char *c0, struct brcmf_if *ifp, struct sk_buff *txp, bool success);
+#define brcmf_txfinalize(ifp, txp, success)	__brcmf_txfinalize(__func__, ifp, txp, success)
 void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb);
 void brcmf_net_setcarrier(struct brcmf_if *ifp, bool on);
 void brcmf_c_set_joinpref_default(struct brcmf_if *ifp);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
index 7e269f9..87c8de0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/flowring.c
@@ -249,6 +249,8 @@ void brcmf_flowring_delete(struct brcmf_flowring *flow, u16 flowid)
 
 	skb = skb_dequeue(&ring->skblist);
 	while (skb) {
+		struct brcmf_if *ifp = NULL;
+
 		brcmu_pkt_buf_free_skb(skb);
 		skb = skb_dequeue(&ring->skblist);
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 9f9024a..7a17afd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -38,6 +38,8 @@
 #include "proto.h"
 #include "common.h"
 
+#include <linux/sched.h>
+
 /**
  * DOC: Firmware Signalling
  *
@@ -590,6 +592,8 @@ static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q,
 	for (prec = 0; prec < q->num_prec; prec++) {
 		skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		while (skb) {
+			struct brcmf_if *ifp = NULL;
+
 			brcmu_pkt_buf_free_skb(skb);
 			skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
 		}
@@ -697,6 +701,8 @@ static void brcmf_fws_hanger_cleanup(struct brcmf_fws_info *fws,
 		    s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED) {
 			skb = h->items[i].pkt;
 			if (fn == NULL || fn(skb, &ifidx)) {
+				struct brcmf_if *ifp = NULL;
+
 				/* suppress packets freed from psq */
 				if (s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE)
 					brcmu_pkt_buf_free_skb(skb);
@@ -845,6 +851,8 @@ static void brcmf_fws_bus_txq_cleanup(struct brcmf_fws_info *fws,
 	for (prec = 0; prec < txq->num_prec; prec++) {
 		skb = brcmu_pktq_pdeq_match(txq, prec, fn, &ifidx);
 		while (skb) {
+			struct brcmf_if *ifp = NULL;
+
 			hslot = brcmf_skb_htod_tag_get_field(skb, HSLOT);
 			hi = &fws->hanger.items[hslot];
 			WARN_ON(skb != hi->pkt);
@@ -971,8 +979,11 @@ static bool brcmf_fws_tim_update(struct brcmf_fws_info *fws,
 		brcmf_fws_unlock(fws);
 		err = brcmf_proto_txdata(fws->drvr, ifidx, data_offset, skb);
 		brcmf_fws_lock(fws);
-		if (err)
+		if (err) {
+			struct brcmf_if *ifp = NULL;
+
 			brcmu_pkt_buf_free_skb(skb);
+		}
 		return true;
 	}
 	return false;
@@ -2056,6 +2067,22 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 		(void)brcmf_proto_hdrpull(fws->drvr, false, skb, NULL);
 		goto rollback;
 	}
+	{
+		struct brcmf_if *ifp = brcmf_get_ifp(fws->drvr, brcmf_skb_if_flags_get_field(skb, INDEX));
+
+		if (ifp) {
+			struct pend_skb *e;
+
+			mutex_lock(&ifp->pend_8021x_mutex);
+			list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+				if (e->skb == skb) {
+					e->commit_time = local_clock();
+					break;
+				}
+			}
+			mutex_unlock(&ifp->pend_8021x_mutex);
+		}
+	}
 
 	fws->stats.pkt2bus++;
 	fws->stats.send_pkts[fifo]++;
@@ -2454,6 +2481,7 @@ bool brcmf_fws_fc_active(struct brcmf_fws_info *fws)
 
 void brcmf_fws_bustxfail(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
+	struct brcmf_if *ifp = NULL;
 	u32 hslot;
 
 	if (brcmf_skbcb(skb)->state == BRCMF_FWS_SKBSTATE_TIM) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 2b9a2bc..6ff91c2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -34,6 +34,8 @@
 #include "bus.h"
 #include "tracepoint.h"
 
+#include <linux/sched.h>
+
 
 #define MSGBUF_IOCTL_RESP_TIMEOUT		msecs_to_jiffies(2000)
 
@@ -392,6 +394,8 @@ brcmf_msgbuf_release_array(struct device *dev,
 	count = 0;
 	do {
 		if (array[count].allocated.counter) {
+			struct brcmf_if *ifp = NULL;
+
 			pktid = &array[count];
 			dma_unmap_single(dev, pktid->physaddr,
 					 pktid->skb->len - pktid->data_offset,
@@ -483,6 +487,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
 	struct sk_buff *skb = NULL;
+	struct brcmf_if *ifp = NULL;
 	int timeout;
 	int err;
 
@@ -747,6 +752,22 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 			brcmf_commonring_write_complete(commonring);
 			count = 0;
 		}
+		{
+			struct brcmf_if *ifp = brcmf_get_ifp(msgbuf->drvr, tx_msghdr->msg.ifidx);
+
+			if (ifp) {
+				struct pend_skb *e;
+
+				mutex_lock(&ifp->pend_8021x_mutex);
+				list_for_each_entry(e, &ifp->pend_8021x_skbs, list) {
+					if (e->skb == skb) {
+						e->commit_time = local_clock();
+						break;
+					}
+				}
+				mutex_unlock(&ifp->pend_8021x_mutex);
+			}
+		}
 	}
 	if (count)
 		brcmf_commonring_write_complete(commonring);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 2f978a3..edbe353 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -498,6 +498,7 @@ static void brcmf_usb_rx_complete(struct urb *urb)
 {
 	struct brcmf_usbreq  *req = (struct brcmf_usbreq *)urb->context;
 	struct brcmf_usbdev_info *devinfo = req->devinfo;
+	struct brcmf_if *ifp = NULL;
 	struct sk_buff *skb;
 
 	brcmf_dbg(USB, "Enter, urb->status=%d\n", urb->status);
@@ -548,6 +549,8 @@ static void brcmf_usb_rx_refill(struct brcmf_usbdev_info *devinfo,
 
 	ret = usb_submit_urb(req->urb, GFP_ATOMIC);
 	if (ret) {
+		struct brcmf_if *ifp = NULL;
+
 		brcmf_usb_del_fromq(devinfo, req);
 		brcmu_pkt_buf_free_skb(req->skb);
 		req->skb = NULL;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c b/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c
index 0543607..bf525b7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmutil/utils.c
@@ -49,7 +49,7 @@ void brcmu_pkt_buf_free_skb(struct sk_buff *skb)
 	WARN_ON(skb->next);
 	dev_kfree_skb_any(skb);
 }
-EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
+//EXPORT_SYMBOL(brcmu_pkt_buf_free_skb);
 
 /*
  * osl multiple-precedence packet queue
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h
index 4196952..7bd705d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcmu_utils.h
@@ -126,7 +126,7 @@ struct sk_buff *brcmu_pktq_pdeq_match(struct pktq *pq, int prec,
 
 /* packet primitives */
 struct sk_buff *brcmu_pkt_buf_get_skb(uint len);
-void brcmu_pkt_buf_free_skb(struct sk_buff *skb);
+//void brcmu_pkt_buf_free_skb(struct sk_buff *skb);
 
 /* Empty the queue at particular precedence level */
 /* callback function fn(pkt, arg) returns true if pkt belongs to if */
-- 
2.9.3
