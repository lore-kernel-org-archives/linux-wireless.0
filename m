Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:47024 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbeIDUtc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 16:49:32 -0400
Date: Tue, 4 Sep 2018 19:23:38 +0300
From: Aleksei Mamlin <mamlinav@gmail.com>
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Add rtl8188ctv support
Message-Id: <20180904192338.e9be91d4be447e33acefed5a@gmail.com> (sfid-20180904_182357_291472_1E5A2573)
In-Reply-To: <53022e37-e9dc-1cf8-ec3c-4df668f3c045@gmail.com>
References: <20180830140541.31964-1-mamlinav@gmail.com>
        <20180904081619.7353B606AC@smtp.codeaurora.org>
        <53022e37-e9dc-1cf8-ec3c-4df668f3c045@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 4 Sep 2018 11:36:50 -0400
Jes Sorensen <jes.sorensen@gmail.com> wrote:

> On 09/04/2018 04:16 AM, Kalle Valo wrote:
> > Aleksei Mamlin <mamlinav@gmail.com> wrote:
> > 
> >> The Realtek rtl8188ctv (0x0bda:0x018a) is a highly integrated single-chip
> >> WLAN USB2.0 network interface controller.
> >>
> >> Currently rtl8188ctv is supported by rtlwifi driver.
> >> It is similar to the rtl8188cus(0x0bda:0x818a) and uses the same config.
> >>
> >> Signed-off-by: Aleksei Mamlin <mamlinav@gmail.com>
> > 
> > Patch applied to wireless-drivers-next.git, thanks.
> > 
> > 514502c3a70b rtl8xxxu: Add rtl8188ctv support
> 
> Looks good to me too - assume it's been tested?
> 

Yes, tested on my ARM tablet. It successfully connected to my home router
using wpa_supplicant. There is dmesg output:

[   16.887902] usb 2-1: This Realtek USB WiFi dongle (0x0bda:0x018a) is untested!
[   16.887916] usb 2-1: Please report results to Jes.Sorensen@gmail.com
[   17.133053] usb 2-1: Vendor: Realtek
[   17.133066] usb 2-1: Product: 802.11n WLAN Adapter
[   17.133076] usb 2-1: rtl8192cu_parse_efuse: dumping efuse (0x80 bytes):
[   17.133084] usb 2-1: 00: 29 81 00 a4 cd 00 20 00
[   17.133090] usb 2-1: 08: ff 00 da 0b 8a 01 03 41
[   17.133096] usb 2-1: 10: 32 00 85 62 9e ad 00 b3
[   17.133102] usb 2-1: 18: 10 00 00 3a 0a 03 52 65
[   17.133108] usb 2-1: 20: 61 6c 74 65 6b 00 16 03
[   17.133114] usb 2-1: 28: 38 30 32 2e 31 31 6e 20
[   17.133120] usb 2-1: 30: 57 4c 41 4e 20 41 64 61
[   17.133125] usb 2-1: 38: 70 74 65 72 00 00 00 00
[   17.133131] usb 2-1: 40: 00 00 00 00 00 00 00 00
[   17.133137] usb 2-1: 48: 00 00 00 00 00 00 00 00
[   17.133143] usb 2-1: 50: 81 00 00 00 00 00 00 00
[   17.133149] usb 2-1: 58: 06 00 2b 2b 2c 00 00 00
[   17.133154] usb 2-1: 60: 27 27 28 00 00 00 00 00
[   17.133160] usb 2-1: 68: 00 02 02 04 04 04 05 00
[   17.133166] usb 2-1: 70: 00 00 00 00 00 0a 00 00
[   17.133172] usb 2-1: 78: 10 00 00 10 36 00 81 00
[   17.133183] usb 2-1: RTL8188CU rev B (TSMC) 1T1R, TX queues 2, WiFi=1, BT=0, GPS=0, HI PA=0
[   17.133191] usb 2-1: RTL8188CU MAC: 00:b3:10:00:00:3a
[   17.133199] usb 2-1: rtl8xxxu: Loading firmware rtlwifi/rtl8192cufw_TMSC.bin
[   17.139167] usb 2-1: Firmware revision 80.0 (signature 0x88c1)

>
> Thanks,
> Jes


-- 
Thanks and regards,
Aleksei Mamlin
