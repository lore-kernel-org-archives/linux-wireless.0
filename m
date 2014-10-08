Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13174 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbaJHOIF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 10:08:05 -0400
Message-ID: <543545AE.8030900@intel.com> (sfid-20141008_160922_814782_27464BFE)
Date: Wed, 08 Oct 2014 16:09:50 +0200
From: Loic Poulain <loic.poulain@intel.com>
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] net: rfkill: gpio: Implement host wake up support
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com> <1412757280-31367-3-git-send-email-loic.poulain@intel.com> <20141008113845.GB3514@kuha.fi.intel.com>
In-Reply-To: <20141008113845.GB3514@kuha.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, it sounds good to use a label instead of index.
However:
- DSD is only compatible with BIOS ACPI 5.1
- gpiod_get_index does not take care of con_id (label) parameter in case 
of ACPI (acpi_find_gpio).
- gpiod_get calls gpiod_get_index with index 0.

Any patch ongoing to support con_id parameter with ACPI?

Regards,
Loic

On 08/10/2014 13:38, Heikki Krogerus wrote:
> On Wed, Oct 08, 2014 at 10:34:38AM +0200, Loic Poulain wrote:
>> Some GPIO based rfkill devices can wake their host up from suspend by
>> toggling an input (from the host perspective) GPIO.
>> This patch adds a generic support for that feature by registering a
>> threaded interrupt routine and thus setting the corresponding GPIO as a
>> wake up source.
>>
>> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
>> ---
>>   net/rfkill/rfkill-gpio.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 49 insertions(+)
> To continue my previous answer, for this you could have the following
> _DSD..
>
>          Name (_DSD, Package ()
>          {
>              ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>              Package () {
>                  Package () {"host_wake-gpio", Package () {^BTH1, 0, 0, 0}},
>                  Package () {"reset-gpio", Package () {^BTH1, 1, 0, 0}},
>                  Package () {"shutdown-gpio", Package () {^BTH1, 2, 0, 0}},
>              }
>          })
>
> And in the driver you can then request it without caring about the
> index..
>
>          ...
>          gpio = devm_gpiod_get_index(dev, "host_wake", 3);
>          if (!IS_ERR(gpio)) {
> 		ret = gpiod_direction_input(gpio);
> 		if (ret)
> 			return ret;
> 		rfkill->irq = gpiod_to_irq(gpio);
>          ...
>
>
> Actually, we could just use devm_gpiod_get instead of
> devm_gpiod_get_index in this case.
>
>
> Cheers,
>

-- 
Intel Open Source Technology Center
http://oss.intel.com/

