Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55316 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbcGRRE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 13:04:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Reizer\, Eyal" <eyalr@ti.com>
Cc: Rob Herring <robh@kernel.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi\@vger.kernel.org" <linux-spi@vger.kernel.org>
Subject: Re: [PATCH v5] wlcore: spi: add wl18xx support
References: <8665E2433BC68541A24DFFCA87B70F5B36156367@DFRE01.ent.ti.com>
	<8665E2433BC68541A24DFFCA87B70F5B3615D8AA@DFRE01.ent.ti.com>
Date: Mon, 18 Jul 2016 20:04:19 +0300
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B3615D8AA@DFRE01.ent.ti.com>
	(Eyal Reizer's message of "Sun, 17 Jul 2016 06:36:11 +0000")
Message-ID: <87vb02x4h8.fsf@kamboji.qca.qualcomm.com> (sfid-20160718_190454_033434_B803F448)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> writes:

> Add support for using with both wl12xx and wl18xx.
>
> - all wilink family needs special init command for entering wspi mode.
>   extra clock cycles should be sent after the spi init command while the
>   cs pin is high.
> - Use inverted chip select for sending a dummy 4 bytes command that
>   completes the init stage.
>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
> v1->v2:update device tree bindings configuration
> v2->v3:revert from manual gpio manipulation. use inverted chip select 
> instead for sending the extra init cycle which, achieves the same hardware 
> purpose.
> update device tree bindings docucmentation accordingly
> v3->v4: Remove redundant data form binding documentation and fix chip 
> select number mismatch in wl1271 example
> v4->v5: Rebase on top of head of wireless-drivers-next

You now sent me two patches with v5 which is just confusing. To make the
life of maintainers easier ALWAYS increase the revision number, no
matter how small the change is.

But the "latter" v5 is corrupted somehow in patchwork:

https://patchwork.kernel.org/patch/9233597/

The "former" v5 again looks ok:

https://patchwork.kernel.org/patch/9222403/

I can't immeaditely see why that happened, but please resend.

-- 
Kalle Valo
