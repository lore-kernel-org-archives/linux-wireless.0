Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37358 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752238AbdH1Izw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Aug 2017 04:55:52 -0400
Received: by mail-wm0-f48.google.com with SMTP id u26so7825136wma.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Aug 2017 01:55:51 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: CVE-2017-9417 and brcmfmac
To: Ben Hutchings <ben@decadent.org.uk>,
        brcm80211-dev-list.pdl@broadcom.com
References: <1503846841.3688.92.camel@decadent.org.uk>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org
Message-ID: <59A3DA95.4050005@broadcom.com> (sfid-20170828_105556_936954_3C55ABDA)
Date: Mon, 28 Aug 2017 10:55:49 +0200
MIME-Version: 1.0
In-Reply-To: <1503846841.3688.92.camel@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-08-17 17:14, Ben Hutchings wrote:
> The CVE-2017-9417 aka "Broadpwn" vulnerability is said to affect the
> firmware for various Broadcom BCM43xx wifi chips, some of which are
> supported by the in-tree brcmfmac driver and firmware in linux-
> firmware.git.
>
> The bcmdhd driver for Android was patched to improve validation of
> events from the firmware:
> https://android.googlesource.com/kernel/msm.git/+/android-6.0.1_r0.92%5E!/
> But the event handling code in
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c still seems to
> lack most of those checks.  Should it be patched?

brcmfmac already has those checks is place [1]. Over a year ago a number 
of extra checks were added with commit 0aedbcaf6f18 ("brcmfmac: Add 
length checks on firmware events") [2].

> I also haven't seen any related updates for BCM43xx firmware in linux-
> firmware.git.  Is any of this firmware vulnerable?

As to firmware it has been brought up that we have quite a collection in 
linux-firmware, but quite a few are EOL. So for now the decision made 
has been to update firmware for bcm43430, bcm4354, bcm4356, and bcm4358. 
For SDIO and USB devices business has moved to Cypress so I will contact 
them to query about their plans. As Stephen indicated they released new 
firmware for bcm43438, which is used in RPi3/ZeroW.

Regards,
Arend

[1] 
http://elixir.free-electrons.com/linux/latest/source/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h#L306
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/commit/?id=0aedbcaf6f18
