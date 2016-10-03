Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751061AbcJCMeo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 08:34:44 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] rtl8xxxu: Fix memory leak in handling rxdesc16 packets
References: <1475178055-16924-1-git-send-email-Jes.Sorensen@redhat.com>
        <1475178055-16924-2-git-send-email-Jes.Sorensen@redhat.com>
        <87wphpsxky.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 03 Oct 2016 08:34:41 -0400
In-Reply-To: <87wphpsxky.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Mon, 03 Oct 2016 10:25:49 +0300")
Message-ID: <wrfjmvil3926.fsf@redhat.com> (sfid-20161003_143448_463147_4BC206BA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> A device running without RX package aggregation could return more data
>> in the USB packet than the actual network packet. In this case the
>> could would clone the skb but then determine that that there was no
>> packet to handle and exit without freeing the cloned skb first.
>
> s/case the/case we/? I can edit that before applying the patch.

Sounds good - thanks!

Jes
