Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr30070.outbound.protection.outlook.com ([40.107.3.70]:45112
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751754AbeDIMXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 08:23:37 -0400
From: Petr Machata <petrm@mellanox.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Himanshu Jha <himanshujha199640@gmail.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        kvalo@codeaurora.org, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: Re: Passing uninitialised local variable
References: <20180328112014.GA11484@himanshu-Vostro-3559>
        <5ABD5735.1050608@broadcom.com>
Date: Mon, 09 Apr 2018 15:23:07 +0300
In-Reply-To: <5ABD5735.1050608@broadcom.com> (Arend van Spriel's message of
        "Thu, 29 Mar 2018 23:14:29 +0200")
Message-ID: <wiho9is602c.fsf@dev-r-vrt-156.mtr.labs.mlnx> (sfid-20180409_142346_987601_4E059774)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 3/28/2018 1:20 PM, Himanshu Jha wrote:
>> I recently found that a local variable in passed uninitialised to the
>> function at
>>
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:2950
>>
>>                  u32 var;
>>                  err = brcmf_fil_iovar_int_get(ifp, "dtim_assoc", &var);

>>
>> s32
>> brcmf_fil_iovar_int_get(struct brcmf_if *ifp, char *name, u32 *data)
>> {
>>          __le32 data_le = cpu_to_le32(*data);

>> }
>>
>> We can cleary see that 'var' in used uninitialised in the very first line
>> which is an undefined behavior.
>
> Why undefined? We copy some stack data and we do transfer that to the device. However in this case
> the device does nothing with it and it is simply overwritten by the response.

"Undefined behavior" is a technical term for when there are no
guarantees as to what the result of executing a given code will be. None
at all--it might for example abort, and that would be perfectly valid as
well. (To be clear, this is not about the device, but about the CPU that
this code runs on.)

Uninitialized reads are one example of a code construct that invokes
undefined behavior.

Thanks,
Petr
