Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:49388 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab2AaT0a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 14:26:30 -0500
Subject: [PATCH] ath6kl: fix compiler warning in ath6kl_init_hw_params()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 31 Jan 2012 21:26:22 +0200
Message-ID: <20120131192622.12404.74061.stgit@localhost6.localdomain6> (sfid-20120131_202634_337402_2B26A3AF)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both Luis and John reported that they see a compiler warning:

drivers/net/wireless/ath/ath6kl/init.c: In function 'ath6kl_init_hw_params':
drivers/net/wireless/ath/ath6kl/init.c:1377:26: warning: ‘hw’
may be used uninitialized in this function

Oddly enough I have never seen it. But AFAICT the code is correct and
hw is not used uninitalized so add uninitialized_var() to inform that to
the compiler.

Reported-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Reported-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index bf56e5f..0d76c37 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1470,7 +1470,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 
 int ath6kl_init_hw_params(struct ath6kl *ar)
 {
-	const struct ath6kl_hw *hw;
+	const struct ath6kl_hw *uninitialized_var(hw);
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {

