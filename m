Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57427 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331AbZCWP7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 11:59:42 -0400
Received: by fxm2 with SMTP id 2so1864991fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 08:59:39 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH1/2] Fix return value handling
Date: Mon, 23 Mar 2009 16:59:48 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com> <200903231313.10699.hs4233@mail.mn-solutions.de> <200903231657.24399.marek.vasut@gmail.com>
In-Reply-To: <200903231657.24399.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903231659.48903.marek.vasut@gmail.com> (sfid-20090323_165951_868328_92E2B377)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 of March 2009 16:57:24 Marek Vasut wrote:
> Hi,
> here is a resend. One patch per mail.
sorry, inlining

>From fd2e610a87a8372cbc513e336fa71e3438742c9d Mon Sep 17 00:00:00 2001
From: Marek Vasut <marek.vasut@gmail.com>
Date: Mon, 23 Mar 2009 15:57:11 +0100
Subject: [PATCH 1/2] Firmware loading functions can return possitive values
 This is not a bug, but take it into consideration and handle it properly.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/net/wireless/libertas/if_cs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c 
b/drivers/net/wireless/libertas/if_cs.c
index 842a08d..3f02e6a 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -867,9 +867,9 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
 
 	/* Load the firmware early, before calling into libertas.ko */
 	ret = if_cs_prog_helper(card);
-	if (ret == 0)
+	if (ret >= 0)
 		ret = if_cs_prog_real(card);
-	if (ret)
+	if (ret < 0)
 		goto out2;
 
 	/* Make this card known to the libertas driver */
-- 
1.6.2


