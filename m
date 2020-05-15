Return-Path: <SRS0=zRRP=65=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C80C433E1
	for <linux-wireless@archiver.kernel.org>; Fri, 15 May 2020 21:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2074420709
	for <linux-wireless@archiver.kernel.org>; Fri, 15 May 2020 21:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589578165;
	bh=axO7uaYrjQR5BXFcyfzz5CtxMgICxAqYcDU4Tgu6OYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FAIKU0sZKuZyf5PL8azhbQpui2na4kH0/zK+Ap/+q5q9kE6jO7A9vvqKAmwj8Kfns
	 YqYof2h926Nv0G0PbT8OYmzNJ6DKnSKiAqQyaHqzHsDp42RkJTXg0xcoMjbXP+oQ+S
	 0nkyr6Yueg7ofXg77NgI9aD2SYHpR0JtGRONxVhk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgEOV3U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 May 2020 17:29:20 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38031 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727972AbgEOV3J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 May 2020 17:29:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id y25so1601914pfn.5;
        Fri, 15 May 2020 14:29:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyaNKYj+csWx0v5/RRrrvPiG/GlOrf9rCpyGTc2gDv0=;
        b=PNU2WB7xGk4aeo9LqsRnFBNqh2ufNpsh3E2UmToKGNuzHfu5s+ztk+s6S6VUKmq0C/
         iwuKhe46HL2A2VjsuMCiBG1UUq668ruWKtTYFkzSo6RRrX/zBJOPXhRKnsWG3B0dZ2hW
         bWS2BRDcZKdi0ogAgjbkHYrTzBOU4NRKRmSTPmsBmzjqEpdkwG3CiEBpgHGmHoGOpB6R
         79oBGxLCemAvW7+V9HRYSkPx8A6zubaw+QyShr460zkG2LBJNAtE7VyZ2ppalO/b0PTK
         iMKzu8k478e+nghLjgvLqcZuQkCqBKzZEUEUe5QfMFc988OM7X2xv4dSblScsJRps6Fl
         5B1A==
X-Gm-Message-State: AOAM531hGbKW+WC3F5TKCbWmueDzmsXgOmOREtXk4XgjwqnH/lMZEyw5
        Y6Oh5B+/fqtxcGWbDJ81iE4=
X-Google-Smtp-Source: ABdhPJzT8OuJIcMz4maB705Q5rp4ih5zCp5ALUBnEyTPR7+PH8X96oQqmCWUmGTpOQxsyRkd6WhDeA==
X-Received: by 2002:aa7:8a92:: with SMTP id a18mr5990105pfc.0.1589578148396;
        Fri, 15 May 2020 14:29:08 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 19sm2216513pjl.52.2020.05.15.14.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 14:29:04 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 7975D4238B; Fri, 15 May 2020 21:28:50 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     jeyu@kernel.org
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        linux-wireless@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Subject: [PATCH v2 15/15] mwl8k: use new module_firmware_crashed()
Date:   Fri, 15 May 2020 21:28:46 +0000
Message-Id: <20200515212846.1347-16-mcgrof@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20200515212846.1347-1-mcgrof@kernel.org>
References: <20200515212846.1347-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This makes use of the new module_firmware_crashed() to help
annotate when firmware for device drivers crash. When firmware
crashes devices can sometimes become unresponsive, and recovery
sometimes requires a driver unload / reload and in the worst cases
a reboot.

Using a taint flag allows us to annotate when this happens clearly.

Cc: linux-wireless@vger.kernel.org
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/net/wireless/marvell/mwl8k.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 97f23f93f6e7..d609ef1bb879 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1551,6 +1551,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
 	 * the firmware has crashed
 	 */
 	if (priv->hw_restart_in_progress) {
+		module_firmware_crashed();
 		if (priv->hw_restart_owner == current)
 			return 0;
 		else
-- 
2.26.2

