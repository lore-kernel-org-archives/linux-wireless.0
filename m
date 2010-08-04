Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35399 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab0HDOBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 10:01:20 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=Dqs_qg=BsoNBTjvJbG+ub+zMv8ctbrJSGPJJJ@mail.gmail.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<1279733634-21974-4-git-send-email-ohad@wizery.com>
	<AANLkTimzA_JJ-byTDWznbL3YzeJ8LAP4M50onf2_3fBF@mail.gmail.com>
	<AANLkTi=Oy8X1xMOwWL_cKBB1LWULT6=p+adUgB+AuSJS@mail.gmail.com>
	<AANLkTi=BUX59heXAW2Uf4wZo2dSS19Je54dkQ5u2YGAW@mail.gmail.com>
	<AANLkTimZQKj7H_GeE=+O9cwxEMTR+LhfFbt=AyXGzN3d@mail.gmail.com>
	<AANLkTikfRja-h9mz7uyRXCZNZjKdU_yB8e58XQucUzrn@mail.gmail.com>
	<AANLkTi=vhWV1RNyemtfppfjvLYAbzd3aRjFOVgLLpG3Z@mail.gmail.com>
	<AANLkTin4m8gJR50zwMB2b0jRMHdNA6CQToKBTAhOL9wF@mail.gmail.com>
	<AANLkTinu2S19r8fueM-jVkc35XL2G0Z16BddE92Ci9KB@mail.gmail.com>
	<20100804114147.GB6852@n2100.arm.linux.org.uk>
	<AANLkTi=Dqs_qg=BsoNBTjvJbG+ub+zMv8ctbrJSGPJJJ@mail.gmail.com>
Date: Wed, 4 Aug 2010 16:01:19 +0200
Message-ID: <AANLkTikvKCJiwbbGz+W+h8ixorCy5=MuV9WQ+vyjUL=Z@mail.gmail.com>
Subject: Re: [PATCH v2 03/20] mmc: support embedded data field in mmc_host
From: Vitaly Wool <vitalywool@gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 4, 2010 at 2:42 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> On Wed, Aug 4, 2010 at 2:41 PM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
>> On Wed, Aug 04, 2010 at 02:24:39PM +0300, Ohad Ben-Cohen wrote:
>>> On Tue, Aug 3, 2010 at 5:17 PM, Vitaly Wool <vitalywool@gmail.com> wrote:
>>> > On Mon, Aug 2, 2010 at 11:35 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>>> >> I'm honestly trying to understand your concerns, but I'm afraid that
>>> >> just saying "it's a hack" is not too informative. Can you please
>>> >> explain what do you think is technically wrong with the proposed
>>> >> solution ? is it not general enough for other use cases ? will it
>>> >> break something ?
>>>
>>> > So if I'd like to set the *same* structure for the *same* WL1271
>>> > driver, provided that I'm working with the other platform, I'll need
>>> > to do the following:
>>> > - add the pointer to the board-specific header;
>>> > - add the structure to the board-specific C file and propagate its
>>> > pointer to the controller driver;
>>> > - add setting the pointer in the core structure into the controller driver.
>>> >
>>> > This is far from being intuitive. This means we need to hack,
>>> > generally speaking, all the MMC controller drivers to get it working
>>> > on all platforms. This is error prone.
>>>
>>> You make it sound really complex.
>>>
>>> Let's see what it means to add it to a totally different platform.
>>>
>>> As an example, let's take Google's ADP1 which is based on a different
>>> host controller (msm-sdcc), and add the required support (untested of
>>> course, just a quick sketch, patch is based on android's msm git):
>>
>> What if some other driver gets attached and tries to use this
>> platform data?  This whole idea sounds extremely silly, cumbersome,
>> error prone, and is inviting misuse by normal MMC sockets.
>>
>> Why not arrange for a small piece of code to be built into the kernel
>> when this driver is selected as a module or built-in, which handles
>> the passing of platform data to the driver?
>
> It's interesting.
>
> The only drawback I can see is that it has an inherent limitation of
> having only a single wl1271 device on board, but there are no such
> boards outside development/testing labs.
>
> Vitaly would that work for you too ?

Works for me, but I've got a remark.
If we try to generalize that idea to handle multiple devices it will
be similar to the following:

static struct wl12xx_platform_data platform_data[MAX_WL12XX_DEVICES];

int __init wl12xx_set_platform_data(const struct wl12xx_platform_data
*data, int id);
int wl12xx_get_platform_data(struct wl12xx_platform_data *data, int id);

which will look pretty much like... yes, a simplified/customized
version board_info applied to a single driver.

But anyway I'm fine with that.

~Vitaly
