Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54696 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1F2Gcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 02:32:51 -0400
Date: Wed, 29 Jun 2011 09:31:49 +0300
From: Dan Carpenter <error27@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:RTL8192CE WIRELES..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] rtlwifi: potential forever loop in rtl92de_hw_init()
Message-ID: <20110629063149.GE14591@shale.localdomain> (sfid-20110629_083255_874481_80C296E3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"i" should be an int here because we are trying to use it to count
to 10000.  The original code looks like it could hang in a forever
loop.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
If we exit the loop via a timeout, that error isn't handled.  Should
we limp along, or return an error?

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index eedfb38..cbc0f40 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -908,7 +908,8 @@ int rtl92de_hw_init(struct ieee80211_hw *hw)
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl_ps_ctl *ppsc = rtl_psc(rtl_priv(hw));
 	bool rtstatus = true;
-	u8 tmp_u1b, i;
+	u8 tmp_u1b;
+	int i;
 	int err;
 	unsigned long flags;
 
