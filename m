Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3863 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758799Ab3JONpM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:45:12 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/12] brcmfmac: store address in trace_brcmf_hexdump()
Date: Tue, 15 Oct 2013 15:44:46 +0200
Message-ID: <1381844697-24881-2-git-send-email-arend@broadcom.com> (sfid-20131015_154527_443026_892D2E63)
In-Reply-To: <1381844697-24881-1-git-send-email-arend@broadcom.com>
References: <1381844697-24881-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The trace function trace_brcmf_hexdump() stores the length, but
having the address of the buffer being dumped helps putting it
in context.

Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
index bc29171..4605a1d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/tracepoint.h
@@ -78,13 +78,15 @@ TRACE_EVENT(brcmf_hexdump,
 	TP_ARGS(data, len),
 	TP_STRUCT__entry(
 		__field(unsigned long, len)
+		__field(unsigned long, addr)
 		__dynamic_array(u8, hdata, len)
 	),
 	TP_fast_assign(
 		__entry->len = len;
+		__entry->addr = (unsigned long)data;
 		memcpy(__get_dynamic_array(hdata), data, len);
 	),
-	TP_printk("hexdump [length=%lu]", __entry->len)
+	TP_printk("hexdump [addr=%lx, length=%lu]", __entry->addr, __entry->len)
 );
 
 TRACE_EVENT(brcmf_bdchdr,
-- 
1.7.10.4


