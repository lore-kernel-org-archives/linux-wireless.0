Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:36424 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYKLTKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 14:10:06 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: throughput problem/bisect with rtl8187B
Date: Wed, 12 Nov 2008 17:10:17 -0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <413196.94590.qm@web23107.mail.ird.yahoo.com>
In-Reply-To: <413196.94590.qm@web23107.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811121710.17957.herton@mandriva.com.br> (sfid-20081112_201011_941204_1F7B4D82)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 November 2008 23:12:42 Hin-Tak Leung wrote:
> --- On Tue, 11/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> > Please check this patch to see if things improve, if not,
> > can you check with
> > the patch I posted earlier, "Add conf_tx callback and
> > use it to configure tx
> > queues of 8187L/8187B.", if things improve? (I think
> > you already checked, but
> > just in case you tested only the rate control related
> > patch)
>
> okay, very good - this one does it. I didn't try the conf_tx callback patch
> when I posted the problem, but I did this time - so I have the conf_tx
> callback patch, feedback patch, and a modified version of this new one, and
> I get decent throughput; reverting the 3rd patch, (ie. just the conf_tx
> callback and feekback transmitted patch) and the throughput is appalling.
> So you can add tested-by me to both the conf_tx and feedback patches, and
> either tested-by or signed-off-by for this version of the 3rd patch (I made
> some small changes just so that it applies on top of the conf_tx patch
> which has a priv->slot_time rather than local slot_time). Sorry about the
> indentation - no doubt you'll polish it up before sending off the three.

Ok, Looks like sifs or eifs setting then expect values in another format or
have a different meaning may be (or just cause some hw bug), it's strange,
I suspect sifs value is the culprit. In the patch I just reverted to values vendor
driver uses, in it difs remains the same, just eifs isn't changed for short slot
case and kept with a default value (along with what is supposed to be ack
timeout register), and sifs set to 0x22. Please try just the following change
to isolate that the SIFS setting caused the throughput issue:

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index d49f2a7..c0392e4 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -924,7 +924,7 @@ static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
 			difs = 0x32;
 			eifs = 0x5b;
 		}
-		rtl818x_iowrite8(priv, &priv->map->SIFS, 0xa);
+		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 		rtl818x_iowrite8(priv, &priv->map->SLOT, slot_time);
 		rtl818x_iowrite8(priv, &priv->map->DIFS, difs);
 

>
> These 3 are tested against v2.6.28-rc4-5168-gaafbf3d (moved on a bit since
> my last tests).
>
> Thanks for looking into this.
>
> Hin-Tak

--
[]'s
Herton
