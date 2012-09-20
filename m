Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44234 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2ITSg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 14:36:26 -0400
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 20 Sep 2012 11:37:40 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Subject: Re: [PATCH v2] cfg80211: Fix regulatory check for 60GHz band
 frequencies
Message-ID: <20120920183740.GY3354@lenteja.do-not-panic.com> (sfid-20120920_203630_673151_197E5E84)
References: <1348039339-22246-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1348039339-22246-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1348039339-22246-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 19, 2012 at 10:22:19AM +0300, Vladimir Kondratiev wrote:
> Adjust check in the freq_in_rule_band for the 60GHz band,
> where channel spacing is 2.160GHz.
> 
> Issue exposed in the following way: 60g band defines 3 channels supported wold-wide:
> channels 1..3 or 58320, 60480, 62640 MHz, and channel 4, or 64800 MHz,
> in the most of the world, with 2160 MHz spacing.
> Corresponded regulatory rule for channels 1..3 would be
> (57240 - 63720 @ 2160)
> 
> And, when regulatory applies to the channel 2 (60480), it get disabled since it is
> more then 2GHz from either frequency boundary and freq_in_rule_band fails
> 
> Expanding frequency limit from 2GHz to 10GHz fixes the problem

This commit log message could use a lot of love. Some code comments
below as well. As for the commit log, how about:

--
The current regulatory code on cfg80211 performs a check to
see if a regulatory rule belongs to an IEEE band so that if
a Country IE is received and no rules are specified for a
band (which is allowed by IEEE) those bands are left intact.
The current band check assumes a rule is bound to a band
if the rule's start or end frequency is less than 2 GHz
apart from the center of frequency being inspected.

In order to support 60 GHz for 802.11ad we need to increase
this to account for the channel spacing of 2160 MHz whereby
a channel somewhere in the middle of a regulatory rule may
be more than 2160 MHz apart from either the beginning or
end of the frequency rule.

Without a fix for this even though channels 1-3 are allowed world
wide on the rule (57240 - 63720 @ 2160), channel 2 at 60480 MHz
will end up geting disabled given that it is 3240 MHz from
both the frequency rule start and end frequency. Fix this by
using 2 GHz separation assumption for the 2.4 and 5 GHz bands
but for 60 GHz use a 10 GHz separation before assuming a rule
is not part of the band.

Since we have no 802.11ad drivers yet merged this change has
no impact to existing Linux upstream device drivers.
---

Then some comments below.

> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  net/wireless/reg.c |   15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 4de18ae..b7c094c 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -510,9 +510,11 @@ static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
>   *
>   * This lets us know if a specific frequency rule is or is not relevant to
>   * a specific frequency's band. Bands are device specific and artificial
> - * definitions (the "2.4 GHz band" and the "5 GHz band"), however it is
> - * safe for now to assume that a frequency rule should not be part of a
> - * frequency's band if the start freq or end freq are off by more than 2 GHz.
> + * definitions (the "2.4 GHz band", the "5 GHz band" and the "60GHz band"),
> + * however it is safe for now to assume that a frequency rule should not be
> + * part of a frequency's band if the start freq or end freq are off by more
> + * than 2 GHz for the 2.4 and 5 GHz bands, and by more then 4 GHz for the
> + * 60 GHz band.

You use "4" here although you meant "10"

>   * This resolution can be lowered and should be considered as we add
>   * regulatory rule support for other "bands".
>   **/
> @@ -520,9 +522,12 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
>  	u32 freq_khz)
>  {
>  #define ONE_GHZ_IN_KHZ	1000000
> -	if (abs(freq_khz - freq_range->start_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
> +	/* DMG frequencies starts from 45 GHz, see 802.11ad */

What's this DMG thing?

> +	u32 limit = freq_khz > 45 * ONE_GHZ_IN_KHZ ?
> +			10 * ONE_GHZ_IN_KHZ : 2 * ONE_GHZ_IN_KHZ;
> +	if (abs(freq_khz - freq_range->start_freq_khz) <= limit)
>  		return true;
> -	if (abs(freq_khz - freq_range->end_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
> +	if (abs(freq_khz - freq_range->end_freq_khz) <= limit)
>  		return true;

Otherwise looks good.

  Luis
