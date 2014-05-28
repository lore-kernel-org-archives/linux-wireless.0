Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbaE1Jwe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 05:52:34 -0400
Message-ID: <5385B1B8.8070803@redhat.com> (sfid-20140528_115251_034580_14A188A1)
Date: Wed, 28 May 2014 11:51:52 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
	Linus Walleij <linus.walleij@linaro.org>
CC: Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 03/11] pinctrl: sunxi: Move setting of mux to irq type
 from unmask to set_type
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com> <1401090486-4414-4-git-send-email-hdegoede@redhat.com> <CACRpkdZcGJTXfcxN_sogm+hYHM56d_VxtuZqth0t-c2mgAJ0vA@mail.gmail.com> <20140528093653.GN4730@lukather>
In-Reply-To: <20140528093653.GN4730@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 05/28/2014 11:36 AM, Maxime Ripard wrote:
> On Tue, May 27, 2014 at 04:18:29PM +0200, Linus Walleij wrote:
>> On Mon, May 26, 2014 at 9:47 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>>
>>> With level triggered interrupt mask / unmask will get called for each
>>> interrupt, doing the somewhat expensive mux setting on each unmask thus is
>>> not a good idea. Instead move it to the set_type callback, which is typically
>>> done only once for each irq.
>>>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>
>> Yes move it out of mask/unmask but no, not into set_type().
>>
>> Can you not use the irqchip startup()/shutdown() callbacks
>> instead?
> 
> I think we can use irq_request_resources then
> https://lkml.org/lkml/2014/3/12/307

Sounds good, I'll modify the patch to move it here before posting a v2 of
this series. Note v2 likely won't happen till this weekend, -ENOTIME.

> We could even merge the gpio_to_irq code into it.

Erm, no we need that as a separate function for the gpio_chip's to_irq
callback.

> It's called in __setup_irq, so it's guaranteed to be called, and it
> will bail out early without doing anything, since it's one of the
> first thing __setup_irq does.

Right, as I said above, this sounds good.

Regards,

Hans
