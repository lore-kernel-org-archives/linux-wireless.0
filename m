Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:35864 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbcBCGZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:25:17 -0500
MIME-Version: 1.0
In-Reply-To: <20160202160538.GA19990@earth>
References: <CANfgCY2nHh+vZ=JOimJdKKKs2JgM-c7m+3ePZtS3XhqyXNkDUQ@mail.gmail.com>
	<CANfgCY2zVXrLGv=YDpNvqhhoj5U2kgqZ_VV1EBPVK78grra84Q@mail.gmail.com>
	<20160202043448.GA9514@earth>
	<CANfgCY21zzinD48DOHaZdkGdDWpuAtJN1T8ofmdwM=P4f-7=Yw@mail.gmail.com>
	<20160202160538.GA19990@earth>
Date: Wed, 3 Feb 2016 17:25:15 +1100
Message-ID: <CANfgCY2UfbcPG279wjRDMvyDi+X8-2idLKRdnxbxDhsDDz036A@mail.gmail.com> (sfid-20160203_072539_782279_3598E5A5)
Subject: Re: wl12xx regression on 4.5 (was: Re: linux-4.5-rc1 TI pandboard-es
 wifi wlcore locks and reset)
From: Ross Green <rgkernel@gmail.com>
To: Sebastian Reichel <sre@kernel.org>
Cc: Shahar Patury <shaharp@ti.com>, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-wireless@vger.kernel.org,
	Guy Mishol <guym@ti.com>, Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 3, 2016 at 3:05 AM, Sebastian Reichel <sre@kernel.org> wrote:
> Hi Ross,
>
> Please don't top-post on kernel mailinglists. Use either inline
> style or bottom posting.
>
> On Tue, Feb 02, 2016 at 04:41:13PM +1100, Ross Green wrote:
>> On Tue, Feb 2, 2016 at 3:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
>> > On Mon, Feb 01, 2016 at 11:38:38PM +1100, Ross Green wrote:
>> >> On Mon, Jan 25, 2016 at 11:47 PM, Ross Green <rgkernel@gmail.com> wrote:
>> >> > Just tried the new kernel release on faithful pandaboard es with the
>> >> > new 4.5-rc1 release.
>> >> >
>> >> > There is a problem with the wifi modules once the modules are loaded.
>> >> > Looks like the wifi firmware gets loaded put no response after that
>> >> > causing recovery action.
>> >> >
>> >> > the kernel 4.4 works quite happily with this board.
>> >> >
>> >> > Here is a dmesg dump in the attachment.
>> >> >
>> >> > Anyone have any ideas here?
>>
>> [...]
>>
>> If I get time, this evening, I'll see if I can give a bisect a try.
>
> On N950 [wl1271 via SPI, using extra patches to init from DT] I get wifi
> working again on 4.5-rc1 with 3719c17e1816 ("wlcore/wl18xx: fw logger
> over sdio") reverted.
>
> -- Sebastian

For the pandaboard using

for 4.5

CONFIG_WLAN_VENDOR_TI=y
CONFIG_WL12XX=m
CONFIG_WLCORE=m
CONFIG_WLCORE_SDIO=m
CONFIG_WILINK_PLATFORM_DATA=y

so I suspect it is something to do with modifications to wlcore,
wlcore_sdio, or wl12xx that have been applied.

Given there are similar problems with the SPI interface then it is
more likely to be problems in the wlcore modifications.

Shahar have these been tested on a pandaboard omap4 setup?

Regards,

Ross
