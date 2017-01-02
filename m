Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39684 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755604AbdABNiW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 08:38:22 -0500
Message-ID: <1483364298.21014.3.camel@sipsolutions.net> (sfid-20170102_143825_771855_F82FDA2E)
Subject: Re: [PATCH V2 1/3] cfg80211: allow passing struct device in the
 wiphy_new call
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Mon, 02 Jan 2017 14:38:18 +0100
In-Reply-To: <20170102132747.3491-1-zajec5@gmail.com> (sfid-20170102_142831_033140_A7AF3467)
References: <20170102132747.3491-1-zajec5@gmail.com>
         (sfid-20170102_142831_033140_A7AF3467)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3730,8 +3730,8 @@ static inline const char *wiphy_name(const
> struct wiphy *wiphy)
>   * Return: A pointer to the new wiphy. This pointer must be
>   * assigned to each netdev's ieee80211_ptr for proper operation.
>   */
> -struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int
> sizeof_priv,
> -			   const char *requested_name);
> +struct wiphy *wiphy_new_nm(struct device *dev, const struct
> cfg80211_ops *ops,
> +			   int sizeof_priv, const char
> *requested_name);

This is obviously missing documentation updates.

>   */
> -static inline struct wiphy *wiphy_new(const struct cfg80211_ops
> *ops,
> +static inline struct wiphy *wiphy_new(struct device *dev,
> +				      const struct cfg80211_ops
> *ops,

Ditto.

It looks like you practically removed all users of set_wiphy_dev(), why
not do that completely and remove that entirely?

johannes
