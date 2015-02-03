Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:34385 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbbBCNMk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 08:12:40 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Anjana Sasindran <anjanasasindran123@gmail.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] staging: rtl8723au: multiple condition with no effect - if identical to else
Date: Tue,  3 Feb 2015 08:08:16 -0500
Message-Id: <1422968896-26562-1-git-send-email-hofrat@osadl.org> (sfid-20150203_141243_366926_E8E1573F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A number if/else if/else branches are identical - so the condition has no
effect on the effective code and can be significantly simplified - this 
patch removes the condition and the duplicated code.

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

This looks like the output of some broken code-generator - unlikely someone
wrote this by hand. In any case it needs a review by someone that knows the
details of the driver. 

Anyway the number of useless code repetition is potentially record breaking !

Patch was compile tested for x86_64_defconfig + CONFIG_STAGING=y
CONFIG_R8723AU=m, CONFIG_8723AU_BT_COEXIST=y

Patch is against 3.0.19-rc7 (localversoin = -next-20150203)

 .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    |   60 +++-----------------
 1 file changed, 8 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
index 412d8cf..73cfddd 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_bt-coexist.c
@@ -7255,63 +7255,19 @@ btdm_2AntTdmaDurationAdjust(struct rtw_adapter *padapter, u8 bScoHid,
 		RTPRINT(FBT, BT_TRACE, ("[BTCoex], first run TdmaDurationAdjust()!!\n"));
 		if (bScoHid) {
 			if (bTxPause) {
-				if (maxInterval == 1) {
-					btdm_2AntPsTdma(padapter, true, 15);
-					pBtdm8723->psTdmaDuAdjType = 15;
-				} else if (maxInterval == 2) {
-					btdm_2AntPsTdma(padapter, true, 15);
-					pBtdm8723->psTdmaDuAdjType = 15;
-				} else if (maxInterval == 3) {
-					btdm_2AntPsTdma(padapter, true, 15);
-					pBtdm8723->psTdmaDuAdjType = 15;
-				} else {
-					btdm_2AntPsTdma(padapter, true, 15);
-					pBtdm8723->psTdmaDuAdjType = 15;
-				}
+				btdm_2AntPsTdma(padapter, true, 15);
+				pBtdm8723->psTdmaDuAdjType = 15;
 			} else {
-				if (maxInterval == 1) {
-					btdm_2AntPsTdma(padapter, true, 11);
-					pBtdm8723->psTdmaDuAdjType = 11;
-				} else if (maxInterval == 2) {
-					btdm_2AntPsTdma(padapter, true, 11);
-					pBtdm8723->psTdmaDuAdjType = 11;
-				} else if (maxInterval == 3) {
-					btdm_2AntPsTdma(padapter, true, 11);
-					pBtdm8723->psTdmaDuAdjType = 11;
-				} else {
-					btdm_2AntPsTdma(padapter, true, 11);
-					pBtdm8723->psTdmaDuAdjType = 11;
-				}
+				btdm_2AntPsTdma(padapter, true, 11);
+				pBtdm8723->psTdmaDuAdjType = 11;
 			}
 		} else {
 			if (bTxPause) {
-				if (maxInterval == 1) {
-					btdm_2AntPsTdma(padapter, true, 7);
-					pBtdm8723->psTdmaDuAdjType = 7;
-				} else if (maxInterval == 2) {
-					btdm_2AntPsTdma(padapter, true, 7);
-					pBtdm8723->psTdmaDuAdjType = 7;
-				} else if (maxInterval == 3) {
-					btdm_2AntPsTdma(padapter, true, 7);
-					pBtdm8723->psTdmaDuAdjType = 7;
-				} else {
-					btdm_2AntPsTdma(padapter, true, 7);
-					pBtdm8723->psTdmaDuAdjType = 7;
-				}
+				btdm_2AntPsTdma(padapter, true, 7);
+				pBtdm8723->psTdmaDuAdjType = 7;
 			} else {
-				if (maxInterval == 1) {
-					btdm_2AntPsTdma(padapter, true, 3);
-					pBtdm8723->psTdmaDuAdjType = 3;
-				} else if (maxInterval == 2) {
-					btdm_2AntPsTdma(padapter, true, 3);
-					pBtdm8723->psTdmaDuAdjType = 3;
-				} else if (maxInterval == 3) {
-					btdm_2AntPsTdma(padapter, true, 3);
-					pBtdm8723->psTdmaDuAdjType = 3;
-				} else {
-					btdm_2AntPsTdma(padapter, true, 3);
-					pBtdm8723->psTdmaDuAdjType = 3;
-				}
+				btdm_2AntPsTdma(padapter, true, 3);
+				pBtdm8723->psTdmaDuAdjType = 3;
 			}
 		}
 		up = 0;
-- 
1.7.10.4

