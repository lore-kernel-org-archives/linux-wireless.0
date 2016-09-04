Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:44025 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753895AbcIDLDA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Sep 2016 07:03:00 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: Matthias Beyer <mail@beyermatthias.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        shivanib134@gmail.com, ksenija.stanojevic@gmail.com,
        Jes.Sorensen@redhat.com, meleodr@gmail.com,
        bhaktipriya96@gmail.com, bhumirks@gmail.com,
        Larry.Finger@lwfinger.net
Subject: [PATCH v2 1/1] drivers: staging: rtl8723au: hal: Remove pointless test
Date: Sun,  4 Sep 2016 13:01:20 +0200
Message-Id: <20160904110120.27028-2-mail@beyermatthias.de> (sfid-20160904_130317_873269_AC81487B)
In-Reply-To: <20160904110120.27028-1-mail@beyermatthias.de>
References: <20160901155447.GB7979@kroah.com>
 <20160904110120.27028-1-mail@beyermatthias.de>
In-Reply-To: <20160901155447.GB7979@kroah.com>
References: <20160901155447.GB7979@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the pointless `else if` test.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
Reported-by: David Binderman <linuxdev.baldrick@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index 6989580..47e8d69 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -3530,7 +3530,7 @@ bthci_CmdLinkStatusNotify(
 				pBtMgnt->ExtConfig.linkInfo[i].BTProfile,
 				pBtMgnt->ExtConfig.linkInfo[i].BTCoreSpec));
 			pTriple += 4;
-		} else if (pBtMgnt->ExtConfig.HCIExtensionVer >= 1) {
+		} else {
 			pBtMgnt->ExtConfig.linkInfo[i].ConnectHandle = *((u16 *)&pTriple[0]);
 			pBtMgnt->ExtConfig.linkInfo[i].BTProfile = pTriple[2];
 			pBtMgnt->ExtConfig.linkInfo[i].BTCoreSpec = pTriple[3];
-- 
2.9.3
