Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38770 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbcA0Odz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 09:33:55 -0500
Received: by mail-wm0-f48.google.com with SMTP id p63so29323080wmp.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 06:33:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1453904819.2351.7.camel@sipsolutions.net>
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
	<1453904772-25289-1-git-send-email-michal.kazior@tieto.com>
	<1453904819.2351.7.camel@sipsolutions.net>
Date: Wed, 27 Jan 2016 15:33:54 +0100
Message-ID: <CA+BoTQn0AhDg628XF2+0gBBPM+8krTnTdeE6FiEBz-ZT+0k6Kg@mail.gmail.com> (sfid-20160127_153401_421179_793DE6A2)
Subject: Re: [PATCH v2] mac80211: expose txq queue depth and size to drivers
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 January 2016 at 15:26, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2016-01-27 at 15:26 +0100, Michal Kazior wrote:
>>
>> @@ -1294,6 +1298,8 @@ struct sk_buff *ieee80211_tx_dequeue(struct
>> ieee80211_hw *hw,
>>       if (!skb)
>>               goto out;
>>
>> +     txqi->byte_cnt -= skb->len;
>> +
>>       atomic_dec(&sdata->txqs_len[ac]);
>>
> This *looks* a bit worrying - you have an atomic dec for the # of
> packets and a non-atomic one for the bytes.
>
> You probably thought about it and I guess it's fine, but can you
> explain it?

The atomic was used because it accesses per-vif counters. You can't
use txqi->queue.lock for that.

On the other hand byte_cnt is per txqi and it was very easy to make
use of the txqi->queue.lock (which was already acquired in both drv_tx
and tx_dequeue functions). Using atomic* for byte_cnt would be
wasteful a bit.


Michał
