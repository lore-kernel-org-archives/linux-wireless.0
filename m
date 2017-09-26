Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34174 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965565AbdIZGmE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 02:42:04 -0400
From: AceLan Kao <acelan.kao@canonical.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] ath9k: set use_msi=1 on Dell Inspiron 3472
Date: Tue, 26 Sep 2017 14:41:37 +0800
Message-Id: <1506408099-18488-4-git-send-email-acelan.kao@canonical.com> (sfid-20170926_084503_675126_32CC1E56)
In-Reply-To: <1506408099-18488-1-git-send-email-acelan.kao@canonical.com>
References: <1506408099-18488-1-git-send-email-acelan.kao@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BIOS on Dell Inspiron 3472 blocks legacy interrupts (INTx),
and only allows MSI for WLAN device.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 6b5d53c..fce9ac7 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -120,6 +120,14 @@ static const struct dmi_system_id ath9k_quirks[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 3262"),
 		},
 	},
+	{
+		.callback = set_use_msi,
+		.ident = "Dell Inspiron 3472",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 3472"),
+		},
+	},
 	{}
 };
 
-- 
2.7.4
