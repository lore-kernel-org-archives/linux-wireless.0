Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:40583 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753251AbeDSRAZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 13:00:25 -0400
Received: by mail-wr0-f174.google.com with SMTP id v60-v6so15901537wrc.7
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2018 10:00:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8736zrjgq6.fsf@kamboji.qca.qualcomm.com>
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
 <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
 <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com> <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
 <87604oodt4.fsf@kamboji.qca.qualcomm.com> <a7dd1b94951725c61034f5be6744b725@codeaurora.org>
 <8736zrjgq6.fsf@kamboji.qca.qualcomm.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Thu, 19 Apr 2018 10:00:22 -0700
Message-ID: <CAJ-Vmoky1JkQ5ZFc_zmvRdtRkVwVftLgqZehvfn6e8bH8TqKCg@mail.gmail.com> (sfid-20180419_190029_855788_C50705D0)
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
To: Kalle Valo <kvalo@codeaurora.org>
Cc: govinds@codeaurora.org, pillair@codeaurora.org,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

My 2c here.

As much as I like power save stuff, I've been bitten enough times by
these wifi chips kinda implementing
mostly-ok-but-not-that-particular-time power savings stuff and so have
had to make it configurable chip by chip.

A good example is active state power management in various runtime and
idle modes on different chips, how it intersects with things like
bluetooth, btcoex, is the bios buggy, etc, etc.

So I'd at least like a way to control that feature as a module load
and/or debugfs entry to aide users trying to figure out why chips
disappear or behave erratically. I'm ok with it being turned on but
I'm not ok with a debugging step being "oh yeah, so just go comment
this out and recompile", especially if people are debugging on an
embedded target where it's not easily self hosted or easy to rebuild
things.




-adrian
