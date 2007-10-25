Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:6598 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbXJYKoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 06:44:13 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 11/30] iwlwifi: using PCI_DEVICE macro
Date: Thu, 25 Oct 2007 12:44:11 +0200
Cc: Jeff Garzik <jeff@garzik.org>, Zhu Yi <yi.zhu@intel.com>,
	linville@tuxdriver.com, Tomas Winkler <tomas.winkler@intel.com>
References: <11933037512140-git-send-email-yi.zhu@intel.com> <11933037674045-git-send-email-yi.zhu@intel.com> <472062BA.6020102@garzik.org>
In-Reply-To: <472062BA.6020102@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710251244.11493.hs4233@mail.mn-solutions.de> (sfid-20071025_114416_523626_9B56958F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >  struct pci_device_id iwl_hw_card_ids[] = {
> > -	{0x8086, 0x4222, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > -	{0x8086, 0x4227, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> > +	{PCI_DEVICE(0x8086, 0x4222)},
> > +	{PCI_DEVICE(0x8086, 0x4227)},

> FWIW I would recommend
>
> 	PCI_VDEVICE(INTEL, 0x4229)

I wonder why.

When I do "lspci -n" to find out the id of an unknown card, then 
I cannot just do

$ cd linux/drivers
$ grep -rl 0x8086 .

to find (from the source), which driver claims to be for the 
device. Because there is this unneeded indirection via a header 
file ...

