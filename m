Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:33877 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758048Ab3BTS0c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 13:26:32 -0500
Received: by mail-bk0-f41.google.com with SMTP id q16so3792459bkw.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 10:26:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361371850.8629.24.camel@jlt4.sipsolutions.net>
References: <1361203709-16669-1-git-send-email-marco@cozybit.com> <1361371850.8629.24.camel@jlt4.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 20 Feb 2013 10:26:11 -0800
Message-ID: <CAG6hwVM6FW7yDH12ngq3MMQMCkfyDwW_trrEn385m5SXirJ+Og@mail.gmail.com> (sfid-20130220_192637_721553_A351B2B7)
Subject: Re: [PATCHv2 1/3] mac80211: move mesh sync beacon handler into neighbour_update
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marco Porsch <marco@cozybit.com>, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, sleffler@google.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 6:50 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-02-18 at 17:08 +0100, Marco Porsch wrote:
>
>> +     /*
>> +      * If available, calculate the time the beacon timestamp field was
>> +      * received from the rx_status->mactime field. Otherwise get the
>> +      * current TSF as approximation before entering rcu-read section.
>> +      */
>> +     if (ieee80211_have_rx_timestamp(rx_status))
>> +             t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
>> +                                                    24 + 12 +
>> +                                                    elems->total_len +
>> +                                                    FCS_LEN,
>> +                                                    24);
>
> That doesn't seem right -- it's calculating the timestamp at the end of
> the frame, but you said you wanted the timestamp at the "timestamp
> field" time, which is just 24 bytes into the frame.

[...]

>> -     if (ieee80211_have_rx_timestamp(rx_status))
>> -             /* time when timestamp field was received */
>> -             t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
>> -                                                    24 + 12 +
>> -                                                    elems->total_len +
>> -                                                    FCS_LEN,
>> -                                                    24);
>
> I see this was already wrong ...

No it's OK. The API is actually
ieee80211_calculate_rx_timestamp(local, status, len, offset).

-- 
Thomas
