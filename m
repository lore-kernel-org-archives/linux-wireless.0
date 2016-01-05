Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:38361 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbcAEJ4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:56:19 -0500
Received: by mail-wm0-f52.google.com with SMTP id b14so20577762wmb.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jan 2016 01:56:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160105094504.GA3015@w1.fi>
References: <1451984419-5727-1-git-send-email-janusz.dziedzic@tieto.com>
	<20160105094504.GA3015@w1.fi>
Date: Tue, 5 Jan 2016 10:56:18 +0100
Message-ID: <CALhHN=qfmdQuTeHEAvE0BgS2XvZJrBVUhU3BYgXMCY-pe5Ur0g@mail.gmail.com> (sfid-20160105_105623_950850_E71C7816)
Subject: Re: [PATCH] mac80211: add use_minrate param to ieee80211_tx_prepare_skb()
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 January 2016 at 10:45, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Jan 05, 2016 at 10:00:19AM +0100, Janusz Dziedzic wrote:
>> Add use_minrate param to ieee80211_tx_prepare_skb() function.
>> This is useful in case we would like to send frames
>> with lowest rates, eg. nullfunc, probe_resp.
>
> I could kind of understand this for short frames like Data nullfunc and
> PS-Poll, but why would we like to hard code Probe Response frames to be
> sent at the lowest rate? Shouldn't the frames be sent at a rate that is
> most likely to get them through and do so in a manner that does not use
> excessive amount of air time?
>
This is used to get/send probe_req() frame, next used by ath9k
"hw_scan" when chanctx used.


> --
> Jouni Malinen                                            PGP id EFC895FA
