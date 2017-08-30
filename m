Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751363AbdH3Nyw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 09:54:52 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2] brcmfmac: Log chip id and revision
Date: Wed, 30 Aug 2017 15:54:49 +0200
Message-Id: <20170830135449.1075-1-hdegoede@redhat.com> (sfid-20170830_155617_011083_CE13489E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For debugging some problems, it is useful to know the chip revision
add a brcmf_info message logging this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Put the brcmf_info in brcmf_fw_map_chip_to_name() so that it works for
 e.g. pcie devices too
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index d231042f19d6..091b52979e03 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -601,6 +601,9 @@ int brcmf_fw_map_chip_to_name(u32 chip, u32 chiprev,
 	if ((nvram_name) && (mapping_table[i].nvram))
 		strlcat(nvram_name, mapping_table[i].nvram, BRCMF_FW_NAME_LEN);
 
+	brcmf_info("using %s for chip %#08x(%d) rev %#08x\n",
+		   fw_name, chip, chip, chiprev);
+
 	return 0;
 }
 
-- 
2.13.4
