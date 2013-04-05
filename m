Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1665 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161614Ab3DEI6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/16] brcmfmac: fix unaligned access in TXSTATUS signal
 handling
Date: Fri, 5 Apr 2013 10:57:39 +0200
Message-ID: <1365152274-4252-2-git-send-email-arend@broadcom.com> (sfid-20130405_105812_807562_5B8B985A)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reported by Hante. Needs to be squashed in commit 187fbcec.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 8ce79af..451cfc1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1181,13 +1181,15 @@ static int brcmf_fws_fifocreditback_indicate(struct brcmf_fws_info *fws,
 
 static int brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
 {
+	__le32 status_le;
 	u32 status;
 	u32 hslot;
 	u32 genbit;
 	u8 flags;
 
 	fws->stats.txs_indicate++;
-	status = le32_to_cpu(*(__le32 *)data);
+	memcpy(&status_le, data, sizeof(status_le));
+	status = le32_to_cpu(status_le);
 	flags = brcmf_txstatus_get_field(status, FLAGS);
 	hslot = brcmf_txstatus_get_field(status, HSLOT);
 	genbit = brcmf_txstatus_get_field(status, GENERATION);
-- 
1.7.10.4


