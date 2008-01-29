Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from v813.rev.tld.pl ([195.149.226.213]:51265 "EHLO
	smtp.host4.kei.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYA2InY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 03:43:24 -0500
From: Marcin Juszkiewicz <openembedded@haerwu.biz>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Add another Prism2 card to hostap
Date: Tue, 29 Jan 2008 09:42:53 +0100
Cc: Jouni Malinen <j@w1.fi>, Pavel Roskin <proski@gnu.org>,
	netdev@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200801290942.56258.openembedded@haerwu.biz> (sfid-20080129_084330_534461_A87E28C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


=46rom: Marcin Juszkiewicz <openembedded@haerwu.biz>

Card reported by =C5ngstr=F6m user:
http://bugs.openembedded.net/show_bug.cgi?id=3D3236

Socket 1:
   product info: "Wireless LAN", "11Mbps PC Card", "Version 01.02", ""
   manfid: 0x0156, 0x0002
   function: 6 (network)

Signed-off-by: Marcin Juszkiewicz <openembedded@haerwu.biz>

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wire=
less/hostap/hostap_cs.c
index 877d3bd..4f6707c 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -894,6 +894,9 @@ static struct pcmcia_device_id hostap_cs_ids[] =3D =
{
                "The Linksys Group, Inc.", "Wireless Network CF Card", =
"ISL37300P",
                "RevA",
                0xa5f472c2, 0x9c05598d, 0xc9049a39, 0x57a66194),
+       PCMCIA_DEVICE_PROD_ID123(
+           "Wireless LAN" , "11Mbps PC Card", "Version 01.02",
+               0x4b8870ff, 0x70e946d1, 0x4b74baa0),
        PCMCIA_DEVICE_NULL
 };
 MODULE_DEVICE_TABLE(pcmcia, hostap_cs_ids);

--=20
JID: hrw-jabber.org
OpenEmbedded developer/consultant

         Computers are not intelligent. They only think they are.


-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
