Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52742 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab2JHSgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 14:36:16 -0400
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <johannes@sipsolutions.net>,
	<arend@broadcom.com>
Date: Mon, 8 Oct 2012 11:37:58 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v2 3.7 1/2] cfg80211: fix antenna gain handling
Message-ID: <20121008183758.GJ3354@lenteja.do-not-panic.com> (sfid-20121008_203620_998975_9DEE693D)
References: <1349527254-41080-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1349527254-41080-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 06, 2012 at 02:40:53PM +0200, Felix Fietkau wrote:
> No driver initializes chan->max_antenna_gain to something sensible, and
> the only place where it is being used right now is inside ath9k. This
> leads to ath9k potentially using less tx power than it can use.
> 
> Rather than going through every single driver, this patch initializes
> chan->orig_mag in wiphy_register(), ignoring whatever value the driver
> left in there. If a driver for some reason wishes to limit it independent
> from regulatory rulesets, it can do so internally.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@vger.kernel.org
> ---
>  net/wireless/core.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index 443d4d7..3f72530 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -526,8 +526,7 @@ int wiphy_register(struct wiphy *wiphy)
>  		for (i = 0; i < sband->n_channels; i++) {
>  			sband->channels[i].orig_flags =
>  				sband->channels[i].flags;
> -			sband->channels[i].orig_mag =
> -				sband->channels[i].max_antenna_gain;
> +			sband->channels[i].orig_mag = INT_MAX;

The commit log for a stable patch should describe the impact of not applying
it. In this case perhaps not being able to associate to APs due to unnecessary
power limitations -- but again that itself would only be true if some other
code used it in a way that it should not. I rather fix that if such cases
exist.

Now the purpose of orig_mag is to allow drivers to spit out to kernel and
eventually userspace if we want it what it knows about the value of the
embedded antenna gain. The regulatory code for antenna gain is useful for us in
that it is the maximum allowed antenna gain values.

This code itself hasn't been widely used throughout code but as you point out
ath9k does use it given that we can populate the antenna gain with what we read
from EEPROM and that in fact should *not* be reducing the max power from ath9k
but instead *helping* it in case it is smaller than the max allowed.

In retrospect there are a few things we can do here to improve this and use
this more efficiently. The orig_mag should be used by wiphy_register() as is.
Then upon wiphy_register() it calls wiphy_regulatory_register() and that
handles with anything regarding regulatory on the device. How about we change
this so that within wiphy_regulatory_register() (or regulatory change,
handle_channel()) we review if the device's antenna gain is over the regulatory
domain max allowed antenna gain and if it is we kick back simply mute the
device only allowing RX. If the device is changed to a regulatory domain that
allows for the antenna gain registered for the device then we unmute it. This
would in turn allow doing dynamic updates of the antenna gain as it seems you
want to introduce API for later, we'd end up checking for the newly supplied
antenna gain (and ensure that that value is higher than the embedded on on
EEPROM).

  Luis
