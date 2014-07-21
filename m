Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:56400 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaGUICU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 04:02:20 -0400
Received: by mail-we0-f173.google.com with SMTP id q58so7181131wes.18
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 01:02:18 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: bzhao@marvell.com, daniel@zonque.org,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v2 1/1] mwifiex: card reset: enable rescan of non-removable card
Date: Mon, 21 Jul 2014 10:01:52 +0200
Message-Id: <1405929712-27268-2-git-send-email-afenkart@gmail.com> (sfid-20140721_100229_736713_D4689613)
In-Reply-To: <1405929712-27268-1-git-send-email-afenkart@gmail.com>
References: <CALtMJEAwvMrZcFW7+ACgDNRVi+O5LE0p8gRUTUN3pNh8N1Eiog@mail.gmail.com>
 <1405929712-27268-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mmc_rescan will scan for non-removable cards only once, hence the card
will not be rediscovered.

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 4ce3d7b..ef22d59 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1931,6 +1931,7 @@ static void sdio_card_reset_worker(struct work_struct *work)
 	mmc_remove_host(target);
 	/* 20ms delay is based on experiment with sdhci controller */
 	mdelay(20);
+	target->rescan_entered = 0; /* rescan non-removable cards */
 	mmc_add_host(target);
 }
 static DECLARE_WORK(card_reset_work, sdio_card_reset_worker);
-- 
2.0.1

