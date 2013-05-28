Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62876 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770Ab3E1MSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 08:18:08 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] wil6210: channel off by 1
Date: Tue, 28 May 2013 15:17:52 +0300
Message-ID: <1369743473-7243-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130528_141813_135816_6C3CB3A3)
In-Reply-To: <1369743473-7243-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1369743473-7243-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WMI commands wants channel index, that is channel - 1

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/wmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 5e01f4e..a091eb1 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -728,7 +728,7 @@ int wmi_pcp_start(struct wil6210_priv *wil, int bi, u8 wmi_nettype, u8 chan)
 		.bcon_interval = cpu_to_le16(bi),
 		.network_type = wmi_nettype,
 		.disable_sec_offload = 1,
-		.channel = chan,
+		.channel = chan - 1,
 	};
 	struct {
 		struct wil6210_mbox_hdr_wmi wmi;
-- 
1.8.1.2

