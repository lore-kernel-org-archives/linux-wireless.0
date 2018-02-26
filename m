Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:39723 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750877AbeBZTVp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 14:21:45 -0500
Received: by mail-wr0-f174.google.com with SMTP id w77so22380864wrc.6
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2018 11:21:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <dd7bb2acd1be43346315d7bb349b45b2@codeaurora.org>
References: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
 <aedd8281-ee1b-e5ae-2521-fd3a7a221dd6@candelatech.com> <dd7bb2acd1be43346315d7bb349b45b2@codeaurora.org>
From: Adrian Chadd <adrian@freebsd.org>
Date: Mon, 26 Feb 2018 11:21:42 -0800
Message-ID: <CAJ-VmokdboP37J8csaj=xKOpiXDxXfF7wrv+cdJp+UCYFjtU_g@mail.gmail.com> (sfid-20180226_202149_191062_30CD91F1)
Subject: Re: [PATCH] Revert "ath10k: send (re)assoc peer command when NSS changed"
To: Karthikeyan Periyasamy <periyasa@codeaurora.org>
Cc: Ben Greear <greearb@candelatech.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

so it's going to eventually leak? Can we fix the firmware bug too? :)


-a


On 26 February 2018 at 09:06,  <periyasa@codeaurora.org> wrote:
> Hi,
>
>
>> Can you share exactly which resource the firmware ran out of?  It would
>> seem to
>> be a FW bug if it is leaking, so maybe it can be fixed as well...
>>
>
> Firmware have total user_id = 528 (512 clients + 16 VAPs). Each user_id is
> allocated to peer when Firmware receive the WMI_PEER_ASSOC_CMDID request
> from host driver. Firmware free the user_id in peer delete operation.
>
> Regards,
> Karthikeyan P.
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
