Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60740 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab2LUSbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 13:31:18 -0500
Received: by mail-pb0-f44.google.com with SMTP id uo1so2898092pbc.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Dec 2012 10:31:17 -0800 (PST)
Date: Fri, 21 Dec 2012 10:30:53 -0800
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com, j@wl.fi
Subject: Re: [PATCH v2 2/3] mac80211_hwsim: beacon at beacon interval
Message-ID: <20121221183053.GB24585@cable.cozybit.com> (sfid-20121221_193121_671243_D8BCDCA2)
References: <1356029871-17794-1-git-send-email-thomas@cozybit.com>
 <1356029871-17794-2-git-send-email-thomas@cozybit.com>
 <1356100584.9580.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1356100584.9580.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 21, 2012 at 03:36:24PM +0100, Johannes Berg wrote:
> On Thu, 2012-12-20 at 10:57 -0800, Thomas Pedersen wrote:
> 
> > +	else if (!hrtimer_is_queued(&data->beacon_timer)) {
> > +		u64 tsf = le64_to_cpu(__mac80211_hwsim_get_tsf(data));
> 
> This is odd, you haven't even modified __mac80211_hwsim_get_tsf() yet?
> Also, there's mac80211_hwsim_get_tsf() (although I'd argue that they
> should be the other way around wrt. endianness)

You're right, mac80211_hwsim_get_tsf() is less redundant. Also I guess
the timebase changes should go into the first patch.

Thomas
