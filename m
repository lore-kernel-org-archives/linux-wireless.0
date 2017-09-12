Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:37863 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751119AbdILHgz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 03:36:55 -0400
Received: by mail-qk0-f178.google.com with SMTP id b82so23355732qkc.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Sep 2017 00:36:55 -0700 (PDT)
Subject: Re: [PATCH V2 1/3] brcmfmac: Avoid possible out-of-bounds read
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170909193020.19061-1-cernekee@chromium.org>
 <deff51ff-40f0-ffa4-afd0-b95465c66a8e@broadcom.com>
 <87tw08mpq1.fsf@purkki.adurom.net>
Cc: Kevin Cernekee <cernekee@chromium.org>, franky.lin@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59B78E94.5040909@broadcom.com> (sfid-20170912_093659_409549_CA06FC98)
Date: Tue, 12 Sep 2017 09:36:52 +0200
MIME-Version: 1.0
In-Reply-To: <87tw08mpq1.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/12/2017 7:48 AM, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>
>> On 09-09-17 21:30, Kevin Cernekee wrote:
>>> In brcmf_p2p_notify_rx_mgmt_p2p_probereq(), chanspec is assigned before
>>> the length of rxframe is validated.  This could lead to uninitialized
>>> data being accessed (but not printed).  Since we already have a
>>> perfectly good endian-swapped copy of rxframe->chanspec in ch.chspec,
>>> and ch.chspec is not modified by decchspec(), avoid the extra
>>> assignment and use ch.chspec in the debug print.
>>>
>>> Suggested-by: Mattias Nissler <mnissler@chromium.org>
>>> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
>>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>> ---
>>>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 +--
>>>    1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>>
>>> V1->V2: Clarify changelog re: whether the uninitialized data is printed.
>>
>> This patch and the others in this series look fine to me.
>
> Should these go to v4.14?

I have no strong opinion. These are certainly improvements, but it does 
not seem an -rc fix to me. Within this series I would say patch 3/3 adds 
an additional sanity check in the event processing against an attack so 
you may consider adding just that one to v4.14 and tag it for stable, ie.:

Cc: stable@vger.kernel.org # v3.8.x

Regards,
Arend
