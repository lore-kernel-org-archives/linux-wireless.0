Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:34736 "EHLO
        resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751384AbeD3WJt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 18:09:49 -0400
To: linux-wireless@vger.kernel.org
From: Jape Person <japers@comcast.net>
Subject: Possible Regression in Wireless Driver Affecting Intel Corporation
 Wireless 7265 (rev 59)
Message-ID: <1b91c09e-d20b-bcb2-5961-7c7b400a78d9@comcast.net> (sfid-20180501_000952_951894_5B218C94)
Date: Mon, 30 Apr 2018 18:01:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two recent kernel upgrades seem to have both affected the Intel
Corporation Wireless 7265 (rev 59) adapters on our systems in a
manner which causes their network transfer rates to be reduced
dramatically. File transfers which normally require a few
minutes are now taking several hours.

These systems are running the Debian testing distribution with
the iwilwifi drivers from Debian's testing/contrib. The altered
behavior came when the Debian linux-image version advanced to
4.15.*.

I looked online for similar reports and didn't find anything
that seemed directly applicably. I finally got lucky when I
experimented with the net.ipv4.tcp_congestion_control setting.

I understand that in version 4.15 of the kernel the default was
changed from cubic to bbr. I used

# sysctl net.ipv4.tcp_congestion_control=cubic

to revert to the previous default on all of the systems. This
has caused all of the systems to return to their normal file
transfer speeds.

Please let me know by direct reply (I'm not subscribed.) if I
can supply more information.

Best regards,
JP
