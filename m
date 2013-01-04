Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51904 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3ADM7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jan 2013 07:59:10 -0500
Message-ID: <1357304360.11302.1.camel@jlt4.sipsolutions.net> (sfid-20130104_135914_116767_7F541645)
Subject: Re: [PATCH v2 2/4] mac80211_hwsim: hrtimer beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linville@tuxdriver.org, j@w1.fi, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Fri, 04 Jan 2013 13:59:20 +0100
In-Reply-To: <1357167319-13338-2-git-send-email-thomas@cozybit.com> (sfid-20130102_235557_467689_F4EE95CB)
References: <1357167319-13338-1-git-send-email-thomas@cozybit.com>
	 <1357167319-13338-2-git-send-email-thomas@cozybit.com>
	 (sfid-20130102_235557_467689_F4EE95CB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-02 at 14:55 -0800, Thomas Pedersen wrote:

> -	struct ieee80211_hw *hw = (struct ieee80211_hw *) arg;
> -	struct mac80211_hwsim_data *data = hw->priv;
> +	struct tasklet_hrtimer *ttimer = container_of(timer,
> +						      struct tasklet_hrtimer,
> +						      timer);
> +	struct mac80211_hwsim_data *data = container_of(ttimer,
> +						struct mac80211_hwsim_data,
> +						beacon_timer);

I simplified this to just use "beacon_timer.timer" in the second
container_of()

johannes

