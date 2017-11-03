Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f177.google.com ([74.125.82.177]:52209 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965027AbdKCC5N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 22:57:13 -0400
Received: by mail-ot0-f177.google.com with SMTP id n74so1337406ota.8
        for <linux-wireless@vger.kernel.org>; Thu, 02 Nov 2017 19:57:13 -0700 (PDT)
MIME-Version: 1.0
From: Daniel Drake <drake@endlessm.com>
Date: Fri, 3 Nov 2017 10:57:11 +0800
Message-ID: <CAD8Lp47N8ENCPp0ELd5_H8efEna9FGemM-vvi0kf7=coG5tNXA@mail.gmail.com> (sfid-20171103_035731_142220_74AA0715)
Subject: ath9k disconnects in 4.13 with reason=4 locally_generated=1
To: linux-wireless@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Endless OS recently upgraded from Linux 4.11 to Linux 4.13, and we now
have a few reports of issues with ath9k wireless becoming unusable.

In the logs we can see that it authenticates, associates and completes
the WPA 4 way handshake, before then being disconnected with:

 wlp2s0: CTRL-EVENT-DISCONNECTED bssid=74:26:ac:68:2f:c0 reason=4
locally_generated=1

The cycle then repeats with it connecting again before being swiftly
disconnected, etc.

More logs: https://gist.github.com/dsd/49f263c67c2859838ce168628ab043e0

At the same time that we upgraded the kernel, we also upgraded many
other components (e.g. NetworkManager and wpa_supplicant), however the
same problem has been reported on Arch Linux and a user there reports
that he narrowed it down to a kernel regression between 4.12 and 4.13:
https://bbs.archlinux.org/viewtopic.php?id=225199

Unfortunately we can not reproduce this in our office, so can't offer
much more info yet, but we are continuing to investigate. I have not
found any codepaths in userspace that generate disconnect reason 4, so
I think it must be something in the kernel causing the disconnection,
but I did not see any suspicious changes in recent commit history.

It would be good to hear from anyone who has heard of this or has any
ideas about causes or solutions.

Thanks
Daniel
