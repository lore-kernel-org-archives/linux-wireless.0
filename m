Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:39861 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaE0IfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 04:35:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140527080257.GA4730@lukather>
References: <1401090486-4414-1-git-send-email-hdegoede@redhat.com>
 <1401090486-4414-2-git-send-email-hdegoede@redhat.com> <20140527080257.GA4730@lukather>
From: Chen-Yu Tsai <wens@csie.org>
Date: Tue, 27 May 2014 16:35:03 +0800
Message-ID: <CAGb2v66MB79bxhYq=iQy75OZ9KxtjocY+tVxZPN1NoVhPe=edQ@mail.gmail.com> (sfid-20140527_103534_375778_DFB3DB6C)
Subject: Re: [linux-sunxi] Re: [PATCH 01/11] pinctrl: sunxi: create irq/pin
 mapping during init
To: linux-sunxi <linux-sunxi@googlegroups.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Chris Ball <chris@printf.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2014 at 4:02 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Hi,
>
> On Mon, May 26, 2014 at 09:47:56AM +0200, Hans de Goede wrote:
>> From: Chen-Yu Tsai <wens@csie.org>
>>
>> The irq/pin mapping is used to lookup the pin to mux to the irq
>> function when the irq is enabled. It is created when gpio_to_irq
>> is called. Creating the mapping during init allows us to map the
>> interrupts directly from the device tree.
>
> Can you be a bit more precise on this?
>
> What is the issue that this patch fix?

IIRC, originally the IRQ to pin mapping was created when gpio_to_irq
was called with a GPIO handle. The mapping in turn is used to mux
the pin into EINT mode.

If the mapping is created during gpio_to_irq, we can't use the
interrupts directly, i.e. through the DT with "interrupts = <&pio A 4>".

Instead we'd have to use "gpios = <&pio A B>", then pass the gpio
through to gpio_to_irq.


ChenYu
