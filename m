Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:38402 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbYC3V5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2008 17:57:14 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Chr <chunkeey@web.de>
Subject: Re: [RFC][PATCH 2/2] p54: statistic readback and other changes
Date: Sun, 30 Mar 2008 23:02:43 +0100
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
References: <200803302349.27450.chunkeey@web.de>
In-Reply-To: <200803302349.27450.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200803310002.44110.florian.fainelli@telecomint.eu> (sfid-20080330_225717_694341_625B1D0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

Le dimanche 30 mars 2008, Chr a =E9crit=A0:
> This patch brings some of the new features for both
> (PCI and USB) devices... unfortunately I don't know if
> the readback works on USB.

@@ -53,10 +53,10 @@ struct pda_entry {
 } __attribute__ ((packed));
=20
 struct eeprom_pda_wrap {
-	__le32 magic;
-	__le16 pad;
-	__le16 len;
-	__le32 arm_opcode;
+	u32 magic;
+	u16 pad;
+	u16 len;
+	u32 arm_opcode;
 	u8 data[0];
 } __attribute__ ((packed));

This change will break p54 on big-endian hosts which is something that =
has=20
been fixed few weeks ago.

Will have some test	on a prism54 usb device and report back here.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
