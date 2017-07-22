Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:38252 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbdGVVeB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Jul 2017 17:34:01 -0400
Received: by mail-qk0-f181.google.com with SMTP id g6so40307498qkf.5
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jul 2017 14:34:01 -0700 (PDT)
Subject: Re: brcm43430 sdio wifi regression with 4.13-rc1
To: Hans de Goede <hdegoede@redhat.com>
Cc: russianneuromancer <russianneuromancer@ya.ru>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com
References: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <95deba4b-7f63-8bb9-f8ab-c22f1d23985c@broadcom.com> (sfid-20170722_233419_185934_D1FC31CE)
Date: Sat, 22 Jul 2017 23:33:57 +0200
MIME-Version: 1.0
In-Reply-To: <d33144fc-c03e-0d71-41b2-e0cd235f5ffa@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-07-17 20:43, Hans de Goede wrote:
> The real culprit here seems to be:
> 
> jul 22 14:13:23 localhost.localdomain kernel: brcmfmac:
> brcmf_sdio_hostmail: Unknown mailbox data content: 0x40012

So I dug a little deeper in our firmware and as it turns out it is
indeed a firmware halt which is indicated by 0x10. 0x02 is DEVREADY and
0x40000 indicates the protocol version.

Regards,
Arend
