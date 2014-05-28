Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:51354 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaE1IxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 04:53:20 -0400
Received: by mail-ob0-f172.google.com with SMTP id wp18so10550927obc.31
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 01:53:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGb2v65NW61+BV2hR3wn_xRvCyPo+AhcMU7hmFjQxKWj49G=Bw@mail.gmail.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
	<1401090486-4414-2-git-send-email-hdegoede@redhat.com>
	<CACRpkdZpy2aT_kFp01bnrviVB3SOggiNUJB46wbWAY_bqW8=gg@mail.gmail.com>
	<CAGb2v65NW61+BV2hR3wn_xRvCyPo+AhcMU7hmFjQxKWj49G=Bw@mail.gmail.com>
Date: Wed, 28 May 2014 10:53:19 +0200
Message-ID: <CACRpkdbJJWXyO-beDCed5rBfAx0aMmdXLTUDtYuyWZGfABXzpA@mail.gmail.com> (sfid-20140528_105327_620014_FA05092E)
Subject: Re: [linux-sunxi] Re: [PATCH 01/11] pinctrl: sunxi: create irq/pin
 mapping during init
From: Linus Walleij <linus.walleij@linaro.org>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-sunxi <linux-sunxi@googlegroups.com>,
	devicetree <devicetree@vger.kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	Chris Ball <chris@printf.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2014 at 4:21 PM, Chen-Yu Tsai <wens@csie.org> wrote:
> On Tue, May 27, 2014 at 10:11 PM, Linus Walleij

>> I tried to hack the sunxi driver to even use the gpiolib
>> irqchip helpers but exactly this complex map thing in
>> ->irq_array[] git me stuck. If any of you guys could be so
>> nice to take a stab at this (compare to other commits
>> converting drivers to use gpiolibs irqchip helpers) then
>> I'd be very happy.
>
> We still need to rework the whole irqchip stuff for sun6i/sun8i,
> which have 1 parent interrupt per EINT capable pin bank.
>
> Earlier discussions with Maxime (on IRC IIRC) suggested moving this
> over to gpiolib irqchip helpers might be more work than using our own
> irqchip implementation, requiring 1 gpiochip per pin group? (not sure)

OK then keep your current code. I do not intend to cover all
cases in the world with these helpers, just the simple cases.
Complex hardware merits complex code.

Yours,
Linus Walleij
