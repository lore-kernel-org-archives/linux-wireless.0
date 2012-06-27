Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39809 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2F0Oat (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 10:30:49 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: Fix signedness in a MCI debug message
Date: Wed, 27 Jun 2012 20:00:27 +0530
Message-ID: <1340807427-5774-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120627_163053_155270_DA848720)
In-Reply-To: <1340807427-5774-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1340807427-5774-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

seems i got a message like this
ath: phy0: BT_Status_Update: is_link=0, linkId=2,
state=1, SEQ=-2085766476 initially.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index c40e568..64cc782 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -348,7 +348,7 @@ static void ath_mci_msg(struct ath_softc *sc, u8 opcode, u8 *rx_payload)
 
 		seq_num = *((u32 *)(rx_payload + 12));
 		ath_dbg(common, MCI,
-			"BT_Status_Update: is_link=%d, linkId=%d, state=%d, SEQ=%d\n",
+			"BT_Status_Update: is_link=%d, linkId=%d, state=%d, SEQ=%u\n",
 			profile_status.is_link, profile_status.conn_handle,
 			profile_status.is_critical, seq_num);
 
-- 
1.7.0.4

