Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:61122 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0AYSZ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:25:29 -0500
Received: by pwi21 with SMTP id 21so2425108pwi.21
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 10:25:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b6c5339f1001231032r155b380av93563a6febeeae2b@mail.gmail.com>
References: <20100123105111.GA24790@progeny.tock> <fe54d8c01001230418u3de7f4ccuc4fbfdecc7c76ebf@mail.gmail.com>
	<20100123134005.GA11322@progeny.tock> <b6c5339f1001231032r155b380av93563a6febeeae2b@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Jan 2010 10:25:09 -0800
Message-ID: <43e72e891001251025s1e3fa358v31527d1b5f7e3436@mail.gmail.com>
Subject: Re: ath5k phy0: unsupported jumbo
To: Bob Copeland <me@bobcopeland.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, Kacper <kacper@kacper.se>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 23, 2010 at 10:32 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sat, Jan 23, 2010 at 8:40 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
>> So it looks like we receive some strange packets that haven’t been
>> explained yet.  It might be worth looking at a few --- sounds kind of
>> interesting.
>>
>> Am I understanding correctly?  This is a hardware bug or undocumented
>> hardware feature then, right?
>>
>> It might be nice to add some user-oriented explanation too, but for
>> now, how about this comment?
>>
>
> That's ok with me.  I'd also be fine with removing the log spam.  I think
> ultimately it represents some kind of driver issue, I'm just not sure what,
> exactly, yet.  I recently added more debugging to a kernel on a system of
> mine that produces it more often -- I'll see what it turns up.

Jumbo frames are frames which the hardware receives for which it does
not have enough DMA leg room for, and so needs to split it out into
multiple descriptors. It should be OK to just drop them if ath5k is
setting the max RX dma size to the max 802.11 frame, as they could be
bogus frames or 11n AMSDU frames which ath5k obviously would not
support.

  Luis
