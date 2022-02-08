Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69826C43217
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Feb 2022 11:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357033AbiBHLbu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Feb 2022 06:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356448AbiBHKrq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Feb 2022 05:47:46 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEB2C03FEC0;
        Tue,  8 Feb 2022 02:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=0dqhvmwEdAX++oVGM1+TtEeGArLVwX6xnXfCDjA3GJM=; t=1644317265; x=1645526865; 
        b=NVmqo931x3XdFrXgpgK7H3FPtlP5HPHCIwMOAOHsjYQZtiK8cS8eOSJ5WFOEYnulDw724wQn91f
        f/2e+UvQR+sbSsEpKPsaz2ABY1FyAZVmEO75npOgrd9dEhoXBH7lA2hI4ap+nuoGEjt3mdLlGgoyH
        XfcWVNmlBkaEfJUKEhm1tAfnzpHrs1sqpVmOigof1PlZRafr4DPm8CJrX/eyhneS9B9vmolBfbUFk
        ix7/FnJcw9v7eBulIn1t7bz8ee924YFlpfl+fY3OMo1B53TctPH+ZfBvyy+HoEtL2wkxdSOng+CWj
        T4t8ZVgmW+jMlHzv7mDRJ5hbmVRXDYuE51bQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nHO26-00G00u-Hv;
        Tue, 08 Feb 2022 11:47:38 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>, stable@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>,
        Wolfgang Walter <linux@stwm.de>,
        Jason Self <jason@bluehome.net>,
        Dominik Behr <dominik@dominikbehr.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH] iwlwifi: fix use-after-free
Date:   Tue,  8 Feb 2022 11:47:30 +0100
Message-Id: <20220208114728.e6b514cf4c85.Iffb575ca2a623d7859b542c33b2a507d01554251@changeid>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

If no firmware was present at all (or, presumably, all of the
firmware files failed to parse), we end up unbinding by calling
device_release_driver(), which calls remove(), which then in
iwlwifi calls iwl_drv_stop(), freeing the 'drv' struct. However
the new code I added will still erroneously access it after it
was freed.

Set 'failure=false' in this case to avoid the access, all data
was already freed anyway.

Cc: stable@vger.kernel.org
Reported-by: Stefan Agner <stefan@agner.ch>
Reported-by: Wolfgang Walter <linux@stwm.de>
Reported-by: Jason Self <jason@bluehome.net>
Reported-by: Dominik Behr <dominik@dominikbehr.com>
Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Fixes: ab07506b0454 ("iwlwifi: fix leaks/bad data after failed firmware load")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 83e3b731ad29..6651e78b39ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1707,6 +1707,8 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
  out_unbind:
 	complete(&drv->request_firmware_complete);
 	device_release_driver(drv->trans->dev);
+	/* drv has just been freed by the release */
+	failure = false;
  free:
 	if (failure)
 		iwl_dealloc_ucode(drv);
-- 
2.34.1

