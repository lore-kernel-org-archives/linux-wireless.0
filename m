Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:46809 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934268AbeBMJuv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 04:50:51 -0500
Received: by mail-qt0-f171.google.com with SMTP id u6so2941484qtg.13
        for <linux-wireless@vger.kernel.org>; Tue, 13 Feb 2018 01:50:51 -0800 (PST)
Subject: Re: Make brcmfmac repeat authentication requests
To: Daniel Drake <drake@endlessm.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com
References: <CAD8Lp47D5sGCpxSiFYQviu0a62W4aj-5Sgs6sjE7E2cZWwsUwg@mail.gmail.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A82B4F8.2090209@broadcom.com> (sfid-20180213_105108_909267_A4264763)
Date: Tue, 13 Feb 2018 10:50:48 +0100
MIME-Version: 1.0
In-Reply-To: <CAD8Lp47D5sGCpxSiFYQviu0a62W4aj-5Sgs6sjE7E2cZWwsUwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/12/2018 3:04 PM, Daniel Drake wrote:
> Hi,
>
> We are working with the Weibu F3C MiniPC which includes BCM43455 SDIO
> wifi chip 0x004345(17221) rev 0x000006
>
> Testing Linux 4.15, this wifi adapter is unable to authenticate with
> the MF928 MiFi Access Point which is common in Africa. The STA sends
> the authentication request, which is ACKed by the AP, but then the
> conversation ends there (a timeout later bubbles up to userspace).
> Windows 10 with broadcom driver version 1.605.1.0 is also unable to
> connect.

I tried to find info about that access point equipment, but not getting 
any hits apart from a olivetti laser printer, but I doubt it is that. 
Can you provide more details.

> My laptop with ath10k can authenticate and connect fine. There the
> conversation is:
>
> 1. STA sends authentication request
> 2. AP sends ACK
> 3. After 0.1s timeout, STA sends another auth request
> 4. AP sends ACK
> 5. AP sends authentication response
> 6. etc.
>
> Also confirmed the same pattern on a couple of smartphones, where the
> delay seems to be 0.3s before repeating the authentication request.
>
> Clearly this AP is not behaving correctly; the authentication request
> should not have to be repeated. However of all the devices to hand,
> unfortunately only this broadcom device is unable to connect.

User-space (wpa_supplicant) would retry the connect attempt so I guess 
you are saying that the timing between the two auth requests is important?

> Is there a way to adjust the driver/firmware to repeat the
> authentication requests when they are not responded to? This would
> match the behaviour of other devices and work around this issue.

Is firmware not repeating at all or is the time between the two auth 
requests too long?

Checking firmware there is a 300ms timeout and it does a retry if the 
limit is not reached. However, that limit is initialized to zero :-p

Could you try the patch below?

Regards,
Arend

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c 
b/drivers
index 19686ef..af1ab00 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -384,6 +384,9 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
                 goto done;
         }

+       /* allow join retry by firmware */
+       (void)brcmf_fil_iovar_int_set(ifp, "assoc_retry_max", 1);
+
         /* Enable tx beamforming, errors can be ignored (not supported) */
         (void)brcmf_fil_iovar_int_set(ifp, "txbf", 1);



> Thanks
> Daniel
>
