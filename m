Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54994 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaE1KvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 06:51:18 -0400
Message-ID: <5385BF9F.8060808@gmail.com> (sfid-20140528_125123_234510_181877A7)
Date: Wed, 28 May 2014 12:51:11 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Hans de Goede <hdegoede@redhat.com>,
	devicetree <devicetree@vger.kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	linux-wireless@vger.kernel.org,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-sunxi@googlegroups.com, linux-mmc@vger.kernel.org,
	Chris Ball <chris@printf.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Arend van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/11] pinctrl: sunxi: add IRQCHIP_SKIP_SET_WAKE flag
 for pinctrl irq chip
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com> <1401090486-4414-3-git-send-email-hdegoede@redhat.com> <20140527080746.GB4730@lukather> <5384B9E7.1070405@gmail.com> <20140528102912.GP4730@lukather>
In-Reply-To: <20140528102912.GP4730@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28.05.2014 12:29, Maxime Ripard wrote:
> On Tue, May 27, 2014 at 06:14:31PM +0200, Tomasz Figa wrote:
>> On 27.05.2014 10:07, Maxime Ripard wrote:
>>> On Mon, May 26, 2014 at 09:47:57AM +0200, Hans de Goede wrote:
>>>> From: Chen-Yu Tsai <wens@csie.org>
>>>> 
>>>> The sunxi pinctrl irq chip driver does not support wakeup at
>>>> the moment. Adding IRQCHIP_SKIP_SET_WAKE lets the irqs work
>>>> with drivers using wakeup.
>>>> 
>>>> Also add a name to the irq chip.
>>>> 
>>>> Signed-off-by: Chen-Yu Tsai <wens@csie.org> Signed-off-by:
>>>> Hans de Goede <hdegoede@redhat.com> --- 
>>>> drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 ++ 1 file changed,
>>>> 2 insertions(+)
>>>> 
>>>> diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c 
>>>> b/drivers/pinctrl/sunxi/pinctrl-sunxi.c index
>>>> db9ccd6..ec60c2e 100644 ---
>>>> a/drivers/pinctrl/sunxi/pinctrl-sunxi.c +++ 
>>>> b/drivers/pinctrl/sunxi/pinctrl-sunxi.c @@ -646,6 +646,8 @@ 
>>>> static struct irq_chip sunxi_pinctrl_irq_chip = {
>>>> .irq_mask_ack	= sunxi_pinctrl_irq_mask_ack, .irq_unmask	= 
>>>> sunxi_pinctrl_irq_unmask, .irq_set_type	= 
>>>> sunxi_pinctrl_irq_set_type, +	.name		= "sunxi-pio", +	.flags
>>>> = IRQCHIP_SKIP_SET_WAKE,
>>> 
>>> I'd rather see the name set to dev_name() or something like
>>> that. This will not work that great with multiple pin
>>> controller supporting interrupts.
>> 
>> Correct me if I'm wrong, but I've always thought that struct
>> irq_chip describes a class of IRQ controllers, not particular
>> instances.
> 
> It's not said as such in <linux/irq.h>, but maybe..

It is not said the otherwise as well, so hopefully someone could
clarify this. Thomas?

My conclusion about the purpose of this struct is based on its
contents - name, flags and a number of callbacks, nothing that could
be per-instance of identical chips. Moreover there is per interrupt
chip_data, which is usually used to store per-instance data by irqchip
drivers.

Best regards,
Tomasz
