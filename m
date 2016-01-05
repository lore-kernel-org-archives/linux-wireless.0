Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:37829 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbcAEKSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:18:20 -0500
Received: by mail-wm0-f45.google.com with SMTP id f206so21565302wmf.0
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 02:18:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=q1kFn7tTQNhj=WH+7RUz+KT+fn9ovBaYJ_wzE5TtXu8Q@mail.gmail.com>
References: <1451984419-5727-1-git-send-email-janusz.dziedzic@tieto.com>
	<20160105094504.GA3015@w1.fi>
	<CALhHN=qfmdQuTeHEAvE0BgS2XvZJrBVUhU3BYgXMCY-pe5Ur0g@mail.gmail.com>
	<20160105100659.GA3864@w1.fi>
	<CALhHN=q1kFn7tTQNhj=WH+7RUz+KT+fn9ovBaYJ_wzE5TtXu8Q@mail.gmail.com>
Date: Tue, 5 Jan 2016 11:18:19 +0100
Message-ID: <CALhHN=o0Ydjw09h2zoqv0Zv6FwUe6fAogpGjgq5WYRDdL5rTEw@mail.gmail.com> (sfid-20160105_111824_600081_4B93BDEF)
Subject: Re: [PATCH] mac80211: add use_minrate param to ieee80211_tx_prepare_skb()
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 January 2016 at 11:16, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> On 5 January 2016 at 11:06, Jouni Malinen <j@w1.fi> wrote:
>> On Tue, Jan 05, 2016 at 10:56:18AM +0100, Janusz Dziedzic wrote:
>>> On 5 January 2016 at 10:45, Jouni Malinen <j@w1.fi> wrote:
>>> > On Tue, Jan 05, 2016 at 10:00:19AM +0100, Janusz Dziedzic wrote:
>>> >> Add use_minrate param to ieee80211_tx_prepare_skb() function.
>>> >> This is useful in case we would like to send frames
>>> >> with lowest rates, eg. nullfunc, probe_resp.
>>> >
>>> > I could kind of understand this for short frames like Data nullfunc and
>>> > PS-Poll, but why would we like to hard code Probe Response frames to be
>>> > sent at the lowest rate? Shouldn't the frames be sent at a rate that is
>>> > most likely to get them through and do so in a manner that does not use
>>> > excessive amount of air time?
>>> >
>>> This is used to get/send probe_req() frame, next used by ath9k
>>> "hw_scan" when chanctx used.
>>
>> Sure, but that's not what I'm asking. I'm asking why would we want to
>> force Probe Response frames to use the lowest rate based on that commit
>> message above. If that's a typo and should have been Probe Request
>> frame, I'm going to ask the same question about Probe Request frames.
>> Why would we like to force the lowest rate to be used for them?
>>
> I did it because most of devices I saw send probe_req using lowest rates?
> Anyway I can skip this for probe_res() frames in next patch if this is
> better idea.
>
BTW, should we export more params except minrate. I see also
IEEE80211_TX_CTL_NO_CCK_RATE is used??

So, other implementation I see is to set
info->flags |= IEEE80211_TX_CTL_NO_CCK_RATE | IEEE80211_TX_CTL_USE_MINRATE;
In the driver and check this in ieee80211_tx_prepare_skb() before
memset(0) in ieee80211_tx_prepare()
I will send V2.

BR
Janusz
