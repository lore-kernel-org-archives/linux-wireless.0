Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:48712 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbcBHW7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 17:59:12 -0500
Date: Mon, 8 Feb 2016 23:59:41 +0100
From: Emil Goode <emil.fsw@goode.io>
To: Ross Green <rgkernel@gmail.com>
Cc: Sebastian Reichel <sre@kernel.org>, Shahar Patury <shaharp@ti.com>,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-wireless@vger.kernel.org, Guy Mishol <guym@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: wl12xx regression on 4.5 (was: Re: linux-4.5-rc1 TI pandboard-es
 wifi wlcore locks and reset)
Message-ID: <20160208225940.GA3681@lianli> (sfid-20160208_235930_584304_85296C64)
References: <CANfgCY2nHh+vZ=JOimJdKKKs2JgM-c7m+3ePZtS3XhqyXNkDUQ@mail.gmail.com>
 <CANfgCY2zVXrLGv=YDpNvqhhoj5U2kgqZ_VV1EBPVK78grra84Q@mail.gmail.com>
 <20160202043448.GA9514@earth>
 <CANfgCY21zzinD48DOHaZdkGdDWpuAtJN1T8ofmdwM=P4f-7=Yw@mail.gmail.com>
 <20160202160538.GA19990@earth>
 <20160207220538.GA4464@lianli>
 <CANfgCY3uxLRwRawA1rDDdrhZW4bFkKU0E-JJTJxfWJ2pjCHfkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANfgCY3uxLRwRawA1rDDdrhZW4bFkKU0E-JJTJxfWJ2pjCHfkg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ross,

On Mon, Feb 08, 2016 at 07:26:34PM +1100, Ross Green wrote:
> On Mon, Feb 8, 2016 at 9:05 AM, Emil Goode <emil.fsw@goode.io> wrote:
> > Hello,
> >
> > On Tue, Feb 02, 2016 at 05:05:38PM +0100, Sebastian Reichel wrote:
> >> On Tue, Feb 02, 2016 at 04:41:13PM +1100, Ross Green wrote:
> >> > On Tue, Feb 2, 2016 at 3:34 PM, Sebastian Reichel <sre@kernel.org> wrote:
> >> > > On Mon, Feb 01, 2016 at 11:38:38PM +1100, Ross Green wrote:
> >> > >> On Mon, Jan 25, 2016 at 11:47 PM, Ross Green <rgkernel@gmail.com> wrote:
> >> > >> > Just tried the new kernel release on faithful pandaboard es with the
> >> > >> > new 4.5-rc1 release.
> >> > >> >
> >> > >> > There is a problem with the wifi modules once the modules are loaded.
> >> > >> > Looks like the wifi firmware gets loaded put no response after that
> >> > >> > causing recovery action.
> >> > >> >
> >> > >> > the kernel 4.4 works quite happily with this board.
> >> > >> >
> >> > >> > Here is a dmesg dump in the attachment.
> >> > >> >
> >> > >> > Anyone have any ideas here?
> >> >
> >> > [...]
> >> >
> >> > If I get time, this evening, I'll see if I can give a bisect a try.
> >>
> >> On N950 [wl1271 via SPI, using extra patches to init from DT] I get wifi
> >> working again on 4.5-rc1 with 3719c17e1816 ("wlcore/wl18xx: fw logger
> >> over sdio") reverted.
> >
> > Reverting the changes in wlcore_set_partition() as below seem to help.
> >
> > Best regards,
> >
> > Emil Goode
> >
> > 8<--------
> >
> > --- a/drivers/net/wireless/ti/wlcore/io.c
> > +++ b/drivers/net/wireless/ti/wlcore/io.c
> > @@ -175,14 +175,15 @@ int wlcore_set_partition(struct wl1271 *wl,
> >         if (ret < 0)
> >                 goto out;
> >
> > +       /*
> > +        * We don't need the size of the last partition, as it is
> > +        * automatically calculated based on the total memory size and
> > +        * the sizes of the previous partitions.
> > +        */
> >         ret = wlcore_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
> >         if (ret < 0)
> >                 goto out;
> >
> > -       ret = wlcore_raw_write32(wl, HW_PART3_SIZE_ADDR, p->mem3.size);
> > -       if (ret < 0)
> > -               goto out;
> > -
> >  out:
> >         return ret;
> >  }
> > diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
> > index 6c257b5..10cf374 100644
> > --- a/drivers/net/wireless/ti/wlcore/io.h
> > +++ b/drivers/net/wireless/ti/wlcore/io.h
> > @@ -36,8 +36,8 @@
> >  #define HW_PART1_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 12)
> >  #define HW_PART2_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 16)
> >  #define HW_PART2_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 20)
> > -#define HW_PART3_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 24)
> > -#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 28)
> > +#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 24)
> > +
> >  #define HW_ACCESS_REGISTER_SIZE         4
> >
> >  #define HW_ACCESS_PRAM_MAX_RANGE       0x3c000
> >
> 
> Thanks Emil,
> 
> Just tested linux-4.5-rc3 with the above patch and confirm everything
> works as expected. So it would be good if this patch can find its way
> into linux-4.5-rc4.
> 
> So all is happy with the wlcore code with this patch.
> Now I can continue with the rest of the testing ;-)

Thank you for testing!

I'm not familiar with this code so it would be good to get a comment from ti developers, 
if not I will send this fix.

Best regards,

Emil Goode
