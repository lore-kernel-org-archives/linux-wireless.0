Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3445 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab2DKJxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/9] brcm80211: fmac: add frame header extension support
Date: Wed, 11 Apr 2012 11:52:46 +0200
Message-ID: <1334137971-3972-5-git-send-email-arend@broadcom.com> (sfid-20120411_115336_858660_CF6F51E3)
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

A header extension is introduced in the received frame to provide
extra space for dongle information. This won't affect current
supported chipset since the data_offset is 0. But it's necessary for
adding support for future chipset.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index b3e3b7f..a5c15ca 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -421,6 +421,7 @@ int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
 	pktbuf->priority = h->priority & BDC_PRIORITY_MASK;
 
 	skb_pull(pktbuf, BDC_HEADER_LEN);
+	skb_pull(pktbuf, h->data_offset << 2);
 
 	return 0;
 }
-- 
1.7.5.4


