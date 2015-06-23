Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54061 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbbFWMay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 08:30:54 -0400
Date: Tue, 23 Jun 2015 14:30:44 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Oleg Zhurakivskyy <oleg.zhurakivskyy@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Charles Gorand <charles.gorand@effinnov.com>
Cc: linux-nfc@ml01.01.org, linux-wireless@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] NFC: nxp-nci_i2c: use flags argument of
 devm_gpiod_get_index
Message-ID: <20150623123044.GH13739@pengutronix.de> (sfid-20150623_143057_647839_0F8ECF68)
References: <1434532252-29485-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1434532252-29485-1-git-send-email-u.kleine-koenig@pengutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Wed, Jun 17, 2015 at 11:10:52AM +0200, Uwe Kleine-König wrote:
> Since 39b2bbe3d715 (gpio: add flags argument to gpiod_get*() functions)
> which appeared in v3.17-rc1, the gpiod_get* functions take an additional
> parameter that allows to specify direction and initial value for output.
> 
> Simplify driver accordingly which even make error checking more correct
I did s/make/makes/ in my tree.

> because gpiod_direction_{in,out}put might fail. Furthermore this is one
> caller less that stops us making the flags argument to gpiod_get*()
> mandatory.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> I intend to make the flags parameter to gpiod_get* mandatory once
> 4.2-rc1 arrives. So unless this patch makes it in, I'd like to get an
> Ack to take it via the gpio tree together with the change to gpiod_get.
> 
> Note this patch depends on 
> 551e306905ef (NFC: nxp-nci_i2c: Add support for enumerating through ACPI)
> which only appeared in today's next.
This still applies. So an ack would be very welcome.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
