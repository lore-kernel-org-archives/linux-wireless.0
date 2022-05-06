Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C366C433FE
	for <linux-wireless@archiver.kernel.org>; Fri,  6 May 2022 17:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444203AbiEFR24 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 May 2022 13:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444199AbiEFR2z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 May 2022 13:28:55 -0400
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4EC4D6D944;
        Fri,  6 May 2022 10:25:11 -0700 (PDT)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 9923C72C8FA;
        Fri,  6 May 2022 20:25:10 +0300 (MSK)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by imap.altlinux.org (Postfix) with ESMTP id 4885B4A46EE;
        Fri,  6 May 2022 20:25:10 +0300 (MSK)
From:   Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] rfkill: uapi: fix RFKILL_IOCTL_MAX_SIZE ioctl request definition
Date:   Fri,  6 May 2022 17:24:54 +0000
Message-Id: <20220506172454.120319-1-glebfm@altlinux.org>
X-Mailer: git-send-email 2.33.3
In-Reply-To: <20220506171534.99509-1-glebfm@altlinux.org>
References: <20220506171534.99509-1-glebfm@altlinux.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes: 54f586a91532 ("rfkill: make new event layout opt-in")
Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Gleb Fotengauer-Malinovskiy <glebfm@altlinux.org>
---
 include/uapi/linux/rfkill.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/rfkill.h b/include/uapi/linux/rfkill.h
index 283c5a7b3f2c..db6c8588c1d0 100644
--- a/include/uapi/linux/rfkill.h
+++ b/include/uapi/linux/rfkill.h
@@ -184,7 +184,7 @@ struct rfkill_event_ext {
 #define RFKILL_IOC_NOINPUT	1
 #define RFKILL_IOCTL_NOINPUT	_IO(RFKILL_IOC_MAGIC, RFKILL_IOC_NOINPUT)
 #define RFKILL_IOC_MAX_SIZE	2
-#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_EXT_SIZE, __u32)
+#define RFKILL_IOCTL_MAX_SIZE	_IOW(RFKILL_IOC_MAGIC, RFKILL_IOC_MAX_SIZE, __u32)
 
 /* and that's all userspace gets */
 
-- 
glebfm

