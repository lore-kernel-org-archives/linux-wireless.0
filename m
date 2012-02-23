Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:62491 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680Ab2BWSwU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 13:52:20 -0500
Message-ID: <4F468AC1.1050100@lri.fr> (sfid-20120223_195228_881654_2EF772DC)
Date: Thu, 23 Feb 2012 19:51:45 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] carl9170: Fix memory accounting when sta is in power-save
 mode.
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr> <201202231752.44125.chunkeey@googlemail.com> <4F46771F.9000200@lri.fr> <201202231908.16364.chunkeey@googlemail.com>
In-Reply-To: <201202231908.16364.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23/02/2012 19:08, Christian Lamparter wrote:
> On Thursday, February 23, 2012 06:27:59 PM Nicolas Cavallari wrote:
>> On 23/02/2012 17:52, Christian Lamparter wrote:
>>> On Thursday, February 23, 2012 04:53:34 PM Nicolas Cavallari wrote:
>>>> While this seems to fix my problem, there could still be problems remaining
>>>> in this code path.  Particularly carl9170_tx_status will do lots of things
>>>> like incrementing counters and waking up mac80211 queues...
>>> That should be alright. As a rule of thumb, for every call to
>>> carl9170_tx_accounting [called by carl9170_op_tx tx handler]
>>> we need to call carl9170_tx_status. If the station is still in
>>> ps mode, mac80211 will cache the station's frames and sets
>>> the TIM bits. 
>> Part of the reason i wrote this, is because, while this patch fixes the
>> memory accounting problem and prevent the AP from stopping working, the
>> powersaving station sometimes cannot communicate with the AP anymore
>> (other stations can). The station uses ath9k, and is just really doing a
>> background scan. The first traces that i have just indicate that the
>> station entered powersave mode, then sends probe requests and probe
>> requests directed to the AP, then sends authentication requests to the
>> AP (?), but the AP does not respond to any of them...
>>
> Do you run an 802.11n ap on carl9170?
No, it's a 802.11g currently.
My current wild guess is that, the responses to those requests are
somehow still queued ...
