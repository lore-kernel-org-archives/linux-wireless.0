Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbaCEMVR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:21:17 -0500
Date: Wed, 5 Mar 2014 13:23:59 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Pedro Francisco <pedrogfrancisco@gmail.com>
Subject: [RFC/RFT 10/9] iwlegacy: fix uninitialized var
Message-ID: <20140305122358.GA3022@redhat.com> (sfid-20140305_132120_996388_E5634C85)
References: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1394021614-11514-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 9f6c492..2cc8a54 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -1272,8 +1272,10 @@ il_send_scan_abort(struct il_priv *il)
 	    !test_bit(S_GEO_CONFIGURED, &il->status) ||
 	    !test_bit(S_SCAN_HW, &il->status) ||
 	    test_bit(S_FW_ERROR, &il->status) ||
-	    test_bit(S_EXIT_PENDING, &il->status))
+	    test_bit(S_EXIT_PENDING, &il->status)) {
+		ret = -EIO;
 		goto out;
+	}
 
 	ret = il_send_cmd_sync(il, &cmd);
 	if (ret)
