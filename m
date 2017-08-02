Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:33523 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752722AbdHBKR7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 06:17:59 -0400
Received: by mail-qt0-f182.google.com with SMTP id a18so24222316qta.0
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 03:17:59 -0700 (PDT)
Message-ID: <5981A6D4.4030805@broadcom.com> (sfid-20170802_121803_608290_56987AAC)
Date: Wed, 02 Aug 2017 12:17:56 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>
CC: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 3/3] brcmfmac: fix wrong num_different_channels when mchan
 feature enabled
References: <1501577287-28904-1-git-send-email-wright.feng@cypress.com> <1501577287-28904-3-git-send-email-wright.feng@cypress.com> <87mv7i48nx.fsf@codeaurora.org>
In-Reply-To: <87mv7i48nx.fsf@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/2/2017 11:32 AM, Kalle Valo wrote:
> Wright Feng <wright.feng@cypress.com> writes:
>
>> The num_different_channels in wiphy info is not correct when firmware
>> supports mchan. When mchan is on, num_different_channels is always
>> overridden to 1 in brcmf_setup_ifmodes. Correct the logic by moving
>> num_different_channels setting forward.
>>
>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>
> Does this fix a user visible bug? If yes, it would be nice to document
> that.

Hi Kalle,

Depends on the users expectation ;-) When the device/firmware supports 
multi-channel (better not use mchan abbreviation) it can have P2P 
connection and regular connection with AP simultaneous. So the current 
state is that this is not possible regardless whether mchan is 
supported. So the device is not used to fullest extent.

Regards,
Arend
