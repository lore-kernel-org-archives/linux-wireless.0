Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:57089 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbbBHKlP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 05:41:15 -0500
Received: by mail-ig0-f174.google.com with SMTP id b16so11222507igk.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 02:41:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150207115758.GA503@w1.fi>
References: <1420645811-17877-1-git-send-email-eliad@wizery.com>
	<1420645811-17877-3-git-send-email-eliad@wizery.com>
	<20150207115758.GA503@w1.fi>
Date: Sun, 8 Feb 2015 12:41:14 +0200
Message-ID: <CAB3XZEfhCkHFNg1ypxGd7sHreYmGDiUZUjOBokrsbGwJs-qP6A@mail.gmail.com> (sfid-20150208_114117_985104_BA30925D)
Subject: Re: [PATCH v2 3/3] mac80211: don't defer scans in case of radar detection
From: Eliad Peller <eliad@wizery.com>
To: Jouni Malinen <j@w1.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

On Sat, Feb 7, 2015 at 1:57 PM, Jouni Malinen <j@w1.fi> wrote:
> On Wed, Jan 07, 2015 at 05:50:11PM +0200, Eliad Peller wrote:
>> Radar detection can last indefinite time. There is no
>> point in deferring a scan request in this case - simply
>> return -EBUSY.
>
>> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
>> @@ -505,7 +505,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
>> -     if (local->scan_req)
>> +     if (local->scan_req || ieee80211_is_radar_required(local))
>>               return -EBUSY;
>
> This seems to be breaking a hwsim test case sequence of ap_vht80plus80
> followed by ap_vht80. In such a case, all the HT40 scans for ap_vht80
> fail due to this added condition resulting in -EBUSY being returned
> every time. It looks like this happens even if I change ap_vht80 to use
> the same country code (US) as ap_vht80plus80, so the change in the
> country code does not explain this either.
>
> I'm not sure what is causing the issue here, but it looks like something
> in ap_vht80plus80 (i.e., an attempt to enable a channel combination that
> would require DFS on one of the 80 MHz segments) leaves behind state
> that makes ieee80211_is_radar_required(local) return true even when it
> shouldn't. DFS for 80+80 is not yet supported, so I'd assume this is
> somehow related to that. Anyway, I don't think mac80211 should behave in
> this way.
>
Thanks for the detailed report.
There was indeed stale state. I've just sent a patch to fix it.

I don't see why returning EBUSY is wrong, though.
Actually, it just make the test fail immediately, instead of waiting
indefinitely until a timeout occurs (i guess, didn't actually test it
with the reverted patch).
This was exactly the intended behavior, and i think it makes much more sense.

Eliad.
