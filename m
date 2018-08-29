Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:33949 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbeH3ARe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 20:17:34 -0400
Received: by mail-yb0-f194.google.com with SMTP id t10-v6so2537221ybb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 13:19:04 -0700 (PDT)
From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: rtl8723bu: low signal, fails to associate
To: James Cameron <quozl@laptop.org>, linux-wireless@vger.kernel.org,
        Mylene JOSSERAND <mylene.josserand@free-electrons.com>,
        Stefan Pappalardo <stefan.pappalardo@gmx.de>,
        Carlo Caione <carlo@endlessm.com>
References: <20180824013645.GB761@us.netrek.org>
Message-ID: <bd9ef21e-b0f6-f947-b14d-cbb8abf4efdb@gmail.com> (sfid-20180829_221924_214105_19383B91)
Date: Wed, 29 Aug 2018 16:19:01 -0400
MIME-Version: 1.0
In-Reply-To: <20180824013645.GB761@us.netrek.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/23/2018 09:36 PM, James Cameron wrote:
> G'day Carlo, Mylene, and James,
> 
> Thanks for your earlier reports about RTL8723bu.  Have you any more
> recent experiences you might share?
> 
> I'm evaluating a sample laptop which worked fine with Windows 10, but
> not very well with Ubuntu 18.04, and kernel v4.15 or kernel v4.18.4.
> 
> The laptop is by Hena, model NT16-PRO-C-E, with a wireless device on
> internal USB (0x0bda:0xb720) which loads rtl8xxxu, identifying as
> RTL8723BU.
> 
> http://dev.laptop.org/~quozl/z/1ft0qv.txt (dmesg)
> 
> Symptoms are low RSSI on scan, very short range, and often a failure
> to associate over a distance of two metres in a radio quiet location.
> 
> Symptoms began after first power off, which suggests that device
> registers programmed by the previous operating system Windows 10 had
> not been reset by reboot into the Ubuntu 18.04 installer.  The device
> worked fine in Ubuntu 18.04 before the first power off.
> 
> Jes, let me know if there is anything I can do to help.

It's been a while since I had time to look at the 8723bu support, and
rtl8xxxu doesn't have BT coexist support. I notice that your laptop does
load the bluetooth module for 8723bu which I believe fiddles with the
antenna configuration and is likely to take control of the antennas. I
suspect this is why you see low signal quality on the WiFi side.

If you blacklist the BT module, does it work better?

Jes
