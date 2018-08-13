Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34989 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730273AbeHMT6G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 15:58:06 -0400
Received: by mail-lf1-f67.google.com with SMTP id f18-v6so11802853lfc.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 10:14:59 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id o74-v6sm3429928lfg.31.2018.08.13.10.14.56
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 Aug 2018 10:14:56 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id p10-v6so13208808ljg.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 10:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <20180810233948.144792-1-briannorris@chromium.org> <5B6F2A47.7070502@broadcom.com>
In-Reply-To: <5B6F2A47.7070502@broadcom.com>
From: Brian Norris <briannorris@chromium.org>
Date: Mon, 13 Aug 2018 10:14:44 -0700
Message-ID: <CA+ASDXOeybJAsWJtVBdLdQ=6xThJja5MaEoa3dERKZ-shkbDkg@mail.gmail.com> (sfid-20180813_191502_916279_94AE7BC4)
Subject: Re: [PATCH] ath10k: retrieve MAC address from firmware if provided
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, govinds@codeaurora.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 11, 2018 at 11:26 AM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> On 8/11/2018 1:39 AM, Brian Norris wrote:
> > Devices may provide their own MAC address via system firmware (e.g.,
>
> You got me confused by using just "firmware" in the subject.

Yeah...I started by writing this patch with device tree specifically
(of_get_mac_address()), and then later found that there were generic
"device" helpers for this, which can assist with other sorts of
firmware nodes. It was easier to put a name on a device tree patch
than on a "device" patch. I suppose "system firmware" might be a
better description?

> > device tree), especially in the case where the device doesn't have a
> > useful EEPROM on which to store its MAC address (e.g., for integrated
> > Wifi).
> >
> > Use the generic device helper to retrieve the MAC address, and (if
> > present) honor it above the MAC address advertised by the card.
>
> But this put me back on track ;-)

Let me know if you have a better way to clarify. I can resend with a
slightly modified subject (s/firmware/system firmware/), or let Kalle
do it, if that's the only thing to change.

Brian
