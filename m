Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35411 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbcDSA2N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 20:28:13 -0400
Received: by mail-oi0-f50.google.com with SMTP id p188so846400oih.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2016 17:28:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALupW3CsuSGy=xBw-Wj5FfD+ALKBGi9xvi=Z8+YTdL9mGku5HQ@mail.gmail.com>
References: <1460765986-12698-1-git-send-email-steve.derosier@lairdtech.com>
 <CAGRGNgV_W6uJF5DR43XdqvHPgBha1AfALYXcX4Lj=4jkO8TftQ@mail.gmail.com> <CALupW3CsuSGy=xBw-Wj5FfD+ALKBGi9xvi=Z8+YTdL9mGku5HQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 19 Apr 2016 10:27:53 +1000
Message-ID: <CAGRGNgVM8cVyKaNi0PEjqPmamPp3+YAXbVMu+Hifi6R0Le-ekg@mail.gmail.com> (sfid-20160419_022817_708106_48484AC2)
Subject: Re: [PATCH] ath6kl: Add ability to set debug uart baud rate
To: Steve deRosier <derosier@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Steve deRosier <steve.derosier@lairdtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Steve,

On Tue, Apr 19, 2016 at 4:12 AM, Steve deRosier <derosier@gmail.com> wrote:
> Hi Julian,
>
> Thanks for looking at the patch.
>
> On Sun, Apr 17, 2016 at 5:07 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Steve,
>>
>> This looks like it's using standard serial rates. Does it accept
>> non-standard rates? If not, should this be checked before being passed
>> to the hardware?
>>
>
> It should use standard serial rates, and obviously I defaulted it to a
> sensible one. However, there's nothing that prevents you from using
> odd and arbitrary rates in the firmware and it should just suck it in
> and use it. In other words, the firmware will happily try to set 9507
> baud if you tell it to.
>
> This is specifically for debugging and working with the firmware and
> IMHO, if you are using this feature and feel a need to set it to
> something weird, I think the user should be allowed to. If you know
> enough to be able to shoot yourself in the foot with this, then you
> should know enough of what you should or shouldn't do and should be
> allowed to. It's a debugging tool only and I don't see any reason to
> waste lines in the driver to validate this input.

I'm of the opinion that one should never underestimate the ability of
people to attempt to shoot themselves in the foot. However this is
only a debugging interface so you do make a good point.

I guess I'm worried that some idiot is going to set it to 2 baud or 2
billion baud for some dumb reason then come complaining to us when
their wireless card crashes or locks up or something.

Maybe we can just sweep this all under the carpet by putting all the
debug uart stuff behind some nice #ifdef.

> That's my perspective on the issue, but I recognize other opinions may
> differ. Or you may know of a specific chip where it does matter (the
> 6003s and 6004s I'm using don't seem to care). If you or Kalle insist
> on it, I'll be happy to add in some value checking for this parameter.
> It just doesn't seem worth-while to me.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
