Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2FTIr4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:47:56 -0400
Message-ID: <1340182072.4655.41.camel@jlt3.sipsolutions.net> (sfid-20120620_104759_565910_572C67DE)
Subject: Re: [PATCH v2 5/7] nl80211/cfg80211: add ap channel switch
 command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 10:47:52 +0200
In-Reply-To: <1340111463-4554-5-git-send-email-victorg@ti.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	 <1340111463-4554-5-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 16:11 +0300, Victor Goldenshtein wrote:

> @@ -565,6 +565,15 @@
>   *	the time passed sines the beginning of the CAC is less than

interestingly now I see a typo in the previous patch: "sines"?


>   * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
> + * @NL80211_FEATURE_AP_CH_SWITCH: This driver supports AP channel switch.

what point is there in separating these flags?


> +	int	(*ap_channel_switch)(struct wiphy *wiphy, struct net_device *dev,
> +				     u32 count, bool block_tx,
> +				     bool post_switch_block_tx,
> +				     struct ieee80211_channel *new_ch);

If mac80211 needs a struct, why not have one here already rather than
all the parameters?

johannes

