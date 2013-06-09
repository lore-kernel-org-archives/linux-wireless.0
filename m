Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25298 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab3FIGNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jun 2013 02:13:24 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/6] wil6210: improve frame type reporting
Date: Sun, 9 Jun 2013 09:12:52 +0300
Message-ID: <1370758375-16867-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130609_081328_141083_6C7E6763)
In-Reply-To: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1370758375-16867-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report FC from the frame itself, as auxiliary information includes
only frame subtype. This is preparation for future changes, when
DMG beacon (extension frame) may be reported through wmi_evt_rx_mgmt()

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index cfcaf7b..ac4d26b 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -315,8 +315,8 @@ static void wmi_evt_rx_mgmt(struct wil6210_priv *wil, int id, void *d, int len)
 
 	wil_dbg_wmi(wil, "MGMT: channel %d MCS %d SNR %d\n",
 		    data->info.channel, data->info.mcs, data->info.snr);
-	wil_dbg_wmi(wil, "status 0x%04x len %d stype %04x\n", d_status, d_len,
-		    le16_to_cpu(data->info.stype));
+	wil_dbg_wmi(wil, "status 0x%04x len %d fc 0x%04x\n", d_status, d_len,
+		    le16_to_cpu(fc));
 	wil_dbg_wmi(wil, "qid %d mid %d cid %d\n",
 		    data->info.qid, data->info.mid, data->info.cid);
 
-- 
1.8.1.2

