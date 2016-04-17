Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:51116 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbcDQWTx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Apr 2016 18:19:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Eyal Reizer <eyalreizer@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-spi@vger.kernel.org
Subject: Re: [PATCHv2] wlcore: spi: add wl18xx support
Date: Mon, 18 Apr 2016 00:19:41 +0200
Message-ID: <14313437.cDJIgY3kzo@wuerfel> (sfid-20160418_002031_094847_E1325A73)
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B360B6C90@DFRE01.ent.ti.com>
References: <1460273570-12298-1-git-send-email-eyalr@ti.com> <8665E2433BC68541A24DFFCA87B70F5B360B6C90@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 10 April 2016 07:37:23 Reizer, Eyal wrote:
> Add support for using with both wl12xx and wl18xx.
> 
> - all wilink family needs special init command for entering wspi mode.
>   extra clock cycles should be sent after the spi init command while the
>   cs pin is high.
> - switch to controling the cs pin from the spi driver for achieveing the
>   above.
> - the selected cs gpio is read from the spi device-tree node using the
>   cs-gpios field and setup as a gpio.
> - See the example below for specifying the cs gpio using the cs-gpios entry
> &spi0   {
>         ...
>         cs-gpios = <&gpio0 5 0>;
>         ...
>         wlcore: wlcore@0 {
>                 compatible = "ti,wl1835";
>         ...
>         ...
>         };
> };
> 
> Signed-off-by: Eyal Reizer <eyalr@ti.com>

I don't think this can work in general: not all SPI hosts uses GPIOs
for controlling CS, so the logic can't work, and it's also a layering
violation for the driver to look at the parent.

I would suggest fixing this using a new API function from the SPI
core, if we don't already have a generic way to do it.

	Arnd
