Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:38662 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751276AbeBWNtR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 08:49:17 -0500
Received: by mail-wr0-f180.google.com with SMTP id n7so14187081wrn.5
        for <linux-wireless@vger.kernel.org>; Fri, 23 Feb 2018 05:49:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5A8FE4D9.80608@broadcom.com>
References: <CAD8Lp46dbsn2qyzYE6N-6quJXc2xUeO4Fi=UhZz=P2Q=G7A41A@mail.gmail.com>
 <5A8D36B7.1010201@broadcom.com> <CAD8Lp44MdsO_F0xEYhdjF=hAj4h26561VQJepubEEmtdWoQ-vA@mail.gmail.com>
 <CAD8Lp44Y-sNqm8_5=1pvBy-3zvVVQSCQ+Qye-2xP8vGmkvrjng@mail.gmail.com> <5A8FE4D9.80608@broadcom.com>
From: Daniel Drake <drake@endlessm.com>
Date: Fri, 23 Feb 2018 16:49:15 +0300
Message-ID: <CAD8Lp44Q0=jS0gqnt1mMfjRe6sTx3Z7n9=iGvk3VFGK2549V7g@mail.gmail.com> (sfid-20180223_144921_770431_4F1A383B)
Subject: Re: brcmfmac signal/interference issues
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 23, 2018 at 12:54 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> Yup. Windows firmware talks NDIS. If you run 'strings 4345r6rtecdc.bin |
> tail -1' you can see the firmware build target and it likely has 'ndis' in
> it.

43455c0-roml/sdio-ag-ndis-vista-pktfilter-d0c-pno-aoe-p2p-dhdoid-ndoe-gtkoe-mfp-proptxstatus-dmatxrc-keepalive-ap-ampduretry-pclose-txbf

Yes, ndis. So no easy way to run the same firmware on the 2 OSes.

> Now are you using BT as well on this device? Another suggestion I got is to
> disable transmit beamforming which brcmfmac enables by default. Not sure if
> this device supports it, but could you try the patch below.

Thanks for the ideas. I had already tried with the bluetooth disabled
- no change there.
Also reproduced the problem after applying your patch.

Daniel
