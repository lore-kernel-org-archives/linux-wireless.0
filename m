Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:41298 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZAEMYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 07:24:16 -0500
Message-ID: <4961FBD1.4030103@openwrt.org> (sfid-20090105_132420_384760_77F2C3AF)
Date: Mon, 05 Jan 2009 13:23:45 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>, Imre Kaloz <kaloz@openwrt.org>
Subject: Re: [RFC 08/12] ath9k: get EEPROM contents from platform data on
 AHB bus
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>	<1230990262-22923-9-git-send-email-juhosg@openwrt.org> <18785.57618.47120.669270@gargle.gargle.HOWL>
In-Reply-To: <18785.57618.47120.669270@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith =EDrta:
> Gabor Juhos wrote:
>> +#ifndef _LINUX_ATH9K_PLATFORM_H
>> +#define _LINUX_ATH9L_PLATFORM_H
>=20
> Typo ?

Oops, yes.

> Also, after addressing Christopher's comments, I don't think too many
> bus specific routines would remain. In that case would it be reasonab=
le
> to just have a single file (bus.c, with appropriate ifdefs), instead
> of pci.c and ahb.c ?

We will have 3 of them actually (read_cachesize, read_eeprom, cleanup),=
 but here
is the whole {pci,platform}_driver specific stuff. Of course we can mov=
e all of
this into one file, but i would like to avoid the unnecessary ifdefs wh=
ere it is
possible. Apart from this, if we will put the PCI and AHB stuff into on=
e file,
we could put it into main.c simply.

-Gabor

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
