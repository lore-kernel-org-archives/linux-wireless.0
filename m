Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2LUOgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 09:36:04 -0500
Message-ID: <1356100584.9580.11.camel@jlt4.sipsolutions.net> (sfid-20121221_153609_598458_0F6B97CC)
Subject: Re: [PATCH v2 2/3] mac80211_hwsim: beacon at beacon interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linville@tuxdriver.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com, j@wl.fi
Date: Fri, 21 Dec 2012 15:36:24 +0100
In-Reply-To: <1356029871-17794-2-git-send-email-thomas@cozybit.com> (sfid-20121220_195826_519528_27AC6675)
References: <1356029871-17794-1-git-send-email-thomas@cozybit.com>
	 <1356029871-17794-2-git-send-email-thomas@cozybit.com>
	 (sfid-20121220_195826_519528_27AC6675)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 10:57 -0800, Thomas Pedersen wrote:

> +	else if (!hrtimer_is_queued(&data->beacon_timer)) {
> +		u64 tsf = le64_to_cpu(__mac80211_hwsim_get_tsf(data));

This is odd, you haven't even modified __mac80211_hwsim_get_tsf() yet?
Also, there's mac80211_hwsim_get_tsf() (although I'd argue that they
should be the other way around wrt. endianness)

johannes


