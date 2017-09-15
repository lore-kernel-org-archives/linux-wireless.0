Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:35741 "EHLO
        alexa-out-lv-02.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751226AbdIOLCq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 07:02:46 -0400
From: <yintang@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: [TDLS PATCH V1 4/5] ath10k: Avoid to set WEP key for TDLS peer
Date: Fri, 15 Sep 2017 19:03:39 +0800
Message-ID: <1505473420-22932-5-git-send-email-yintang@qti.qualcomm.com> (sfid-20170915_130248_975923_8301C472)
In-Reply-To: <1505473420-22932-1-git-send-email-yintang@qti.qualcomm.com>
References: <TDLS for ath10k>
 <1505473420-22932-1-git-send-email-yintang@qti.qualcomm.com>
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
