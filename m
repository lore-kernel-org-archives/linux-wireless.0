Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:12019 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbYKEDCZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 22:02:25 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 19:02:25 -0800
Date: Tue, 4 Nov 2008 19:02:23 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Kalle Valo <kalle.valo@nokia.com>
CC: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k : Display MAC/BB and RF version at startup
Message-ID: <20081105030223.GD16413@tesla> (sfid-20081105_040229_717220_2EAEEB17)
References: <490F63B6.8080600@free.fr> <878ws0ar2u.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <878ws0ar2u.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 03, 2008 at 11:27:37PM -0800, Kalle Valo wrote:
> "Benoit PAPILLAULT" <benoit.papillault@free.fr> writes:
> 
> > This patch decodes the MAC/BB version (for instance: AR5416) and the RF
> > part version (for instance: AR5133). It has been tested on AR5416/AR5133
> > which is a 2.4/5GHz 3x3 11n device. It also makes the differences
> > between AR5416 (PCI) and AR5418 (PCI Express). Both are named AR5416 in
> > the register definitions.
> >
> > Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
> 
> [...]
> 
> > -     printk(KERN_INFO "%s: %s: mem=0x%lx, irq=%d\n",
> > +     ah = sc->sc_ah;
> > +     macVersion = ah->ah_macVersion;
> > +     rfVersion  = (ah->ah_analog5GhzRev & AR_RADIO_SREV_MAJOR);
> > +     printk(KERN_INFO
> > +            "%s: Atheros AR%s%s%s%s%s%s MAC/BB Rev:%x "
> > +            "AR%s%s%s%s%s RF Rev:%x: mem=0x%lx, irq=%d\n",
> >              wiphy_name(hw->wiphy),
> > -            athname ? athname : "Atheros ???",
> > +            macVersion == AR_SREV_VERSION_5416_PCI  ? "5416" : "",
> > +            macVersion == AR_SREV_VERSION_5416_PCIE ? "5418" : "",
> > +            macVersion == AR_SREV_VERSION_9100      ? "9100" : "",
> > +            macVersion == AR_SREV_VERSION_9160      ? "9160" : "",
> > +            macVersion == AR_SREV_VERSION_9280      ? "9280" : "",
> > +            macVersion == AR_SREV_VERSION_9285      ? "9285" : "",
> > +            ah->ah_macRev,
> > +            rfVersion  == 0                         ? "5133" : "",
> > +            rfVersion  == AR_RAD5133_SREV_MAJOR     ? "5133" : "",
> > +            rfVersion  == AR_RAD5122_SREV_MAJOR     ? "5122" : "",
> > +            rfVersion  == AR_RAD2133_SREV_MAJOR     ? "2133" : "",
> > +            rfVersion  == AR_RAD2122_SREV_MAJOR     ? "2122" : "",
> > +            ah->ah_phyRev,
> 
> I recommend adding a separate function returning the string instead of
> this ugly "%s%s%s%s" trick. Much cleaner that way.

Agreed, also please remove 3x3 comment as we don't have support for
those yet nor do I even have hardware for it. To be clear ath9k supports
2x2 right now. :)

  Luis
