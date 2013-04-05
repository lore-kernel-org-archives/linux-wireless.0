Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:19574 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162285Ab3DEVBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 17:01:21 -0400
Date: Fri, 5 Apr 2013 23:02:22 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] [PATCH 2/6] rt2x00: rt2400pci: use the
 rt2x00mmio_* routines
Message-ID: <20130405210222.GA2396@localhost.localdomain> (sfid-20130405_230126_398877_BE73DEB1)
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
 <1365143225-24532-3-git-send-email-juhosg@openwrt.org>
 <20130405133234.GB1571@redhat.com>
 <515EED2D.8090601@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <515EED2D.8090601@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 05, 2013 at 05:26:37PM +0200, Gabor Juhos wrote:
> 2013.04.05. 15:32 keltezéssel, Stanislaw Gruszka írta:
> > On Fri, Apr 05, 2013 at 08:27:01AM +0200, Gabor Juhos wrote:
> >> Use the recently introduced rt2x00mmio_* routines
> >> instead of the rt2x00pci_* variants.
> >>
> >> The patch contains no functional changes.
> >>
> >> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> >> ---
> >>  drivers/net/wireless/rt2x00/rt2400pci.c |  309 ++++++++++++++++---------------
> > 
> > Why do you modify rt2400pci ?
> 
> Because the rt2x00pci_* functions provided by the rt2x00mmio module has been
> renamed in the first patch and those are using the rt2x00mmio_ prefix now. The
> rt2x00mmio.h header provides definitions for the old function names but those
> definitions are removed by the last patch.

Ah, ok, but this breaks compilation. This should be avoided, to do not
break bisection. Hance patches should be merged into one or incremental
changes proposed that do not break compilation. Otherwise changes look
ok for me.

Stanislaw
