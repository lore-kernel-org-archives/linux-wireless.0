Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:20313 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbYGNN2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 09:28:18 -0400
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	<1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	<1216039127.11189.15.camel@johannes.berg>
	<1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 14 Jul 2008 16:26:49 +0300
In-Reply-To: <1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com> (ext Tomas Winkler's message of "Mon\, 14 Jul 2008 15\:46\:41 +0300")
Message-ID: <87fxqcoaue.fsf@nokia.com> (sfid-20080714_152822_338452_CA3B4FAB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

>> If this is a knob that should be adjusted then we want to enable users
>> to do it, and if it isn't then we can put a value into mac80211 and fix
>> it. Having drivers make these kinds of decisions is very bad for uniform
>> wireless behaviour.
>
> The same story as with beacon interval. This is for the power
> management. It's really hw dependent for how many beacons we can stay
> dormant.

This stuff is very much hardware dependent, I don't deny that, but
still I would assume that the basic principles are almost the same. We
just need to come up with a good interface for the drivers. Sure, it's
more work now, but if we don't do it, PSM support will eventually get
really messy because all drivers do it somehow differently.

> I really don't know what other vendors do and user should not guess
> this.

Yes, for the user this is too difficult, but I think the driver
shouldn't be making the decision either. So mac80211 stack would be
the most logical choice, and it could be make the decisions based on
user input (or something like that).

-- 
Kalle Valo
