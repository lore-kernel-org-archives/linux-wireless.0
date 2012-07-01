Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:56296 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab2GANEq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 09:04:46 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: don't require associated->beacon_ies for ps
References: <1340610505-7713-1-git-send-email-eliad@wizery.com>
	<87395j4j3y.fsf@purkki.adurom.net>
	<CAB3XZEcUoo0g7ZjGCkZViAs+B=nsYgfsZGvN1vE+WN8bFuE8Sw@mail.gmail.com>
Date: Sun, 01 Jul 2012 16:04:44 +0300
In-Reply-To: <CAB3XZEcUoo0g7ZjGCkZViAs+B=nsYgfsZGvN1vE+WN8bFuE8Sw@mail.gmail.com>
	(Eliad Peller's message of "Mon, 25 Jun 2012 16:54:39 +0300")
Message-ID: <87txxr3a4z.fsf@purkki.adurom.net> (sfid-20120701_150449_826077_AB2A8394)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eliad,

sorry for the late reply, I'm on vacation and enjoying Finland's great
summer, 18 C and raining :)

Eliad Peller <eliad@wizery.com> writes:

> On Mon, Jun 25, 2012 at 4:27 PM, Kalle Valo <kvalo@adurom.com> wrote:
>>> beacon_ies is needed only in order to extract the dtim
>>> period. However, even if it's missing we can still enter
>>> ps with dtim=1 (which also happens if the TIM ie is invalid).
>>>
>>> Most drivers don't use conf.max_sleep_period/ps_dtim_period
>>> anyway, and this check prevents them from entering ps if
>>> they don't have beacon (but only probe response), even though
>>> the beacon is not needed at all.
>>
>> Does this increase the chances of accidentally using dtim 1 even though
>> AP has dtim > 1? I'm just worried that it's difficult to detect cases
>> when we are forcing dtim to 1 and nobody might not notice it. How often
>> will this happen?
>>
> doesn't dtim=1 is still better than not entering ps at all?
> i think the only bad effect of using dtim=1 (instead of greater value)
> is wrt power saving. but entering psm with dtim=1 is still better than
> not entering psm at all.

Sure. I was just thinking ahead and trying to avoid future problems
(ie. accidentally using dtim=1).

-- 
Kalle Valo
