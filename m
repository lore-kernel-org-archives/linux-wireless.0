Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54396 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbcFIN2u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 09:28:50 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Remove unneccessary WARN_ON_ONCE in rx during ACS
Date: Thu, 9 Jun 2016 18:59:51 +0530
Message-ID: <1465478991-21449-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160609_152854_229117_7A589474)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

The below warning message seems to hit occasionally with the following
combination (IPQ4019 + ACS scan) where we receive packets as a self peer
when hostapd does ACS when we bring up AP mode . ath10k has the below
fall back mechanism to fetch current operating channel in rx (it will
check for the next channel tracking variable if the current one is NULL)

	[scan channel] --> [rx channel] --> [peer channel] -->
	[vdev channel] -->  [any vdev channel] --> [target oper channel]

'scan channel' and 'target operating channel' are directly fetched from
firmware events. All the others should be updated by mac80211.

During ACS scan we wouldn't have a valid channel context
assigned from mac80211 ('ar->rx_channel'), and also relying on
('ar->scan_channel') is not helpful (it becomes NULL when it goes to
BSS channel and also when the scan event is completed). In short we
cannot always rely on these two channel tracking variables.

'Target Operating Channel' (ar->tgt_oper_chan) seems to keep track of
the current operating even while we are doing ACS scan and etc. Hence
remove this un-necessary warning message and continue with
target_operating channel. At the worst case scenario when the target
operating channel is invalid (NULL) we already have an ath10k warning
message to notify we really don't have a proper channel configured in
rx to update the rx status("no channel configured; ignoring frame(s)!")

    WARNING: CPU: 0 PID: 0 at ath/ath10k/htt_rx.c:803
    [<c0318838>] (warn_slowpath_null) from [<bf4a0104>]
    (ath10k_htt_rx_h_channel+0xe0/0x1b8 [ath10k_core])
    [<bf4a0104>] (ath10k_htt_rx_h_channel [ath10k_core]) from
    [<bf4a025c>] (ath10k_htt_rx_h_ppdu+0x80/0x288 [ath10k_core])
    [<bf4a025c>] (ath10k_htt_rx_h_ppdu [ath10k_core]) from
    [<bf4a1a9c>] (ath10k_htt_txrx_compl_task+0x724/0x9d4 [ath10k_core])
    [<bf4a1a9c>] (ath10k_htt_txrx_compl_task [ath10k_core])

Fixes:3b0499e9ce42 ("ath10k: reduce warning messages during rx without proper channel context")
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---

[updated commit log - Michal Kazior]

 drivers/net/wireless/ath/ath10k/htt_rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 7bf1909..aa44c09 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -748,7 +748,7 @@ ath10k_htt_rx_h_peer_channel(struct ath10k *ar, struct htt_rx_desc *rxd)
 	if (WARN_ON_ONCE(!arvif))
 		return NULL;
 
-	if (WARN_ON_ONCE(ath10k_mac_vif_chan(arvif->vif, &def)))
+	if (ath10k_mac_vif_chan(arvif->vif, &def))
 		return NULL;
 
 	return def.chan;
-- 
1.7.9.5

