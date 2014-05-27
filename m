Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46513 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbaE0OSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 10:18:30 -0400
Received: by mail-ob0-f169.google.com with SMTP id vb8so9392423obc.0
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 07:18:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401090486-4414-4-git-send-email-hdegoede@redhat.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
	<1401090486-4414-4-git-send-email-hdegoede@redhat.com>
Date: Tue, 27 May 2014 16:18:29 +0200
Message-ID: <CACRpkdZcGJTXfcxN_sogm+hYHM56d_VxtuZqth0t-c2mgAJ0vA@mail.gmail.com> (sfid-20140527_161834_420690_89521B4B)
Subject: Re: [PATCH 03/11] pinctrl: sunxi: Move setting of mux to irq type
 from unmask to set_type
From: Linus Walleij <linus.walleij@linaro.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 26, 2014 at 9:47 AM, Hans de Goede <hdegoede@redhat.com> wrote:

> With level triggered interrupt mask / unmask will get called for each
> interrupt, doing the somewhat expensive mux setting on each unmask thus is
> not a good idea. Instead move it to the set_type callback, which is typically
> done only once for each irq.
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Yes move it out of mask/unmask but no, not into set_type().

Can you not use the irqchip startup()/shutdown() callbacks
instead?

And how come we have no clean separation between gpiochip
and the pinmux parts here, why cant we just call
pinctrl_request_gpio() and pinctrl_free_gpio() here instead?
Or maybe pinctrl_gpio_direction_input() and have that set
up the muxing in the pinctrl driver side?

It looks slightly convoluted.

Yours,
Linus Walleij
