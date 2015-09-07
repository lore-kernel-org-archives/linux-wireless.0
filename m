Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36033 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbbIGLUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 07:20:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Chor Teck Law <ctlaw@marvell.com>
Cc: David Lin <dlin@marvell.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
	<1436455659.36587.131.camel@sakura.staff.proxad.net>
	<87vbcvyokg.fsf@kamboji.qca.qualcomm.com>
	<20150804220956.GA28583@sakura.staff.proxad.net>
	<1d5d24295c1c45ec856c908c60dab13b@SC-EXCH03.marvell.com>
Date: Mon, 07 Sep 2015 14:20:04 +0300
In-Reply-To: <1d5d24295c1c45ec856c908c60dab13b@SC-EXCH03.marvell.com> (Chor
	Teck Law's message of "Wed, 5 Aug 2015 08:39:28 +0000")
Message-ID: <87vbbmeasb.fsf@kamboji.qca.qualcomm.com> (sfid-20150907_132014_185676_1F642CAB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chor Teck Law <ctlaw@marvell.com> writes:

>> On Tuesday 04 Aug 2015 à 20:02:23 (+0300), Kalle Valo wrote:
>> 
>> > I haven't looked at the driver myself yet. Do you have any estimates
>> > how much duplication there is?
>> 
>
> I do think that someone interested in this thread should compare the
> two drivers to decide if they want to accept mwlwifi (or we let it
> develop closed door).
>
> You will find the differences with some leverage. To make your
> comparison easier, here is the summary (excluding the patch1-patch6
> improvements as per review feedbacks from Johannes and community):
>
> mwlwifi functions leveraged from mwl8k:
> - 802.11n setting for mac80211
> - Functions needed to hook up to mac80211
> - Interactions with mac80211 to establish BA streams
> - Partial firmware APIs, some data fields
> - Method to pass rx packets to mac80211 (but added with 11ac rate map/reports)
>
> All others are different/new. Including some listed below:
> - Different/new 11ac chipsets, including combo BT devices
> - Added support for 11ac related settings and functions
> - Added support for concurrent AP+STA functionalities with single firmware per chip
> - Additional firmware APIs 
> - Added functions to convert newly supported settings from mac80211 to firmware
> - Different Tx datapath 
> - Different Rx low level datapath (though data structure for receiving is same)
> - Reorganized the files for future scalability and features addition (more to come)
> - Addressed all (sort of) review feedbacks from patch1-patch6 of this submission

You have named the new driver as mwlwifi, which is a really generic
name. Does that imply that mwlwifi will start supporting more Marvell
devices in the future? Or will be in the situation that you fork the
driver again and we end up having mwlwifi2, mwlwifi3 and so on?

-- 
Kalle Valo
