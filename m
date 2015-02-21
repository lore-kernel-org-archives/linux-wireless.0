Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:57591 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbbBUXel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2015 18:34:41 -0500
Received: by mail-ig0-f179.google.com with SMTP id l13so11000285iga.0
        for <linux-wireless@vger.kernel.org>; Sat, 21 Feb 2015 15:34:40 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 21 Feb 2015 15:34:40 -0800
Message-ID: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com> (sfid-20150222_003444_873500_6DADB8A7)
Subject: AR9462 problems connecting again..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I've had problems connecting to some networks before on my
Chromebook Pixel, but now I'm testing a new Ubiquiti network at home,
and can see this issue at home too.

I know the wireless works, because other devices work fine on that
network. Also, I know the AR9462 works, because I still have my old
network up and it connects to that.

And it *occasionally* connects to the new one. But it's rare, and it
clearly has problems.

It looks something like this:

[   73.757869] wlp1s0: authenticate with 20:9f:db:e7:80:80
[   73.771471] wlp1s0: send auth to 20:9f:db:e7:80:80 (try 1/3)
[   73.773706] wlp1s0: authenticated
[   73.775122] wlp1s0: associate with 20:9f:db:e7:80:80 (try 1/3)
[   73.787434] wlp1s0: RX AssocResp from 20:9f:db:e7:80:80
(capab=0x431 status=0 aid=9)
[   73.787573] wlp1s0: associated
[   77.784931] wlp1s0: deauthenticated from 20:9f:db:e7:80:80 (Reason:
2=PREV_AUTH_NOT_VALID)

and the password I used definitely is right, and sometimes works.
Despite that PREV_AUTH_NOT_VALID thing.

Any suggestions for what I should do to give you guys any sane and
useful debug output?

              Linus
