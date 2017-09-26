Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33878 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934198AbdIZGl6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 02:41:58 -0400
From: AceLan Kao <acelan.kao@canonical.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] ath9k: set use_msi=1 on Dell Vostro 3262
Date: Tue, 26 Sep 2017 14:41:36 +0800
Message-Id: <1506408099-18488-3-git-send-email-acelan.kao@canonical.com> (sfid-20170926_084503_142638_BB023478)
In-Reply-To: <1506408099-18488-1-git-send-email-acelan.kao@canonical.com>
References: <1506408099-18488-1-git-send-email-acelan.kao@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BIOS on Dell Vostro 3262 blocks legacy interrupts (INTx),
and only allows MSI for WLAN device.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1667949..6b5d53c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -112,6 +112,14 @@ static const struct dmi_system_id ath9k_quirks[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 24-3460"),
 		},
 	},
+	{
+		.callback = set_use_msi,
+		.ident = "Dell Vostro 3262",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 3262"),
+		},
+	},
 	{}
 };
 
-- 
2.7.4
