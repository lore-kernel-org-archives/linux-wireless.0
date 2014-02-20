Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:50731 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbaBTQiv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 11:38:51 -0500
Message-ID: <53062F97.3050407@wwwdotorg.org> (sfid-20140220_173914_915802_A8D6F211)
Date: Thu, 20 Feb 2014 09:38:47 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>
CC: Chen-Yu Tsai <wens@csie.org>, Rhyland Klein <rklein@nvidia.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCH 2/4] net: rfkill: gpio: remove gpio names
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com> <1392900697-27577-3-git-send-email-heikki.krogerus@linux.intel.com>
In-Reply-To: <1392900697-27577-3-git-send-email-heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2014 05:51 AM, Heikki Krogerus wrote:
> There is no use for them in this driver. This will fix a
> static checker warning..

Didn't you remove the use:

-	gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
+	gpio = devm_gpiod_get_index(&pdev->dev, NULL, 0);

doesn't that parameter get put into the sysfs GPIO debug file, so people
can see which GPIOs are used for what?
