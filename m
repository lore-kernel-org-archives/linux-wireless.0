Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:39943 "EHLO foss.arm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbcF0M5W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 08:57:22 -0400
Date: Mon, 27 Jun 2016 13:57:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, nbd@nbd.name, chunkeey@googlemail.com,
	robh+dt@kernel.org
Subject: Re: [PATCH RFC v2 1/2] Documentation: dt: net: add ath9k wireless
 device binding
Message-ID: <20160627125709.GF1113@leverpostej> (sfid-20160627_145728_718410_8FD0E51C)
References: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
 <20160623174536.5967-2-martin.blumenstingl@googlemail.com>
 <20160623175809.GA31170@leverpostej>
 <CAFBinCC6iY_y-_w_yeoqOOysqYBQxcRf8oVgXYs3YqqSE=sJrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFBinCC6iY_y-_w_yeoqOOysqYBQxcRf8oVgXYs3YqqSE=sJrQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 23, 2016 at 08:14:29PM +0200, Martin Blumenstingl wrote:
> On Thu, Jun 23, 2016 at 7:58 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Thu, Jun 23, 2016 at 07:45:35PM +0200, Martin Blumenstingl wrote:
> >> +- qca,eeprom-name: The name of the file which contains the EEPROM data (which
> >> +                     will be loaded via request_firmware)
> >
> > The binding shouldn't know anything about the host filesystem,
> > request_firmware, etc. So the description is a best a little off.
> >
> > What happens when a new FW comes out? I shouldn't have to update my DT
> > to cater for that.
> This is not exactly a "firmware" but rather device-specific
> calibration data (RF settings, MAC address, etc). Usually there is an
> eeprom connected directly to the wifi chip, but on embedded devices
> this is usually skipped and instead the calibration data is shipped
> somewhere on the main flash (directly on SPI-/NOR-/NAND flash,
> sometimes even inside an UBI volume).

Ok. I believe that previously, for ath10k, it was suggested that this
calibration data be placed directly in the DT (assuming it's small
enough).

> > Please find a better way to identify relevant FW. What exactly affects
> > which FW can be used, or would ideally be used? Are different FWs
> > required for the same HW in some contexts?
> >
> > Can we not figure out the relevant FW names in the driver based on some
> > identification mechanism (e.g. a more thoroughly defined set of
> > compatible strings)?
> The only way of auto-detecting a "correct" name would be via
> dev_name() (with some prefix this could give something like
> ath9k-pci-0000:00:0e.0.bin).

That may work, if the above is not an option.

> 
> >> +- qca,check-eeprom-endianness: Allow checking the EEPROM endianness and
> >> +                             swapping of the EEPROM data if required
> >
> > CAn we not simply always do this?
> I've asked myself this question as well, but unfortunately some
> manufacturers ship the EEPROM data with incorrect endianness magic.
> Thus I decided to stay consistent with ath9k_platform_data which also
> has a boolean (which defaults to false).

Ah. It's probably worth a note in the binding that this is not always
safe, and should only be set if the eeprom is known to have valid
endianness magic.

It would also be worth specifying teh behaviour in the absence of this
property.

> 
> >> +- qca,disable-2ghz: Disables the 2.4GHz band, even if enabled in the EEPROM
> >> +- qca,disable-5ghz: Disables the 5GHz band, even if enabled in the EEPROM
> >
> > When/why would these be necessary?
> sometimes a manufacturer (accidentally) leaves both bands enabled in
> the EEPROM data,while the RF hardware is only suitable for one of both
> bands. The same settings exist in ath9k_platform_data, serving exactly
> the same purpose

Ok. Can we invert these instead (i.e. describe when the feature is
available)? e.g. qca,supports-2ghz.

Thanks,
Mark.
