Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaFKJNv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 05:13:51 -0400
Message-ID: <53981D9E.8010401@redhat.com> (sfid-20140611_111358_608518_86DF67D9)
Date: Wed, 11 Jun 2014 11:13:02 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Chris Ball <chris@printf.net>,
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
Subject: Re: [PATCH 04/11] pinctrl: sunxi: Properly handle level triggered
 gpio interrupts
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>	<1401090486-4414-5-git-send-email-hdegoede@redhat.com> <CACRpkdZ5_21aFBSJBXDzgorcEKeR9Pv5fVgmeVrBw1zDawVptA@mail.gmail.com>
In-Reply-To: <CACRpkdZ5_21aFBSJBXDzgorcEKeR9Pv5fVgmeVrBw1zDawVptA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linus,

On 06/11/2014 11:00 AM, Linus Walleij wrote:
> On Mon, May 26, 2014 at 9:47 AM, Hans de Goede <hdegoede@redhat.com> wrote:
> 
>> For level triggered gpio interrupts we need to use handle_fasteoi_irq,
>> like we do with the irq-sunxi-nmi driver. This is necessary to give threaded
>> interrupt handlers a chance to actuall clear the source of the interrupt
>> (which may involve sleeping waitnig for i2c / spi / mmc transfers), before
>> acknowledging the interrupt.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> I haven't seen any feedback on the pin controller patches in this
> series from Maxime, I might have missed it due to being tied to
> some other patch in the series.
> 
> Anyway, this needs to be rebased and reposted anyway, I
> just merged some base patches from Maxime for external
> interrupts that will go in after the merge window, I need some
> help to figure out what and how to merge here.

No problem I plan to do a rebased v2 of the pinctrl bits in
this series (and only the pinctrl bits) with some remarks
from Maxime fixed soon.

Regards,

Hans
