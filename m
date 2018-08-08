Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-cys01nam02on0135.outbound.protection.outlook.com ([104.47.37.135]:1902
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726258AbeHHEuE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Aug 2018 00:50:04 -0400
Reply-To: chi-hsien.lin@cypress.com
Subject: Re: [PATCH v2] brcmfmac: fix brcmf_wiphy_wowl_params() NULL pointer
 dereference
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Winnie Chang <winnie.chang@cypress.com>
References: <1533649107-157808-1-git-send-email-chi-hsien.lin@cypress.com>
 <5B69F407.6040004@broadcom.com>
From: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-ID: <61e55b75-2505-0fd8-f58d-aa85fe8431fd@cypress.com> (sfid-20180808_043247_647564_05AEC99D)
Date: Wed, 8 Aug 2018 10:32:25 +0800
MIME-Version: 1.0
In-Reply-To: <5B69F407.6040004@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/08/2018 3:33, Arend van Spriel wrote:
> On 8/7/2018 3:38 PM, Chi-Hsien Lin wrote:
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
> 
> The above info should be in Fixes: tag, but maybe Kalle is willing to
> reformat it this time.

Thanks for the note. I've fixed this and submitted v3.

> 
> Regards,
> Arend
> 
>> Signed-off-by: Winnie Chang <winnie.chang@cypress.com>
>> Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
>> ---
