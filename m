Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62214 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab1KUEIj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 23:08:39 -0500
Received: by ywt32 with SMTP id 32so4256764ywt.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 20:08:38 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 21 Nov 2011 06:08:38 +0200
Message-ID: <CAFtRNNz6YEVp2efHqnh0aQ8DEdWm9-ztp8vRTmdorUjf8tJs5w@mail.gmail.com> (sfid-20111121_050842_816863_86D63DCE)
Subject: A weird hw crypto bug...
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel <ath5k-devel@lists.ath5k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some time ago we had a few reports of AR2413 cards being unable to
encrypt packets of specific lengths.

>From https://bugs.launchpad.net/ubuntu/+source/linux/+bug/568090, user
Musaraigne did some further investigation/debuging on this:

"The cause of the high and unpredictable latencies is that packets are
dropped depending on their size. According to my tests, packet sizes
of the form
  size = 128*k + 81 + m
or
  size = 128*k + 105 + m
for any k>=2 and 0<=m<=7

are dropped randomly in 90-95% of the cases. Conversely, all other
packet sizes work fine.

You can see for yourself if this is true on your system:
  ping -M do -s 596 www.google.com
should result in 90% packet loss (because 624 = 128*4 + 105 + 7; the
28 byte difference comes from network headers added by ping)
while
  ping -M do -s 597 www.google.com
should result in negligible packet loss."

So far I couldn't reproduce this bug with my AR2413 and now after e
few user reports I'm almost sure that it's only present on cards
created by Askey. I verified it again recently based on a bug report
from an OpenSUSE user here...

https://bugzilla.novell.com/show_bug.cgi?id=731576

What seems weird is that some users reported that MadWiFi worked fine
on these cards (I have no idea what happens on their windows driver,
maybe they disable hw crypto) ! Since for hw crypto we use code from
the common ath module (and I think this is the same with HAL) I don't
see how that can happen.

Anyway my question is how to handle this:

a) Just disable hw crypto for all AR2413 cards made by Askey
b) If we handle such card do some padding based on Musaraigne's findings

I'd like to go with b but I don't know how to do it correctly without
corrupting anything. Any ideas ?


-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
