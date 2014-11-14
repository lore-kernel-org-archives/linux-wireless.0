Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49639 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422644AbaKNWMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 17:12:25 -0500
Received: by mail-ie0-f170.google.com with SMTP id tp5so18916162ieb.29
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2014 14:12:24 -0800 (PST)
Date: Fri, 14 Nov 2014 14:12:21 -0800
From: Dmitry Torokhov <dtor@chromium.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: fix error handling of irq_of_parse_and_map
Message-ID: <20141114221221.GA35541@dtor-ws> (sfid-20141114_231245_241043_A5D5208D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Return value of irq_of_parse_and_map() is unsigned int, with 0
indicating failure, so testing for negative result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---

Not tested, found by casual code inspection.

 drivers/net/wireless/brcm80211/brcmfmac/of.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/of.c b/drivers/net/wireless/brcm80211/brcmfmac/of.c
index eb3fce82..c824570 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/of.c
@@ -40,8 +40,8 @@ void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
 		return;
 
 	irq = irq_of_parse_and_map(np, 0);
-	if (irq < 0) {
-		brcmf_err("interrupt could not be mapped: err=%d\n", irq);
+	if (!irq) {
+		brcmf_err("interrupt could not be mapped\n");
 		devm_kfree(dev, sdiodev->pdata);
 		return;
 	}
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
