Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:39916 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaE0OVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 10:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZpy2aT_kFp01bnrviVB3SOggiNUJB46wbWAY_bqW8=gg@mail.gmail.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-2-git-send-email-hdegoede@redhat.com> <CACRpkdZpy2aT_kFp01bnrviVB3SOggiNUJB46wbWAY_bqW8=gg@mail.gmail.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 27 May 2014 22:21:04 +0800
Message-ID: <CAGb2v65NW61+BV2hR3wn_xRvCyPo+AhcMU7hmFjQxKWj49G=Bw@mail.gmail.com> (sfid-20140527_162137_386552_30AE4094)
Subject: Re: [linux-sunxi] Re: [PATCH 01/11] pinctrl: sunxi: create irq/pin
 mapping during init
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2014 at 10:11 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> On Mon, May 26, 2014 at 9:47 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>
>> From: Chen-Yu Tsai <wens@csie.org>
>>
>> The irq/pin mapping is used to lookup the pin to mux to the irq
>> function when the irq is enabled. It is created when gpio_to_irq
>> is called. Creating the mapping during init allows us to map the
>> interrupts directly from the device tree.
>>
>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>
> This is exactly correct. Patch applied.

Thanks.

> I tried to hack the sunxi driver to even use the gpiolib
> irqchip helpers but exactly this complex map thing in
> ->irq_array[] git me stuck. If any of you guys could be so
> nice to take a stab at this (compare to other commits
> converting drivers to use gpiolibs irqchip helpers) then
> I'd be very happy.

We still need to rework the whole irqchip stuff for sun6i/sun8i,
which have 1 parent interrupt per EINT capable pin bank.

Earlier discussions with Maxime (on IRC IIRC) suggested moving this
over to gpiolib irqchip helpers might be more work than using our own
irqchip implementation, requiring 1 gpiochip per pin group? (not sure)


ChenYu
