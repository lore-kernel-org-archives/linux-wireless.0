Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:46692 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbbAaPBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 10:01:39 -0500
Received: by mail-we0-f172.google.com with SMTP id q59so31791728wes.3
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 07:01:38 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Raphael Silva <rapphil@gmail.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: core: rtw_sta_mgt: Removed variables that is never used
Date: Sat, 31 Jan 2015 16:04:59 +0100
Message-Id: <1422716699-4774-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20150131_160155_281734_52A10551)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable was assigned a value that was never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
index d17998d..7a9feb6 100644
--- a/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
+++ b/drivers/staging/rtl8723au/core/rtw_sta_mgt.c
@@ -390,7 +390,6 @@ int rtw_init_bcmc_stainfo23a(struct rtw_adapter *padapter)
 {
 	struct	sta_priv *pstapriv = &padapter->stapriv;
 	struct sta_info		*psta;
-	struct tx_servq	*ptxservq;
 	int res = _SUCCESS;
 
 	psta = rtw_alloc_stainfo23a(pstapriv, bc_addr, GFP_KERNEL);
@@ -403,7 +402,6 @@ int rtw_init_bcmc_stainfo23a(struct rtw_adapter *padapter)
 	/*  default broadcast & multicast use macid 1 */
 	psta->mac_id = 1;
 
-	ptxservq = &psta->sta_xmitpriv.be_q;
 	return _SUCCESS;
 }
 
-- 
1.7.10.4

