Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:33886 "EHLO
	mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932322AbcHJVIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 17:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <9bc980fff61541c2879d5d1dacda7462@SC-EXCH04.marvell.com>
References: <1469788731-5361-1-git-send-email-akarwar@marvell.com>
 <20160809184406.GA12186@localhost> <9bc980fff61541c2879d5d1dacda7462@SC-EXCH04.marvell.com>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 10 Aug 2016 14:08:39 -0700
Message-ID: <CALupW3CC2ketRdMoaV1r3Wuo4tZx5gZ5tF_DCAAjFgntgYWW4A@mail.gmail.com> (sfid-20160810_231249_089384_AF24CC6D)
Subject: Re: mwifiex: PCIe8997 chip specific handling
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Brian Norris <briannorris@chromium.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Wei-Ning Huang <wnhuang@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Aug 10, 2016 at 12:07 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Brian,
>
>> From: Brian Norris [mailto:briannorris@chromium.org]
>> Sent: Wednesday, August 10, 2016 12:14 AM
>> To: Amitkumar Karwar
>> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
>> linux-kernel@vger.kernel.org
>> Subject: Re: mwifiex: PCIe8997 chip specific handling
>>
>> Hi,
>>
>> On Fri, Jul 29, 2016 at 04:08:51PM +0530, Amitkumar Karwar wrote:
>> > The patch corrects the revision id register and uses it along with
>> > magic value and chip version registers to download appropriate
>> > firmware image.
>> >
>> > PCIe8997 Z chipset variant code has been removed, as it won't be used
>> > in production.
>> >
>> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> > ---
>> >  drivers/net/wireless/marvell/mwifiex/pcie.c | 35
>> > ++++++++++-------------------
>> > drivers/net/wireless/marvell/mwifiex/pcie.h | 14 +++++-------
>> >  2 files changed, 18 insertions(+), 31 deletions(-)
>>
>> [...]
>>
>> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h
>> > b/drivers/net/wireless/marvell/mwifiex/pcie.h
>> > index f6992f0..46f99ca 100644
>> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.h
>> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
>> > @@ -32,12 +32,9 @@
>> >  #define PCIE8897_DEFAULT_FW_NAME "mrvl/pcie8897_uapsta.bin"
>> >  #define PCIE8897_A0_FW_NAME "mrvl/pcie8897_uapsta_a0.bin"
>> >  #define PCIE8897_B0_FW_NAME "mrvl/pcie8897_uapsta.bin"
>> > -#define PCIE8997_DEFAULT_FW_NAME "mrvl/pcieusb8997_combo_v2.bin"
>> > -#define PCIEUART8997_FW_NAME_Z "mrvl/pcieuart8997_combo.bin"
>> > -#define PCIEUART8997_FW_NAME_V2 "mrvl/pcieuart8997_combo_v2.bin"
>> > -#define PCIEUSB8997_FW_NAME_Z "mrvl/pcieusb8997_combo.bin"
>> > -#define PCIEUSB8997_FW_NAME_V2 "mrvl/pcieusb8997_combo_v2.bin"
>> > -#define PCIE8997_DEFAULT_WIFIFW_NAME "mrvl/pcie8997_wlan.bin"
>> > +#define PCIEUART8997_FW_NAME_V4 "mrvl/pcieuart8997_combo_v4.bin"
>> > +#define PCIEUSB8997_FW_NAME_V4 "mrvl/pcieusb8997_combo_v4.bin"
>> > +#define PCIE8997_DEFAULT_WIFIFW_NAME "mrvl/pcie8997_wlan_v4.bin"
>>
>> Why do version bumps require firmware renames? Is this just to make sure
>> you don't load the new firmware on old chip revs that you don't plan to
>> support for production (i.e., only early revs like the _Z you're
>> dropping)? This doesn't seems like a good long-term solution, at least
>> once you start getting this silicon out in the wild. At some point, I'd
>> expect to see a stable file name.
>>
>> Brian
>>
>
> We haven't yet submitted any firmware image upstream for 8997 chipset.
> pcieuart8997_combo_v4.bin/pcieusb8997_combo_v4.bin would be our firmware candidate for upstream submission. The filename would remain same hereafter.
>
> pcie*8997_combo_v2.bin had support only for A0 chipset
> pcie*8997_combo_v3.bin was our internal development version which had support for A1 chipset
> pcie*8997_combo_v4.bin has support for both A0 and A1 chipsets and this is the version that shall be released to customers/upstream from now on.
>

Seems to me then it should just be named pcie*8997_wlan.bin.  A
version number shouldn't be part of the file name in this case. Having
to update the driver for a firmware name change is silly. Most
wireless drivers have different names for different hardware/chip revs
and/or an incompatible API change.  Most distributions would typically
only carry a single instance of the firmware for a particular chip.
Speaking for the ones I work with, I usually keep the original
filename intact (with a version number) and make a symlink to it with
the name the driver expects.  eg:

fw-4.bin -> fw_v3.4.0.94.bin
fw_v3.2.0.144.bin
fw_v3.4.0.94.bin

That way I can keep track of the version in my filesystem, but I'm not
hacking the driver every couple of weeks.  And we do issue new
firmware every few weeks. I can't imagine asking our customers to keep
updating the driver for each firmware enhancement.

IMHO changing the driver to rename the firmwares on new versions seems
both inconvenient to people using it, and extra non-useful commit
noise.

- Steve
