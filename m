Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36730 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756010AbcKXIEP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 03:04:15 -0500
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Thu, 24 Nov 2016 00:01:58 -0800
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Raja Mani <rmani@qti.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] ath10k: Remove unused wmi_p2p_noa_descriptor 'noa' in
 wmi-tlv
Message-ID: <99d0ff42e57d5f62560e72d926b4d69d5d7c418b.1479974100.git.kirtika@chromium.org> (sfid-20161124_090420_807381_A9515BCB)
References: <cover.1479974100.git.kirtika@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479974100.git.kirtika@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit ca996ec56608 (ath10k: implement wmi-tlv backend)
introduced ath10k_wmi_tlv_op_gen_vdev_start() where
'struct wmi_p2p_noa_descriptor *noa' is defined and set but not used.
Compiling with W=1 gives the following warning, fix it.
drivers/net/wireless/ath/ath10k/wmi-tlv.c: In function ‘ath10k_wmi_tlv_op_gen_vdev_start’:
drivers/net/wireless/ath/ath10k/wmi-tlv.c:1647:33: warning: variable ‘noa’ set but not used [-Wunused-but-set-variable]

Fixes: ca996ec56608 ("ath10k: implement wmi-tlv backend")
Cc: Michal Kazior <michal.kazior@tieto.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Kirtika Ruchandani <kirtika@chromium.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e64f593..0e4bd29 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1644,7 +1644,6 @@ ath10k_wmi_tlv_op_gen_vdev_start(struct ath10k *ar,
 {
	struct wmi_tlv_vdev_start_cmd *cmd;
	struct wmi_channel *ch;
-	struct wmi_p2p_noa_descriptor *noa;
	struct wmi_tlv *tlv;
	struct sk_buff *skb;
	size_t len;
@@ -1702,7 +1701,6 @@ ath10k_wmi_tlv_op_gen_vdev_start(struct ath10k *ar,
	tlv = ptr;
	tlv->tag = __cpu_to_le16(WMI_TLV_TAG_ARRAY_STRUCT);
	tlv->len = 0;
-	noa = (void *)tlv->value;

	/* Note: This is a nested TLV containing:
	 * [wmi_tlv][wmi_p2p_noa_descriptor][wmi_tlv]..
--
2.8.0.rc3.226.g39d4020
