Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662Ab1B1UJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Feb 2011 15:09:00 -0500
Subject: Re: [PATCH] rtlwifi: usb parts should depend on CONFIG_USB
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George <george0505@realtek.com>, linux-next@vger.kernel.org
In-Reply-To: <1298922500-21632-1-git-send-email-linville@tuxdriver.com>
References: <alpine.DEB.2.00.1102171354200.16788@ayla.of.borg>
	 <1298922500-21632-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Feb 2011 21:08:51 +0100
Message-ID: <1298923731.10109.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 14:48 -0500, John W. Linville wrote:
>  
> +ifeq ($(CONFIG_USB),y)
> +rtlwifi-objs	+= usb.o
> +endif

That reads weird, shouldn't

rtlwifi-$(CONFIG_USB) += usb.o

do? Or more likely actually use CONFIG_RTL8192CU?

johannes

