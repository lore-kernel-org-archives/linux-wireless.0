Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23255 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933689AbcHJSUC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:20:02 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cathy Luo" <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@google.com>
Subject: RE: mwifiex: PCIe8997 chip specific handling
Date: Wed, 10 Aug 2016 07:07:33 +0000
Message-ID: <9bc980fff61541c2879d5d1dacda7462@SC-EXCH04.marvell.com> (sfid-20160810_222640_923678_300F3C68)
References: <1469788731-5361-1-git-send-email-akarwar@marvell.com>
 <20160809184406.GA12186@localhost>
In-Reply-To: <20160809184406.GA12186@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Wednesday, August 10, 2016 12:14 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> linux-kernel@vger.kernel.org
> Subject: Re: mwifiex: PCIe8997 chip specific handling
> 
> Hi,
> 
> On Fri, Jul 29, 2016 at 04:08:51PM +0530, Amitkumar Karwar wrote:
> > The patch corrects the revision id register and uses it along with
> > magic value and chip version registers to download appropriate
> > firmware image.
> >
> > PCIe8997 Z chipset variant code has been removed, as it won't be used
> > in production.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> >  drivers/net/wireless/marvell/mwifiex/pcie.c | 35
> > ++++++++++-------------------
> > drivers/net/wireless/marvell/mwifiex/pcie.h | 14 +++++-------
> >  2 files changed, 18 insertions(+), 31 deletions(-)
> 
> [...]
> 
> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h
> > b/drivers/net/wireless/marvell/mwifiex/pcie.h
> > index f6992f0..46f99ca 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.h
> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
> > @@ -32,12 +32,9 @@
> >  #define PCIE8897_DEFAULT_FW_NAME "mrvl/pcie8897_uapsta.bin"
> >  #define PCIE8897_A0_FW_NAME "mrvl/pcie8897_uapsta_a0.bin"
> >  #define PCIE8897_B0_FW_NAME "mrvl/pcie8897_uapsta.bin"
> > -#define PCIE8997_DEFAULT_FW_NAME "mrvl/pcieusb8997_combo_v2.bin"
> > -#define PCIEUART8997_FW_NAME_Z "mrvl/pcieuart8997_combo.bin"
> > -#define PCIEUART8997_FW_NAME_V2 "mrvl/pcieuart8997_combo_v2.bin"
> > -#define PCIEUSB8997_FW_NAME_Z "mrvl/pcieusb8997_combo.bin"
> > -#define PCIEUSB8997_FW_NAME_V2 "mrvl/pcieusb8997_combo_v2.bin"
> > -#define PCIE8997_DEFAULT_WIFIFW_NAME "mrvl/pcie8997_wlan.bin"
> > +#define PCIEUART8997_FW_NAME_V4 "mrvl/pcieuart8997_combo_v4.bin"
> > +#define PCIEUSB8997_FW_NAME_V4 "mrvl/pcieusb8997_combo_v4.bin"
> > +#define PCIE8997_DEFAULT_WIFIFW_NAME "mrvl/pcie8997_wlan_v4.bin"
> 
> Why do version bumps require firmware renames? Is this just to make sure
> you don't load the new firmware on old chip revs that you don't plan to
> support for production (i.e., only early revs like the _Z you're
> dropping)? This doesn't seems like a good long-term solution, at least
> once you start getting this silicon out in the wild. At some point, I'd
> expect to see a stable file name.
> 
> Brian
> 

We haven't yet submitted any firmware image upstream for 8997 chipset.
pcieuart8997_combo_v4.bin/pcieusb8997_combo_v4.bin would be our firmware candidate for upstream submission. The filename would remain same hereafter.

pcie*8997_combo_v2.bin had support only for A0 chipset
pcie*8997_combo_v3.bin was our internal development version which had support for A1 chipset
pcie*8997_combo_v4.bin has support for both A0 and A1 chipsets and this is the version that shall be released to customers/upstream from now on.

Regards,
Amitkumar Karwar
