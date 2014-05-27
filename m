Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:35915 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbaE0JxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 05:53:18 -0400
MIME-Version: 1.0
In-Reply-To: <5384563D.2000000@redhat.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-3-git-send-email-hdegoede@redhat.com> <20140527080746.GB4730@lukather>
 <5384563D.2000000@redhat.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 27 May 2014 17:52:57 +0800
Message-ID: <CAGb2v66PnSHekfBvUBe=GHqH9Ym+EvjLO7fFuPhULjRMn1EBwA@mail.gmail.com> (sfid-20140527_115324_614447_695B814C)
Subject: Re: [PATCH 02/11] pinctrl: sunxi: add IRQCHIP_SKIP_SET_WAKE flag for
 pinctrl irq chip
To: Hans de Goede <hdegoede@redhat.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2014 at 5:09 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
> On 05/27/2014 10:07 AM, Maxime Ripard wrote:
>> On Mon, May 26, 2014 at 09:47:57AM +0200, Hans de Goede wrote:
>>> From: Chen-Yu Tsai <wens@csie.org>
>>>
>>> The sunxi pinctrl irq chip driver does not support wakeup at the
>>> moment. Adding IRQCHIP_SKIP_SET_WAKE lets the irqs work with drivers
>>> using wakeup.
>>>
>>> Also add a name to the irq chip.
>>>
>>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>>  drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
>>> index db9ccd6..ec60c2e 100644
>>> --- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
>>> +++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
>>> @@ -646,6 +646,8 @@ static struct irq_chip sunxi_pinctrl_irq_chip = {
>>>      .irq_mask_ack   = sunxi_pinctrl_irq_mask_ack,
>>>      .irq_unmask     = sunxi_pinctrl_irq_unmask,
>>>      .irq_set_type   = sunxi_pinctrl_irq_set_type,
>>> +    .name           = "sunxi-pio",
>>> +    .flags          = IRQCHIP_SKIP_SET_WAKE,
>>
>> I'd rather see the name set to dev_name() or something like that. This
>> will not work that great with multiple pin controller supporting
>> interrupts.
>
> That would require moving the irq_chip struct to become a member of the
> sunxi_pinctrl struct. Not undoable, but that seems like something which
> should be done in a separate patch. So shall I just drop the .name part
> of this patch for now ?

Please do. AFAIK, .name is only used for the debugfs representation.
This change was only meant for cosmetic purposes.


ChenYu
