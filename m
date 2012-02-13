Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2BMKXr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Feb 2012 05:23:47 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 01/24] iwlegacy: dump stack when fail to gain access to the device
Date: Mon, 13 Feb 2012 11:23:08 +0100
Message-Id: <1329128611-6815-2-git-send-email-sgruszka@redhat.com> (sfid-20120213_112351_109980_3D7E1851)
In-Reply-To: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
References: <1329128611-6815-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print dump stack when the device is not responding. This should give
some more clue about the reason of failure. Also change the message we
print, since "MAC in deep sleep" is kinda confusing.

On the way add unlikely(), as fail to gain NIC access is hmm ...
unlikely.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 04ec38e..3900967 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -111,9 +111,10 @@ _il_grab_nic_access(struct il_priv *il)
 	    _il_poll_bit(il, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
 			 (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
 			  CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
-	if (ret < 0) {
+	if (unlikely(ret < 0)) {
 		val = _il_rd(il, CSR_GP_CNTRL);
-		IL_ERR("MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
+		WARN_ONCE(1, "Timeout waiting for ucode processor access "
+			     "(CSR_GP_CNTRL 0x%08x)\n", val);
 		_il_wr(il, CSR_RESET, CSR_RESET_REG_FLAG_FORCE_NMI);
 		return -EIO;
 	}
-- 
1.7.1

