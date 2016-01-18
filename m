Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34556 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616AbcARUar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 15:30:47 -0500
Received: by mail-ob0-f173.google.com with SMTP id vt7so170693023obb.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2016 12:30:47 -0800 (PST)
Subject: Re: Fwd: 8192 WiFi Realtek 8192E disconnects after a while and fails
 to reconnect
To: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>,
	gilbertdion@gmail.com, wlanfae@realtek.com,
	chaoming_li@realsil.com.cn
References: <CAKQFV0H+K46CO62w=9yNRvVaOpwmDj3UKXD0QOmF1XPs54GwnQ@mail.gmail.com>
 <CAKQFV0EV9WvmzJaUaFEGODc-kxpt=rXJVYe5Md4oM5H00cBaeQ@mail.gmail.com>
 <568EE125.1030103@gmail.com> <569C10A9.8020200@gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <569D4B74.4040709@lwfinger.net> (sfid-20160118_213104_499919_FC956233)
Date: Mon, 18 Jan 2016 14:30:44 -0600
MIME-Version: 1.0
In-Reply-To: <569C10A9.8020200@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2016 04:07 PM, Mateusz Kulikowski wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
> Hi Gilbert,
>
> Small update from my side - It took me a while to setup x86_64 machine,
> but today was finally able to do test.
>
>
> My result are the same as Larry:
> I got my board running for ~4 hours and there was no disconnect.
> For part of the time I was doing (some) activity, for around hour machine
> was idle.
>
> I also did suspend-resume cycle.
>
> System: Ubuntu 15.04 (from usb stick), kernel 3.19.0-15-generic, x86_64
> Machine: MSI AM1I, Sempron 2650,
> PCIe to mini-pcie "wifi" bridge (with antenna connector and proper RFKILL
> wiring).
>
>
> Are you able to do more troubleshooting?
>
> Perhaps try different AP/Channel/mode, (dis)connect power cable from laptop etc.
>
> I'll try to make another reproduction attempt, as without being able
> to reproduce it I will probably not be able to fix it.

The problem only shows up when you hit the NIC hard. Try downloading a large 
file while browsing.

Some info from the Realtek engineer:

=============================
About 92EE's 64 bit mode (PCI DAC), there are three roles -- (PCI host, PCI 
device, TRX desc).
All possible combinations are:
(32, 32, 32)
(64, 64, 64)
(32, 32, 64)	<== special one

To setup 64 bit mode, please use followings:
1. PCI host
     pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
2. PCI device
     configuration space 0x719[5] = 1 indicate 64 bit mode
3. TRX desc
     register 0x382[15] = 1 indicate 64 bits mode


If we turn on DMA_IS_64BIT, it will be the combination (32, 32, 64).
It is rare to use because of 32 bit DMA address (SAC), but I think it will be work.
We may extend DMA_IS_64BIT to the combination (64, 64, 64) to be meaningful.
=============================

I did the easy step by effectively turning on DMA_IS_64BIT, and the driver 
failed. I have not had time to investigate any other of the 64-bit fixes.

Larry

