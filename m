Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:19744 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab0FWKJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jun 2010 06:09:02 -0400
Subject: Re: [PATCH 2/2] nl80211: Add option to adjust transmit power
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Artem Mygaiev <joculator@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <op.veqxtlvunp38ce@conquistador-pc.synapse.com>
References: <1277284358-11014-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1277284358-11014-2-git-send-email-juuso.oikarinen@nokia.com>
	 <op.veqxtlvunp38ce@conquistador-pc.synapse.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 13:08:48 +0300
Message-ID: <1277287728.5277.43208.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Artem,

On Wed, 2010-06-23 at 11:26 +0200, ext Artem Mygaiev wrote:
> Hello Juuso
> 
> A very minor comment - why do you need 'idx' here? Can't you just directly
> access array by NL80211_* index without adding an index variable?

The idx is there for pure beautification - there's no way to decently
fit onto one line without it ;)

-Juuso

> 
> > +	if (info->attrs[NL80211_ATTR_WIPHY_TX_POWER_SETTING]) {
> > +		enum nl80211_tx_power_setting type;
> > +		int idx, mbm = 0;
> > +
> > +		if (!rdev->ops->set_tx_power) {
> > +			return -EOPNOTSUPP;
> > +			goto bad_res;
> > +		}
> > +
> > +		idx = NL80211_ATTR_WIPHY_TX_POWER_SETTING;
> > +		type = nla_get_u32(info->attrs[idx]);
> > +
> > +		if (!info->attrs[NL80211_ATTR_WIPHY_TX_POWER_LEVEL] &&
> > +		    (type != NL80211_TX_POWER_AUTOMATIC)) {
> > +			result = -EINVAL;
> > +			goto bad_res;
> > +		}
> > +
> > +		if (type != NL80211_TX_POWER_AUTOMATIC) {
> > +			idx = NL80211_ATTR_WIPHY_TX_POWER_LEVEL;
> > +			mbm = nla_get_u32(info->attrs[idx]);
> > +		}
> > +
> > +		result = rdev->ops->set_tx_power(&rdev->wiphy, type, mbm);
> > +		if (result)
> > +			goto bad_res;
> > +	}
> 


