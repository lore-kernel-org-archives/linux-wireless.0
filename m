Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50599 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaGGVAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 17:00:15 -0400
Date: Mon, 7 Jul 2014 16:48:46 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] bcma: support for PCIe Gen 2 as host platform
Message-ID: <20140707204846.GF29650@tuxdriver.com> (sfid-20140707_230021_823504_0FD72EB3)
References: <1404645103-26100-1-git-send-email-zajec5@gmail.com>
 <53B93EBC.7010107@broadcom.com>
 <CACna6rwt3vr0cHxRR8XkSg+C9NDN5Oxi8Syus8fGBpGLJVVYPw@mail.gmail.com>
 <CACna6rwQmW6AX3BwfE5Q_MkcJ1UWMeeJ1VXXqxATH1oX15Zgkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwQmW6AX3BwfE5Q_MkcJ1UWMeeJ1VXXqxATH1oX15Zgkg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 07, 2014 at 09:37:10PM +0200, Rafał Miłecki wrote:
> On 7 July 2014 11:38, Rafał Miłecki <zajec5@gmail.com> wrote:
> > On 6 July 2014 14:19, Arend van Spriel <arend@broadcom.com> wrote:
> >> On 06-07-14 13:11, Rafał Miłecki wrote:
> >>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> >>> ---
> >>> I got reply from Bjorn, that we should *not* depend on PCI_EXP_LNKCAP:
> >>> http://marc.info/?l=linux-pci&m=140457671930896&w=2
> >>>
> >>> So the change since RFC is adding a list of PCIe 1.0 and 2.0 devices.
> >>> Use PCI_EXP_LNKCAP only as a fallback, in case someone tries sth like:
> >>> echo "14e4 4360" > /sys/bus/pci/drivers/bcma-pci-bridge/new_id
> >>
> >> Do you have to know this before or after enumerating the cores? They
> >> have a different core id, right?
> >
> > Sure, having a list of cores would allow me to determine PCIe revision.
> >
> > Unfortunately right now we have only this single bcma_bus_register
> > call that does both: scanning and initialization. I'd need to first
> > scan cores, then determine PCIe revision and finally initialize cores.
> >
> > I wonder if I could try to use bcma_bus_scan_early that was developer
> > for SoC needs...
> 
> John: please kindly drop this patch for now. All other bcma/b43
> patches are unaffected.

OK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
