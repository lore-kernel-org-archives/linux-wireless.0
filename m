Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:13486 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbbIRUIZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 06/16] brcmfmac: Fix bug in flowring management.
Date: Fri, 18 Sep 2015 22:08:09 +0200
Message-ID: <1442606899-31872-7-git-send-email-arend@broadcom.com> (sfid-20150918_221654_349121_F5ED4CF3)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The hash index stored in the flowrings is of type u16 but gets
stored in u8. This can result in incorrect indexing and possibly
result in crashes. This patch fixes the type.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/flowring.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
index 5551861..95fd1c9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.h
@@ -34,7 +34,7 @@ enum ring_status {
 };
 
 struct brcmf_flowring_ring {
-	u8 hash_id;
+	u16 hash_id;
 	bool blocked;
 	enum ring_status status;
 	struct sk_buff_head skblist;
-- 
1.9.1

