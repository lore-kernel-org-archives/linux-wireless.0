Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52937 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2HNPDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 11:03:35 -0400
Received: by yhmm54 with SMTP id m54so526363yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2012 08:03:35 -0700 (PDT)
Date: Tue, 14 Aug 2012 10:03:27 -0500
From: "Saul St. John" <saul.stjohn@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] bcma: add cc core driver, expose sprom to sysfs
Message-ID: <20120814150043.GA15645@eris.garyseven.net> (sfid-20120814_170340_260056_0CB8ECE8)
References: <20120810002305.GA5966@eris.garyseven.net>
 <CACna6rz83DOTDYG1ehd-dvMoWrnduvJ44Lpi3vM0wMLMrC0-hA@mail.gmail.com>
 <20120810234202.GA8644@eris.garyseven.net>
 <5029053F.1010207@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5029053F.1010207@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Saul St. John" <saul.stjohn@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: 
Bcc: 
Subject: Re: [RFC] bcma: add cc core driver, expose sprom to sysfs
Reply-To: 
In-Reply-To: <5029053F.1010207@broadcom.com>

On Mon, Aug 13, 2012 at 03:46:39PM +0200, Arend van Spriel wrote:
> On 08/11/2012 01:42 AM, Saul St. John wrote:
> > On Fri, Aug 10, 2012 at 06:55:22AM +0200, Rafał Miłecki wrote:
> > > > 2012/8/10 Saul St. John <saul.stjohn@gmail.com>:
> > > > > Adds a driver for BCMA ChipCommon cores, registers the struct device
> > > > > bcma_bus.drv_cc->core->dev with device_register(), and exposes the SPROM
> > > > > in rev 31+ cc cores as a R/W sysfs attribute.

> > > > I also wish to see some explanation on that changes. Why do you need
> > > > CC to be registered as a bus core device? Why anyone may need
> > > > overwriting SPROM? Did it work for you? Have you tested
> > > > suspend&resume?
> 
> Hi Saul,
> 
> I am really not in favor for adding write support. As Rafał noted there
> is no need for linux end-users to be modifying SPROM content. It is
> called Serial Programmable *Read-Only* Memory for a reason. The only
> parties that need write access are the chip manufacturer and OEM/ODM.
> 
> Most information is rather device specific and sensitive to change. Also
> changing information like country code (as you indicated you did) can
> cause violations in the regulatory area.
> 
> Without a clear need of this functionality for the linux users I tend to
> discard this change, but I am not the bcma maintainer. Could you
> elaborate what your higher-level use is?
> 
> If the reasons for having this patch accepted are clear and valid I
> would suggest to make it depend on CFG80211_CERTIFICATION_ONUS Kconfig
> option.
> 
> Gr. AvS
> 

Hi Arend,

I don't really agree that there is no use-case for sprom-modification among
linux end-users.  I believe the canonical use-case is to alter the PCI 
subsystem IDs so as to allow mini-PCI cards from one vendor to play well with 
the BIOS in other vendors' laptops. (As the README from b43-tools explains: 
"[L]et us suppose that you have purchased a Dell mini-pci card to use in an HP 
laptop. The HP BIOS refuses to use the card when the pcivendor is Dell (code 
0x1028), not HP (code 0x103C).") 

Personally, I wanted to be able to permanently change the interface address on 
my wireless card, in a manner that would "stick" after a reboot into OS X.  I 
suspect it could also be useful for those who purchase a wireless interface 
for use in a country other than that described in the SPROM, or for operation 
under regulations other than Part 15.

It would seriously diminish the utility of this functionality to restrict it by 
configuration flags-- especially by flags that are not commonly set by 
mainstream distributions, as many users don't have the wherewithal or 
inclination to compile their own kernels. What's more, virtually identical 
functionality is already exposed by the 'ssb' driver by default. It would be
confusing to end users were ssb and bcma dissimilar in the way you suggest.

I'd be interested in the opinions of the various maintainers of/contributors
to the bcma and ssb modules, and the b43-tools package. I guess I'm not 
totally opposed to adding some configuration burden to impede use of what is,
admittedly, functionality that can be dangerous when misused. However, I 
do think it's important for ssb and bcma to be consistent in this respect--
and I don't think CFG80211_CERTIFICATION_ONUS would be appropriate, as bcma
doesn't strictly depend on cfg80211.

-saul
