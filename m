Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35805 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbLRMSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 07:18:38 -0500
Received: by mail-wm0-f44.google.com with SMTP id l126so61807757wml.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2015 04:18:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450440458.2849.0.camel@sipsolutions.net>
References: <1450439850-1587-1-git-send-email-janusz.dziedzic@tieto.com>
	<1450440458.2849.0.camel@sipsolutions.net>
Date: Fri, 18 Dec 2015 13:18:36 +0100
Message-ID: <CALhHN=rQ0Juzjx8xraZK=7tdUVViPzFT-Ksh2uJj78qm4OPWqg@mail.gmail.com> (sfid-20151218_131841_205306_C4227588)
Subject: Re: [RFC/RFT v2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 December 2015 at 13:07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-12-18 at 12:57 +0100, Janusz Dziedzic wrote:
>> HW/driver should set NEED_ALIGNED4_SKBS flag in case require
>> aligned skbs to four-byte boundaries.
>>
>> Before we have to do memmove() in the driver before
>> pass this to HW and memmove() back in tx completion.
>> This patch allow to save CPU and skip such memmoves.
>> For each skb we call memmove(ieee80211_hdrsize()) twice.
>>
>> Currently this was tested with ath9k, both hw/sw crypt for
>> tkip/ccmp.
>> For sure more tests required (eg. fast path isn't used for
>> ath9k STA, wep sw crypt).
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> ---
>>  include/net/mac80211.h     |  4 ++++
>>  net/mac80211/debugfs.c     |  1 +
>>  net/mac80211/ieee80211_i.h |  1 +
>>  net/mac80211/sta_info.h    |  4 ++--
>>  net/mac80211/tkip.c        | 15 ++++++++++++---
>>  net/mac80211/tx.c          | 38 +++++++++++++++++++++++++++++++++---
>> --
>>  net/mac80211/util.c        |  7 ++++++-
>>  net/mac80211/wep.c         | 11 ++++++-----
>>  net/mac80211/wep.h         |  1 +
>>  net/mac80211/wpa.c         | 14 ++++++--------
>>  10 files changed, 72 insertions(+), 24 deletions(-)
>>
> Btw, how can you get away without changing the status path?
>
Yes, this is still missed.

> johannes
