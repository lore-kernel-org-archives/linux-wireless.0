Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54075 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756260AbaJHLi7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2014 07:38:59 -0400
Date: Wed, 8 Oct 2014 14:38:45 +0300
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Loic Poulain <loic.poulain@intel.com>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] net: rfkill: gpio: Implement host wake up support
Message-ID: <20141008113845.GB3514@kuha.fi.intel.com> (sfid-20141008_134929_694001_B0D42DDF)
References: <1412757280-31367-1-git-send-email-loic.poulain@intel.com>
 <1412757280-31367-3-git-send-email-loic.poulain@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1412757280-31367-3-git-send-email-loic.poulain@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2014 at 10:34:38AM +0200, Loic Poulain wrote:
> Some GPIO based rfkill devices can wake their host up from suspend by
> toggling an input (from the host perspective) GPIO.
> This patch adds a generic support for that feature by registering a
> threaded interrupt routine and thus setting the corresponding GPIO as a
> wake up source.
> 
> Signed-off-by: Loic Poulain <loic.poulain@intel.com>
> ---
>  net/rfkill/rfkill-gpio.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)

To continue my previous answer, for this you could have the following
_DSD..

        Name (_DSD, Package ()
        {
            ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
            Package () {
                Package () {"host_wake-gpio", Package () {^BTH1, 0, 0, 0}},
                Package () {"reset-gpio", Package () {^BTH1, 1, 0, 0}},
                Package () {"shutdown-gpio", Package () {^BTH1, 2, 0, 0}},
            }
        })

And in the driver you can then request it without caring about the
index..

        ...
        gpio = devm_gpiod_get_index(dev, "host_wake", 3);
        if (!IS_ERR(gpio)) {
		ret = gpiod_direction_input(gpio);
		if (ret)
			return ret;
		rfkill->irq = gpiod_to_irq(gpio);
        ...


Actually, we could just use devm_gpiod_get instead of
devm_gpiod_get_index in this case.


Cheers,

-- 
heikki
