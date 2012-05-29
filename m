Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:33633 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752542Ab2E2IdK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 04:33:10 -0400
Received: by lahi5 with SMTP id i5so2889008lah.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2012 01:33:07 -0700 (PDT)
Message-ID: <1338280385.15008.74.camel@cumari.coelho.fi> (sfid-20120529_103326_247559_FB16E8C4)
Subject: Re: [PATCH v2] wlcore: fix undefined symbols when CONFIG_PM is not
 defined
From: Luciano Coelho <coelho@ti.com>
To: eyal@wizery.com, "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 29 May 2012 11:33:05 +0300
In-Reply-To: <1338280122-28648-1-git-send-email-eyal@wizery.com>
References: <1338280122-28648-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-05-29 at 01:28 -0700, Eyal Shapira wrote:
> commit c21eebb50379a96e1335e933583dcd5b455c6b64
> "wl12xx: add RX filters ACX commands" breaks the build
> when CONFIG_PM isn't defined:
> 
> ERROR: "wl1271_rx_filter_get_fields_size"
> [drivers/net/wireless/ti/wlcore/wlcore.ko] undefined!
> ERROR: "wl1271_rx_filter_flatten_fields"
> [drivers/net/wireless/ti/wlcore/wlcore.ko] undefined!
> 
> code in drivers/net/wireless/ti/wlcore/acx.c is using these
> functions unconditionally while they are #ifdefed CONFIG_PM.
> Fix it by ifdefing all relevant RX filters code with CONFIG_PM.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---
> v2: reference the correct commit in linux-next (Thanks Stephen!)

Thanks for the correction.  For v2:

Acked-by: Luciano Coelho <coelho@ti.com>

-- 
Cheers,
Luca.

