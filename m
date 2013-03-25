Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:40421 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558Ab3CYQPg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 12:15:36 -0400
Received: from mail-ie0-f173.google.com (mail-ie0-f173.google.com [209.85.223.173])
	by mail.nanl.de (Postfix) with ESMTPSA id 531F94040C
	for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 16:15:26 +0000 (UTC)
Received: by mail-ie0-f173.google.com with SMTP id 9so7644714iec.32
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 09:15:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1364226597.17540.2.camel@jlt4.sipsolutions.net>
References: <1364225994-19375-1-git-send-email-jogo@openwrt.org> <1364226597.17540.2.camel@jlt4.sipsolutions.net>
From: Jonas Gorski <jogo@openwrt.org>
Date: Mon, 25 Mar 2013 17:15:08 +0100
Message-ID: <CAOiHx=kwzdSvD33vMOEbpRAG_cdy50eFEUQb77qhOKHJxi4ruQ@mail.gmail.com> (sfid-20130325_171539_533051_4938C09F)
Subject: Re: [PATCH] mwl8k: always apply configuration even when device is idle
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 March 2013 16:49, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2013-03-25 at 16:39 +0100, Jonas Gorski wrote:
>> Fix settings not being applied when the device is idle and the firmware
>> gets reloaded (because of changing from STA to AP mode). This caused
>> the device using the wrong channel (and likely band), e.g. a 5 GHz only
>> card still defaulted to channel 6 in the 2.4 GHz band when left
>> unconfigured.
>>
>> This issue was always present, but only made visible with "mwl8k: Do not
>> call mwl8k_cmd_set_rf_channel unconditionally" (0f4316b9), since before
>> that the channel was (re-)configured at the next _config call even when
>> it did not change from the mac80211 perspective.
>
> I'm changing mac80211 back to unset idle first and then set the channel,
> if that helps ... ath9k_htc was also broken by the change.

I think it only helps partially - the main issue is that a firmware
reload seems to require reapplying any settings, but this wasn't done
the if the device was currently in idle.

Also setting the channel when the device is in idle has the advantage
for mwl8k that it does not start rx'ing packets from the wrong channel
- which did confuse mac80211 in case of my 5 GHz "only" card that
happily received frames while being left unconfigured in 2.4 GHz, with
->bands[2GHZ] == NULL. Produced several pages worth of WARN_ON()s with
stack traces, and the reason why I caught this.


Jonas
