Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41646 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1LZFMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 00:12:25 -0500
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>, <ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH v2] ath9k: Fix kernel panic in AR2427 in AP mode
Date: Mon, 26 Dec 2011 10:42:15 +0530
Message-ID: <1324876335-1867-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111226_061239_463014_0E5AF302)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

don't do aggregation related stuff for 'AP mode client power save
handling' if aggregation is not enabled in the driver, otherwise it
will lead to panic because those data structures won't be never
intialized in 'ath_tx_node_init' if aggregation is disabled

	EIP is at ath_tx_aggr_wakeup+0x37/0x80 [ath9k]
	EAX: e8c09a20 EBX: f2a304e8 ECX: 00000001 EDX: 00000000
	ESI: e8c085e0 EDI: f2a304ac EBP: f40e1ca4 ESP: f40e1c8c
	DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
	Process swapper/1 (pid: 0, ti=f40e0000 task=f408e860
	task.ti=f40dc000)
	Stack:
	0001e966 e8c09a20 00000000 f2a304ac e8c085e0 f2a304ac
	f40e1cb0 f8186741
	f8186700 f40e1d2c f922988d f2a304ac 00000202 00000001
	c0b4ba43 00000000
	0000000f e8eb75c0 e8c085e0 205b0001 34383220 f2a304ac
	f2a30000 00010020
	Call Trace:
	[<f8186741>] ath9k_sta_notify+0x41/0x50 [ath9k]
	[<f8186700>] ? ath9k_get_survey+0x110/0x110 [ath9k]
	[<f922988d>] ieee80211_sta_ps_deliver_wakeup+0x9d/0x350
	[mac80211]
	[<c018dc75>] ? __module_address+0x95/0xb0
	[<f92465b3>] ap_sta_ps_end+0x63/0xa0 [mac80211]
	[<f9246746>] ieee80211_rx_h_sta_process+0x156/0x2b0
	[mac80211]
	[<f9247d1e>] ieee80211_rx_handlers+0xce/0x510 [mac80211]
	[<c018440b>] ? trace_hardirqs_on+0xb/0x10
	[<c056936e>] ? skb_queue_tail+0x3e/0x50
	[<f9248271>] ieee80211_prepare_and_rx_handle+0x111/0x750
	[mac80211]
	[<f9248bf9>] ieee80211_rx+0x349/0xb20 [mac80211]
	[<f9248949>] ? ieee80211_rx+0x99/0xb20 [mac80211]
	[<f818b0b8>] ath_rx_tasklet+0x818/0x1d00 [ath9k]
	[<f8187a75>] ? ath9k_tasklet+0x35/0x1c0 [ath9k]
	[<f8187a75>] ? ath9k_tasklet+0x35/0x1c0 [ath9k]
	[<f8187b33>] ath9k_tasklet+0xf3/0x1c0 [ath9k]
	[<c0151b7e>] tasklet_action+0xbe/0x180

Cc: stable@kernel.org
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Reported-by: Ashwin Mendonca <ashwinloyal@gmail.com>
Tested-by: Ashwin Mendonca <ashwinloyal@gmail.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6e3d838..e267c92 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1797,6 +1797,9 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 
+	if (!(sc->sc_flags & SC_OP_TXAGGR))
+		return;
+
 	switch (cmd) {
 	case STA_NOTIFY_SLEEP:
 		an->sleeping = true;
-- 
1.7.0.4

