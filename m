Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47621 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2ITUMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 16:12:40 -0400
Received: by lbbgj3 with SMTP id gj3so2934170lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2012 13:12:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <505B77F9.1010000@broadcom.com>
References: <1348039339-22246-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1348039339-22246-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <20120920183740.GY3354@lenteja.do-not-panic.com> <505B77F9.1010000@broadcom.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 20 Sep 2012 13:12:18 -0700
Message-ID: <CAB=NE6XzFa5sGJKGwSxoNOwq3N3ROoSc7_bmd_-btH2A=k4jNQ@mail.gmail.com> (sfid-20120920_221243_322827_9A18C1F2)
Subject: Re: [PATCH v2] cfg80211: Fix regulatory check for 60GHz band frequencies
To: Arend van Spriel <arend@broadcom.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 20, 2012 at 1:09 PM, Arend van Spriel <arend@broadcom.com> wrote:
> On 09/20/2012 08:37 PM, Luis R. Rodriguez wrote:
>>
>> On Wed, Sep 19, 2012 at 10:22:19AM +0300, Vladimir Kondratiev wrote:
>>>
>>> @@ -520,9 +522,12 @@ static bool freq_in_rule_band(const struct
>>> ieee80211_freq_range *freq_range,
>>>         u32 freq_khz)
>>>   {
>>>   #define ONE_GHZ_IN_KHZ        1000000
>>> -       if (abs(freq_khz - freq_range->start_freq_khz) <= (2 *
>>> ONE_GHZ_IN_KHZ))
>>> +       /* DMG frequencies starts from 45 GHz, see 802.11ad */
>>
>>
>> What's this DMG thing?
>>
>
> From 11ad:
>
> directional multi-gigabit (DMG): Pertaining to operation in a frequency band
> containing a channel with the Channel starting frequency above 45 GHz.

Adding something like that then may help explain to those who have no
clue what DMG is :D

  Luis
