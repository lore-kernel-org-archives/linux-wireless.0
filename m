Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758891AbcHYPM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 11:12:29 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3/3] mwifiex: do not print dot when downloading FW
Date: Thu, 25 Aug 2016 17:05:18 +0200
Message-Id: <1472137518-10431-4-git-send-email-sgruszka@redhat.com> (sfid-20160825_171233_254344_F1ABA9F5)
In-Reply-To: <1472137518-10431-1-git-send-email-sgruszka@redhat.com>
References: <1472137518-10431-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Printing about 3000 lines like this

[   20.691850] mwifiex_pcie 0000:02:00.0: .
[   20.693466] mwifiex_pcie 0000:02:00.0: .

is not useful. If FW downloading will be interrupted, we will get
proper error message about that.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 2f555b0..50a6a53 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1956,8 +1956,6 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 			if (firmware_len - offset < txlen)
 				txlen = firmware_len - offset;
 
-			mwifiex_dbg(adapter, INFO, ".");
-
 			tx_blocks = (txlen + card->pcie.blksz_fw_dl - 1) /
 				    card->pcie.blksz_fw_dl;
 
-- 
1.8.3.1
