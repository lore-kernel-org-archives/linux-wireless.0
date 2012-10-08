Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57327 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2JHTAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 15:00:36 -0400
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <johannes@sipsolutions.net>,
	<arend@broadcom.com>
Date: Mon, 8 Oct 2012 12:01:56 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v2 3.7 2/2] cfg80211: fix initialization of
 chan->max_reg_power
Message-ID: <20121008190156.GK3354@lenteja.do-not-panic.com> (sfid-20121008_210040_723181_334FDFFB)
References: <1349527254-41080-1-git-send-email-nbd@openwrt.org>
 <1349527254-41080-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1349527254-41080-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 06, 2012 at 02:40:54PM +0200, Felix Fietkau wrote:
> A few places touch chan->max_power based on updated tx power rules, but
> forget to do the same to chan->max_reg_power.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@vger.kernel.org
> ---
>  net/wireless/reg.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 3b8cbbc..bcc7d7e 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -908,7 +908,7 @@ static void handle_channel(struct wiphy *wiphy,
>  			map_regdom_flags(reg_rule->flags) | bw_flags;
>  		chan->max_antenna_gain = chan->orig_mag =
>  			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
> -		chan->max_power = chan->orig_mpwr =
> +		chan->max_reg_power = chan->max_power = chan->orig_mpwr =
>  			(int) MBM_TO_DBM(power_rule->max_eirp);
>  		return;
>  	}
> @@ -1331,7 +1331,8 @@ static void handle_channel_custom(struct wiphy *wiphy,
>  
>  	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
>  	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
> -	chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
> +	chan->max_reg_power = chan->max_power =
> +		(int) MBM_TO_DBM(power_rule->max_eirp);

This looks good to me, good catch! The commit log could use some love,
given that this is a stable patch it is worthy to describe the
consequences of not applying this patch. Can you describe what you
observed that makes this a critical patch? The only piece of code
that uses max_reg_power in cfg80211, mac80211 or drivers is on
net/wireless/reg.c and drivers/net/wireless/mwifiex/cfg80211.c.
In either case the issue the code you are patching is for code
that deals with drivers that have a custom regulatory domain
in which orig_mpwr would have been initialized to a non-zero value
upon registration. In such cases we could only potenially run into
an issue on this piece of code on handle_channel():

        chan->max_reg_power = (int) MBM_TO_DBM(power_rule->max_eirp);
        if (chan->orig_mpwr) {
                /*
                 * Devices that have their own custom regulatory domain
                 * but also use WIPHY_FLAG_STRICT_REGULATORY will follow the
                 * passed country IE power settings.
                 */
                if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
                    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
                    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY)
                        chan->max_power = chan->max_reg_power;
                else
                        chan->max_power = min(chan->orig_mpwr,
                                              chan->max_reg_power);
        } else
                chan->max_power = chan->max_reg_power;

The issue would happen if orig_mpwr is non zero (custom) and
then max_reg_power would not have been initialized. This runs
when you change a regulatory domain on a card with a custom
regulatory domain and this would be an issue if max_reg_power
would not be initialized. This however does not happen due to
the first line above.

So I agree with this patch but do not see the requirement for
it to go in as a stable fix to older stable kernels.

  Luis
