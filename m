Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22853 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbdAaPGD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 10:06:03 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <linux-wireless@vger.kernel.org>,
        Michal Kazior <michal.kazior@tieto.com>,
        <ath10k@lists.infradead.org>
Message-ID: <8c891ab36ff94bdfa1ff91c3f4d2e2a3@eusanexr01a.eu.qualcomm.com> (sfid-20170131_160705_683105_4EFAF766)
Date: Tue, 31 Jan 2017 07:02:10 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> wrote:
> Firmware files are versioned to prevent older
> driver instances to load unsupported firmware
> blobs. This is reflected with a fallback logic
> which attempts to load several firmware files.
> 
> This however produced a lot of unnecessary
> warnings sometimes confusing users and leading
> them to rename firmware files making things even
> more confusing.
> 
> Hence use request_firmware_direct() which does not
> produce extra warnings. This shouldn't really
> break anything because most modern systems don't
> rely on udev/hotplug helpers to load firmware
> files anymore.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

While testing Erik's usb patches I noticed one problem if the firmware (or
board file) is not found:

[  517.389399] usbcore: registered new interface driver ath10k_usb
[  517.391756] usb 2-1.3: could not fetch firmware files (-2)
[  517.391985] usb 2-1.3: could not probe fw (-2)

Now the user has no way to know what file is exactly missing. I'll try to
improve that in v2.

-- 
https://patchwork.kernel.org/patch/9237095/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
