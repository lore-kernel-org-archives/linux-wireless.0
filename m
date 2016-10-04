Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:34746 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbcJDARB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 20:17:01 -0400
Received: by mail-yw0-f173.google.com with SMTP id g192so118591504ywh.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Oct 2016 17:17:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161003130407.4D94161803@smtp.codeaurora.org>
References: <1475027104-17423-1-git-send-email-rajatja@google.com> <20161003130407.4D94161803@smtp.codeaurora.org>
From: Rajat Jain <rajatja@google.com>
Date: Mon, 3 Oct 2016 17:16:19 -0700
Message-ID: <CACK8Z6Fe34xdvd5-=3dNmqKXYC=Qr9+kpG46eCV7uFArLW+yyQ@mail.gmail.com> (sfid-20161004_021709_036494_B67C028F)
Subject: Re: [v2] mwifiex: report wakeup for wowlan
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Wei-Ning Huang <wnhuang@google.com>,
        Brian Norris <briannorris@google.com>,
        Eric Caruso <ejcaruso@chromium.org>,
        Rajat Jain <rajatxjain@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalie,

On Mon, Oct 3, 2016 at 6:04 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rajat Jain <rajatja@google.com> wrote:
>> Enable notifying wakeup source to the PM core in case of
>> a wake on wireless LAN event.
>>
>> Signed-off-by: Wei-Ning Huang <wnhuang@google.com>
>> Signed-off-by: Rajat Jain <rajatja@google.com>
>> Tested-by: Wei-Ning Huang <wnhuang@chromium.org>
>> Reviewed-by: Eric Caruso <ejcaruso@chromium.org>
>> Acked-by: Amitkumar Karwar <akarwar@marvell.com>
>
> The commit log doesn't give any background info. Does this fix a bug or
> why is it needed?

Some of chromeos' features (called "darkresume" in chromeos
terminology) use and track the wake up sources using the wakeup
attributes in sysfs. Since the wireless device can wake up the host,
hence we wanted to add it as a wakeup source to the system, and in the
case of an actual wakeup event, trigger to the PM core that it was
indeed caused by the device and it increments the different counters
etc. In the absence of this patch,  the feature wasn't working very
well (as it was apparently confused about the cause of wake up).

Thanks,

Rajat
