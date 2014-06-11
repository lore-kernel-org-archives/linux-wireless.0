Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57386 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaFKJAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 05:00:31 -0400
Received: by mail-ob0-f180.google.com with SMTP id vb8so4902423obc.11
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 02:00:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1401090486-4414-5-git-send-email-hdegoede@redhat.com>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
	<1401090486-4414-5-git-send-email-hdegoede@redhat.com>
Date: Wed, 11 Jun 2014 11:00:30 +0200
Message-ID: <CACRpkdZ5_21aFBSJBXDzgorcEKeR9Pv5fVgmeVrBw1zDawVptA@mail.gmail.com> (sfid-20140611_110040_444391_C0E7405A)
Subject: Re: [PATCH 04/11] pinctrl: sunxi: Properly handle level triggered
 gpio interrupts
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

> For level triggered gpio interrupts we need to use handle_fasteoi_irq,
> like we do with the irq-sunxi-nmi driver. This is necessary to give threaded
> interrupt handlers a chance to actuall clear the source of the interrupt
> (which may involve sleeping waitnig for i2c / spi / mmc transfers), before
> acknowledging the interrupt.
>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

I haven't seen any feedback on the pin controller patches in this
series from Maxime, I might have missed it due to being tied to
some other patch in the series.

Anyway, this needs to be rebased and reposted anyway, I
just merged some base patches from Maxime for external
interrupts that will go in after the merge window, I need some
help to figure out what and how to merge here.

Yours,
Linus Walleij
