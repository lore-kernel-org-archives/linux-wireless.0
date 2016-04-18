Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:35121 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbcDRMiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 08:38:23 -0400
Received: by mail-wm0-f45.google.com with SMTP id a140so117999966wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 05:38:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQkHAOhwFh5grveGCH5tfsxOT=BXAx2qgF1c=GcT7SrSQw@mail.gmail.com>
References: <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-1-git-send-email-michal.kazior@tieto.com>
	<1460636302-31161-5-git-send-email-michal.kazior@tieto.com>
	<1460845772.2075.31.camel@sipsolutions.net>
	<CA+BoTQkHAOhwFh5grveGCH5tfsxOT=BXAx2qgF1c=GcT7SrSQw@mail.gmail.com>
Date: Mon, 18 Apr 2016 14:38:21 +0200
Message-ID: <CA+BoTQkQrUyihsk9MMMGY3XXGD+RqwziLwe+jKsKTG5q=StuAg@mail.gmail.com> (sfid-20160418_143826_546926_033F5853)
Subject: Re: [PATCHv3 4/5] mac80211: implement codel on fair queuing flows
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dave Taht <dave.taht@gmail.com>,
	make-wifi-fast@lists.bufferbloat.net, codel@lists.bufferbloat.net,
	Avery Pennarun <apenwarr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 April 2016 at 07:31, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 17 April 2016 at 00:29, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Thu, 2016-04-14 at 14:18 +0200, Michal Kazior wrote:
>>>
>>> +                             struct ieee80211_vif *vif;
>>> +
>>> +                             /* When packets are enqueued on txq
>>> it's easy
>>> +                              * to re-construct the vif pointer.
>>> There's no
>>> +                              * more space in tx_info so it can
>>> be used to
>>> +                              * store the necessary enqueue time
>>> for packet
>>> +                              * sojourn time computation.
>>> +                              */
>>> +                             u64 enqueue_time;
>>> +                     };
>>
>> I wonder if we could move something like the hw_key into tx_control
>> instead?
>
> Hmm.. It's probably doable. From a quick look it'll require quite some
> change here and there (e.g. tdls_channel_switch op will need to be
> extended to pass tx_control). I'll play with the idea..

This is actually far more than I thought initially. A lot of drivers
(b43, b43legacy, rtlwifi, wlxxxx, cw1200) access hw_key outside of tx
op context (tx workers, tx completions). I'm not even sure this is
safe (keys can be freed in the meantime by mac80211 hence invaliding
the pointer inside skb, no?).


Michał
