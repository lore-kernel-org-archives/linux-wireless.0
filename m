Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:59830 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbbBGTR6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2015 14:17:58 -0500
Received: by mail-wi0-f173.google.com with SMTP id em10so1890220wid.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Feb 2015 11:17:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150207115758.GA503@w1.fi>
References: <1420645811-17877-1-git-send-email-eliad@wizery.com>
	<1420645811-17877-3-git-send-email-eliad@wizery.com>
	<20150207115758.GA503@w1.fi>
Date: Sat, 7 Feb 2015 20:17:57 +0100
Message-ID: <CALhHN=rj=1OE8xv_q4cTRVkF_=Ko-3amjn4_6tYHXg9dtev=9A@mail.gmail.com> (sfid-20150207_201802_748262_703BEF39)
Subject: Re: [PATCH v2 3/3] mac80211: don't defer scans in case of radar detection
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Jouni Malinen <j@w1.fi>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 February 2015 at 12:57, Jouni Malinen <j@w1.fi> wrote:
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

BTW, what in case we will start AP on first interface (DFS channel),
on second one we will try to connect to other AP. As I understand this
correctly, second iface (STA iface) will not allow to scan (connect)
...?

Other case, what if we start DFS AP and allow to scan in AP mode (eg
for ACS purpose, allow to choose better channel and do CSA ...)?

BR
Janusz
