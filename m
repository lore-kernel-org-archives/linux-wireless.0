Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:60640 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdGZGTd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 02:19:33 -0400
Date: Wed, 26 Jul 2017 08:19:25 +0200 (CEST)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Franky Lin <franky.lin@broadcom.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-rpi-kernel@lists.infradead.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>
Message-ID: <314866679.136055.1501049965582@email.1und1.de> (sfid-20170726_082032_299009_CDC96577)
In-Reply-To: <1389331679.85833.1500323470395@email.1und1.de>
References: <384537059.123625.1498678388857@email.1und1.de>
 <1133935948.74840.1500297053336@email.1und1.de>
 <CA+8PC_eKn_LddvcpYG=V6vD7qZfVNEmmzR3gWXxWO80SNKR-3Q@mail.gmail.com>
 <1389331679.85833.1500323470395@email.1und1.de>
Subject: Re: brcmfmac: BCM43431 won't get probed on Raspberry Pi Zero W
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Stefan Wahren <stefan.wahren@i2se.com> hat am 17. Juli 2017 um 22:31 geschrieben:
> 
> 
> Hi,
> 
> > Franky Lin <franky.lin@broadcom.com> hat am 17. Juli 2017 um 21:50 geschrieben:
> > 
> > 
> > On Mon, Jul 17, 2017 at 6:10 AM, Stefan Wahren <stefan.wahren@i2se.com> wrote:
> > > Hi,
> > >
> > >> Stefan Wahren <stefan.wahren@i2se.com> hat am 28. Juni 2017 um 21:33 geschrieben:
> > >>
> > >>
> > >> Hi,
> > >>
> > >> i'm currently working on Raspberry Pi Zero W for Mainline. Here is my first patch series [1].
> > >>
> > >> Unfortunately i didn't get brcmfmac (connected via SDIO) probed with this patch series against 4.12.0-rc5-next-20170616+
> > >>
> > >> [    8.389167] brcmfmac: F1 signature read @0x18000000=0x1541a9a6
> > >> [    8.735111] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: May 27 2016 00:13:38 version 7.45.41.26 (r640327) FWID 01-df77e4a7
> > >> [    8.786016] brcmfmac: brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012
> > >> [   11.288798] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> > >> [   11.292822] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> > >> [   13.848777] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> > >> [   13.852974] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> > >> [   16.408762] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> > >> [   16.413004] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> > >> [   18.968769] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> > >> [   18.972965] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> > >> [   21.528743] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> > >> [   21.532924] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> > >> [   24.088745] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
> > >> [   24.092948] brcmfmac: brcmf_sdio_checkdied: firmware trap in dongle
> > >> [   26.648764] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
> > >> [   26.648789] brcmfmac: brcmf_cfg80211_attach: Failed to get D11 version (-110)
> > >> [   26.648831] brcmfmac: brcmf_bus_started: failed: -12
> > >> [   26.648842] brcmfmac: brcmf_sdio_firmware_callback: dongle is not responding
> > >>
> > ...
> > Can you please try to comment out the following lines in
> > brcmf_feat_attach? That's the only suspicious line that interact with
> > firmware in the patch.
> > 
> > + brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN, "pfn_gscan_cfg",
> > +                                            &gscan_cfg, sizeof(gscan_cfg));
> 
> after commenting out this line, the issue doesn't appear.
>

what are the plans to fix this regression?
