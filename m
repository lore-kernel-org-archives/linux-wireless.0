Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from v813.rev.tld.pl ([195.149.226.213]:59005 "EHLO
	smtp.host4.kei.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbXL3PBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2007 10:01:05 -0500
From: Marcin Juszkiewicz <openembedded@haerwu.biz>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Add Linksys WCF11 to hostap driver
Date: Sun, 30 Dec 2007 16:00:41 +0100
Cc: Pavel Roskin <proski@gnu.org>, Jouni Malinen <j@w1.fi>,
	netdev@vger.kernel.org
References: <200712281416.59079.openembedded@haerwu.biz> <1198901689.2221.3.camel@dv>
In-Reply-To: <1198901689.2221.3.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200712301600.46342.openembedded@haerwu.biz> (sfid-20071230_150110_184360_03B6BAB5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dnia sobota, 29 grudnia 2007, Pavel Roskin napisa=C5=82:
> Hello!
>
> On Fri, 2007-12-28 at 14:16 +0100, Marcin Juszkiewicz wrote:
> > +       PCMCIA_DEVICE_PROD_ID1234(
> > +               "The Linksys Group, Inc.", "Wireless Network CF
> > Card", "ISL37300P", +               "RevA",
> > +               0xa5f472c2, 0x9c05598d, 0xc9049a39, 0x57a66194),
>
> I would prefer that revisions are not used for card identification in
> presence of the chip name.  It's not like RevB would need another
> driver as long as "ISL37300P" is still a part of the PCMCIA ID.
> PCMCIA_DEVICE_PROD_ID123 should be enough.

OK - updated patch below:

=46rom: Marcin Juszkiewicz <openembedded@haerwu.biz>

Linksys WCF11 submitted by =C3=85ngstr=C3=B6m user.

"The Linksys Group, Inc.", "Wireless Network CF Card", "ISL37300P", "Re=
vA",
0xa5f472c2, 0x9c05598d, 0xc9049a39, 0x57a66194=20
manfid: 0x0274, 0x3301

Signed-off-by: Marcin Juszkiewicz <openembedded@haerwu.biz>

---
=C2=A0drivers/net/wireless/hostap/hostap_cs.c | =C2=A0 =C2=A03 +++
=C2=A01 file changed, 3 insertions(+)

--- linux-2.6.23.orig/drivers/net/wireless/hostap/hostap_cs.c
+++ linux-2.6.23/drivers/net/wireless/hostap/hostap_cs.c
@@ -887,10 +887,13 @@ static struct pcmcia_device_id hostap_cs
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Ver. 1.00",
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x5cd01705, 0x4=
271660f, 0x9d08ee12),
=C2=A0 =C2=A0 =C2=A0 =C2=A0 PCMCIA_DEVICE_PROD_ID123(
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "corega", "WL P=
CCL-11", "ISL37300P",
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0xa21501a, 0x59=
868926, 0xc9049a39),
+ =C2=A0 =C2=A0 =C2=A0 PCMCIA_DEVICE_PROD_ID1233(
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "The Linksys Group, =
Inc.", "Wireless Network CF Card", "ISL37300P",
+ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0xa5f472c2, 0x9c0559=
8d, 0xc9049a39),
=C2=A0 =C2=A0 =C2=A0 =C2=A0 PCMCIA_DEVICE_NULL
=C2=A0};
=C2=A0MODULE_DEVICE_TABLE(pcmcia, hostap_cs_ids);


--=20
JID: hrw-jabber.org
OpenEmbedded developer/consultant

Zemsta jest rozkosz=C4=85 umys=C5=82=C3=B3w miernych, s=C5=82abych i ma=
=C5=82ostkowych. Ale jednak
rozkosz=C4=85 by=C4=87 nie przestaje


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
