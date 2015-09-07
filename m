Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:33901 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbbIGUmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2015 16:42:01 -0400
Received: by laeb10 with SMTP id b10so57864040lae.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2015 13:42:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANfLQraZAkw0Eqt-Mog5t4ZfGFx3xm_8-6nJoJ68Mim18bW3Tg@mail.gmail.com>
References: <CANfLQrbXn2pLjVY8DVC=xs9oWZC2nX3VcEZQMLh1zQa7i4EHCg@mail.gmail.com>
	<55DAD0FD.3070807@broadcom.com>
	<CANfLQrYQnk6bUjPEKxucxBhLvsRsqpfydvAkvsvKdg0nnte3iA@mail.gmail.com>
	<CAG8K7gRdXqpfA3_HPoaM+ivgxH4eiPRWkD238QwMMbNigYHDBw@mail.gmail.com>
	<CANfLQraZAkw0Eqt-Mog5t4ZfGFx3xm_8-6nJoJ68Mim18bW3Tg@mail.gmail.com>
Date: Mon, 7 Sep 2015 23:41:59 +0300
Message-ID: <CANfLQrYVq_eMa-CLJhqVthbm_h7yLBhZN5nm0_f70eEob+rUdw@mail.gmail.com> (sfid-20150907_224209_313698_21CC3608)
Subject: Fwd: bcmdhd: Concurrent use of wlan0 and virtual interface in managed mode
From: Gucea Doru <gucea.doru@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Thanks for helping me. I have some more questions related to parallel
usage of p2p and STA (station) interface.

I use a Nexus 5 device which has a BCM4339 [1] chip and it seems that
it's possible to transfer data in parallel using two connections: one
based on Wi-Fi direct(p2p, 2.4Ghz) and the other one based on a
connection to AP (wlan0, 5Ghz).

This is done by _time-sharing_ the wireless interface radio? From my
understanding the mac80211 layer have support for multiple virtual
interfaces and the switching between this interfaces is done inside
mac80211. Does the driver creates multiple virtual interfaces (one for
p2p and one for the connection to the AP) and the mac80211 manages the
time-sharing between them?

I am interested in understanding the code that decides how much the
radio should stay on a specific channel. I would be really grateful if
you could give me some details about the architecture.

[1] http://www.broadcom.com/press/release.php?id=s766879

Thanks,
Doru
