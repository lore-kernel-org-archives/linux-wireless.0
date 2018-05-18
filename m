Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54104 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbeERL2L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 07:28:11 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, loic.poulain@linaro.org,
        bjorn.andersson@linaro.org, nicolas.dechesne@linaro.org,
        wcn36xx@lists.infradead.org, rfried@codeaurora.org
Subject: Re: [PATCH 00/10] Some more patches for wcn36xx
References: <20180516140820.1636-1-daniel@zonque.org>
        <95b89ceb-cc25-023e-9fa2-e45b2deb5027@zonque.org>
Date: Fri, 18 May 2018 14:28:05 +0300
In-Reply-To: <95b89ceb-cc25-023e-9fa2-e45b2deb5027@zonque.org> (Daniel Mack's
        message of "Fri, 18 May 2018 12:50:53 +0200")
Message-ID: <874lj5jj96.fsf@kamboji.qca.qualcomm.com> (sfid-20180518_132814_725120_FC3B9F96)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Mack <daniel@zonque.org> writes:

> On Wednesday, May 16, 2018 04:08 PM, Daniel Mack wrote:
>> Hence I believe that some sort of firmware internal buffer is overrun if
>> too many SMD requests fly in in a short amount of time. The firmware
>> does, however, still ack all packets just fine on the SMD channels, and
>> also the DXE communication flows are all healthy. No errors are reported
>> anywhere, but nothing is being put on the ether anymore.
>
> And FTR, there is a commit in the prima repository that caught my
> attention a while back:
>
>   https://source.codeaurora.org/external/wlan/prima/commit/?id=93cd8f3c
>
> What this does (through an remarkable number of indirection layers) is
> sending the DUMP_COMMAND_REQ command with args = (274, 0, 0, 0, 0)
> when management frames get stuck, which smells pretty much like the
> issue I'm seeing. Doing the same with the mainline driver and the
> debugfs interface it exposes doesn't have any effect though.
>
> But even if it did work, I wouldn't see a way to detect the situation
> in which this is needed reliably.

The firmware version might make a difference so I recommend always
mentioning the firmware version as well. For example, what if your
firmware does not support that command or parameter?

Also I would recommend to file a bug to bugzilla.kernel.org so that all
the information is one place and it can be easily updated. Now it's
pretty difficult to get the big picture from various emails on the list.

-- 
Kalle Valo
