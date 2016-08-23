Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from libra.uberspace.de ([95.143.172.171]:38962 "EHLO
        libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754924AbcHWUMa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Aug 2016 16:12:30 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
        amitoj1606@gmail.com, bhaktipriya96@gmail.com, bhumirks@gmail.com,
        ksenija.stanojevic@gmail.com, mail@beyermatthias.de,
        meleodr@gmail.com, shivanib134@gmail.com
Subject: [PATCH] drivers: staging: rtl8723au: hal: Remove pointless test
Date: Tue, 23 Aug 2016 21:44:17 +0200
Message-Id: <20160823194417.30531-2-mail@beyermatthias.de> (sfid-20160823_221234_181540_B932103A)
In-Reply-To: <20160823194417.30531-1-mail@beyermatthias.de>
References: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
 <20160823194417.30531-1-mail@beyermatthias.de>
In-Reply-To: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
References: <CAMzoamY0HSt4af8EeJpt73FD++q1MZ7iHJFa4NDBtzzQrNMjbg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the pointless `else if` test.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
Reported-by: David Binderman <linuxdev.baldrick@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index bfcbd7a..7f11521 100644
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
2.9.2
