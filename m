Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2150 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755096Ab3IYLGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 07:06:05 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 5/7] brcmfmac: fix sparse error 'bad constant
 expression'
Date: Wed, 25 Sep 2013 13:05:44 +0200
Message-ID: <1380107146-24026-6-git-send-email-arend@broadcom.com> (sfid-20130925_130609_006278_1A38A999)
In-Reply-To: <1380107146-24026-1-git-send-email-arend@broadcom.com>
References: <1380107146-24026-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The definition of BRCMF_EVENTING_MASK_LEN results in a sparse
error message

.../fweh.c:331:22: error: bad constant expression
.../fweh.c:388:22: error: bad constant expression
.../dhd_common.c:256:22: error: bad constant expression

This is caused by the use of roundup() in BRCMF_EVENTING_MASK_LEN
and it is used to allocate an array variable on the stack. Better
use DIV_ROUND_UP() macro.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
index 9ee5c51..14bc24d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
@@ -115,7 +115,7 @@ enum brcmf_fweh_event_code {
 };
 #undef BRCMF_ENUM_DEF
 
-#define BRCMF_EVENTING_MASK_LEN		(roundup(BRCMF_E_LAST, 8)/8)
+#define BRCMF_EVENTING_MASK_LEN		DIV_ROUND_UP(BRCMF_E_LAST, 8)
 
 /* flags field values in struct brcmf_event_msg */
 #define BRCMF_EVENT_MSG_LINK		0x01
-- 
1.7.10.4


