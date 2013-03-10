Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:37467 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3CJGQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 01:16:11 -0500
Subject: [PATCH] ath6kl: Fix the byte alignment rule to avoid loss of bytes in
 a TCP segment
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	mjei78@gmail.com
Date: Sun, 10 Mar 2013 08:16:05 +0200
Message-ID: <20130310061605.27321.89150.stgit@localhost6.localdomain6> (sfid-20130310_071614_974779_FA5BB45A)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Myoungje Kim <mjei78@gmail.com>

Either first 3 bytes of the first received tcp segment or last one
over MTU size file can be loss due to the byte alignment problem.
Although ATH6KL_HTC_ALIGN_BYTES was defined for 'extra bytes for htc header
alignment' in the patch "Fix buffer alignment for scatter-gather
I/O"(1df94a857), there exists the bytes loss issue which means that it will be
truncated 3 bytes in the transmitted file contents if a file which has over MTU
size is transferred through TCP/IP stack.  It doesn't look like TCP/IP stack
bug of 3.5 or the latest version of kernel but the byte alignment issue.  This
patch is to use the roundup() function for the byte alignment rather than the
predefined ATH6KL_HTC_ALIGN_BYTES.

kvalo: fixed indentation

Signed-off-by: Myoungje Kim <mjei78@gmail.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    4 ++--
 drivers/net/wireless/ath/ath6kl/main.c |    8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 4ad45bb..40ffee6 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -201,8 +201,8 @@ struct sk_buff *ath6kl_buf_alloc(int size)
 	u16 reserved;
 
 	/* Add chacheline space at front and back of buffer */
-	reserved = (2 * L1_CACHE_BYTES) + ATH6KL_DATA_OFFSET +
-		   sizeof(struct htc_packet) + ATH6KL_HTC_ALIGN_BYTES;
+	reserved = roundup((2 * L1_CACHE_BYTES) + ATH6KL_DATA_OFFSET +
+		   sizeof(struct htc_packet) + ATH6KL_HTC_ALIGN_BYTES, 4);
 	skb = dev_alloc_skb(size + reserved);
 
 	if (skb)
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index bad62b3..d4fcfca 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1294,9 +1294,11 @@ void init_netdev(struct net_device *dev)
 	dev->watchdog_timeo = ATH6KL_TX_TIMEOUT;
 
 	dev->needed_headroom = ETH_HLEN;
-	dev->needed_headroom += sizeof(struct ath6kl_llc_snap_hdr) +
-				sizeof(struct wmi_data_hdr) + HTC_HDR_LENGTH
-				+ WMI_MAX_TX_META_SZ + ATH6KL_HTC_ALIGN_BYTES;
+	dev->needed_headroom += roundup(sizeof(struct ath6kl_llc_snap_hdr) +
+					sizeof(struct wmi_data_hdr) +
+					HTC_HDR_LENGTH +
+					WMI_MAX_TX_META_SZ +
+					ATH6KL_HTC_ALIGN_BYTES, 4);
 
 	dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
 

