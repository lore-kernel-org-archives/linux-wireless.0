Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37564 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab1CQUJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 16:09:13 -0400
Received: by bwz15 with SMTP id 15so2787675bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 13:09:11 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Juan Carlos Garza <juancarlosgarza@gmail.com>
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers in AP and IBSS
Date: Thu, 17 Mar 2011 21:07:25 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com> <201103171316.02636.helmut.schaa@googlemail.com> <AANLkTi=Gm-apOyop22UgFMgoQE_+maEQgrMDdH-kTxZq@mail.gmail.com>
In-Reply-To: <AANLkTi=Gm-apOyop22UgFMgoQE_+maEQgrMDdH-kTxZq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103172107.25316.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 17. März 2011 schrieb Juan Carlos Garza:
> Warning - TX status report missed for queue 0 entry 42
> Mar 17 17:10:26 LS817 kernel: phy0 -> rt2x00queue_flush_queue: Warning
> - Queue 0 failed to flush

Looks as if some tx status reports got lost and that triggered the
watchdog. There are some experimental patches in the rt2x00 experimental
tree ([1], [2], [3] and [4]) that might mitigate some of these issues.

Mind to try these out and report back if they improve the behavior
under load?

Thanks,
Helmut

[1] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=878a2bbc20100d8bccf84cc058373fe7de2e6501
[2] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=4f3ab1e88d8b5ce4852d075016ca784a00383452
[3] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=c8cb3a0af064fb5d9cbbaa16bd2f308ba3b90ceb
[4] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=66b096e6ad64f718425d2de9a70d82ba187d7db4
