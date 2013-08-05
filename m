Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:46738 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HEPgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 11:36:07 -0400
Received: by mail-ee0-f54.google.com with SMTP id e53so1696958eek.27
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2013 08:36:05 -0700 (PDT)
In-Reply-To: <CA+aCzhVEu63FWO6+Y=_jD1+UK=e3NKJSx1+oGb7V_aF4dBgxXg@mail.gmail.com>
References: <1375371582-31004-1-git-send-email-sylvain.roger.rieunier@gmail.com> <CAGXE3d9syXY6cZjsBs0vLi72zZAeo-xM+e0Zw2jhy+ZzdjhsOA@mail.gmail.com> <CA+aCzhVEu63FWO6+Y=_jD1+UK=e3NKJSx1+oGb7V_aF4dBgxXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [[PATCHv2]rt2800usb: ampdu len] rt2800usb: update aggregation len
From: Helmut Schaa <helmut.schaa@googlemail.com>
Date: Mon, 05 Aug 2013 17:35:55 +0200
To: Sylvain ROGER RIEUNIER <sylvain.roger.rieunier@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Message-ID: <22cbeb29-8fcf-43bd-bcb6-113b6e837942@email.android.com> (sfid-20130805_173614_601434_9E1E2CAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>





Sylvain ROGER RIEUNIER <sylvain.roger.rieunier@gmail.com> schrieb:
>Dear Helmut,
>
>I already did a test using the Sysfs with an synchronous read. But more
>you
>read  TX_AGG_CNT counters and more you reduce the bandwith.
>My idea was to make asynchronous read periodically to allow Sysfs
>reading without
>impact the bandwith performance.
>Do you have an other suggestion?

Maybe just rate limit register reading in the sysfs interface? Something like: we've just updated the stats a second ago, use the old data ...

Or as a different idea, schedule a work from the tx status path (the counters can only change if we transmit something), also rate limited ... This could be used for rt2800pci as well then ...

Helmut

>
>Sylvain
>
>
>
>2013/8/5 Helmut Schaa <helmut.schaa@googlemail.com>
>
>> On Thu, Aug 1, 2013 at 5:39 PM, Sylvain ROGER RIEUNIER
>> <sylvain.roger.rieunier@gmail.com> wrote:
>> > From: Sylvain Roger Rieunier <sylvain.roger.rieunier@gmail.com>
>> >
>> > I tried to read periodically TX_AGG_CNT registers on the rt2800usb
>> driver.
>> > I'had made USB synchronous and asynchronous read. But it's only
>reduces
>> the
>> > bandwidth.
>> > Does anyone have an idea?
>> >
>> >
>> > Signed-off-by: Sylvain ROGER RIEUNIER
><sylvain.roger.rieunier@gmail.com>
>>
>> Instead of updating the statistics from within a timer can't you just
>> update them when reading the sysfs file?
>> Helmut
>>

-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
