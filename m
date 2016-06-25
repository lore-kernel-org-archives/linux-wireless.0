Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35646 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbcFYMBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jun 2016 08:01:17 -0400
Received: by mail-wm0-f68.google.com with SMTP id a66so11995201wme.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jun 2016 05:01:16 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name, chunkeey@googlemail.com,
	mark.rutland@arm.com, robh+dt@kernel.org,
	arend.vanspriel@broadcom.com
Subject: Re: [PATCH RFC v3 3/3] ath9k: parse the device configuration from an OF node
Date: Sat, 25 Jun 2016 14:01:12 +0200
Message-ID: <2421107.Vh3zsAgVDf@debian64> (sfid-20160625_140129_210797_B34E901A)
In-Reply-To: <20160624123430.4097-4-martin.blumenstingl@googlemail.com>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com> <20160624123430.4097-4-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, June 24, 2016 02:34:30 PM Martin Blumenstingl wrote:
> This makes it possible to configure ath9k based devices using
> devicetree. That makes some out-of-tree "convert devicetree to
> ath9k_platform_data glue"-code obsolete.

Hm, what about the embedded ath9k pcie chips that need the early
pci-fixup routine for the device to work properly [0], [1]? How
will this be handled/integrated? I know that the ar71xx and the
lantiq platforms use similar pci-fixup routines that need a few
bytes from the eeprom/cal data. So lantiq has a few extra properties:
"ath,pci-slot", "ath,device-id" and "ath,eep-flash". 

As an example: the AR9280 in the Cisco Z1 AP is initially 
0x168c:0xff1f (<-- ath9k doesn't know about that id). The
pci-fixup routine will change it to  0x168c:0x002A. Only 
then ath9k can take it over and will initialize it.
Thing is: this is all currently done by platform code for
those architectures... And currently, the request_firmware
doesn't work for caldata on UBI partitions.

Regards,
Christian

[0] <https://git.lede-project.org/?p=source.git;a=blob;f=target/linux/ar71xx/files/arch/mips/ath79/pci-ath9k-fixup.c;h=22023518069bc9b15b898f12f342b89563358e6a;hb=HEAD>

[1] <https://dev.openwrt.org/browser/trunk/target/linux/lantiq/patches-4.4/0035-owrt-lantiq-wifi-and-ethernet-eeprom-handling.patch>
