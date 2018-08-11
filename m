Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34551 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbeHKWyj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 11 Aug 2018 18:54:39 -0400
Received: by mail-wm0-f65.google.com with SMTP id l2-v6so4248972wme.1
        for <linux-wireless@vger.kernel.org>; Sat, 11 Aug 2018 13:19:21 -0700 (PDT)
Subject: Re: [PATCH] ath10k: retrieve MAC address from firmware if provided
To: Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>
References: <20180810233948.144792-1-briannorris@chromium.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        linux-kernel@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B6F2A47.7070502@broadcom.com> (sfid-20180811_221924_370185_F5ADF909)
Date: Sat, 11 Aug 2018 20:26:15 +0200
MIME-Version: 1.0
In-Reply-To: <20180810233948.144792-1-briannorris@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/11/2018 1:39 AM, Brian Norris wrote:
> Devices may provide their own MAC address via system firmware (e.g.,

You got me confused by using just "firmware" in the subject.

> device tree), especially in the case where the device doesn't have a
> useful EEPROM on which to store its MAC address (e.g., for integrated
> Wifi).
>
> Use the generic device helper to retrieve the MAC address, and (if
> present) honor it above the MAC address advertised by the card.

But this put me back on track ;-)

> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
>   drivers/net/wireless/ath/ath10k/core.c | 3 +++
>   drivers/net/wireless/ath/ath10k/wmi.c  | 3 ++-
>   2 files changed, 5 insertions(+), 1 deletion(-)
