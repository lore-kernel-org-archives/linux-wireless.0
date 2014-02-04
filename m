Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:61177 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaBDLTF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 06:19:05 -0500
Received: by mail-bk0-f45.google.com with SMTP id v16so3367472bkz.32
        for <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 03:19:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391433519.4488.17.camel@jlt4.sipsolutions.net>
References: <1391421529-6067-1-git-send-email-michal.kazior@tieto.com>
	<1391421529-6067-2-git-send-email-michal.kazior@tieto.com>
	<1391433519.4488.17.camel@jlt4.sipsolutions.net>
Date: Tue, 4 Feb 2014 12:19:02 +0100
Message-ID: <CA+BoTQno+CO-MVQ8JbD-FeMzjbqf2Vr2+BDMJr0xZgZTO4S6zg@mail.gmail.com> (sfid-20140204_121942_116940_1BFF46F2)
Subject: Re: [RFC 1/2] mac80211: merge STA CSA code
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 February 2014 14:18, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-02-03 at 10:58 +0100, Michal Kazior wrote:
>> + * @timestamp: value in microseconds of the 64-bit Time Synchronization
>> + *   Function (TSF) timer when the frame containing the channel switch
>> + *   announcement was received. This is simply the rx.mactime parameter
>> + *   the driver passed in.
>
> That doesn't make a lot of sense, since "rx.mactime" is a mac80211
> thing, so you should probably describe this. I'm not sure it really
> needs to be mactime/TSF, does that even make sense? It seems more likely
> you'd actually need the device time, i.e. something that works across
> multiple vifs?
>
> Not sure this even belongs into this patch anyway though?

It does belong here. How else are you supposed to pass the timestamp
for STA CSA offload?

Would making this sort of a drv_priv thing work?

If we could just kill the offload, adding timestamp to
cfg80211_csa_settings wouldn't be necessary.


Michał
