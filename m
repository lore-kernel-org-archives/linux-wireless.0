Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37297 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbbLRInm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 03:43:42 -0500
Received: by mail-wm0-f53.google.com with SMTP id p187so54495851wmp.0
        for <linux-wireless@vger.kernel.org>; Fri, 18 Dec 2015 00:43:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56728A91.7010503@openwrt.org>
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
	<56728A91.7010503@openwrt.org>
Date: Fri, 18 Dec 2015 09:43:41 +0100
Message-ID: <CALhHN=ouW-DShR1xwy12z08sQz+VKQM+DUVrebFCwi4GWN11pw@mail.gmail.com> (sfid-20151218_094346_516528_37F84608)
Subject: Re: [RFC/RFT 1/2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 December 2015 at 11:12, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2015-12-17 10:20, Janusz Dziedzic wrote:
>> HW/driver should set NEED_ALIGNED4_SKBS flag in case require
>> aligned skbs to four-byte boundaries.
>>
>> Before we have to do memmove() in the driver before
>> pass this to HW and memmove() back in tx completion.
>> This patch allow to save CPU and skip such memmoves.
>> For each skb we called memmove(ieee80211_hdrsize()) twice.
>>
>> Currently this was tested with ath9k, both hw/sw crypt for
>> tkip/ccmp.
>> For sure more tests required.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>> ---
>>  include/net/mac80211.h |  4 ++++
>>  net/mac80211/debugfs.c |  1 +
>>  net/mac80211/tkip.c    | 15 ++++++++++++---
>>  net/mac80211/tx.c      | 21 +++++++++++++++++++--
>>  net/mac80211/wep.c     |  6 ++++++
>>  net/mac80211/wpa.c     | 35 +++++++++++++++++++++++++++--------
>>  6 files changed, 69 insertions(+), 13 deletions(-)
>>
>> diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
>> index 0ae2077..26b2663 100644
>> --- a/net/mac80211/tkip.c
>> +++ b/net/mac80211/tkip.c
>> @@ -204,9 +204,18 @@ void ieee80211_get_tkip_p2k(struct ieee80211_key_conf *keyconf,
>>       const u8 *tk = &key->conf.key[NL80211_TKIP_DATA_OFFSET_ENCR_KEY];
>>       struct tkip_ctx *ctx = &key->u.tkip.tx;
>>       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>> -     const u8 *data = (u8 *)hdr + ieee80211_hdrlen(hdr->frame_control);
>> -     u32 iv32 = get_unaligned_le32(&data[4]);
>> -     u16 iv16 = data[2] | (data[0] << 8);
>> +     unsigned int hdrlen;
>> +     const u8 *data;
>> +     u32 iv32;
>> +     u16 iv16;
>> +
>> +     hdrlen = ieee80211_hdrlen(hdr->frame_control);
>> +     if (ieee80211_hw_check(&key->local->hw, NEEDS_ALIGNED4_SKBS))
>> +             hdrlen += hdrlen & 3;
> I think this check is duplicated way too often, maybe you should
> implement a wrapper for ieee80211_hdrlen and convert all relevant call
> sites. Makes it easier to spot places where this was forgotten.
>
Or other option is to add this to ieee80211_tx_data - while this param
we pass to most of encrypt funtions ...
>From other side I see ieee80211_tx_data skbs list could be used -
seems only for fragmentation?

@Johannes - will be safe add "real" hdrlen to ieee80211_tx_data?

Other option I see is ieee80211_tx_info or like Felix suggest new
hdrlen() function.

BR
Janusz

> - Felix
