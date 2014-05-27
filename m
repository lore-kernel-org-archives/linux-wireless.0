Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64738 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaE0OLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 10:11:10 -0400
Received: by mail-oa0-f47.google.com with SMTP id i7so9641211oag.6
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2014 07:11:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401090486-4414-2-git-send-email-hdegoede@redhat.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
	<1401090486-4414-2-git-send-email-hdegoede@redhat.com>
Date: Tue, 27 May 2014 16:11:09 +0200
Message-ID: <CACRpkdZpy2aT_kFp01bnrviVB3SOggiNUJB46wbWAY_bqW8=gg@mail.gmail.com> (sfid-20140527_161115_678163_2CC7D7C3)
Subject: Re: [PATCH 01/11] pinctrl: sunxi: create irq/pin mapping during init
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

> From: Chen-Yu Tsai <wens@csie.org>
>
> The irq/pin mapping is used to lookup the pin to mux to the irq
> function when the irq is enabled. It is created when gpio_to_irq
> is called. Creating the mapping during init allows us to map the
> interrupts directly from the device tree.
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

This is exactly correct. Patch applied.

I tried to hack the sunxi driver to even use the gpiolib
irqchip helpers but exactly this complex map thing in
->irq_array[] git me stuck. If any of you guys could be so
nice to take a stab at this (compare to other commits
converting drivers to use gpiolibs irqchip helpers) then
I'd be very happy.

Yours,
Linus Walleij
