Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34620 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966826AbcAZQ5W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 11:57:22 -0500
Received: by mail-lf0-f54.google.com with SMTP id 17so109170182lfz.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 08:57:21 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/5] brcmfmac: analyze descriptors of current component only
Date: Tue, 26 Jan 2016 17:57:01 +0100
Message-Id: <1453827425-16455-2-git-send-email-zajec5@gmail.com> (sfid-20160126_175730_199770_950D66CE)
In-Reply-To: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
References: <1453827425-16455-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So far we were looking for address descriptors without a check for
crossing current component border. In case of dealing with unsupported
descriptor or descriptor missing at all the code would incorrectly get
data from another component.

Consider this binary-described component from BCM4366 EROM:
4bf83b01	TAG==CI		CID==0x83b
20080201	TAG==CI		PORTS==0+1	WRAPPERS==0+1
18400035	TAG==ADDR	SZ_SZD		TYPE_SLAVE
00050000
18107085	TAG==ADDR	SZ_4K		TYPE_SWRAP

Driver was assigning invalid base address to this core:
brcmfmac:  [6 ] core 0x83b:32 base 0x18109000 wrap 0x18107000
which came from totally different component defined in EROM:
43b36701	TAG==CI		CID==0x367
00000201	TAG==CI		PORTS==0+1	WRAPPERS==0+0
18109005	TAG==ADDR	SZ_4K		TYPE_SLAVE

This change will also allow us to support components without wrapper
address in the future.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 82e4382..e434e2a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -803,7 +803,14 @@ static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip_priv *ci, u32 *eromaddr,
 				*eromaddr -= 4;
 				return -EFAULT;
 			}
-		} while (desc != DMP_DESC_ADDRESS);
+		} while (desc != DMP_DESC_ADDRESS &&
+			 desc != DMP_DESC_COMPONENT);
+
+		/* stop if we crossed current component border */
+		if (desc == DMP_DESC_COMPONENT) {
+			*eromaddr -= 4;
+			return 0;
+		}
 
 		/* skip upper 32-bit address descriptor */
 		if (val & DMP_DESC_ADDRSIZE_GT32)
-- 
1.8.4.5

