Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:36007 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbbLBHb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 02:31:57 -0500
MIME-Version: 1.0
In-Reply-To: <20151202070026.GA29067@sudip-pc>
References: <20151108215953.GO18797@mwanda>
	<563FFEEB.1090307@atmel.com>
	<56405328.4040004@atmel.com>
	<20151109081842.GR18797@mwanda>
	<56405F71.6090404@atmel.com>
	<CABXAfNJHAWd_ygUbcZXDqwGvaCxM3nA5ibOF4sNwzhA3AP=07g@mail.gmail.com>
	<56406F0F.1050701@atmel.com>
	<CABXAfNKhtdRSm1BJK+pk9t4wwnFBXzAP_CKSVhS0p7m_FZG_8Q@mail.gmail.com>
	<20151109102342.GA3868@sudip-pc>
	<CABXAfN+Rgkfr=LHO_PrCGgSaWkupZTRvJXk+ccHvBzQTP6miYA@mail.gmail.com>
	<20151202070026.GA29067@sudip-pc>
Date: Wed, 2 Dec 2015 13:01:56 +0530
Message-ID: <CABXAfNKmGZA5iK6j4D3R5RadWnVQMKjmVJHxrkoUKT0Xj=f=hQ@mail.gmail.com> (sfid-20151202_083219_625455_923CB3F9)
Subject: Re: [PATCH V2] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
From: punit vara <punitvara@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: glen lee <glen.lee@atmel.com>, devel@driverdev.osuosl.org,
	chris.park@atmel.com, Austin Shin <austin.shin@atmel.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	linux-kernel@vger.kernel.org, tony.cho@atmel.com,
	leo.kim@atmel.com, Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 2, 2015 at 12:30 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> On Wed, Dec 02, 2015 at 08:39:10AM +0530, punit vara wrote:
>> On Mon, Nov 9, 2015 at 3:53 PM, Sudip Mukherjee
>> <sudipm.mukherjee@gmail.com> wrote:
>> > On Mon, Nov 09, 2015 at 03:43:38PM +0530, punit vara wrote:
>> >> On Mon, Nov 9, 2015 at 3:31 PM, glen lee <glen.lee@atmel.com> wrote:
>> >> >
>> >> >
>> >> > On 2015년 11월 09일 18:05, punit vara wrote:
>> >> >>
>> >> >> On Mon, Nov 9, 2015 at 2:25 PM, glen lee <glen.lee@atmel.com> wrote:
>> >> >>>
>> >> >>> On 2015년 11월 09일 17:18, Dan Carpenter wrote:
>> >> >>>>
>> >> >>>> On Mon, Nov 09, 2015 at 05:02:48PM +0900, glen lee wrote:
>> >> >>>>>
>> >>
>> >> make ./drivers/staging/wilc1000/    this working fine for me
>> >>
>> >> but
>> >>
>> >> make ./drivers/staging/wilc1000/linux_wlan.o is creates error.
>> >
>> > I am also not getting build failure. Can you please post your .config file.
>> >
>> > regards
>> > sudip
>> I have attached .config file . and please tell me should I focus on
>> this patch or not . Because build is still broken.For temporary this
>> patch can be useful to fix the build .Later on as per requirement Glen
>> can change the code .
>
> With your config file also I am not getting any build failure. Can you
> please tell what are the exact compilation steps you are following?
>
> Here are my steps after I have copied your config file as .config.
> 1) make oldconfig && make prepare
> 2) make bzImage && make modules
>
> And I dont see any build failure.
> I think you are not building bzImage and the modules before testing wilc
> compilation. And that is why it is unable to find SPI or SDIO.
>
> regards
> sudip
Steps I have followed:
1. I have updated staging tree and checkout to new branch.
2. make drivers/staging/wilc1000/linux_wlan.o

When I have performed second step it automatically ask me about
different modules options "yes/no" I have pressed ENTER in every
option .At last configuration are written to .config. and module start
building and I have found error at last. I will try to perform 2 step
you have suggested .
