Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52628 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdILFs7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 01:48:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kevin Cernekee <cernekee@chromium.org>, franky.lin@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Subject: Re: [PATCH V2 1/3] brcmfmac: Avoid possible out-of-bounds read
References: <20170909193020.19061-1-cernekee@chromium.org>
        <deff51ff-40f0-ffa4-afd0-b95465c66a8e@broadcom.com>
Date: Tue, 12 Sep 2017 08:48:54 +0300
In-Reply-To: <deff51ff-40f0-ffa4-afd0-b95465c66a8e@broadcom.com> (Arend van
        Spriel's message of "Sun, 10 Sep 2017 20:50:35 +0200")
Message-ID: <87tw08mpq1.fsf@purkki.adurom.net> (sfid-20170912_074920_026034_1FCF3E80)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 09-09-17 21:30, Kevin Cernekee wrote:
>> In brcmf_p2p_notify_rx_mgmt_p2p_probereq(), chanspec is assigned before
>> the length of rxframe is validated.  This could lead to uninitialized
>> data being accessed (but not printed).  Since we already have a
>> perfectly good endian-swapped copy of rxframe->chanspec in ch.chspec,
>> and ch.chspec is not modified by decchspec(), avoid the extra
>> assignment and use ch.chspec in the debug print.
>>
>> Suggested-by: Mattias Nissler <mnissler@chromium.org>
>> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>>
>> V1->V2: Clarify changelog re: whether the uninitialized data is printed.
>
> This patch and the others in this series look fine to me.

Should these go to v4.14?

-- 
Kalle Valo
