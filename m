Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17966 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1LTSrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 13:47:00 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 4/6] ath9k: fix tx queue sparse complaint
Date: Tue, 20 Dec 2011 10:46:09 -0800
Message-ID: <1324406771-7100-5-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_194703_966419_231AE7BE)
In-Reply-To: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

This fixes this rant from sparse:

  CHECK   drivers/net/wireless/ath/ath9k/xmit.c
drivers/net/wireless/ath/ath9k/xmit.c:107:13: warning: context imbalance in 'ath_txq_lock' - wrong count at exit
drivers/net/wireless/ath/ath9k/xmit.c:112:13: warning: context imbalance in 'ath_txq_unlock' - unexpected unlock
drivers/net/wireless/ath/ath9k/xmit.c:123:30: warning: context imbalance in 'ath_txq_unlock_complete' - unexpected unlock
  CC [M]  drivers/net/wireless/ath/ath9k/xmit.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b092523..c8fc180 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -105,16 +105,19 @@ static int ath_max_4ms_framelen[4][32] = {
 /*********************/
 
 static void ath_txq_lock(struct ath_softc *sc, struct ath_txq *txq)
+	__acquires(&txq->axq_lock)
 {
 	spin_lock_bh(&txq->axq_lock);
 }
 
 static void ath_txq_unlock(struct ath_softc *sc, struct ath_txq *txq)
+	__releases(&txq->axq_lock)
 {
 	spin_unlock_bh(&txq->axq_lock);
 }
 
 static void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq)
+	__releases(&txq->axq_lock)
 {
 	struct sk_buff_head q;
 	struct sk_buff *skb;
-- 
1.7.4.15.g7811d

