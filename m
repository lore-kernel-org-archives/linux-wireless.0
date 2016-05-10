Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26187 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbcEJPLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2016 11:11:20 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Reduce warning messages during rx without proper channel context
Date: Tue, 10 May 2016 20:42:16 +0530
Message-ID: <1462893136-16051-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160510_171144_795403_5393CAB3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

WARN_ON_ONCE when we receive packets for self peer when mac80211
had not assigned a proper channel context. This scenario happens
in QCA4019 when we start the AP via hostapd in background and start
it once again in the background without killing the previous instance!
This happens intermittently when we start / stop hostapd in a while loop
(incase the hostapd is not properly killed).  This results in mac80211
chancontext to be unassigned, while the self peer continuous receive
packets in target operating channel. This results in lot of call traces
in the rx path. Make this as a WARN_ON_ONCE to avoid flooding the console
which result in rebooting low memory systems, while still reporting the
warning once that we are receiving packets in target operating channel and
to indicate that something is happening which is not the expected result.

WARNING: CPU: 0 PID: 0 at ath/ath10k/htt_rx.c:803
[<c0318838>] (warn_slowpath_null) from [<bf4a0104>]
(ath10k_htt_rx_h_channel+0xe0/0x1b8 [ath10k_core])
[<bf4a0104>] (ath10k_htt_rx_h_channel [ath10k_core]) from
[<bf4a025c>] (ath10k_htt_rx_h_ppdu+0x80/0x288 [ath10k_core])
[<bf4a025c>] (ath10k_htt_rx_h_ppdu [ath10k_core]) from
[<bf4a1a9c>] (ath10k_htt_txrx_compl_task+0x724/0x9d4 [ath10k_core])
[<bf4a1a9c>] (ath10k_htt_txrx_compl_task [ath10k_core])

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cc979a4..77d9200 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -748,7 +748,7 @@ ath10k_htt_rx_h_peer_channel(struct ath10k *ar, struct htt_rx_desc *rxd)
 	if (WARN_ON_ONCE(!arvif))
 		return NULL;
 
-	if (WARN_ON(ath10k_mac_vif_chan(arvif->vif, &def)))
+	if (WARN_ON_ONCE(ath10k_mac_vif_chan(arvif->vif, &def)))
 		return NULL;
 
 	return def.chan;
-- 
1.7.9.5

