Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47190 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbcEVXFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2016 19:05:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1b4cQh-0007vJ-TX
	for linux-wireless@vger.kernel.org; Mon, 23 May 2016 01:05:04 +0200
Received: from 66-87-113-223.pools.spcsdns.net ([66-87-113-223.pools.spcsdns.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2016 01:05:03 +0200
Received: from dlenski by 66-87-113-223.pools.spcsdns.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2016 01:05:03 +0200
To: linux-wireless@vger.kernel.org
From: Dan Lenski <dlenski@gmail.com>
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
Date: Sun, 22 May 2016 23:02:40 +0000 (UTC)
Message-ID: <nhtdqf$te$1@ger.gmane.org> (sfid-20160523_010523_839049_D3A3BA06)
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com> <wrfjinyayf2i.fsf@redhat.com> <CAOw_LSHnV+244fT7YvEoV+7VSH_+OoGFmZSdGK4a3NqB407VGQ@mail.gmail.com> <wrfj4m9svn35.fsf@redhat.com> <CAOw_LSH8yGT+OoJU=a23B32mZ+qLkNuronB+vqZ5SaBRAG-fQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Lenski wrote:

> - Hypothesis: since the rtl8xxxu driver does not explicitly power off the
>  device before attempting to power it on, if it boots up in an unknown
>  state, it will remain in this state until explicitly power-cycled.

I am now pretty sure that this is the true cause of fimware not starting.

I found that I can induce "Firmware failed to start" by using kexec --force to restart the kernel without a clean shutdown.

After this incomplete reboot, the firmware always fails to start. I guess the rtl8xxxu hardware must be left in some unknown state:

[    2.794118] usb 1-1.4: Vendor: Realtek
[    2.794121] usb 1-1.4: Product: 802.11n WLAN Adapter
[    2.794124] usb 1-1.4: RTL8723AU rev B (TSMC) 1T1R, TX queues 2, WiFi=1, BT=1, GPS=0, HI PA=0
[    2.794125] usb 1-1.4: RTL8723AU MAC: 20:16:d8:ce:5e:29
[    2.794127] usb 1-1.4: rtl8xxxu: Loading firmware rtlwifi/rtl8723aufw_B_NoBT.bin
[    2.797136] usb 1-1.4: Firmware revision 31.0 (signature 0x2302)
[    2.878370] usb 1-1.4: Firmware checksum poll completed after 0 loops
[    4.153567] usb 1-1.4: Firmware failed to start after 5000 loops

After power-off and retry of rtl8xxxu_init_device, it then starts correctly:

[    4.153569] usb 1-1.4: Failed to init device, will retry 5 more times.
[    4.746357] usb 1-1.4: Firmware checksum poll completed after 0 loops
[    4.752456] usb 1-1.4: Firmware started after 23 loops
[    5.194825] usb 1-1.4: Enabling HT_20_40 on the 2.4GHz band

Should I submit a new patch to retry rtl8xxxu_init_device after power cycling?

Thanks,
Dan

