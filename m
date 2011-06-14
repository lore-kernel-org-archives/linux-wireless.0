Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:56190 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1FNFx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 01:53:59 -0400
Received: from kpbe18.cbf.corp.google.com (kpbe18.cbf.corp.google.com [172.25.105.82])
	by smtp-out.google.com with ESMTP id p5E5rtc7019044
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 22:53:55 -0700
Received: from pvf33 (pvf33.prod.google.com [10.241.210.97])
	by kpbe18.cbf.corp.google.com with ESMTP id p5E5rr2e027706
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 22:53:54 -0700
Received: by pvf33 with SMTP id 33so2585876pvf.38
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 22:53:53 -0700 (PDT)
Subject: [PATCH][TRIVIAL] if_spi: Fix compilation warning - unused variable
From: Nikanth Karthikesan <nikanth@google.com>
To: Dan Williams <dcbw@redhat.com>
Cc: libertas-dev@lists.infradead.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Kosina <trivial@kernel.org>
In-Reply-To: <1307976362.2117.4.camel@dcbw.foobar.com>
References: <1307696222.28682.20.camel@nikanth.blr.corp.google.com>
	 <1307976362.2117.4.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jun 2011 11:23:46 +0530
Message-ID: <1308030827.28682.32.camel@nikanth.blr.corp.google.com> (sfid-20110614_075404_250233_A7753AD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if_spi: Fix compilation warning - unused variable 'spi'

drivers/net/wireless/libertas/if_spi.c: In function ‘if_spi_init_card’:
drivers/net/wireless/libertas/if_spi.c:1035: warning: unused variable ‘spi’

The variable is used only in a macro which uses the args only for DEBUG builds.
Remove the 'spi' variable completely.

Signed-off-by: Nikanth Karthikesan <nikanth@google.com>

---

Index: linux-2.6/drivers/net/wireless/libertas/if_spi.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/libertas/if_spi.c	2011-06-10 14:16:17.990985032 +0530
+++ linux-2.6/drivers/net/wireless/libertas/if_spi.c	2011-06-14 09:33:16.151025614 +0530
@@ -1032,7 +1032,6 @@
 static int if_spi_init_card(struct if_spi_card *card)
 {
 	struct lbs_private *priv = card->priv;
-	struct spi_device *spi = card->spi;
 	int err, i;
 	u32 scratch;
 	const struct firmware *helper = NULL;
@@ -1080,8 +1079,9 @@
 				"attached to SPI bus_num %d, chip_select %d. "
 				"spi->max_speed_hz=%d\n",
 				card->card_id, card->card_rev,
-				spi->master->bus_num, spi->chip_select,
-				spi->max_speed_hz);
+				card->spi->master->bus_num,
+				card->spi->chip_select,
+				card->spi->max_speed_hz);
 		err = if_spi_prog_helper_firmware(card, helper);
 		if (err)
 			goto out;


