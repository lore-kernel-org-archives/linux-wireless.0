Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:61081 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbbBWAy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 19:54:59 -0500
Received: by mail-ig0-f176.google.com with SMTP id hl2so14772287igb.3
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 16:54:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
	<CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
	<CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
	<CAJ-Vmokz5h8BoHfgziT9qa_hmiGYk+oDrQUzaMdjKesT5zvaug@mail.gmail.com>
	<CA+55aFz8EzduL5t49DWtqf1F5X1e=xbgGLfKJV9Mopv21YAP6w@mail.gmail.com>
	<CA+55aFwxqnLCcfaW36pa4aFW_S3EtLvAb4Z6NowjUV6btog+6w@mail.gmail.com>
Date: Sun, 22 Feb 2015 16:54:58 -0800
Message-ID: <CAJ-VmomoWa_tC4ytbLp=3CbVDCv5XCyQai3X8R3TqJtCm=s91w@mail.gmail.com> (sfid-20150223_015811_318055_F54C68F9)
Subject: Re: AR9462 problems connecting again..
From: Adrian Chadd <adrian@freebsd.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 February 2015 at 15:00, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Feb 22, 2015 at 1:50 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Ugh. When I add "-dd" to the command line, it has now worked three
>> times in a row, when before it worked once out of ten tries.
>>
>> So my guess is that it's something timing-dependent.
>
> So it stays working with -dd, but I do get *occasional* failures that
> then seem to clear up on retry. So it ends up working in the end, but
> I think I have a few example failures in the logs.
>
> So for example, from my dmesg, I get this:
>
> [14:07:15] wlp1s0: authenticate with 20:9f:db:e7:80:80
> [14:07:15] wlp1s0: send auth to 20:9f:db:e7:80:80 (try 1/3)
> [14:07:15] wlp1s0: send auth to 20:9f:db:e7:80:80 (try 2/3)
> [14:07:15] wlp1s0: send auth to 20:9f:db:e7:80:80 (try 3/3)
> [14:07:15] wlp1s0: authentication with 20:9f:db:e7:80:80 timed out
> [14:07:18] wlp1s0: authenticate with 20:9f:db:e7:80:80
> [14:07:18] wlp1s0: send auth to 20:9f:db:e7:80:80 (try 1/3)
> [14:07:18] wlp1s0: authenticated
> [14:07:18] wlp1s0: associate with 20:9f:db:e7:80:80 (try 1/3)
> [14:07:18] wlp1s0: RX AssocResp from 20:9f:db:e7:80:80 (capab=0x431
> status=0 aid=16)
> [14:07:18] wlp1s0: associated
> [14:07:22] wlp1s0: deauthenticated from 20:9f:db:e7:80:80 (Reason:
> 2=PREV_AUTH_NOT_VALID)
>
> with another failure at 14:07:22, but then it ends up working a bit
> later at 14:07:33.
>
> I've got the wpa supplicant log for this timeframe, but I'd rather not
> send it out in public. I see "[REMOVED] for what looks like the key
> data, but there's a lot of other hex data. Is any of it sensitive?

I /think/ it's okay? The removed stuff is the pre-shared key pieces.

So if I were debugging this (on any OS); I'd start by looking at
what's going on over the air. I'd be worried that there's something
failing to transmit right / be heard by the recipient. In the past
it's been things like EAPOL frames not going out at basic rate (and
listening to the rate control code for what rate it should be
transmitted at) and that makes it transmit at rates wholly unsuited
for the initial handshake.

Do you have another laptop with an atheros NIC in it that you could
use in monitor mode to capture all the frames?

(Also, you can email me the log file privately if you'd like.)



-adrian
