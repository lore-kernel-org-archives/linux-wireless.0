Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:31021 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394AbYGOTcz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 15:32:55 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by low level driver
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	<1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	<1216039127.11189.15.camel@johannes.berg>
	<1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	<87fxqcoaue.fsf@nokia.com> <1216109543.23746.21.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 15 Jul 2008 22:30:52 +0300
In-Reply-To: <1216109543.23746.21.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 15 Jul 2008 10\:12\:23 +0200")
Message-ID: <87skub9c7n.fsf@nokia.com> (sfid-20080715_213258_338190_5569F22B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Yes, for the user this is too difficult, but I think the driver
>> shouldn't be making the decision either. So mac80211 stack would be
>> the most logical choice, and it could be make the decisions based on
>> user input (or something like that).
>
> Well, the user may want to make a choice based on the latency.

Yeah, latency might be a good choise for the user. Also it would be
nice to be able to say if packet loss is acceptable. For example, I
have heard cases where DTIMs are skipped just to save power in the
expense of loosing some of the broadcast and multicast frames.

> Or, ideally, we would detect that they're using voice and want lower
> latency. Or something like that.

In that case U-APSD needs to be considered as well.

This PSM stuff will be challenging...

-- 
Kalle Valo
