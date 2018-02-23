Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:53382 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751383AbeBWJyg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 04:54:36 -0500
Received: by mail-wm0-f53.google.com with SMTP id t74so3542773wme.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Feb 2018 01:54:35 -0800 (PST)
Subject: Re: brcmfmac signal/interference issues
To: Daniel Drake <drake@endlessm.com>
References: <CAD8Lp46dbsn2qyzYE6N-6quJXc2xUeO4Fi=UhZz=P2Q=G7A41A@mail.gmail.com>
 <5A8D36B7.1010201@broadcom.com>
 <CAD8Lp44MdsO_F0xEYhdjF=hAj4h26561VQJepubEEmtdWoQ-vA@mail.gmail.com>
 <CAD8Lp44Y-sNqm8_5=1pvBy-3zvVVQSCQ+Qye-2xP8vGmkvrjng@mail.gmail.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A8FE4D9.80608@broadcom.com> (sfid-20180223_105440_440076_A2B016DB)
Date: Fri, 23 Feb 2018 10:54:33 +0100
MIME-Version: 1.0
In-Reply-To: <CAD8Lp44Y-sNqm8_5=1pvBy-3zvVVQSCQ+Qye-2xP8vGmkvrjng@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/23/2018 9:26 AM, Daniel Drake wrote:
> Hi,
>
> On Wed, Feb 21, 2018 at 12:39 PM, Daniel Drake <drake@endlessm.com> wrote:
>> Thanks for looking into this. Here is the brcmfmac43455-sdio.txt file
>> we are using:
>> https://gist.github.com/dsd/d7ee3caa6dfd77f0bcd16cf272b20298
>> This is identical to the 4345r6nvram.txt file from windows.
>
> I checked Windows again and it seems to be using a firmware file
> 4345r6rtecdc.bin alongside this nvram data.
> This firmware is different from the one in linux-firmware. I've
> uploaded it here:
> https://drive.google.com/open?id=1MUsiaoozslJb8SCYOR-FNbJFuD-h4PY_
>
> I was hoping to try this on Linux to see if it makes any difference to
> the issue seen here.
> However, with thisi firmware in place, I can't connect to the network
> at all. It associates, wpa_supplicant never sees the first WPA2 key
> message sent from the AP - even though wireshark on a separate monitor
> shows that the key message was sent, and that the STA acked it.
>
> I turned off WPA2 to make it an open network instead, and now I am
> unable to complete the DHCP conversation. According to the monitor
> station, the STA succesfully transmits DHCPDISCOVER and the AP
> responds with DHCPOFFER. The offer is acked, but dhclient never sees
> it, and eventually times out.
>
> Any ideas why this firmware may not be working at all on linux?

Yup. Windows firmware talks NDIS. If you run 'strings 4345r6rtecdc.bin | 
tail -1' you can see the firmware build target and it likely has 'ndis' 
in it.

Now are you using BT as well on this device? Another suggestion I got is 
to disable transmit beamforming which brcmfmac enables by default. Not 
sure if this device supports it, but could you try the patch below.

Regards,
Arend

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c 
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 9be0b05..512ea57 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -363,9 +363,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
                 goto done;
         }

-       /* Enable tx beamforming, errors can be ignored (not supported) */
-       (void)brcmf_fil_iovar_int_set(ifp, "txbf", 1);
-
         /* do bus specific preinit here */
         err = brcmf_bus_preinit(ifp->drvr->bus_if);
  done:
