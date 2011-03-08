Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53750 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab1CHLBF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 06:01:05 -0500
Received: by qwd7 with SMTP id 7so3850057qwd.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 03:01:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299539491.7802.18.camel@marge>
References: <AANLkTikky+cwYO+S_QSebnyQRV9TftbeNZDzVN8EAT_7@mail.gmail.com>
	<1299539491.7802.18.camel@marge>
Date: Tue, 8 Mar 2011 12:01:04 +0100
Message-ID: <AANLkTikVN8QZjYc0jX4zcpO=xUwt4d8mfkPZkPSLvnMe@mail.gmail.com>
Subject: Re: SSB bus driver documentation?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, today that ssb code makes more sense to me, thanks for help.


I'd like to ask few more questions:
1) In case of PCI host we have b43_pci_bridge that loads ssb. What
about other hosts? I don't see any IDs table in sdio.c or pcmcia.c.
2) Could you say a word more about pcihost_wrapper? What is this for?
I can see we use that in pci bridge. What we can't call
ssb_bus_pcibus_register directly?
3) What is embedded.c?


I've also few comments to analyzed code. Could you check them, say if
it's OK/worth fixing that?

1) main.c::ssb_modinit
Hacks for bridge and gige (both being not modules) are not documented.
New developer have no idea why we call b43_pci_ssb_bridge_init and
ssb_gige_init. Tracking that calls lead to even more confusion.

2) ssb.h::ssb_bustype
SSB_BUSTYPE_SSB,
SSB_BUSTYPE_PCI,
SSB_BUSTYPE_PCMCIA,
SSB_BUSTYPE_SDIO,
I think first define is confusing. Is sounds like SSB being host for
SSB, or whatever... I think it should be sth like SSB_BUSTYPE_SYSTEM,
SSB_BUSTYPE_NONE, SSB_BUSTYPE_NATIVE, SSB_BUSTYPE_EMBEDDED, or sth.

3) main.c::ssb_ssb_ops
We keep all host-specific ops in separated files, but not in this
case. OK, it makes some sense as this one is not for host, but I think
it makes main.c more complicated and we can not compile SSB without
it. I think we could build every PC kernel without this, right?

4) scan.c::scan_switchcore
Why we don't have ops->switchcore? We could get rid of that switch
with simple pointer.

5) scan.c::scan_read32
I'm not sure about this yet... but do we need that here? Shouldn't
scan.c focus on just scanning? It's just one another "offset +=
current_coreidx * SSB_CORE_SIZE;" calculation.


I criticized scan.c::scan_read32, but could you say why do we need
that specific read at all? Why can't we use some ops->read32? I can
see sdio.c have some additional masking and is claims host, but didn't
analyze that yet.


-- 
Rafał
