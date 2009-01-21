Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:49610 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbZAUUHE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 15:07:04 -0500
Message-ID: <4977805E.70906@lwfinger.net> (sfid-20090121_210710_769759_7324E6FE)
Date: Wed, 21 Jan 2009 14:06:54 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC][RFT][PATCH] p54usb: rx refill revamp
References: <200901211450.50880.chunkeey@web.de>
In-Reply-To: <200901211450.50880.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch fixes a long standing issue in p54usb.
>=20
> Under high memory pressure, dev_alloc_skb couldn't always allocate a=20
> replacement skb. In such situations, we had to free the associated ur=
b.
> And over the time all urbs were eventually gone altogether and=20
> obviously the device remained mute from then on.

With this patch, I get lots of missing rx_refill_* messages such as

drivers/net/wireless/p54/p54usb.c:1024: error: =E2=80=98struct p54u_pri=
v=E2=80=99 has no member named
=E2=80=98rx_refill_work=E2=80=99
drivers/net/wireless/p54/p54usb.c:1025: error: =E2=80=98struct p54u_pri=
v=E2=80=99 has no member named
=E2=80=98rx_refill_lock=E2=80=99
drivers/net/wireless/p54/p54usb.c:1026: error: =E2=80=98struct p54u_pri=
v=E2=80=99 has no member named
=E2=80=98rx_refill_list=E2=80=99

Did I miss a patch? I did a search for the string "rx_refill" in my ent=
ire mailbox and
found only this mail and Artur's reply.

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
