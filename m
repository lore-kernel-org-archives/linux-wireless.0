Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65316 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab0GURob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:44:31 -0400
Received: by fxm14 with SMTP id 14so3765794fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 10:44:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100721171926.GE2355@tuxdriver.com>
References: <AANLkTiknLRzt2bdhcin5WRzwPXSWqEs8dIUe5imlN0I9@mail.gmail.com>
	<1279572443-14361-1-git-send-email-linville@tuxdriver.com>
	<AANLkTino_4FKtMWZU7_lKGzPUXNOtfrmlw_rmmr836eA@mail.gmail.com>
	<20100721133320.GB2355@tuxdriver.com>
	<AANLkTint5uT6PQ8pmEIVSoVYOSCZE5k-TGB1knwHtupw@mail.gmail.com>
	<20100721171926.GE2355@tuxdriver.com>
Date: Wed, 21 Jul 2010 20:44:29 +0300
Message-ID: <AANLkTilzWtAtA2cGbqG1Ored7fwjPKlSwl4v_nRNvLZo@mail.gmail.com>
Subject: Re: [PATCH] rtl8180: improve signal reporting for rtl8185 hardware
From: Pauli Nieminen <suokkos@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 8:19 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Jul 21, 2010 at 08:07:56PM +0300, Pauli Nieminen wrote:
>> On Wed, Jul 21, 2010 at 4:33 PM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > On Wed, Jul 21, 2010 at 08:08:41AM +0300, Pauli Nieminen wrote:
>> >> On Mon, Jul 19, 2010 at 11:47 PM, John W. Linville
>> >> <linville@tuxdriver.com> wrote:
>> >> > The existing code seemed to be somewhat based on the datasheet, but
>> >> > varied substantially from the vendor-provided driver.  This mirrors the
>> >> > handling of the rtl8185 case from that driver, but still neglects the
>> >> > specifics for the rtl8180 hardware.  Those details are a bit muddled...
>> >> >
>> >> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>> >> > ---
>> >> >  drivers/net/wireless/rtl818x/rtl8180_dev.c |   11 ++++++++---
>> >> >  1 files changed, 8 insertions(+), 3 deletions(-)
>> >
>> >> I tested this version of patch. Patch didn't apply cleanly for some
>> >> reason even tough when I mnauly typed it diff looks same.
>> >
>> > Please try the v2 version of the patch.  Some "back of the envelope"
>> > math suggests that the v2 version of the patch will give numbers more
>> > to your liking.
>> >
>> > John
>> > --
>> > John W. Linville                Someday the world will need a hero, and you
>> > linville@tuxdriver.com                  might be all we have.  Be ready.
>> >
>>
>> But version 2 doesn't change the fact that driver is going to report
>> same signal strength even tough I know that only one wifi should have
>> 100 % strength and others less than 50 %. There is only one router in
>> same room with me and all others routers are a lot more father away.
>> So driver is either reading wrong bits from hardware or my hardware is
>> broken.
>
> Did you try the patch?  I suspect not.
>
> I can't really decipher what problem you are reporting here with "100 %
> strength and others less than 50 %".  In any case, if you have RTL8185
> hardware then this patch changes the signal calculation to match what
> the Realtek-provided vendor driver does (which doesn't seem to match
> their datasheet, FWIW).  If you have a better source of information
> then I am happy to receive it.
>

I mean that excepted values for signal strength is that single AP has
close 100% signal strength and others should show less than 50%. When
actual result with your 2nd patch is that all APs are reported having
100% signal strength.

Card is old 8180b. I don't have any documentations but I'm just
guessing from values that are coming from hw.
What I see coming from hw it looks signal strength is reported in
flags & 0xfff or flags2 & 0xff. They are only part of those memory
areas that change enough to be field for signal strength.


> If you have RTL8180 (i.e. not RTL8185) hardware then neither version of
> the patch is likely to help you much (beyond avoiding the warning you
> originally reported).  I hope to improve that as well in the future.
>

I understood that patch is only fixing the WARN_ON problem. I don't
really need the signal strength (I have known the strength reporting
bug for quite sometime) so I'm happy with this patch. But I tried to
find if signal strength reporting could be fixed easily same time for
8180 too.

> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
