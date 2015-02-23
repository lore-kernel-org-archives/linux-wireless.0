Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:41117 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbBWXAk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 18:00:40 -0500
Received: by iecrd18 with SMTP id rd18so27547144iec.8
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 15:00:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150223224305.GA30228@w1.fi>
References: <CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
	<CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com>
	<CA+55aFwc6Uz7HOQ6S6SzSkWY39QBYWnURFjvQXC6QWNmoFB4=Q@mail.gmail.com>
	<20150223171700.GA29730@w1.fi>
	<CA+55aFz0pAMbtczpe9fe5m9HjTysNVm3639VyNc3hrpkdenSGg@mail.gmail.com>
	<20150223213050.GA23232@w1.fi>
	<CA+55aFyNqdNk5aq17YdqTCjiWpZ9=ifF3ii+Ko=EzUWZgnCGoQ@mail.gmail.com>
	<CAJ-Vmo=Tu9vBgm2xwqHWqXhx6df9h5cff5_ivERShJ9QPdwYww@mail.gmail.com>
	<20150223224305.GA30228@w1.fi>
Date: Mon, 23 Feb 2015 15:00:39 -0800
Message-ID: <CA+55aFzpmD+XOF4PTePgi6WnRTyXbVUQxc7kgwvmFbfG_2VoTg@mail.gmail.com> (sfid-20150224_000043_897533_649C4DEE)
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

On Mon, Feb 23, 2015 at 2:43 PM, Jouni Malinen <j@w1.fi> wrote:
>
> This did not get exactly supportive response when this was proposed last
> time (Sep 2013). Anyway, for a quick test, this can be done with the
> following one-liner:

fwiw, that one-liner seems to work fine for me.

Which I guess is not a huge surprise.

Side note: I've done the "turn off wifi and turn it back on" several
times to test that patch, and it has worked every time. BUT I also see
this odd behavior where the logs show that it tries to authenticate
twice: the first time it does that "send auth to 20:9f .." thing three
times (looks like 100ms apart), and nothing happens so it does
"authentication with 20:9f .. timed out". Then it waits three seconds
and tries again, and now it succeeds on the first try.

The only downside of that seems to be that it takes an extra 3s to
connect to the network - but it does now seem to *reliably* connect -
so it's not a big problem, but I wonder why it should be that
repeatable. Is there some difference between the first and the second
time it tries to authenticate?

Anyway, even if people don't like that particular patch, it does seem
like *something* like that should be done.

                         Linus
