Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:44605 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751801AbdJPF6q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 01:58:46 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V6 4/5] ath10k: Avoid to set WEP key for TDLS peer
Date: Mon, 16 Oct 2017 14:00:32 +0800
Message-ID: <1508133633-23214-5-git-send-email-yintang@qti.qualcomm.com> (sfid-20171016_075850_293695_7F9EF1F3)
In-Reply-To: <1508133633-23214-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k patches V6>
 <1508133633-23214-1-git-send-email-yintang@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yingying Tang <yintang@qti.qualcomm.com>

TDLS peer do not need WEP key. Setting WEP key will lead
to TDLS setup failure. Add fix to avoid setting WEP key
for TDLS peer.

Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1672043..a984a72 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2966,7 +2966,7 @@ static int ath10k_station_assoc(struct ath10k *ar,
 		}
 
 		/* Plumb cached keys only for static WEP */
-		if (arvif->def_wep_key_idx != -1) {
+		if ((arvif->def_wep_key_idx != -1) && (!sta->tdls)) {
 			ret = ath10k_install_peer_wep_keys(arvif, sta->addr);
 			if (ret) {
 				ath10k_warn(ar, "failed to install peer wep keys for vdev %i: %d\n",
-- 
1.7.9.5
