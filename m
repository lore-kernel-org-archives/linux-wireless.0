Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56903 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbZCWV6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 17:58:52 -0400
Received: by fxm2 with SMTP id 2so2012200fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 14:58:49 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Marvell CF8381
Date: Mon, 23 Mar 2009 22:58:57 +0100
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com> <200903231327.18890.hs4233@mail.mn-solutions.de> <1237824927.14758.20.camel@localhost.localdomain>
In-Reply-To: <1237824927.14758.20.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903232258.57323.marek.vasut@gmail.com> (sfid-20090323_225855_409197_71D2D74A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 of March 2009 17:15:27 Dan Williams wrote:
> On Mon, 2009-03-23 at 13:27 +0100, Holger Schurig wrote:
> > > -       priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
> > > +       priv->regioncode = (le16_to_cpu(cmd.regioncode) &
> >
> > 0xFF00) >> 8;
> >
> > Hmm, the change that this breaks 8385 is quite high, maybe 100
> > percent.
>
> The cf8385-5.0.16.p0-26306 (gumstix) driver has:
>
> 	Adapter->RegionCode = wlan_le16_to_cpu(hwspec->RegionCode) >> 8;
>
> So it appears there's precedent for this even on 8385 parts.
>
> Dan
>
> > It could simply be the case that your firmware returns the value
> > in a different order than mine. So we either need to test for the
> > firmware version or for the hardware before getting the value via
> > one or the other method.
> >
> > Maybe it's worthwhile to create some hw_is_8381() function and
> > then do the things that need to be differently based on it's
> > return value?
> >
> >
> >
> > The documentation for CMG_GET_HW_SPEC that I have says
> >
> > RegionCode   UINT16    Set to 0
> >
> > so I see no indicator that we have two 8 bit values here. But
> > we've seen bugs in docs before :-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

Ok, so this should be it. I dropped the 8305 support since I found I have some 
issues with it still.

>From 3ac8f34db9c4d96197fbdc2776ebbcd571e3fbbe Mon Sep 17 00:00:00 2001
From: Marek Vasut <marek.vasut@gmail.com>
Date: Mon, 23 Mar 2009 22:55:51 +0100
Subject: [PATCH] Add support for CF8381 WiFi card.
 A detection function was added for identifying CF8381.

Signed-off-by: <marek.vasut@gmail.com>
---
 drivers/net/wireless/libertas/if_cs.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c 
b/drivers/net/wireless/libertas/if_cs.c
index 3f02e6a..56b6475 100644
--- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -273,7 +273,20 @@ static int if_cs_poll_while_fw_download(struct if_cs_card 
*card, uint addr, u8 r
  */
 #define IF_CS_PRODUCT_ID               0x0000001C
 #define IF_CS_CF8385_B1_REV            0x12
+#define IF_CS_CF8381_B3_REV            0x04

+/*
+ * Used to detect other cards than CF8385 since their revisions of silicon
+ * doesn't match those from CF8385, eg. CF8381 B3 works with this driver.
+ */
+#define CF8381_MANFID          0x02db
+#define CF8381_CARDID          0x6064
+
+static inline int if_cs_hw_is_cf8381(struct pcmcia_device *p_dev)
+{
+       return (p_dev->manf_id == CF8381_MANFID &&
+               p_dev->card_id == CF8381_CARDID);
+}

 /********************************************************************/
 /* I/O and interrupt handling                                       */
@@ -757,6 +770,7 @@ static void if_cs_release(struct pcmcia_device *p_dev)
 static int if_cs_probe(struct pcmcia_device *p_dev)
 {
        int ret = -ENOMEM;
+       unsigned int prod_id;
        struct lbs_private *priv;
        struct if_cs_card *card;
        /* CIS parsing */
@@ -859,7 +873,14 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
               p_dev->io.BasePort1 + p_dev->io.NumPorts1 - 1);

        /* Check if we have a current silicon */
-       if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
+       prod_id = if_cs_read8(card, IF_CS_PRODUCT_ID);
+       if (if_cs_hw_is_cf8381(p_dev) && prod_id < IF_CS_CF8381_B3_REV) {
+               lbs_pr_err("old chips like 8381 rev B3 aren't supported\n");
+               ret = -ENODEV;
+               goto out2;
+       }
+
+       if (prod_id < IF_CS_CF8385_B1_REV) {
                lbs_pr_err("old chips like 8385 rev B1 aren't supported\n");
                ret = -ENODEV;
                goto out2;
@@ -950,6 +971,7 @@ static void if_cs_detach(struct pcmcia_device *p_dev)
 /********************************************************************/

 static struct pcmcia_device_id if_cs_ids[] = {
+       PCMCIA_DEVICE_MANF_CARD(CF8381_MANFID, CF8381_CARDID),
        PCMCIA_DEVICE_MANF_CARD(0x02df, 0x8103),
        PCMCIA_DEVICE_NULL,
 };
--
1.6.2

