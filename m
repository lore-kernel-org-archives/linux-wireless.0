Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam01on0132.outbound.protection.outlook.com ([104.47.32.132]:18608
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732639AbeHGP6U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Aug 2018 11:58:20 -0400
Reply-To: chi-hsien.lin@cypress.com
Subject: Re: [PATCH] brcmfmac: fix brcmf_wiphy_wowl_params() NULL pointer
 dereference
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Winnie Chang <winnie.chang@cypress.com>
References: <1533622686-145733-1-git-send-email-chi-hsien.lin@cypress.com>
 <87a7py4dqz.fsf@kamboji.qca.qualcomm.com>
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-ID: <d336b996-9762-2c58-0b51-297b4e2c291b@cypress.com> (sfid-20180807_154359_240709_3499F461)
Date: Tue, 7 Aug 2018 21:40:44 +0800
MIME-Version: 1.0
In-Reply-To: <87a7py4dqz.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/07/2018 7:28, Kalle Valo wrote:
> Chi-Hsien Lin <chi-hsien.lin@cypress.com> writes:
> 
>> From: Winnie Chang <winnie.chang@cypress.com>
>>
>> The kernel BUG happens when wowl is enabled from firmware. In
>> brcmf_wiphy_wowl_params(), cfg is a NULL pointer because it is
>> drvr->config returned from wiphy_to_cfg(), and drvr->config is not set
>> yet. To fix it, set drvr->config before brcmf_setup_wiphy() which
>> calls brcmf_wiphy_wowl_params().
>>
>> The kernel panic is introduced in below commit:
>> commit id: 856d5a011c86b59f6564be4508912fb1d866adfc
>> brcmfmac: allocate struct brcmf_pub instance using wiphy_new()
>>
>> Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
>> Reviewed-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
> 
> Chi-Hsien, you need to include your own s-o-b as well when you are
> submitting the patch:
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#signed-off-by_missing

Hi Kalle,

Thanks a lot for the notes. I've added proper s-o-b in V2.

Chi-hsien Lin

> 
> --
> Kalle Valo
> 
> 
> ----------
> 
> You're receiving this message because you're a member of the brcm80211-dev-list group.
> .
> 
