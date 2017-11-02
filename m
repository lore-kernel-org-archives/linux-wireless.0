Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933071AbdKBJaR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 05:30:17 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Juliana Rodrigues <juliana.orod@gmail.com>
Subject: [PATCH 1/3] staging: rtl8188eu: Revert part of "staging: rtl8188eu: fix comments with lines over 80 characters"
Date: Thu,  2 Nov 2017 10:30:11 +0100
Message-Id: <20171102093013.10745-1-hdegoede@redhat.com> (sfid-20171102_103021_390195_392BFE4A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 74e1e498e84e ("staging: rtl8188eu: fix comments with lines over 80
characters") not only changed comments but also changed an if check:

-if (pmlmepriv->cur_network.join_res != true) {
+if (!(pmlmepriv->cur_network.join_res)) {

This is not equivalent as join_res is an int and can have values such
as -2 and -3.

Note for the next time, please only make one type of changes in a single
clean-up commit.

Fixes: 74e1e498e84e ("staging: rtl8188eu: fix comments with lines over 80 ...")
Cc: Juliana Rodrigues <juliana.orod@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/staging/rtl8188eu/core/rtw_ap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
index 32a483769975..fa611455109a 100644
--- a/drivers/staging/rtl8188eu/core/rtw_ap.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
@@ -754,7 +754,7 @@ static void start_bss_network(struct adapter *padapter, u8 *pbuf)
 	}
 
 	/* setting only at  first time */
-	if (!(pmlmepriv->cur_network.join_res)) {
+	if (pmlmepriv->cur_network.join_res != true) {
 		/* WEP Key will be set before this function, do not
 		 * clear CAM.
 		 */
-- 
2.14.2
