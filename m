Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab3ABNkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 08:40:17 -0500
Message-ID: <1357134029.9839.28.camel@jlt4.sipsolutions.net> (sfid-20130102_144020_682605_2924F20A)
Subject: Re: [PATCHv5 4/8] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	zefir.kurtisi@neratec.com, adrian@freebsd.org, j@w1.fi,
	coelho@ti.com, assaf@ti.com, igalc@ti.com, nbd@nbd.name,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Jan 2013 14:40:29 +0100
In-Reply-To: <1355407113-27006-5-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1355407113-27006-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1355407113-27006-5-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 14:58 +0100, Simon Wunderlich wrote:

> +	int (*start_radar_detection)(struct ieee80211_hw *hw,
> +				     struct ieee80211_vif *vif,
> +				     struct ieee80211_channel *chan);

pass a chandef?


> +void ieee80211_radar_detected(struct ieee80211_vif *vif,
> +			      struct ieee80211_channel *chan, gfp_t gfp);

Here you probably don't need to pass the channel, once the tracking in
cfg80211 moves into the sdata (or even local) struct the same can happen
in mac80211.

johannes

