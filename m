Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbaEGJCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:02:31 -0400
Message-ID: <1399453340.10517.7.camel@jlt4.sipsolutions.net> (sfid-20140507_110235_340141_1A135760)
Subject: Re: [PATCH] rfkill-gpio: Use gpio cansleep version
From: Johannes Berg <johannes@sipsolutions.net>
To: Loic Poulain <loic.poulain@intel.com>
Cc: linux-wireless@vger.kernel.org,
	linux-gpio <linux-gpio@vger.kernel.org>
Date: Wed, 07 May 2014 11:02:20 +0200
In-Reply-To: <1399392849-6021-1-git-send-email-loic.poulain@intel.com>
References: <1399392849-6021-1-git-send-email-loic.poulain@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-06 at 18:14 +0200, Loic Poulain wrote:

> +	if (gpiod_cansleep(rfkill->shutdown_gpio))
> +		gpiod_set_value_cansleep(rfkill->shutdown_gpio, !blocked);
> +	else
> +		gpiod_set_value(rfkill->shutdown_gpio, !blocked);
> +
> +	if (gpiod_cansleep(rfkill->reset_gpio))
> +		gpiod_set_value_cansleep(rfkill->reset_gpio, !blocked);
> +	else
> +		gpiod_set_value(rfkill->reset_gpio, !blocked);

Really? I mean, there's not even a fallback where the cansleep() API
calls the non-sleeping one if the cansleep isn't support? This is really
ugly.

johannes

