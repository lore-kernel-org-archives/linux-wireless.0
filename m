Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:41889 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbZCWMNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 08:13:21 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH] Marvell CF8381
Date: Mon, 23 Mar 2009 13:13:10 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com>
In-Reply-To: <200903220127.21836.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903231313.10699.hs4233@mail.mn-solutions.de> (sfid-20090323_131330_382266_61BCDDEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marek !

Great.


Some nitpicks:

1. you attached the patches, not inline
2. There's no signed-off
3. You didn't submit one mail per patch

All of this makes review harder. If you adhere a bit to
Documentation/SubmittingPatches you'd get the fame all by
yourself :-)


Some more rants:


--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -273,7 +273,14 @@ static int if_cs_poll_while_fw_download(struct if_cs_card *card, uint addr, u8 r
  */
 #define IF_CS_PRODUCT_ID               0x0000001C
 #define IF_CS_CF8385_B1_REV            0x12
+#define        IF_CS_CF8381_B3_REV             0x04

Here's a tab, not a space. Maybe you run scripts/checkpatch.pl on it as well?




-       if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
+       if (!(p_dev->manf_id == CF8381_MANFID &&
+               p_dev->card_id == CF8381_CARDID) &&
+               (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV)) {

I think change then breaks the existing logic for 8385 cards.
code broke then the 8385 case. Therefore a NAK for now.




Kindly repost both patches again, with signed-off and fixes, thanks!
