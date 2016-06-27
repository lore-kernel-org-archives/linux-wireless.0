Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35983 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbcF0NHK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 09:07:10 -0400
Subject: Re: [PATCH RFC v2 1/2] Documentation: dt: net: add ath9k wireless
 device binding
To: Mark Rutland <mark.rutland@arm.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
References: <20160623174536.5967-1-martin.blumenstingl@googlemail.com>
 <20160623174536.5967-2-martin.blumenstingl@googlemail.com>
 <20160623175809.GA31170@leverpostej>
 <CAFBinCC6iY_y-_w_yeoqOOysqYBQxcRf8oVgXYs3YqqSE=sJrQ@mail.gmail.com>
 <20160627125709.GF1113@leverpostej>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, chunkeey@googlemail.com,
	robh+dt@kernel.org
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <b48c8a3b-bcec-f9df-9fe9-ce16ed8ca750@nbd.name> (sfid-20160627_150736_935553_DAB2F592)
Date: Mon, 27 Jun 2016 15:07:04 +0200
MIME-Version: 1.0
In-Reply-To: <20160627125709.GF1113@leverpostej>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-27 14:57, Mark Rutland wrote:
> On Thu, Jun 23, 2016 at 08:14:29PM +0200, Martin Blumenstingl wrote:
>> On Thu, Jun 23, 2016 at 7:58 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>> > On Thu, Jun 23, 2016 at 07:45:35PM +0200, Martin Blumenstingl wrote:
>> >> +- qca,eeprom-name: The name of the file which contains the EEPROM data (which
>> >> +                     will be loaded via request_firmware)
>> >
>> > The binding shouldn't know anything about the host filesystem,
>> > request_firmware, etc. So the description is a best a little off.
>> >
>> > What happens when a new FW comes out? I shouldn't have to update my DT
>> > to cater for that.
>> This is not exactly a "firmware" but rather device-specific
>> calibration data (RF settings, MAC address, etc). Usually there is an
>> eeprom connected directly to the wifi chip, but on embedded devices
>> this is usually skipped and instead the calibration data is shipped
>> somewhere on the main flash (directly on SPI-/NOR-/NAND flash,
>> sometimes even inside an UBI volume).
> 
> Ok. I believe that previously, for ath10k, it was suggested that this
> calibration data be placed directly in the DT (assuming it's small
> enough).
I don't think the data should go directly into DT, because then we need
a lot more complex kernel loader stubs. There are hundreds of devices
out there with calibration data in flash, and many of them have the data
in different places, and almost all of them don't support passing DT via
boot loader.
The actual RF settings are calibrated for every individual device, so
they need to be read from the flash partition anyway.
I think it makes sense to add an optional reference to a mtd partition
and allow the kernel to read from it directly.

>> > Please find a better way to identify relevant FW. What exactly affects
>> > which FW can be used, or would ideally be used? Are different FWs
>> > required for the same HW in some contexts?
>> >
>> > Can we not figure out the relevant FW names in the driver based on some
>> > identification mechanism (e.g. a more thoroughly defined set of
>> > compatible strings)?
>> The only way of auto-detecting a "correct" name would be via
>> dev_name() (with some prefix this could give something like
>> ath9k-pci-0000:00:0e.0.bin).
> 
> That may work, if the above is not an option.
I think that's a good idea.

- Felix
