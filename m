Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52291 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab3HSI0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 04:26:30 -0400
Received: by mail-wi0-f172.google.com with SMTP id hj13so2779961wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 19 Aug 2013 01:26:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5211996B.4060800@gmail.com>
References: <5211996B.4060800@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 19 Aug 2013 13:56:08 +0530
Message-ID: <CABPxzYK_q9VXcXnGLb=8aFzD1ZJdLStyhBz-LRpvwg4oVaBTDw@mail.gmail.com> (sfid-20130819_102633_169996_D4433D51)
Subject: Re: WiFi roaming question
To: chris <chgans@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It turned out that, as a client, I don't have to bother with roaming stuff, it simply works out of the box.

Roaming has 2 types:

1) based on the disconnection (beacon loss)
2) based on the RSSI

Is it really roaming doing background scanning and preauth #2 (or) a
connect and disconnect (assuming same ssid and security) #1?

> Though, I have a couple of questions regarding this OOBX (new buzz word seen here and there for "out of the box experience" :) ).
> - At which level the roaming is done? Is it at the WiFi kernel stack (cfg/mac 80211), at driver level, or at chipset/firmware level or a mix of them?
> - Can I change my setup, so that I have control over the roaming?
> - Is it a good idea to try to manage that myself from userspace?

wpa_supplicant (userspace) takes care of the roaming for you, i belive
it has support for both types #1 and #2 (along with background scan)

Some proprietary version which implement at driver/fw level, this
reduces the roam delay as it need not involve any context switches.
