Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:44367 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608AbXKAT2G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 15:28:06 -0400
Message-ID: <472A28C0.6060106@garzik.org> (sfid-20071101_192809_127900_7FB47564)
Date: Thu, 01 Nov 2007 15:28:00 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH] RFC: move ath5k to use pci_request_selected_regions()
References: <20071101192251.GB3201@pogo>
In-Reply-To: <20071101192251.GB3201@pogo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Documentation/pci.txt states:
> 
> "If your PCI device driver doesn't need I/O port resources assigned to
> I/O Port BARs, you should use pci_enable_device_bars() instead of
> pci_enable_device() in order not to enable I/O port regions for the
> corresponding devices. In addition, you should use
> pci_request_selected_regions() and pci_release_selected_regions()
> instead of pci_request_regions()/pci_release_regions() in order not to
> request/release I/O port regions for the corresponding devices."
> 
> So shall we? This also re-arranges the pci_release_selected_regions()
> as per the documenation.
> 
> Changes to base.c
> Changes-licensed-under: 3-clause-BSD
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

IMO the documentation is a bit bogus:

pci_request_regions() ensures that nobody else will touch -any- of your 
resources.

I see no logical reason to enable sharing of I/O regions with another 
driver, which would be the net effect of avoiding their request/release 
by using pci_request_selected_regions()

pci_enable_device() and pci_request_regions() are just fine; the strange 
and lesser-used APIs should be avoided unless you _need_ to use them.

	Jeff



