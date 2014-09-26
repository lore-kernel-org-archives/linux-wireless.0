Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:49157 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176AbaIZWDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 18:03:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH] bcma: use device from DT (brcm,bus-gpio) for SoC GPIO chip
Date: Sat, 27 Sep 2014 00:03:18 +0200
Message-ID: <2539898.4te2VKk57a@wuerfel> (sfid-20140927_000356_443854_CDE68FA0)
In-Reply-To: <1411741733-13888-1-git-send-email-zajec5@gmail.com>
References: <1411741733-13888-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 September 2014 16:28:53 Rafał Miłecki wrote:
> +The top-level axi bus may contain following children:
> +
> +- gpio: GPIO chip on the SoC
> +
> +  Required properties:
> +  - compatible: "brcm,bus-gpio"
> +  - gpio-controller : makes the node a GPIO controller
> +  - #gpio-cells : size of the GPIO specifier, must be 2
> +
> 

I wonder if it would be better to avoid the subnode here and just
make the parent itself the gpio controller.

Is the gpio controller part of the bus itself in reality, or is it
a device that gets probed on the bus?

	Arnd
