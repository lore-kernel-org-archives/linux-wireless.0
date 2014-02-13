Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42799 "EHLO
	hauke-m.de" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaBMXfW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 18:35:22 -0500
Message-ID: <52FD569F.1070408@hauke-m.de> (sfid-20140214_003541_461411_BCDD8942)
Date: Fri, 14 Feb 2014 00:34:55 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [3.14 FIX][PATCH] bcma: gpio: register all 32 GPIOs
References: <1392311186-7805-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1392311186-7805-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2014 06:06 PM, Rafał Miłecki wrote:
> Broadcom boards have 32 GPIOs (not 16) and these higher ones are
> actually used on some devices (for buttons, reset of WiFi devices).
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> Similar patch may be needed for ssb, however I didn't meet any ssb SoC
> with GPIOs 16-31 connected to anything.
> This is so trivial I hope it can go as a fix for 3.14. It allows support
> for some devices that use these higher GPIOs.
> ---
>  drivers/bcma/driver_gpio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
Are you sure all the bcma SoC have 32 GPIO lines or is there no problem
when they do not? For at least some ssb based SoCs I know that they only
have 16 GPIO lines.

Hauke
