Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:58084 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752915AbeEOJPH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:15:07 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6/8] brcmfmac: validate user provided data for memdump before copying
Date: Tue, 15 May 2018 11:14:49 +0200
Message-Id: <1526375691-31789-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180515_111600_419787_8A302FAA)
In-Reply-To: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <franky.lin@broadcom.com>

In patch "brcmfmac: add support for sysfs initiated coredump", a new
scenario of brcmf_debug_create_memdump was added in which the user of
the function might not necessarily provide prefix data. Hence the
function should not assume the data is always valid and should perform a
check before copying.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index 5048320..489b5df 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -40,7 +40,8 @@ int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 	if (!dump)
 		return -ENOMEM;
 
-	memcpy(dump, data, len);
+	if (data && len > 0)
+		memcpy(dump, data, len);
 	err = brcmf_bus_get_memdump(bus, dump + len, ramsize);
 	if (err) {
 		vfree(dump);
-- 
1.9.1
