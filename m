Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03350CCA47C
	for <linux-wireless@archiver.kernel.org>; Sun, 12 Jun 2022 19:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiFLTzG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 12 Jun 2022 15:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234538AbiFLTzF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Jun 2022 15:55:05 -0400
Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB38D5A0AC
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2022 12:55:03 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 0TfnoXfr5OOQ10TfooLdpb; Sun, 12 Jun 2022 21:55:01 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 12 Jun 2022 21:55:01 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] p54: Fix an error handling path in p54spi_probe()
Date:   Sun, 12 Jun 2022 21:54:58 +0200
Message-Id: <41d88dff4805800691bf4909b14c6122755f7e28.1655063685.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If an error occurs after a successful call to p54spi_request_firmware(), it
must be undone by a corresponding release_firmware() as already done in
the error handling path of p54spi_request_firmware() and in the .remove()
function.

Add the missing call in the error handling path and update some goto
label accordingly.

Fixes: cd8d3d321285 ("p54spi: p54spi driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/intersil/p54/p54spi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/p54spi.c b/drivers/net/wireless/intersil/p54/p54spi.c
index f99b7ba69fc3..679ac164c994 100644
--- a/drivers/net/wireless/intersil/p54/p54spi.c
+++ b/drivers/net/wireless/intersil/p54/p54spi.c
@@ -650,14 +650,16 @@ static int p54spi_probe(struct spi_device *spi)
 
 	ret = p54spi_request_eeprom(hw);
 	if (ret)
-		goto err_free_common;
+		goto err_release_firmaware;
 
 	ret = p54_register_common(hw, &priv->spi->dev);
 	if (ret)
-		goto err_free_common;
+		goto err_release_firmaware;
 
 	return 0;
 
+err_release_firmaware:
+	release_firmware(priv->firmware);
 err_free_common:
 	free_irq(gpio_to_irq(p54spi_gpio_irq), spi);
 err_free_gpio_irq:
-- 
2.34.1

