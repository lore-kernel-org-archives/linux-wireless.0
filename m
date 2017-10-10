Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56533 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932083AbdJJIJm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 04:09:42 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V5 4/5] ath10k: Avoid to set WEP key for TDLS peer
Date: Tue, 10 Oct 2017 16:11:19 +0800
Message-ID: <1507623080-9311-5-git-send-email-yintang@qti.qualcomm.com> (sfid-20171010_100945_635932_46DBFCB0)
In-Reply-To: <1507623080-9311-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k patch>
 <1507623080-9311-1-git-send-email-yintang@qti.qualcomm.com>
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
index 399f9ba..f6702cb 100644
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
