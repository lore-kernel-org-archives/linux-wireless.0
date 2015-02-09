Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:48455 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932938AbbBIIiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 03:38:24 -0500
Received: by mail-ig0-f171.google.com with SMTP id h15so14868156igd.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 00:38:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150208155623.GA5485@w1.fi>
References: <1420645811-17877-1-git-send-email-eliad@wizery.com>
	<1420645811-17877-3-git-send-email-eliad@wizery.com>
	<20150207115758.GA503@w1.fi>
	<CAB3XZEfhCkHFNg1ypxGd7sHreYmGDiUZUjOBokrsbGwJs-qP6A@mail.gmail.com>
	<20150208155623.GA5485@w1.fi>
Date: Mon, 9 Feb 2015 10:38:23 +0200
Message-ID: <CAB3XZEdrWG72XC9oXRm6cUHGdgOqb+3-qt-LKUqKz_YK3=sh7w@mail.gmail.com> (sfid-20150209_093834_760821_713D6DE0)
Subject: Re: [PATCH v2 3/3] mac80211: don't defer scans in case of radar detection
From: Eliad Peller <eliad@wizery.com>
To: Jouni Malinen <j@w1.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 8, 2015 at 5:56 PM, Jouni Malinen <j@w1.fi> wrote:
>> I don't see why returning EBUSY is wrong, though.
>> Actually, it just make the test fail immediately, instead of waiting
>> indefinitely until a timeout occurs (i guess, didn't actually test it
>> with the reverted patch).
>> This was exactly the intended behavior, and i think it makes much more sense.
>
> I have no issues with EBUSY being returned for a case where an
> offchannel operation would be required while on a channel that require
> constant monitoring for radars. I guess it would be fine to run a
> single-channel scan on that same channel in such a state, but I'm not
> sure whether this code prevents that or not. (Or whether there is really
> that much of a real use case for such an operation.)
>
See my answers to Janusz.
The current code blocks any scan (including on-channel one).
I guess an exception for on-channel scan can be added if needed.

Eliad.
