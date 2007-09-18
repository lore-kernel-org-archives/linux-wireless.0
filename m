Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60409 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbXIRWok (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 18:44:40 -0400
Message-ID: <46F054D4.5090006@garzik.org>
Date: Tue, 18 Sep 2007 18:44:36 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] revert ath5k ioread32()/iowrite32() usage - use readl()/writel(),  we're MMIO-only
References: <43e72e890709171334y321dc2c8ke255a126a733dad6@mail.gmail.com>	 <46EEE735.5050306@gmail.com> <46EEEA9B.70407@garzik.org>	 <46EEF543.7060901@gmail.com>	 <43e72e890709181203x30144451hf332da4032b5b770@mail.gmail.com>	 <43e72e890709181212u75ec6fe2x7aa639bac319c087@mail.gmail.com> <1190153934.6403.123.camel@localhost.localdomain>
In-Reply-To: <1190153934.6403.123.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Herrenschmidt wrote:
> To be more precise, a platform has every right to return some kind of
> "token" from ioport_map/pci_iomap that encodes the type of address, and
> that is -different- from what a normal ioremap does. In which case, you
> will -not- be able to use readb/writeb & cie on such a token.
> 
> The fact that current implementations seem to return something for MMIO
> that is equivalent to what ioremap returns is an accident and cannot be
> relied upon.


Fair enough.  It's easy enough to change ath5k to using ioremap (or 
pci_ioremap).

	Jeff


