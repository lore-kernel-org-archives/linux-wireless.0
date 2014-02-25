Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:61819 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaBYNLW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 08:11:22 -0500
Received: by mail-bk0-f54.google.com with SMTP id 6so217585bkj.41
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 05:11:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393330210.4170.1.camel@jlt4.sipsolutions.net>
References: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com>
	<1393330040.4170.0.camel@jlt4.sipsolutions.net>
	<1393330210.4170.1.camel@jlt4.sipsolutions.net>
Date: Tue, 25 Feb 2014 14:11:20 +0100
Message-ID: <CA+BoTQnvSxOCxV4UwUmi2_if8NQWWJCht=urAewBZAiEJdHpZA@mail.gmail.com> (sfid-20140225_141125_579061_058B4156)
Subject: Re: [PATCH] mac80211: don't downgrade VHT20 to HT20
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 February 2014 13:10, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-02-25 at 13:07 +0100, Johannes Berg wrote:
>> On Tue, 2014-02-25 at 12:27 +0100, Michal Kazior wrote:
>> > The check led to VHT-capable devices being unable
>> > to pair in VHT20 and were instead paired in HT20.
>>
>> ??
>>
>> 802.11ac says:
>> ---
>> A VHT STA shall support the following features:
>> [...]
>> — 20 MHz, 40 MHz, and 80 MHz channel widths
>> [...]
>> ---
>>
>> so how can you have a device that's "VHT-capable" but doesn't support 40
>> MHz?
>
> And also:
>
> A VHT STA shall set the Supported Channel Width Set subfield in its HT
> Capabilities element HT Capabilities Info field to 1, indicating that
> both 20 MHz operation and 40 MHz operation are supported.
>
> (10.39.1)

The spec also defines VHT BSS operating channel width is derived from
HT Operation Element: STA Channel Width field (Table 10-19) and 20 MHz
is not forbidden for AP/mesh. hostapd seems to go in line with this
and allows VHT20 and VHT40.

Without my patch (i.e. with the 20/40 check left intact):

* If a station connects to VHT20 BSS, hostapd tries to add a VHT20
station, but mac80211 downgrades it to HT20,
* If mac80211 station connects to a VHT20 BSS it gets downgraded to HT20 too.

This means mac80211 is unable to setup VHT20 pairing properly even
though VHT20 BSS is defined in the spec.

My take is 10.39.1 means VHT STA AssocReq must contain
IEEE80211_HT_CAP_SUP_WIDTH_20_
40. I suppose AP (hostapd) should deny STA association in that case.

I'm not really sure how IBSS fits here though.


Michał
