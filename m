Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbaEGJEg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 05:04:36 -0400
Message-ID: <1399453472.10517.8.camel@jlt4.sipsolutions.net> (sfid-20140507_110445_944778_61B6730F)
Subject: Re: [PATCH] rfkill-gpio: Use gpio cansleep version
From: Johannes Berg <johannes@sipsolutions.net>
To: Loic Poulain <loic.poulain@intel.com>
Cc: linux-wireless@vger.kernel.org,
	linux-gpio <linux-gpio@vger.kernel.org>
Date: Wed, 07 May 2014 11:04:32 +0200
In-Reply-To: <1399453340.10517.7.camel@jlt4.sipsolutions.net>
References: <1399392849-6021-1-git-send-email-loic.poulain@intel.com>
	 <1399453340.10517.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 11:02 +0200, Johannes Berg wrote:
> On Tue, 2014-05-06 at 18:14 +0200, Loic Poulain wrote:
> 
> > +	if (gpiod_cansleep(rfkill->shutdown_gpio))
> > +		gpiod_set_value_cansleep(rfkill->shutdown_gpio, !blocked);
> > +	else
> > +		gpiod_set_value(rfkill->shutdown_gpio, !blocked);
> > +
> > +	if (gpiod_cansleep(rfkill->reset_gpio))
> > +		gpiod_set_value_cansleep(rfkill->reset_gpio, !blocked);
> > +	else
> > +		gpiod_set_value(rfkill->reset_gpio, !blocked);
> 
> Really? I mean, there's not even a fallback where the cansleep() API
> calls the non-sleeping one if the cansleep isn't support? This is really
> ugly.

Actually, it looks like unconditionally using the cansleep API should be
fine since it just calls the same internal helper function. Please
respin.

johannes

