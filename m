Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35542 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbcBHI0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 03:26:36 -0500
MIME-Version: 1.0
In-Reply-To: <20160207220538.GA4464@lianli>
References: <CANfgCY2nHh+vZ=JOimJdKKKs2JgM-c7m+3ePZtS3XhqyXNkDUQ@mail.gmail.com>
	<CANfgCY2zVXrLGv=YDpNvqhhoj5U2kgqZ_VV1EBPVK78grra84Q@mail.gmail.com>
	<20160202043448.GA9514@earth>
	<CANfgCY21zzinD48DOHaZdkGdDWpuAtJN1T8ofmdwM=P4f-7=Yw@mail.gmail.com>
	<20160202160538.GA19990@earth>
	<20160207220538.GA4464@lianli>
Date: Mon, 8 Feb 2016 19:26:34 +1100
Message-ID: <CANfgCY3uxLRwRawA1rDDdrhZW4bFkKU0E-JJTJxfWJ2pjCHfkg@mail.gmail.com> (sfid-20160208_092711_132691_4A5B0A56)
Subject: Re: wl12xx regression on 4.5 (was: Re: linux-4.5-rc1 TI pandboard-es
 wifi wlcore locks and reset)
From: Ross Green <rgkernel@gmail.com>
To: Emil Goode <emil.fsw@goode.io>
Cc: Sebastian Reichel <sre@kernel.org>, Shahar Patury <shaharp@ti.com>,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-wireless@vger.kernel.org, Guy Mishol <guym@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 8, 2016 at 9:05 AM, Emil Goode <emil.fsw@goode.io> wrote:
> Hello,
>
> On Tue, Feb 02, 2016 at 05:05:38PM +0100, Sebastian Reichel wrote:
>> On Tue, Feb 02, 2016 at 04:41:13PM +1100, Ross Green wrote:
>> > On Tue, Feb 2, 2016 at 3:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
>> > > On Mon, Feb 01, 2016 at 11:38:38PM +1100, Ross Green wrote:
>> > >> On Mon, Jan 25, 2016 at 11:47 PM, Ross Green <rgkernel@gmail.com> wrote:
>> > >> > Just tried the new kernel release on faithful pandaboard es with the
>> > >> > new 4.5-rc1 release.
>> > >> >
>> > >> > There is a problem with the wifi modules once the modules are loaded.
>> > >> > Looks like the wifi firmware gets loaded put no response after that
>> > >> > causing recovery action.
>> > >> >
>> > >> > the kernel 4.4 works quite happily with this board.
>> > >> >
>> > >> > Here is a dmesg dump in the attachment.
>> > >> >
>> > >> > Anyone have any ideas here?
>> >
>> > [...]
>> >
>> > If I get time, this evening, I'll see if I can give a bisect a try.
>>
>> On N950 [wl1271 via SPI, using extra patches to init from DT] I get wifi
>> working again on 4.5-rc1 with 3719c17e1816 ("wlcore/wl18xx: fw logger
>> over sdio") reverted.
>
> Reverting the changes in wlcore_set_partition() as below seem to help.
>
> Best regards,
>
> Emil Goode
>
> 8<--------
>
> --- a/drivers/net/wireless/ti/wlcore/io.c
> +++ b/drivers/net/wireless/ti/wlcore/io.c
> @@ -175,14 +175,15 @@ int wlcore_set_partition(struct wl1271 *wl,
>         if (ret < 0)
>                 goto out;
>
> +       /*
> +        * We don't need the size of the last partition, as it is
> +        * automatically calculated based on the total memory size and
> +        * the sizes of the previous partitions.
> +        */
>         ret = wlcore_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
>         if (ret < 0)
>                 goto out;
>
> -       ret = wlcore_raw_write32(wl, HW_PART3_SIZE_ADDR, p->mem3.size);
> -       if (ret < 0)
> -               goto out;
> -
>  out:
>         return ret;
>  }
> diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
> index 6c257b5..10cf374 100644
> --- a/drivers/net/wireless/ti/wlcore/io.h
> +++ b/drivers/net/wireless/ti/wlcore/io.h
> @@ -36,8 +36,8 @@
>  #define HW_PART1_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 12)
>  #define HW_PART2_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 16)
>  #define HW_PART2_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 20)
> -#define HW_PART3_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 24)
> -#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 28)
> +#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 24)
> +
>  #define HW_ACCESS_REGISTER_SIZE         4
>
>  #define HW_ACCESS_PRAM_MAX_RANGE       0x3c000
>



Thanks Emil,

Just tested linux-4.5-rc3 with the above patch and confirm everything
works as expected. So it would be good if this patch can find its way
into linux-4.5-rc4.



here is a portion of the dmesg:
# dmesg
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 4.5.0-rc3-panda (rfg@red.dwarf) (gcc
version 5.3.0 (Buildroot 2016.02-git-00183-g1682aee) ) #1 S6
[    0.000000] CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7),
cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing
instruction cache
[    0.000000] Machine model: TI OMAP4 PandaBoard-ES
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] OMAP4: Map 0xbfe00000 to fe600000 for dram barrier
[    0.000000] On node 0 totalpages: 261632

...
...[   39.164764] wlcore: loaded
[   52.577209] wlcore: firmware booted (Rev 6.3.10.0.133)
[   56.101531] wlan0: authenticate with 90:f6:52:81:ee:70
[   56.138732] wlan0: send auth to 90:f6:52:81:ee:70 (try 1/3)
[   56.146728] wlan0: authenticated
[   56.162078] wlan0: associate with 90:f6:52:81:ee:70 (try 1/3)
[   56.172821] wlan0: RX AssocResp from 90:f6:52:81:ee:70 (capab=0x431
status=0 aid=1)
[   56.188201] wlan0: associated
[   56.244812] wlcore: Association completed.


So all is happy with the wlcore code with this patch.
Now I can continue with the rest of the testing ;-)

Regards,

Ross Green
