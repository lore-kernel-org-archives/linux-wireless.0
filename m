Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:47799 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbZAUUvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 15:51:12 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
Date: Wed, 21 Jan 2009 21:51:16 +0100
Cc: linux-wireless@vger.kernel.org
References: <200901211450.50880.chunkeey@web.de> <4977805E.70906@lwfinger.net>
In-Reply-To: <4977805E.70906@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901212151.16503.chunkeey@web.de> (sfid-20090121_215139_316825_B7D6390E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 January 2009 21:06:54 Larry Finger wrote:
> Christian Lamparter wrote:
> > This patch fixes a long standing issue in p54usb.
> >=20
> > Under high memory pressure, dev_alloc_skb couldn't always allocate =
a=20
> > replacement skb. In such situations, we had to free the associated =
urb.
> > And over the time all urbs were eventually gone altogether and=20
> > obviously the device remained mute from then on.
>=20
> With this patch, I get lots of missing rx_refill_* messages such as
>=20
> drivers/net/wireless/p54/p54usb.c:1024: error: =E2=80=98struct p54u_p=
riv=E2=80=99 has no member named
> =E2=80=98rx_refill_work=E2=80=99
> drivers/net/wireless/p54/p54usb.c:1025: error: =E2=80=98struct p54u_p=
riv=E2=80=99 has no member named
> =E2=80=98rx_refill_lock=E2=80=99
> drivers/net/wireless/p54/p54usb.c:1026: error: =E2=80=98struct p54u_p=
riv=E2=80=99 has no member named
> =E2=80=98rx_refill_list=E2=80=99
>=20
> Did I miss a patch? I did a search for the string "rx_refill" in my e=
ntire mailbox and
> found only this mail and Artur's reply.
>=20
No, you don't miss anything... here's the other p54usb.h change.

Sorry!

Regards,
	Chr
---
diff --git a/drivers/net/wireless/p54/p54usb.h b/drivers/net/wireless/p=
54/p54usb.h
index 8bc5898..04c7258 100644
--- a/drivers/net/wireless/p54/p54usb.h
+++ b/drivers/net/wireless/p54/p54usb.h
@@ -134,6 +134,10 @@ struct p54u_priv {
=20
 	spinlock_t lock;
 	struct sk_buff_head rx_queue;
+	spinlock_t rx_refill_lock;
+	struct list_head rx_refill_list;
+	struct work_struct rx_refill_work;
+
 	struct usb_anchor submitted;
 };
=20



--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
