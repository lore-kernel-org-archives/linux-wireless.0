Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62638 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3KYCLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 21:11:16 -0500
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MWS00I7WRER7NE0@mailout4.samsung.com> for
 linux-wireless@vger.kernel.org; Mon, 25 Nov 2013 11:11:15 +0900 (KST)
From: Jingoo Han <jg1.han@samsung.com>
To: "'John W. Linville'" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>,
	'Dan Williams' <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org
Subject: [PATCH] wireless: libertas: remove unnecessary spi_set_drvdata()
Date: Mon, 25 Nov 2013 11:11:15 +0900
Message-id: <001a01cee983$9eb1c0c0$dc154240$%han@samsung.com> (sfid-20131125_031123_866755_35A80BB1)
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/net/wireless/libertas/if_spi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 8366915..f11728a 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -93,7 +93,6 @@ static void free_if_spi_card(struct if_spi_card *card)
 		list_del(&packet->list);
 		kfree(packet);
 	}
-	spi_set_drvdata(card->spi, NULL);
 	kfree(card);
 }
 
-- 
1.7.10.4


