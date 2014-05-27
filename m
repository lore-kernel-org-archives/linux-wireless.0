Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbaE0JBy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 05:01:54 -0400
Message-ID: <5384544F.6000806@redhat.com> (sfid-20140527_110200_907754_A426AD82)
Date: Tue, 27 May 2014 11:01:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chen-Yu Tsai <wens@csie.org>,
	linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 03/11] pinctrl: sunxi: Move setting of mux to irq type
 from unmask to set_type
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com> <1401090486-4414-4-git-send-email-hdegoede@redhat.com> <20140527080952.GC4730@lukather>
In-Reply-To: <20140527080952.GC4730@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 05/27/2014 10:09 AM, Maxime Ripard wrote:
> On Mon, May 26, 2014 at 09:47:58AM +0200, Hans de Goede wrote:
>> With level triggered interrupt mask / unmask will get called for each
>> interrupt, doing the somewhat expensive mux setting on each unmask thus is
>> not a good idea. Instead move it to the set_type callback, which is typically
>> done only once for each irq.
> 
> *This* is the bad idea. Nothing prevents you from calling
> gpio_get_value whenever you just got your interrupt, that will change
> the muxing, and never change it back, effectively breaking the
> interrupts.

Hmm, interesting point, but your assuming 2 things which are both not true:

1) That calling gpiod_get_value changes the muxing, which is not true, all
gpiod_get_value variants end up in drivers/gpio/gpiolib.c _gpiod_get_raw_value()
which does no such thing

2) That unmask will always get called after the gpio_get_value to restore the mux
setting for us, which is not guaranteed at all. Before this patch set pinctrl-sunxi.c
was using handle_simple_irq which does not mask / unmask at all.

And even with an irq-handler which masks / unmasks, what if the irq wakes up
a thread and that thread then does the gpio_get_value ?

Note this is *exactly* what e.g. the mmc gpio card-detect code does, it uses
a thread to read the gpio for debouncing.

Luckily 2. is not a problem, since 1. means that the mux won't get changed at all
so we don't need to change it back.

Regards,

Hans
