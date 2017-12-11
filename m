Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:36362 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752217AbdLKRof (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 12:44:35 -0500
Received: by mail-yb0-f178.google.com with SMTP id j7so6315257ybl.3
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 09:44:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171211154140.GD4803@minitux>
References: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org>
 <20171211153403.GA30332@codeaurora.org> <20171211154140.GD4803@minitux>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Mon, 11 Dec 2017 18:43:54 +0100
Message-ID: <CAMZdPi_9RSSxBzaLq07JcoZXMwztgcD=YfeJ1X4yzaZck-d+bg@mail.gmail.com> (sfid-20171211_184441_778296_27168348)
Subject: Re: [PATCH v2] wcn36xx: Fix dynamic power saving
To: Ramon Fried <rfried@codeaurora.org>
Cc: kvalo@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ramon,

On 11 December 2017 at 16:41, Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
> On Mon 11 Dec 07:34 PST 2017, Ramon Fried wrote:
>
>> On Mon, Dec 11, 2017 at 10:52:22AM +0200, Loic Poulain wrote:
>> > Since driver does not report hardware dynamic power saving cap,
>> > this is up to the mac80211 to manage power saving timeout and
>> > state machine, using the ieee80211 config callback to report
>> > PS changes. This patch enables/disables PS mode according to
>> > the new configuration.
>> >
>> > Remove old behaviour enabling PS mode in a static way, this make
>> > the device unusable when power save is enabled since device is
>> > forced to PS regardless RX/TX traffic.
>> >
>>
>> Hi.
>> I tried to see if this patch solves the ping delay once power save is
>> turned on and it appears it doesn't (log below).
>> I do see some change in the delay though in comparison to testing without the patch.
>> Bjorn, How did you test it ?

For me this is the expected behavior, when station is in PS mode, some
time is required
to leave PS, this is the cost for saving power. Since ping is every
second, station goes
back to PS between each ping due to dynamic PS timeout, this indeed
leads to some
latency... I obtain same kind of results pinging my mobile phone. Note
that the PS
timeout can be changed (100ms by default).

>>
>
> Without this patch I get ping times around a second and SSH is not
> usable, with this patch I see similar ping times as you, but SSH is
> usable.
>
> I have not been able to run iperf, because I keep hitting
> https://bugs.96boards.org/show_bug.cgi?id=663

Yes, improvement can be mainly observed with high traffic.

Regards,
Loic
