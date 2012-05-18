Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49719 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758215Ab2ERJvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 05:51:50 -0400
Received: by bkcji2 with SMTP id ji2so2198700bkc.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 May 2012 02:51:49 -0700 (PDT)
Message-ID: <4FB61BB2.5050900@gmail.com> (sfid-20120518_115207_744300_90F0F502)
Date: Fri, 18 May 2012 11:51:46 +0200
From: =?ISO-8859-1?Q?Mustafa_Y=FCcel?= <yuecelm@gmail.com>
MIME-Version: 1.0
To: "Divinsky, Yonatan" <yoni.divinsky@ti.com>
CC: coelho@ti.com, linux-wireless@vger.kernel.org
Subject: Re: wl12xx: extend survey with channel_time_tx, channel_busy_time
 and channel_time
References: <4FB12E62.4030905@gmail.com> <CANJm+iAxcPrgJfx_03P1L-G7YFdPDK7B-aRXDgbpand0XgULVA@mail.gmail.com>
In-Reply-To: <CANJm+iAxcPrgJfx_03P1L-G7YFdPDK7B-aRXDgbpand0XgULVA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> currently only the noise of the main channel is filled within the
>> wl1271_op_get_survey function. but to get acs working, in need to fill
>> channel_time, channel_time_tx and channel_busy_time in the survey. is it
>> somehow possible to get these values (or similar values like a duty
>> cycle value) from the firmware? the only requirement I see as far, is
>> that it should measure these values inside a ROC phase...
>>
> 
> I checked and currenty I don't see a possiblity to get this parameter,
> I am trying to find out with the firmware team. I don't quite
> understand what the parameter stand for.
> for example what does channel_time_tx exactly mean?

I am not sure if I can help you here much, because I am more familiar
with rf technologies from low-power radios like the TI CC1000 and
CC2500. maybe we dont need channel_time_tx at all as we dont send data
inside the ROC phase, we only have to find out how clear or busy the
channel is (maybe its also possible to differ valid 802.11 frames from
other APs and interference noise like from microwaves). In the terms of
CC1000/CC2500 it would be called "clear channel assessment", in terms of
ethernet "carrier sense multiple access", maybe Wifi have something
similiar to sense the channel...

here is the definition from the nl80211.h header:
NL80211_SURVEY_INFO_CHANNEL_TIME:
  amount of time (in ms) that the radio spent on this channel
NL80211_SURVEY_INFO_CHANNEL_TIME_BUSY:
  amount of the time the primary channel was sensed busy (either due to
activity or energy detect)
NL80211_SURVEY_INFO_CHANNEL_TIME_TX:
  amount of time the radio spent transmitting data
