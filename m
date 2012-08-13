Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2215 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab2HMNqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 09:46:51 -0400
Message-ID: <5029053F.1010207@broadcom.com> (sfid-20120813_154659_963570_F82C1D6C)
Date: Mon, 13 Aug 2012 15:46:39 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Saul St. John" <saul.stjohn@gmail.com>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC] bcma: add cc core driver, expose sprom to sysfs
References: <20120810002305.GA5966@eris.garyseven.net>
 <CACna6rz83DOTDYG1ehd-dvMoWrnduvJ44Lpi3vM0wMLMrC0-hA@mail.gmail.com>
 <20120810234202.GA8644@eris.garyseven.net>
In-Reply-To: <20120810234202.GA8644@eris.garyseven.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2012 01:42 AM, Saul St. John wrote:
> On Fri, Aug 10, 2012 at 06:55:22AM +0200, Rafał Miłecki wrote:
>> > 2012/8/10 Saul St. John <saul.stjohn@gmail.com>:
>>> > > Adds a driver for BCMA ChipCommon cores, registers the struct device
>>> > > bcma_bus.drv_cc->core->dev with device_register(), and exposes the SPROM
>>> > > in rev 31+ cc cores as a R/W sysfs attribute.
>> > 
>> > Well, that's a little messy. You change a few not strictly related
>> > things in a one patch, please provide patch-per-change. That changes
>> > are quite sensitive so we really need it.
> Ok, v2 will be split over a couple of patches.
> 
>> > I also wish to see some explanation on that changes. Why do you need
>> > CC to be registered as a bus core device? Why anyone may need
>> > overwriting SPROM? Did it work for you? Have you tested
>> > suspend&resume?

Hi Saul,

I am really not in favor for adding write support. As Rafał noted there
is no need for linux end-users to be modifying SPROM content. It is
called Serial Programmable *Read-Only* Memory for a reason. The only
parties that need write access are the chip manufacturer and OEM/ODM.

Most information is rather device specific and sensitive to change. Also
changing information like country code (as you indicated you did) can
cause violations in the regulatory area.

Without a clear need of this functionality for the linux users I tend to
discard this change, but I am not the bcma maintainer. Could you
elaborate what your higher-level use is?

If the reasons for having this patch accepted are clear and valid I
would suggest to make it depend on CFG80211_CERTIFICATION_ONUS Kconfig
option.

Gr. AvS

