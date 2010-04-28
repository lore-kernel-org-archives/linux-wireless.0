Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0D1Thu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 15:37:50 -0400
Subject: [PATCH] libertas: fix 8686 firmware loading regression in
 96021f096e5178582af296a2fbb6df7dbd6b695c
From: Dan Williams <dcbw@redhat.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Steve deRosier <steve@cozybit.com>,
	Alagu Sankar <alagusankar@gmail.com>
In-Reply-To: <1272413690.32717.10.camel@localhost.localdomain>
References: <i2y446ae9281004271235sf6f04323j2faa28108481d81b@mail.gmail.com>
	 <1272413690.32717.10.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 12:37:46 -0700
Message-ID: <1272483466.14103.4.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'ready' condition was incorrectly evaluated which sometimes lead to
failures loading the second-stage firmware on 8686 devices.

Signed-off-by: Dan Williams <dcbw@redhat.com>

---
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index 13dfeda..64dd345 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -324,7 +324,9 @@ static int if_sdio_wait_status(struct if_sdio_card *card, const u8 condition)
 	timeout = jiffies + HZ;
 	while (1) {
 		status = sdio_readb(card->func, IF_SDIO_STATUS, &ret);
-		if (ret || (status & condition))
+		if (ret)
+			return ret;
+		if ((status & condition) == condition)
 			break;
 		if (time_after(jiffies, timeout))
 			return -ETIMEDOUT;


