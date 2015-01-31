Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:59138 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbbAaPAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 10:00:00 -0500
Received: by mail-wg0-f53.google.com with SMTP id a1so31465242wgh.12
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 06:59:59 -0800 (PST)
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Greg Donald <gdonald@gmail.com>,
	Yeliz Taneroglu <yeliztaneroglu@gmail.com>,
	Tina Ruchandani <ruchandani.tina@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8723au: core: rtw_security: Removed variables that is never used
Date: Sat, 31 Jan 2015 16:03:20 +0100
Message-Id: <1422716600-4498-1-git-send-email-rickard_strandqvist@spectrumdigital.se> (sfid-20150131_160025_333799_2830E070)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Variable was assigned a value that was never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/rtl8723au/core/rtw_security.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
index 715a474..8799ba4 100644
--- a/drivers/staging/rtl8723au/core/rtw_security.c
+++ b/drivers/staging/rtl8723au/core/rtw_security.c
@@ -612,7 +612,6 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 	u8   hw_hdr_offset = 0;
 	struct arc4context mycontext;
 	int			curfragnum, length;
-	u32	prwskeylen;
 	u8	*pframe, *payload, *iv, *prwskey;
 	union pn48 dot11txpn;
 	struct	sta_info		*stainfo;
@@ -651,8 +650,6 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
 			else
 				prwskey = &stainfo->dot118021x_UncstKey.skey[0];
 
-			prwskeylen = 16;
-
 			for (curfragnum = 0;curfragnum<pattrib->nr_frags;curfragnum++) {
 				iv = pframe+pattrib->hdrlen;
 				payload = pframe+pattrib->iv_len+pattrib->hdrlen;
-- 
1.7.10.4

