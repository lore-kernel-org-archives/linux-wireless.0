Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33823 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760555Ab0HFKCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 06:02:45 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimrb5P9cVo30y_udoi4+vu3cM4YzfpDaYCfwGEA@mail.gmail.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<1279733634-21974-4-git-send-email-ohad@wizery.com> <AANLkTimzA_JJ-byTDWznbL3YzeJ8LAP4M50onf2_3fBF@mail.gmail.com>
	<AANLkTi=Oy8X1xMOwWL_cKBB1LWULT6=p+adUgB+AuSJS@mail.gmail.com>
	<AANLkTi=BUX59heXAW2Uf4wZo2dSS19Je54dkQ5u2YGAW@mail.gmail.com>
	<AANLkTimZQKj7H_GeE=+O9cwxEMTR+LhfFbt=AyXGzN3d@mail.gmail.com>
	<AANLkTikfRja-h9mz7uyRXCZNZjKdU_yB8e58XQucUzrn@mail.gmail.com>
	<AANLkTi=vhWV1RNyemtfppfjvLYAbzd3aRjFOVgLLpG3Z@mail.gmail.com>
	<AANLkTin4m8gJR50zwMB2b0jRMHdNA6CQToKBTAhOL9wF@mail.gmail.com>
	<AANLkTinu2S19r8fueM-jVkc35XL2G0Z16BddE92Ci9KB@mail.gmail.com>
	<20100804114147.GB6852@n2100.arm.linux.org.uk> <AANLkTi=Dqs_qg=BsoNBTjvJbG+ub+zMv8ctbrJSGPJJJ@mail.gmail.com>
	<AANLkTimrb5P9cVo30y_udoi4+vu3cM4YzfpDaYCfwGEA@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 6 Aug 2010 13:02:24 +0300
Message-ID: <AANLkTim6Yuor4CAEmQPs3zPVz1svEbckzO0HHeFWGmjy@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] mmc: support embedded data field in mmc_host
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Vitaly Wool <vitalywool@gmail.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>,
	linux-wireless@vger.kernel.org,
	Roger Quadros <roger.quadros@nokia.com>,
	linux-mmc@vger.kernel.org, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	linux-omap@vger.kernel.org, akpm@linux-foundation.org,
	linux-arm-kernel@lists.infradead.org, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 6, 2010 at 10:07 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/8/4 Ohad Ben-Cohen <ohad@wizery.com>:
>> On Wed, Aug 4, 2010 at 2:41 PM, Russell King - ARM Linux
>>>
>>> Why not arrange for a small piece of code to be built into the kernel
>>> when this driver is selected as a module or built-in, which handles
>>> the passing of platform data to the driver?
>>
>> It's interesting.
>>
>> The only drawback I can see is that it has an inherent limitation of
>> having only a single wl1271 device on board,
>
> ...which is exactly what the *_board_info scheme in the spi
> and i2c subsystems is designed to solve.
>
> This is an established design pattern in the kernel with two
> precedents, what makes it so hard to implement this idea?
> There are plenty of examples all over the place.

How would a driver ask for the platform data of its specific device ?

Using DEVICE_ID and VENDOR_ID is wrong - those numbers do not identify
a specific device instance (think of a board with two wl1271 devices.
the only difference between them is the index of their mmc
controller).

The only sane way to uniquely identify a specific device instance is
to couple its platform data with the host controller the device is
hardwired to.

So if we want to have an external sdio_board_info table to work, it
would have to map a controller index to sdio_board_info objects.
Something in the lines of:

int sdio_get_platform_data(struct sdio_board_info *data, struct sdio_func *func)
{
       if (platform_data[func->card->host->index]) {
               memcpy(data, platform_data[func->card->host->index],
sizeof(*data));
               return 0;
       }
       return -ENODEV;
}

typechecking is not preserved (the driver would have to cast
data->platform_data), and there is a possibility for the wrong driver
to pick up the data (at least as much as there was with the original
proposal).

AFAICS, the difference between SDIO and I2C/SPI in that respect, is
that SDIO devices are created dynamically when hardware is probed,
whereas I2C/SPI uses the *_board_info table to populate the device
tree. The I2C/SPI drivers then elegantly get the platform data in the
probe call. In our case, the device is created dynamically, and the
only way to couple it with the correct platform data is using the
knowledge that it is hardwired to a specific host controller.

So using an external repository of platform data objects seem to have
similar disadvantages like the original proposal, but with much more
code.

We have Russell's suggestion which is nice and simple, but it has the
1 device limitation.

Or, we can go back to the approach of creating another platform device
for that chip. That device's name should be "wl1271.x" where x is the
index of the controller the device is hardwired to. Later, when the
SDIO function probe is invoked, it would register the platform driver
(after dynamically sprintf()ing the name using the
func->card->host->index number), and then
wait_for_completion_interruptible_timeout() for it to probe.

That seem to settle all the concerns raised: we get typechecking, no
wrong driver getting the data, no 1 device limit, no races between the
two probes.

Thanks,
Ohad.
