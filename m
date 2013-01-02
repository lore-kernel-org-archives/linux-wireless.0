Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3914 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab3ABOXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:07 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/18] brcmfmac: Removing obsolete variables and inline
 functions.
Date: Wed, 2 Jan 2013 15:22:50 +0100
Message-ID: <1357136572-18273-18-git-send-email-arend@broadcom.com> (sfid-20130102_155320_539301_4BD9167D)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h     |   24 ---------------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c |    2 --
 2 files changed, 26 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index bbefaf3..a2f32fb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -481,33 +481,14 @@ struct brcmf_pub {
 	unsigned long drv_version;	/* Version of dongle-resident driver */
 	u8 mac[ETH_ALEN];		/* MAC address obtained from dongle */
 
-	/* Additional stats for the bus level */
-
 	/* Multicast data packets sent to dongle */
 	unsigned long tx_multicast;
-	/* Packets flushed due to unscheduled sendup thread */
-	unsigned long rx_flushed;
-	/* Number of times dpc scheduled by watchdog timer */
-	unsigned long wd_dpc_sched;
-
-	/* Number of flow control pkts recvd */
-	unsigned long fc_packets;
-
-	/* Last error return */
-	int bcmerror;
-
-	/* Suspend disable flag  flag */
-	int suspend_disable_flag;	/* "1" to disable all extra powersaving
-					 during suspend */
-	int in_suspend;		/* flag set to 1 when early suspend called */
-	int dtim_skip;		/* dtim skip , default 0 means wake each dtim */
 
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 
 	struct mutex proto_block;
 	unsigned char proto_buf[BRCMF_DCMD_MAXLEN];
 
-	u8 macvalue[ETH_ALEN];
 	atomic_t pend_8021x_cnt;
 	wait_queue_head_t pend_8021x_wait;
 
@@ -550,11 +531,6 @@ struct brcmf_if {
 	u8 mac_addr[ETH_ALEN];
 };
 
-static inline s32 brcmf_ndev_bssidx(struct net_device *ndev)
-{
-	struct brcmf_if *ifp = netdev_priv(ndev);
-	return ifp->bssidx;
-}
 
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 4557709..bb454cd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -92,8 +92,6 @@ struct brcmf_proto_bdc_header {
 
 struct brcmf_proto {
 	u16 reqid;
-	u8 pending;
-	u32 lastcmd;
 	u8 bus_header[BUS_HEADER_LEN];
 	struct brcmf_proto_cdc_dcmd msg;
 	unsigned char buf[BRCMF_DCMD_MAXLEN + ROUND_UP_MARGIN];
-- 
1.7.10.4


