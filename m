Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40132 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755137AbdEKMLo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 08:11:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Eugene Krasnikov <k.eugene.e@gmail.com>,
        Eyal Ilsar <c_eilsar@qti.qualcomm.com>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] wcn36xx: Close SMD channel on device removal
References: <20170509043637.28179-1-bjorn.andersson@linaro.org>
        <87h90u3672.fsf@kamboji.qca.qualcomm.com>
        <20170509230312.GR15143@minitux>
        <6e1cc217-924f-c536-6009-f6a377844d6f@broadcom.com>
        <20170510175254.GS15143@minitux>
Date: Thu, 11 May 2017 15:11:38 +0300
In-Reply-To: <20170510175254.GS15143@minitux> (Bjorn Andersson's message of
        "Wed, 10 May 2017 10:52:55 -0700")
Message-ID: <87o9uzsidh.fsf@kamboji.qca.qualcomm.com> (sfid-20170511_141340_804323_9069F23C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> writes:

> On Wed 10 May 00:27 PDT 2017, Arend van Spriel wrote:
>
>> On 5/10/2017 1:03 AM, Bjorn Andersson wrote:
>>
>> > AFAICT this never worked, as it seems I did the rework in SMD while we
>> > tried to figure out the dependency issues we had with moving to SMD. So
>> > v4.9 through v4.11 has SMD support - with this bug.
>> > 
>> > How do I proceed, do you want me to write up a fix for stable@? Do I
>> > send that out as an ordinary patch?
>> 
>> If the patch applies cleanly on branches linux-4.9.y through linux-4.11.y in
>> the stable repository you can go for '--- Option 1 ---' as described in
>> <linux-repo>/Documentation/stable_kernel_rules.txt.
>> 
>
> It does not, before v4.12 it's a completely different function to call
> to close the channel.
>
> But "Option 3" describes the situation, thanks for the reference. I'll
> try to find the time to verify the patch on v4.11 and send it to
> stable@.

Great, thanks. This seems to be that serious that better to fix this
also in older releases.

-- 
Kalle Valo
