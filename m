Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47009 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759785AbcHYP3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 11:29:44 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/3] mwifiex: print status of FW ready event
Date: Thu, 25 Aug 2016 17:05:17 +0200
Message-Id: <1472137518-10431-3-git-send-email-sgruszka@redhat.com> (sfid-20160825_173006_211961_A2221C99)
In-Reply-To: <1472137518-10431-1-git-send-email-sgruszka@redhat.com>
References: <1472137518-10431-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For debugging purpose print content of reg->fw_status register and other
variables values when waiting for firmware ready event.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 8abbbfe..2f555b0 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2043,6 +2043,10 @@ mwifiex_check_fw_status(struct mwifiex_adapter *adapter, u32 poll_num)
 			ret = -1;
 		else
 			ret = 0;
+
+		mwifiex_dbg(adapter, INFO, "Try %d if FW is ready <%d,%#x>",
+			    tries, ret, firmware_stat);
+
 		if (ret)
 			continue;
 		if (firmware_stat == FIRMWARE_READY_PCIE) {
-- 
1.8.3.1
