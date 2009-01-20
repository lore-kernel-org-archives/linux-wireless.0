Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54622 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704AbZATTnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 14:43:18 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 11:43:18 -0800
Date: Tue, 20 Jan 2009 11:42:43 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Paul Hickey <paul@christianpatriot.us>, <stable@kernel.org>,
	Kyle McMartin <kyle@mcmartin.ca>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: Failed Build of modules for 2.6.27.9-159
Message-ID: <20090120194243.GC19581@tesla> (sfid-20090120_204322_930201_4326E11E)
References: <1232319854.4596.1.camel@localhost.localdomain> <20090119191138.GA4018@tesla> <1232404986.3641.2.camel@localhost.localdomain> <20090120000336.GB4018@tesla> <1232433738.3696.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1232433738.3696.3.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 19, 2009 at 10:42:18PM -0800, Paul Hickey wrote:
> Hi Luis,
>=20
> 2.6.27.9-159.fc10.x86_64 is the kernel. I burned the distro right fro=
m
> Fedora.

I am =FCber-surprised to hear that FC10 2.6.27 kernels have added
pci_ioremap_bar() in their kernel header include/linux/pci.h. I
have verified this by checking:

http://download.fedora.redhat.com/pub/fedora/linux/updates/10/x86_64/ke=
rnel-devel-2.6.27.9-159.fc10.x86_64.rpm

I have checked upstrea 2.6.27.9 and even 2.6.27.12 and they do not have=
 this. This breaks
compatibility projects like compat-wireless :(

Kyle?

> Also, the ForceXPA might not be a problem, but it makes and logs its
> attempts 4X per minute. It may not be much of an impact on the CPU, b=
ut
> is it necessary? Plus the message log gets really long really fast.

Good point, hopefully this is enough of an argument to make the patch
go into 2.6.27. The patch is already in for >=3D 2.6.28.

Greg -- there is an annoying message that gets printed very often
when new Atheros 11n cards are used, this is printed upon hw reset
which occurs on channel changes (scans) and as such happens quite
often. The message was moved to print only when "EEPROM debugging"
was enaabled through upstream commit f1dc56003b23d2d5bb5a756de6b1633a76=
c9e697.
Unfortunately this commit is pretty large as it refactored hw.c into
separate files. Below is a small one line patch that changes this. Plea=
se
let me know if this is OK for 2.6.27.x

  Luis

=46rom: Luis R. Rodriguez <lrodriguez@atheros.com>
Subject: [PATCH] ath9k: quiet harmless ForceXPAon messages

This is a port of one line of upstream patch
f1dc56003b23d2d5bb5a756de6b1633a76c9e697

The "ForceXPAon" messages on ath9k were not meant to be printed
regularly, lets quiet them as this can happen quite frequently
(scans) and will fill the logs with tons of these messages.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

--- drivers/net/wireless/ath9k/hw.c.orig	2009-01-20 11:33:44.000000000 =
-0800
+++ drivers/net/wireless/ath9k/hw.c	2009-01-20 11:34:10.000000000 -0800
@@ -729,7 +729,7 @@
 					  AR_AN_TOP2_LOCALBIAS,
 					  AR_AN_TOP2_LOCALBIAS_S,
 					  pModal->local_bias);
-		DPRINTF(ah->ah_sc, ATH_DBG_ANY, "ForceXPAon: %d\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "ForceXPAon: %d\n",
 			pModal->force_xpaon);
 		REG_RMW_FIELD(ah, AR_PHY_XPA_CFG, AR_PHY_FORCE_XPA_CFG,
 			      pModal->force_xpaon);

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
