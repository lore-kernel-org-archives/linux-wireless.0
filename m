Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50103 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499Ab2JNUQC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2012 16:16:02 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2145251bkc.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Oct 2012 13:16:00 -0700 (PDT)
Subject: [PATCH] rtlwifi: pass rx setup error code to caller
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org, Joshua.Roys@gtri.gatech.edu,
	linville@tuxdriver.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 14 Oct 2012 22:15:48 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201210142215.48645.chunkeey@googlemail.com> (sfid-20121014_221606_171797_9F4B162E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If _rtl_usb_receive fails, the device is
probably not ready. Hence the error code
should be passed to the caller, so it can
react accordingly and notify the user.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 rtlwifi/usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rtlwifi/usb.c b/rtlwifi/usb.c
index d7744e1..696d29f 100644
--- a/rtlwifi/usb.c
+++ b/rtlwifi/usb.c
@@ -682,7 +682,7 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
 		set_hal_start(rtlhal);
 
 		/* Start bulk IN */
-		_rtl_usb_receive(hw);
+		err = _rtl_usb_receive(hw);
 	}
 
 	return err;
-- 
1.7.10.4

