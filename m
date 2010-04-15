Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756682Ab0DOUdg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 16:33:36 -0400
Subject: [PATCH 2/2] libertas: Davinci platforms need more time loading
 helper firmware
From: Dan Williams <dcbw@redhat.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Alagu Sankar <alagusankar@gmail.com>
In-Reply-To: <1271363264.10765.3.camel@localhost.localdomain>
References: <1271363264.10765.3.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 13:32:58 -0700
Message-ID: <1271363578.10765.8.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Davinci platforms apparently need more time in-between helper firmware
blocks.  Even though this is an increased delay, we only take this hit
once at initialization time.

Signed-off-by: Dan Williams <dcbw@redhat.com>

---
diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
index dcd14da..2e71dae 100644
--- a/drivers/net/wireless/libertas/if_sdio.c
+++ b/drivers/net/wireless/libertas/if_sdio.c
@@ -497,6 +497,11 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
 		if (ret)
 			goto release;
 
+		/* On some platforms (like Davinci) the chip needs more time
+		 * between helper blocks.
+		 */
+		mdelay(2);
+
 		chunk_size = min(size, (size_t)60);
 
 		*((__le32*)chunk_buffer) = cpu_to_le32(chunk_size);


