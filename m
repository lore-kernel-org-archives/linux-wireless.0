Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:9157 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbYBGVvK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2008 16:51:10 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2717576fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2008 13:51:08 -0800 (PST)
Message-ID: <47AB7D48.2020805@gmail.com> (sfid-20080207_215116_069264_365D207B)
Date: Thu, 07 Feb 2008 22:51:04 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>,
	Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [RFT 1/1] single_chip test
References: <20080206014131.9d489a34.akpm@linux-foundation.org> <1202294560-7313-1-git-send-email-jirislaby@gmail.com> <20080206150043.GA6921@nineveh.local> <b6c5339f0802060746m3a5f87edj4465797564430292@mail.gmail.com> <20080207212529.GA5975@dose.home.local>
In-Reply-To: <20080207212529.GA5975@dose.home.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/07/2008 10:25 PM, Tino Keitel wrote:
> On Wed, Feb 06, 2008 at 10:46:39 -0500, Bob Copeland wrote:
>>>> We failed to resume after a hardware reset here for a whole second. Is there any
>>>> version of ath5k which worked for you (is this a regression)?
>>> I cannot speak for Tino, but my ath5k never worked in MacBook -- it
>>> failed the same way, and I believe the hardware was the same.  My
>>> understanding was that it was a known bug with PCIE devices, but I got
>>> that out of reading list archives.
>> Nick Kossifidis and I are in the process of debugging this -- we
>> determined that AR5K_RESET_CTL_PCI hangs the card in hw_nic_wakeup.
>> It doesn't look like there is any general support for 5424 cards yet.

Seems hold for this case too, as Bob noted.

> I tried the patch, and the card was detected. I was able to associate
> with an WPA2 AP and send/receive some traffic. But after a while the
> interface broke:
> 
> ath0: No ProbeResp from current AP 00:14:bf:16:25:87 - assume out of
> range
> ath5k_hw_get_isr: 0x00000020
> ...
> ath0: failed to set channel 165 (5825 MHz) for scan
> ath0: failed to restore operational channel after scan
> printk: 19 messages suppressed.
> ath5k phy0: calibration timeout (2447MHz)
> printk: 1 messages suppressed.
> ath5k phy0: calibration timeout (2447MHz)
> ath5k phy0: unable to reset hardware: -11

What's the srev a phy ver printed few lines above this, please?
