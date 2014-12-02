Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbaLBMSf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 07:18:35 -0500
Date: Tue, 2 Dec 2014 13:15:32 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 4/4] Revert "rt2x00: Endless loop on hub port power down"
Message-ID: <20141202121531.GA2676@redhat.com> (sfid-20141202_131838_063725_01D2B9C1)
References: <1417012156-26197-1-git-send-email-sgruszka@redhat.com>
 <1417012156-26197-4-git-send-email-sgruszka@redhat.com>
 <547D9FE5.1010006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <547D9FE5.1010006@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 02, 2014 at 12:17:57PM +0100, Richard Genoud wrote:
> It tested this serie but unfortunately, reverting this still caused an infinite loop.
> (cf https://lkml.org/lkml/2014/4/3/492 to reproduce)

It is possible to disable internal hub? It fails here, but perhaps I do
not have compiled proper options in the kernel:

[stasiu@localhost Downloads]$ lsusb -t
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/3p, 480M
    |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/8p, 480M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/3p, 480M
    |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/6p, 480M
        |__ Port 3: Dev 3, If 0, Class=Vendor Specific Class, Driver=, 12M
        |__ Port 4: Dev 4, If 0, Class=Vendor Specific Class, Driver=btusb, 12M
        |__ Port 4: Dev 4, If 1, Class=Vendor Specific Class, Driver=btusb, 12M
        |__ Port 4: Dev 4, If 2, Class=Vendor Specific Class, Driver=, 12M
        |__ Port 4: Dev 4, If 3, Class=Application Specific Interface, Driver=, 12M
        |__ Port 6: Dev 5, If 0, Class=Video, Driver=uvcvideo, 480M
        |__ Port 6: Dev 5, If 1, Class=Video, Driver=uvcvideo, 480M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 5000M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 480M
    |__ Port 2: Dev 2, If 0, Class=Vendor Specific Class, Driver=rt2800usb, 480M
    |__ Port 3: Dev 3, If 0, Class=Human Interface Device, Driver=usbhid, 12M
[stasiu@localhost Downloads]$ sudo ./hub-ctrl -b 1 -d 1 -P 1 -p 0
Device not found.
[stasiu@localhost Downloads]$ sudo ./hub-ctrl -b 1 -d 2 -P 2 -p 0
Device not found.

> [  642.476562] ieee80211 phy0: rt2800usb_watchdog: Warning - TX HW queue 1 timed out, invoke forced kick
> [  642.585937] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x0408 with error -71
> [  642.695312] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x0408 with error -71
> [  642.796875] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
> [...]
> So it seems the "forced kick" is not done 

"Forced kick" does not mean to remove device, it means restarting
hardware queue. It is not done, because it requires write to PBF_CFG
register (0x0408), which is not possible.

I do not see an "infinite" loop. What I can see is continues failures
when sending requests to to the hardware. I consider this as proper
behaviour, taking that USB layer continuously return -EPROTO error. If
for example there will be not possible to down interface or remove
rt2800usb module in such condition, I would consider this as a minor
bug, but I'm not sure if that happen or not.

Stanislaw
