Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36337 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751623AbeBWI0p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 03:26:45 -0500
Received: by mail-wr0-f193.google.com with SMTP id v111so964028wrb.3
        for <linux-wireless@vger.kernel.org>; Fri, 23 Feb 2018 00:26:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD8Lp44MdsO_F0xEYhdjF=hAj4h26561VQJepubEEmtdWoQ-vA@mail.gmail.com>
References: <CAD8Lp46dbsn2qyzYE6N-6quJXc2xUeO4Fi=UhZz=P2Q=G7A41A@mail.gmail.com>
 <5A8D36B7.1010201@broadcom.com> <CAD8Lp44MdsO_F0xEYhdjF=hAj4h26561VQJepubEEmtdWoQ-vA@mail.gmail.com>
From: Daniel Drake <drake@endlessm.com>
Date: Fri, 23 Feb 2018 11:26:42 +0300
Message-ID: <CAD8Lp44Y-sNqm8_5=1pvBy-3zvVVQSCQ+Qye-2xP8vGmkvrjng@mail.gmail.com> (sfid-20180223_092656_103301_D53D8072)
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

Hi,

On Wed, Feb 21, 2018 at 12:39 PM, Daniel Drake <drake@endlessm.com> wrote:
> Thanks for looking into this. Here is the brcmfmac43455-sdio.txt file
> we are using:
> https://gist.github.com/dsd/d7ee3caa6dfd77f0bcd16cf272b20298
> This is identical to the 4345r6nvram.txt file from windows.

I checked Windows again and it seems to be using a firmware file
4345r6rtecdc.bin alongside this nvram data.
This firmware is different from the one in linux-firmware. I've
uploaded it here:
https://drive.google.com/open?id=1MUsiaoozslJb8SCYOR-FNbJFuD-h4PY_

I was hoping to try this on Linux to see if it makes any difference to
the issue seen here.
However, with thisi firmware in place, I can't connect to the network
at all. It associates, wpa_supplicant never sees the first WPA2 key
message sent from the AP - even though wireshark on a separate monitor
shows that the key message was sent, and that the STA acked it.

I turned off WPA2 to make it an open network instead, and now I am
unable to complete the DHCP conversation. According to the monitor
station, the STA succesfully transmits DHCPDISCOVER and the AP
responds with DHCPOFFER. The offer is acked, but dhclient never sees
it, and eventually times out.

Any ideas why this firmware may not be working at all on linux?

Thanks,
Daniel
