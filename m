Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56465 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbaHKPOv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 11:14:51 -0400
Message-ID: <1407770081.9844.12.camel@jlt4.sipsolutions.net> (sfid-20140811_171454_769365_46643721)
Subject: Re: [PATCHv4 1/2] cfg80211: enable dynack through nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Date: Mon, 11 Aug 2014 17:14:41 +0200
In-Reply-To: <1406556148-3924-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140728_160233_044426_F578F4E5)
References: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406556148-3924-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20140728_160233_044426_F578F4E5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index f1db15b..0b2d55d 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -1594,6 +1594,9 @@ enum nl80211_commands {
>   * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
>   *	the TDLS link initiator.
>   *
> + * @NL80211_ATTR_WIPHY_DYN_ACK: whether dynamic ack timeout estimation
> + *	algorithm is enabled

You should probably describe that it's related to the
NL80211_FEATURE_ACKTO_ESTIMATION feature (and you should document that
it's a flag) since otherwise nobody will be able to correlate the two
things easily. :)


> +       if (info->attrs[NL80211_ATTR_WIPHY_DYN_ACK]) {
> +               if (!(rdev->wiphy.features &
> NL80211_FEATURE_ACKTO_ESTIMATION))
> +                       return -EOPNOTSUPP;
> +
> +               changed |= WIPHY_PARAM_DYN_ACK;
> +       }

that doesn't really seem right, how do you turn it off??

johannes

