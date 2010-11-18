Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33871 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab0KRQfh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 11:35:37 -0500
Received: by vws13 with SMTP id 13so1769614vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 08:35:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101118162617.GA2468@tuxdriver.com>
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>
	<1288823326-9686-2-git-send-email-zajec5@gmail.com>
	<20101116212321.GF10774@tuxdriver.com>
	<20101118162617.GA2468@tuxdriver.com>
Date: Thu, 18 Nov 2010 17:35:36 +0100
Message-ID: <AANLkTi=EVw=EnM=M4op7hTP6JZnNyXi+BNnVokLmYK3x@mail.gmail.com>
Subject: Re: [PATCH] ssb: fail registration for unknown SPROM revision
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/18 John W. Linville <linville@tuxdriver.com>:
> On Tue, Nov 16, 2010 at 04:23:21PM -0500, John W. Linville wrote:
>> On Wed, Nov 03, 2010 at 11:28:46PM +0100, Rafał Miłecki wrote:
>> > Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> > ---
>> > As noticed my Michael we have this left from old times of limited amount of
>> > revisions. It's not reliable to treat unknown as rev1.
>> >
>> > Michael: would you like to add Reported-by?
>> >
>> > John: it's for 2.6.38.
>> > ---
>> >  drivers/ssb/pci.c |    8 +++-----
>> >  1 files changed, 3 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
>> > index b5343ac..41a7337 100644
>> > --- a/drivers/ssb/pci.c
>> > +++ b/drivers/ssb/pci.c
>> > @@ -600,11 +600,9 @@ static int sprom_extract(struct ssb_bus *bus, struct ssb_sprom *out,
>> >             sprom_extract_r8(out, in);
>> >             break;
>> >     default:
>> > -           ssb_printk(KERN_WARNING PFX "Unsupported SPROM"
>> > -                      "  revision %d detected. Will extract"
>> > -                      " v1\n", out->revision);
>> > -           out->revision = 1;
>> > -           sprom_extract_r123(out, in);
>> > +           ssb_printk(KERN_ERR PFX "Unsupported SPROM revision %d"
>> > +                      " detected\n", out->revision);
>> > +           return -EINVAL;
>> >     }
>> >
>> >     if (out->boardflags_lo == 0xFFFF)
>>
>> I think this is going to make my b43 PCI-E card not work...I'll try
>> it and get back to you...
>
> Yeah...
>
> [  125.520348] b43-pci-bridge 0000:04:00.0: enabling device (0000 -> 0002)
> [  125.520359] b43-pci-bridge 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [  125.520373] b43-pci-bridge 0000:04:00.0: setting latency timer to 64
> [  125.529241] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x11, vendor 0x4243)
> [  125.529255] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x0A, vendor 0x4243)
> [  125.529268] ssb: Core 2 found: USB 1.1 Host (cc 0x817, rev 0x03, vendor 0x4243)
> [  125.529280] ssb: Core 3 found: PCI-E (cc 0x820, rev 0x01, vendor 0x4243)
> [  125.545750] ssb: WARNING: Invalid SPROM CRC (corrupt SPROM)
> [  125.545752] ssb: Unsupported SPROM revision 255 detected
> [  125.545797] ssb: Failed to register PCI version of SSB with error -22
> [  125.545810] b43-pci-bridge 0000:04:00.0: PCI INT A disabled
> [  125.545827] b43-pci-bridge: probe of 0000:04:00.0 failed with error -22

Hm, now I wonder if we should create sth like list of devices with
invalid SPROM, or maybe we should keep current fallback method?

-- 
Rafał
