Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753155AbdEMOzG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 10:55:06 -0400
Subject: Re: New brcmfmac errors in 4.12: brcmf_sdio_rxglom: sublen ... not
 multiple of 8
To: Heiner Kallweit <hkallweit1@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
References: <e8055bc7-eaf4-1ab6-31d1-130d83485980@redhat.com>
 <540e89cd-c222-e81a-5e34-600ae0aa052e@redhat.com>
 <701cc6a7-b66b-8a51-8755-13dd584cbebd@gmail.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <cf896651-18a6-ee07-62a4-437c191ddde4@redhat.com> (sfid-20170513_165513_148324_D39C56B1)
Date: Sat, 13 May 2017 16:55:02 +0200
MIME-Version: 1.0
In-Reply-To: <701cc6a7-b66b-8a51-8755-13dd584cbebd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 13-05-17 15:39, Heiner Kallweit wrote:
> Am 13.05.2017 um 14:35 schrieb Hans de Goede:
>> <resend with the author of the commit causing this added>
>>
>> Hi,
>>
>> On 13-05-17 14:19, Hans de Goede wrote:
>>> Hi,
>>>
>>> I've just rebased my personal kernel tree to what will soon be 4.12-rc1
>>> and I'm getting my dmesg log filled with the following errors:
>>>
>>> [   32.528271] brcmfmac: brcmf_sdio_rxglom: sublen 524 not multiple of 8
>>> [   32.528296] brcmfmac: brcmf_sdio_rxglom: sublen 84 not multiple of 8
>>> [   33.063241] brcmfmac: brcmf_sdio_rxglom: sublen 1492 not multiple of 8
>>>
> After a brief look at the code I'm not sure that the check actually checks
> for an error condition. Apart from the error messages:
> Do you face issues with the functionality of the driver?

Yes after a while I get -ETIMEOUT errors for any sdio transfers
to the device. But I'm not sure if this is caused by this commit,
I think I've seen this once with 4.11 too.

I've reverted the commit for now, but I'm fine with instead of
doing the revert dropping the error check if the brcmfmac developers
think that is ok. Currently the ETIMEOUT seems to be gone, so
if dropping the revert causes it to re-appear then we know more.

Regards,

Hans
