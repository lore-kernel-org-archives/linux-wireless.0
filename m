Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:42204 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932157AbeEWKFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 06:05:16 -0400
Subject: Re: [PATCH 00/10] Some more patches for wcn36xx
To: Kalle Valo <kvalo@codeaurora.org>
Cc: loic.poulain@linaro.org, linux-wireless@vger.kernel.org,
        bjorn.andersson@linaro.org, nicolas.dechesne@linaro.org,
        wcn36xx@lists.infradead.org, rfried@codeaurora.org
References: <20180516140820.1636-1-daniel@zonque.org>
 <95b89ceb-cc25-023e-9fa2-e45b2deb5027@zonque.org>
 <874lj5jj96.fsf@kamboji.qca.qualcomm.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <65b0f1d0-0c74-0efb-c7ca-c0fbae681810@zonque.org> (sfid-20180523_120519_377146_9E10498B)
Date: Wed, 23 May 2018 12:05:12 +0200
MIME-Version: 1.0
In-Reply-To: <874lj5jj96.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Friday, May 18, 2018 01:28 PM, Kalle Valo wrote:
> Daniel Mack <daniel@zonque.org> writes:
> 
>> On Wednesday, May 16, 2018 04:08 PM, Daniel Mack wrote:
>>> Hence I believe that some sort of firmware internal buffer is overrun if
>>> too many SMD requests fly in in a short amount of time. The firmware
>>> does, however, still ack all packets just fine on the SMD channels, and
>>> also the DXE communication flows are all healthy. No errors are reported
>>> anywhere, but nothing is being put on the ether anymore.
>>
>> And FTR, there is a commit in the prima repository that caught my
>> attention a while back:
>>
>>    https://source.codeaurora.org/external/wlan/prima/commit/?id=93cd8f3c
>>
>> What this does (through an remarkable number of indirection layers) is
>> sending the DUMP_COMMAND_REQ command with args = (274, 0, 0, 0, 0)
>> when management frames get stuck, which smells pretty much like the
>> issue I'm seeing. Doing the same with the mainline driver and the
>> debugfs interface it exposes doesn't have any effect though.
>>
>> But even if it did work, I wouldn't see a way to detect the situation
>> in which this is needed reliably.
> 
> The firmware version might make a difference so I recommend always
> mentioning the firmware version as well. For example, what if your
> firmware does not support that command or parameter?

Sure, that could be the case. FTR - the firmware I'm using is the one 
that came out of the Qualcomm r1034.2.1 BSP. It is recognized by the 
driver as 'WCN v2.0 RadioPhy vRhea_GF_1.12 with 19.2MHz XO'.

> Also I would recommend to file a bug to bugzilla.kernel.org so that all
> the information is one place and it can be easily updated. Now it's
> pretty difficult to get the big picture from various emails on the list.

Yes, I agree it's a bit convoluted. However, there's already the bug 
report on 96board.org that Bjorn opened some time back, and I considered 
that sufficient. IMO, it has all the information needed, plus a link to 
a tool to reproduce the issue.

   https://bugs.96boards.org/show_bug.cgi?id=538

The patches in this series can be considered as general cleanups that 
are not necessarily related to this particular issue.


Thanks,
Daniel
