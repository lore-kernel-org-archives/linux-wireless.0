Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37359 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab2KPSTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 13:19:11 -0500
Message-ID: <1353089894.10872.77.camel@cumari.coelho.fi> (sfid-20121116_191934_644363_9F844545)
Subject: Re: [PATCH 2/5] drivers/net/wireless/ti/wlcore/main.c: eliminate
 possible double power off
From: Luciano Coelho <coelho@ti.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: <kernel-janitors@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Date: Fri, 16 Nov 2012 20:18:14 +0200
In-Reply-To: <1350816727-1381-3-git-send-email-Julia.Lawall@lip6.fr>
References: <1350816727-1381-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1350816727-1381-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-10-21 at 12:52 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The function wl12xx_set_power_on is only called twice, once in
> wl12xx_chip_wakeup and once in wl12xx_get_hw_info.  On the failure of the
> call in wl12xx_chip_wakeup, the containing function just returns, but on
> the failure of the call in wl12xx_get_hw_info, the containing function
> calls wl1271_power_off.  This does not seem necessary, because if
> wl12xx_set_power_on has set the power on and then fails, it has already
> turned the power off.

[...]

Applied and pushed, thanks!

--
Luca.

