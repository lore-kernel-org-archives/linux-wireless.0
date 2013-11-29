Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4317 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab3K2LZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/19] brcmfmac: fix driver build issue when
 CONFIG_BRCMDBG is not set
Date: Fri, 29 Nov 2013 12:25:08 +0100
Message-ID: <1385724324-6361-4-git-send-email-arend@broadcom.com> (sfid-20131129_123808_329182_C3BD58E3)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When CONFIG_BRCMDBG is not set we get the following build issue:
  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/fwsignal.o
drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c:
    In function ‘brcmf_fws_hdrpush’:
	drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c:852:18:
	error: ‘BRCMF_FWS_TYPE_SEQ_LEN’ undeclared

The define BRCMF_FWS_TYPE_SEQ_LEN was introduced by:

    commit 6918f38e4ed4e0493a90a4331e0033bdfc806e00
    Author: Hante Meuleman <meuleman@broadcom.com>
    Date:   Wed Oct 23 14:58:51 2013 +0200

        brcmfmac: Update fwsignal to fix out of order tx.

Unfortunately, it was put in conditional part of the source
file under #ifdef DEBUG.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 784cf94..296dbf1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -105,8 +105,6 @@ static struct {
 };
 #undef BRCMF_FWS_TLV_DEF
 
-#define BRCMF_FWS_TYPE_SEQ_LEN				2
-
 
 static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 {
@@ -126,6 +124,12 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 #endif /* DEBUG */
 
 /*
+ * The PKTTAG tlv has additional bytes when firmware-signalling
+ * mode has REUSESEQ flag set.
+ */
+#define BRCMF_FWS_TYPE_SEQ_LEN				2
+
+/*
  * flags used to enable tlv signalling from firmware.
  */
 #define BRCMF_FWS_FLAGS_RSSI_SIGNALS			0x0001
-- 
1.7.10.4


