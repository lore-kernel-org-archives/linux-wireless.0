Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57513 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753067AbcJRTGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 15:06:22 -0400
Message-ID: <1476817578.6425.40.camel@sipsolutions.net> (sfid-20161018_210624_954027_21817017)
Subject: Re: Intel 7260 not working on 4.4.24 / armv7
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Zemann <oliver.zemann@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 18 Oct 2016 21:06:18 +0200
In-Reply-To: <fa098763-cdf6-03f8-6d75-0fa9dfb270e4@gmail.com> (sfid-20161018_182323_634850_59C65E60)
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
         <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com>
         <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
         <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com>
         <fa098763-cdf6-03f8-6d75-0fa9dfb270e4@gmail.com>
         (sfid-20161018_182323_634850_59C65E60)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-18 at 18:22 +0200, Oliver Zemann wrote:
> Because of the problems with the ath10 card, i bought an intel 7260 
> (mpcie) wifi card. Unfortunately it is also not working.
> I get tons of those messages:
> 
> [  175.777030] usb 1-1: new full-speed USB device number 2 using
> orion-ehci
> [  175.933953] usb 1-1: New USB device found, idVendor=8087,
> idProduct=07dc
> [  175.940681] usb 1-1: New USB device strings: Mfr=0, Product=0, 
> SerialNumber=0
> [  175.966954] Bluetooth: hci0: read Intel version:
> 3707100180012d0d00
> [  175.973313] Bluetooth: hci0: Intel Bluetooth firmware file: 
> intel/ibt-hw-37.7.10-fw-1.80.1.2d.d.bseq
> [  176.183954] Bluetooth: hci0: Intel Bluetooth firmware patch
> completed 
> and activated
> [  176.749831] usb 1-1: USB disconnect, device number 2

This is odd. However, it's entirely related to the NICs *Bluetooth*
function, which lives on USB.

> What's confusing me is that this device is connected through pcie,
> not usb. When i use lspci i get:
> [root@alarm log]# lspci
> 00:02.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev
> 04)
> 00:03.0 PCI bridge: Marvell Technology Group Ltd. Device 6828 (rev
> 04)
> 02:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac 
> Wireless Network Adapter (rev ff)
> 
> So the other card is seen as pci device, but the intel is not. I am 
> really lost now.

The NICs *WiFi* function should be a PCIe device, but the USB
connect/disconnect cycles suggest that there's something wrong with the
electrical connection, which presumably causes the PCIe part of the
device to never appear on the bus.

johannes
