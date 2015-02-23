Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37478 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbbBWVxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 16:53:46 -0500
Received: by mail-ig0-f182.google.com with SMTP id h15so22078871igd.3
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 13:53:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150223213050.GA23232@w1.fi>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
	<20150223171700.GA29730@w1.fi>
	<CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>
	<20150223213050.GA23232@w1.fi>
Date: Mon, 23 Feb 2015 13:53:45 -0800
Message-ID: <CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com> (sfid-20150223_225353_372302_CD206FEE)
Subject: Re: AR9462 problems connecting again..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jouni Malinen <j@w1.fi>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2015 at 1:30 PM, Jouni Malinen <j@w1.fi> wrote:
>
> How far is the station from the AP? Would it be possible to see whether
> the behavior changes if you were within, say, five meters or so?

Well, it was pretty much within five meters already, but there was a
thin wall in between (and the old AP was right next to the laptop,
which might add some noise even if they are on different channels).
Going closer does seem to help, but again, it's not like this is 100%
reproducible to begin with.

So the theory that the driver starts at too high a transmit rate, and
then does not handle failures well, might be true. Of course, "not
handle failures well" is something of an understatement.

> It would be useful if you can capture the 802.11 frame exchange from a
> failed connection case with an external wireless sniffer.

I will try with my (much more reliable) iwlwifi laptop. At least the
merge window is over, so I should have some time. Knock wood.

              Linus
