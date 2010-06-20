Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58688 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427Ab0FTQ5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jun 2010 12:57:45 -0400
Received: by bwz7 with SMTP id 7so635814bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jun 2010 09:57:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C1CC5A0.7080600@lwfinger.net>
References: <AANLkTimIkTaIrdXHulE6YVnB3ZwWrMBCNnCK1SKdyctL@mail.gmail.com>
	<AANLkTimvdtruvFaugHTYcSNhL5pBZXPYtzEF3qolO_qW@mail.gmail.com>
	<AANLkTimxOgQySTag7u4DlZugbveWr7csDSAERkewAYhp@mail.gmail.com>
	<4C1CC5A0.7080600@lwfinger.net>
Date: Sun, 20 Jun 2010 17:57:43 +0100
Message-ID: <AANLkTilKr0mPrTQ5T9zBf7waqFUYnW2zl-HbqzPj9whn@mail.gmail.com>
Subject: Re: Problems with b43 wirelesss
From: Magnus Therning <magnus@therning.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	b43-dev@lists.infradead.org,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 19, 2010 at 14:26, Larry Finger <Larry.Finger@lwfinger.net> wrote:
[...]
> No, it is a fatal DMA error and your device did switch to PIO mode. The
> dmesg output does not make that clear. I'm sending a patch to change the
> logged message.

No, we are communicating past each other

You mean, it's fatal since it doesn't work with DMA.
I mean, it's not fatal because it realises it doesn't work with DMA
and restarts itself using PIO.

In any case, DMA *is not* the issue here AFAICS.

>> It looks like the following is more relevant to my problem:
>>
>> No probe response from AP 00:22:3f:c3:99:a8 after 500ms, disconnecting.
>> cfg80211: Calling CRDA to update world regulatory domain
>> wlan0: authenticate with 00:22:3f:c3:99:a8 (try 1)
>> wlan0: authenticated
>> wlan0: associate with 00:22:3f:c3:99:a8 (try 1)
>> wlan0: RX AssocResp from 00:22:3f:c3:99:a8 (capab=0x431 status=0 aid=1)
>> wlan0: associated
>> wlan0: deauthenticated from 00:22:3f:c3:99:a8 (Reason: 15)
>>
>> Especially since that sequence of messages is repeated over an over.
>>
>> My next test will be to turn off all security on the wireless, just to
>> rule out WPA completley.
>
> I looked for an explanation of Reason 15 deauthentications. Perhaps
> someone on the wireless ML will know the answer.

I'd be most interested in finding out what it means and the possible
cause for it.

/M

-- 
Magnus Therning                        (OpenPGP: 0xAB4DFBA4)
magnus＠therning．org          Jabber: magnus＠therning．org
http://therning.org/magnus         identi.ca|twitter: magthe
