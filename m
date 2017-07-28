Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:37043 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdG1Bna (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2017 21:43:30 -0400
Received: by mail-io0-f170.google.com with SMTP id c74so85378968iod.4
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jul 2017 18:43:30 -0700 (PDT)
MIME-Version: 1.0
From: George H <ghh19622@gmail.com>
Date: Fri, 28 Jul 2017 11:43:29 +1000
Message-ID: <CAG5S3ZR8ZgNNR8k-iRgRdvZ3Jwhakk4OxYJtvh8ezA4ESf=QMg@mail.gmail.com> (sfid-20170728_034333_971521_95E8B5E5)
Subject: Problem seen with wireless mesh
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I have two wireless products forming a wireless mesh. One (let's call
it A) runs 2.6.37 kernel while the other (let's call it B) runs 3.18
kernel. The wireless mesh based on IEEE80211s runs successfully
(mac80211 module).

I see a problem where the communication between A to B freezes
intermittently, each time the duration is between a minute and two
minutes. The product A is at fault here. During this period, no ping
from a PC to A succeeds. Using a serial terminal to A, I investigated
and found:

1) Top doesn't show anything suspicious when the issue is hit. The
same processes are seen always.

2) The watchdog on A is not triggered when the issue is hit.

3) It's not a firewall issue, had tried clearing all iptables entries.

4) I checked netstat, nothing that gave further clues.

5) Added debug printk's through the mesh code in mac80211, but I'm not
seeing anything with strong evidence so far.

Any tips to debug the issue? Thanks.
