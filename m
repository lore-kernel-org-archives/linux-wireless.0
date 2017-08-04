Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:38603 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752681AbdHDMfc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 Aug 2017 08:35:32 -0400
Received: by mail-wr0-f171.google.com with SMTP id f21so16275017wrf.5
        for <linux-wireless@vger.kernel.org>; Fri, 04 Aug 2017 05:35:31 -0700 (PDT)
Message-ID: <59846A11.80400@broadcom.com> (sfid-20170804_143537_511952_C1824979)
Date: Fri, 04 Aug 2017 14:35:29 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH resend] brcmfmac: p2p and normal ap access are not always
 possible at the same time
References: <20170526105747.16874-1-hdegoede@redhat.com> <20170526105747.16874-2-hdegoede@redhat.com>
In-Reply-To: <20170526105747.16874-2-hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/26/2017 12:57 PM, Hans de Goede wrote:
> The firmware responding with -EBUSY when trying to add an extra virtual-if
> is a normal thing, do not print an error for this.

Hi Hans,

First of all, sorry! This one is long overdue (thanks for the reminder, 
Kalle). Not sure what the claim is here. I have to check the firmware to 
see what could make this fail. Thing is that wpa_supplicant will try to 
create the interface upon startup and it is really required for P2P 
operations. Now people not using that will probably not care about the 
failure, but I would like to find out why it is failing. wpa_supplicant 
will not do a retry upon -EBUSY.

With which firmware (target string and version) are you seeing this so I 
know where to dive in.

Regards,
Arend

> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>   .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 14 ++++++++++----
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c     |  5 ++++-
>   2 files changed, 14 insertions(+), 5 deletions(-)
>
