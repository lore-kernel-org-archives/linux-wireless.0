Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:44449 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab3CSMS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 08:18:59 -0400
Received: by mail-ee0-f50.google.com with SMTP id e51so204568eek.23
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 05:18:57 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: extract board_type from SPROM
Date: Tue, 19 Mar 2013 13:18:44 +0100
Message-Id: <1363695524-22064-2-git-send-email-zajec5@gmail.com> (sfid-20130319_131901_802910_87163CD3)
In-Reply-To: <1363695524-22064-1-git-send-email-zajec5@gmail.com>
References: <1363695524-22064-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 4adf9ef..8934298 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -217,6 +217,7 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 	}
 
 	SPEX(board_rev, SSB_SPROM8_BOARDREV, ~0, 0);
+	SPEX(board_type, SSB_SPROM1_SPID, ~0, 0);
 
 	SPEX(txpid2g[0], SSB_SPROM4_TXPID2G01, SSB_SPROM4_TXPID2G0,
 	     SSB_SPROM4_TXPID2G0_SHIFT);
-- 
1.7.10.4

