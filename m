Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63790 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab0GFLsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 07:48:50 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTim4E4LlFERmfYA1M0HLBOoRAsQuvdW6QBNu6pC0@mail.gmail.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-6-git-send-email-ohad@wizery.com> <alpine.LFD.2.00.1007052134460.6020@xanadu.home>
	<AANLkTim4E4LlFERmfYA1M0HLBOoRAsQuvdW6QBNu6pC0@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 6 Jul 2010 14:48:29 +0300
Message-ID: <AANLkTinE5LygUWJsJSEE2miZF1GK58LTr8zErkuu_7yM@mail.gmail.com>
Subject: Re: [PATCH 05/15] omap: hsmmc: add virtual card detect support
To: Nicolas Pitre <nico@fluxnic.net>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Pandita, Vikram" <vikram.pandita@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 6, 2010 at 1:22 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Note: the wl1271 device does support standard card detection, but
> AFAIK there's a limitation to use that with the specific omap
> controller the device is hardwired to. I will try to get more info
> about that, but probably Madhu can comment on that better.


Some correction and additional info:

The wl1271 device has an issue which makes the standard card detect
mechanism irrelevant: it is always up, even if the power enable gpio
input of the device is down (the power enable input does not supply
the power to the chip, it's just logical digital high/low input upon
which the device reacts).  That's why we must use software control for
emulating card detect with that device.

In addition, as far as I could find out, the card detect mechanism on
the ZOOM is implemented by mechanical means, and thus is not relevant
for hardwired embedded SDIO devices (I'm not even sure card detect is
supported for the 3rd mmc controller).
