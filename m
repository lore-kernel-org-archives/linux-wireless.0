Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:43077 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbbBVSY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 13:24:59 -0500
Received: by mail-ig0-f174.google.com with SMTP id b16so13650076igk.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 10:24:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
Date: Sun, 22 Feb 2015 10:24:58 -0800
Message-ID: <CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com> (sfid-20150222_192503_394692_F3952889)
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

On 21 February 2015 at 15:34, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So I've had problems connecting to some networks before on my
> Chromebook Pixel, but now I'm testing a new Ubiquiti network at home,
> and can see this issue at home too.
>
> I know the wireless works, because other devices work fine on that
> network. Also, I know the AR9462 works, because I still have my old
> network up and it connects to that.
>
> And it *occasionally* connects to the new one. But it's rare, and it
> clearly has problems.
>
> It looks something like this:
>
> [   73.757869] wlp1s0: authenticate with 20:9f:db:e7:80:80
> [   73.771471] wlp1s0: send auth to 20:9f:db:e7:80:80 (try 1/3)
> [   73.773706] wlp1s0: authenticated
> [   73.775122] wlp1s0: associate with 20:9f:db:e7:80:80 (try 1/3)
> [   73.787434] wlp1s0: RX AssocResp from 20:9f:db:e7:80:80
> (capab=0x431 status=0 aid=9)
> [   73.787573] wlp1s0: associated
> [   77.784931] wlp1s0: deauthenticated from 20:9f:db:e7:80:80 (Reason:
> 2=PREV_AUTH_NOT_VALID)
>
> and the password I used definitely is right, and sometimes works.
> Despite that PREV_AUTH_NOT_VALID thing.
>
> Any suggestions for what I should do to give you guys any sane and
> useful debug output?

Just a wild shot - try disabling fast authentication and see if that
makes a difference?

wpa_supplicant.conf:

fast_reauth=0

I recall having issues with fast_reauth once, but I never stuck around
that location long enough to debug it.




-adrian
