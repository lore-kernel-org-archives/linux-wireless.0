Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4441 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760486Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 17/25] brcmfmac: avoid error output in receive path
Date: Wed, 3 Apr 2013 12:40:42 +0200
Message-ID: <1364985650-11719-18-git-send-email-arend@broadcom.com> (sfid-20130403_124134_868554_FC1FAE8D)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Parsing the tlv upon receiving frames can fail. Instead of printing
an error message, just count the parse failure. On some devices we
receive a lot of invalid tlv signals.

this commit will be squashed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Change-Id: I08e0f62c55e5028f9aa70c396d291679abd273c9
Reviewed-on: http://lb-bun-88.bun.broadcom.com:8080/72
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index eb63419..314aedc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -440,7 +440,6 @@ static int brcmf_fws_get_tlv_len(struct brcmf_fws_info *fws,
 	switch (id) {
 	BRCMF_FWS_TLV_DEFLIST
 	default:
-		brcmf_err("invalid tlv id: %d\n", id);
 		fws->stats.tlv_invalid_type++;
 		break;
 	}
@@ -1013,6 +1012,9 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		len = signal_data[1];
 		data = signal_data + 2;
 
+		brcmf_dbg(INFO, "tlv type=%d (%s), len=%d, data[0]=%d\n", type,
+			  brcmf_fws_get_tlv_name(type), len, *data);
+
 		/* abort parsing when length invalid */
 		if (data_len < len + 2)
 			break;
@@ -1020,8 +1022,6 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		if (len != brcmf_fws_get_tlv_len(fws, type))
 			break;
 
-		brcmf_dbg(INFO, "tlv type=%d (%s), len=%d\n", type,
-			  brcmf_fws_get_tlv_name(type), len);
 		switch (type) {
 		case BRCMF_FWS_TYPE_MAC_OPEN:
 		case BRCMF_FWS_TYPE_MAC_CLOSE:
-- 
1.7.10.4


