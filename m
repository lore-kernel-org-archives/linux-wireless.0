Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:38416 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753505AbeARJJe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 04:09:34 -0500
Received: by mail-it0-f43.google.com with SMTP id w14so12086128itc.3
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 01:09:33 -0800 (PST)
MIME-Version: 1.0
From: Tambet Arak <tambet.arak@gmail.com>
Date: Thu, 18 Jan 2018 11:09:27 +0200
Message-ID: <CAMNDV2kK33fWYVNNAO8=ZqgxyPdXxTdOrxdQnW6ORMFM1hkrxQ@mail.gmail.com> (sfid-20180118_100939_973414_852CE9BA)
Subject: A few questions about iwlwifi and its rate control mechanism
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm not really a Linux developer, more of a curious user, but the
wireless developers mailing list seems appropriate for my questions.
Please bear with me if they don't make much sense, as I'm a complete
novice when it comes to the wireless subsystem.

In any case, I was looking into how to optimally tune wireless
reception at work, since the APs are aging and only support up to MCS7
(65 Mb/s), so any improvements would help. I'm using a HP laptop with
a Intel Centrino Advanced-N 6235, driven by iwlwifi / iwldvm (vanilla
Linux 4.14.8). I noticed that `iw dev wlo1 station dump` generally
reports a 58.5-65 Mb/s rx bitrate, but when the connection is taxed
(e.g. downloading a file), it drops.

Since the only other OS on my machine is Windows, I tested by
downloading a large file there and generally the average throughput
was slightly higher. I'm not a Windows user, so I don't have a clue if
`netsh show interfaces` reports a correct effective bit rate, but it
was always fixed to 65 Mb/s in my tests.

This led me to digging around in iwlwifi. It seems that iwlwifi
registers its own rate control algorithm (iwl-agn-rs) with the
mac80211 subsystem and this is hardcoded.

Hence a few questions:

- Why does iwlwifi have / need its own rc algorithm, instead of using minstrel?
- It seems that iwl-agn-rs is not configurable by the end user. Would
there be any interest in development for iwl-agn-rs configurability,
e.g. being less / more conservative about lowering rates? I'm mostly
interested in rx performance - I'm making the assumption here that rx
rates are negotiated with the AP (as opposed to being forced).
- Is there any documentation regarding iwlwifi or its rc algorithm
implementation? If so, I would kindly appreciate pointers.

Cheers,

Tambet
