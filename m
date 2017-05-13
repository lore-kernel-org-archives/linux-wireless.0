Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38447 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbdEMNj3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 09:39:29 -0400
Received: by mail-wm0-f53.google.com with SMTP id v15so6072446wmv.1
        for <linux-wireless@vger.kernel.org>; Sat, 13 May 2017 06:39:28 -0700 (PDT)
Subject: Re: New brcmfmac errors in 4.12: brcmf_sdio_rxglom: sublen ... not
 multiple of 8
To: Hans de Goede <hdegoede@redhat.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
References: <e8055bc7-eaf4-1ab6-31d1-130d83485980@redhat.com>
 <540e89cd-c222-e81a-5e34-600ae0aa052e@redhat.com>
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <701cc6a7-b66b-8a51-8755-13dd584cbebd@gmail.com> (sfid-20170513_153933_054107_7A60895E)
Date: Sat, 13 May 2017 15:39:13 +0200
MIME-Version: 1.0
In-Reply-To: <540e89cd-c222-e81a-5e34-600ae0aa052e@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 13.05.2017 um 14:35 schrieb Hans de Goede:
> <resend with the author of the commit causing this added>
> 
> Hi,
> 
> On 13-05-17 14:19, Hans de Goede wrote:
>> Hi,
>>
>> I've just rebased my personal kernel tree to what will soon be 4.12-rc1
>> and I'm getting my dmesg log filled with the following errors:
>>
>> [   32.528271] brcmfmac: brcmf_sdio_rxglom: sublen 524 not multiple of 8
>> [   32.528296] brcmfmac: brcmf_sdio_rxglom: sublen 84 not multiple of 8
>> [   33.063241] brcmfmac: brcmf_sdio_rxglom: sublen 1492 not multiple of 8
>>
After a brief look at the code I'm not sure that the check actually checks
for an error condition. Apart from the error messages:
Do you face issues with the functionality of the driver?

>> Other brcmfmac dmesg messages:
>>
>> [   16.020013] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jul 17 2013 07:36:07 version 6.10.197.71 (r412987) FWID 01-882d2634
>>
>> This is on a Asus T100TA which uses a 43241b1
> 
> Ok, this seems to be a regression caused by:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6e84ab604bded
> "brcmfmac: properly align buffers on certain platforms with 64 bit DMA"
> 
> I believe this may need a different fix then that.
> 
> Regards,
> 
> Hans
> 
