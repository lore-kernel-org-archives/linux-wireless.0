Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:61030 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469AbaLBQfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 11:35:32 -0500
Received: by mail-lb0-f171.google.com with SMTP id n15so10883786lbi.30
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 08:35:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141202121531.GA2676@redhat.com>
References: <1417012156-26197-1-git-send-email-sgruszka@redhat.com>
 <1417012156-26197-4-git-send-email-sgruszka@redhat.com> <547D9FE5.1010006@gmail.com>
 <20141202121531.GA2676@redhat.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 2 Dec 2014 17:35:10 +0100
Message-ID: <CACQ1gAj4rW7OZRfA58ZQPb+t8kq+hr3GGbj2Yw0H2Q9A6ONU9w@mail.gmail.com> (sfid-20141202_173540_848291_195F571F)
Subject: Re: [PATCH 4/4] Revert "rt2x00: Endless loop on hub port power down"
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-12-02 13:15 GMT+01:00 Stanislaw Gruszka <sgruszka@redhat.com>:
> On Tue, Dec 02, 2014 at 12:17:57PM +0100, Richard Genoud wrote:
>> It tested this serie but unfortunately, reverting this still caused an infinite loop.
>> (cf https://lkml.org/lkml/2014/4/3/492 to reproduce)
>
> It is possible to disable internal hub? It fails here, but perhaps I do
> not have compiled proper options in the kernel:
>
> [stasiu@localhost Downloads]$ lsusb -t
> /:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/3p, 480M
>     |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/8p, 480M
> /:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/3p, 480M
>     |__ Port 1: Dev 2, If 0, Class=Hub, Driver=hub/6p, 480M
>         |__ Port 3: Dev 3, If 0, Class=Vendor Specific Class, Driver=, 12M
>         |__ Port 4: Dev 4, If 0, Class=Vendor Specific Class, Driver=btusb, 12M
>         |__ Port 4: Dev 4, If 1, Class=Vendor Specific Class, Driver=btusb, 12M
>         |__ Port 4: Dev 4, If 2, Class=Vendor Specific Class, Driver=, 12M
>         |__ Port 4: Dev 4, If 3, Class=Application Specific Interface, Driver=, 12M
>         |__ Port 6: Dev 5, If 0, Class=Video, Driver=uvcvideo, 480M
>         |__ Port 6: Dev 5, If 1, Class=Video, Driver=uvcvideo, 480M
> /:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 5000M
> /:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=xhci_hcd/4p, 480M
>     |__ Port 2: Dev 2, If 0, Class=Vendor Specific Class, Driver=rt2800usb, 480M
>     |__ Port 3: Dev 3, If 0, Class=Human Interface Device, Driver=usbhid, 12M
> [stasiu@localhost Downloads]$ sudo ./hub-ctrl -b 1 -d 1 -P 1 -p 0
> Device not found.
> [stasiu@localhost Downloads]$ sudo ./hub-ctrl -b 1 -d 2 -P 2 -p 0
> Device not found.
I've just tried on my machine, and it doesn't work on root_hub.
root@lnx-rg:~$ lsusb -t
/:  Bus 08.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/6p, 480M
    |__ Port 3: Dev 2, If 0, Class=hub, Driver=hub/4p, 480M
        |__ Port 1: Dev 3, If 0, Class=HID, Driver=usbhid, 1.5M
        |__ Port 4: Dev 4, If 0, Class=vend., Driver=ftdi_sio, 12M
/:  Bus 07.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/6p, 480M
    |__ Port 4: Dev 2, If 0, Class=stor., Driver=usb-storage, 480M
    |__ Port 5: Dev 10, If 0, Class=hub, Driver=hub/4p, 480M
        |__ Port 1: Dev 11, If 0, Class=vend., Driver=rt2800usb, 480M
    |__ Port 6: Dev 12, If 0, Class=vend., Driver=rt2800usb, 480M
/:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
root@lnx-rg:~$ /home/rgenoud/bin/hub-ctrl -b 7 -d 1 -P 6 -p 0
Device not found.

but with an external hub: (not every usb hubs have individual port
power management)
root@lnx-rg:~$ lsusb -t
/:  Bus 08.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/6p, 480M
    |__ Port 3: Dev 2, If 0, Class=hub, Driver=hub/4p, 480M
        |__ Port 1: Dev 3, If 0, Class=HID, Driver=usbhid, 1.5M
        |__ Port 4: Dev 4, If 0, Class=vend., Driver=ftdi_sio, 12M
/:  Bus 07.Port 1: Dev 1, Class=root_hub, Driver=ehci-pci/6p, 480M
    |__ Port 4: Dev 2, If 0, Class=stor., Driver=usb-storage, 480M
    |__ Port 5: Dev 10, If 0, Class=hub, Driver=hub/4p, 480M
        |__ Port 1: Dev 11, If 0, Class=vend., Driver=rt2800usb, 480M
/:  Bus 06.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 05.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 04.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 03.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=uhci_hcd/2p, 12M
root@lnx-rg:~$ /home/rgenoud/bin/hub-ctrl -b 7 -d 10 -P 1 -p 0


>> [  642.476562] ieee80211 phy0: rt2800usb_watchdog: Warning - TX HW queue 1 timed out, invoke forced kick
>> [  642.585937] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x0408 with error -71
>> [  642.695312] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x06 failed for offset 0x0408 with error -71
>> [  642.796875] ieee80211 phy0: rt2800usb_tx_sta_fifo_read_completed: Warning - TX status read failed -71
>> [...]
>> So it seems the "forced kick" is not done
>
> "Forced kick" does not mean to remove device, it means restarting
> hardware queue. It is not done, because it requires write to PBF_CFG
> register (0x0408), which is not possible.
>
> I do not see an "infinite" loop. What I can see is continues failures
> when sending requests to to the hardware. I consider this as proper
> behaviour, taking that USB layer continuously return -EPROTO error. If
> for example there will be not possible to down interface or remove
> rt2800usb module in such condition, I would consider this as a minor
> bug, but I'm not sure if that happen or not.
>
> Stanislaw
Understood.
With a:
ip link set wlan0 down
just before shuting down the usb port, I haven't got any more complains.

With the other way around,
the error messages stops when the link is set down:
# strace -r ip link set wlan0 down
     0.000000 execve("/sbin/ip", ["ip", "link", "set", "wlan0",
"down"], [/* 18 vars */]) = 0
     0.010134 uname({sys="Linux", node="LNS", ...}) = 0
     0.010741 brk(0)                    = 0x152000
     0.019857 brk(0x152d20)             = 0x152d20
     0.004385 set_tls(0x1524c0, 0x14c07c, 0, 0x152d20, 0x14d200) = 0
     0.004250 readlink("/proc/self/exe", "/bin/busybox", 4096) = 12
     0.005069 brk(0x173d20)             = 0x173d20
     0.003573 brk(0x174000)             = 0x174000
     0.003200 getuid32()                = 0
     0.001635 socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
     0.002335 ioctl(3, SIOCGIFFLAGS, {ifr_name="wlan0",
ifr_flags=IFF_UP|IFF_BROADCAST|IFF_MULTICAST}) = 0
     0.004430 ioctl(3, SIOCSIFFLAGS, {ifr_name="wlan0",
ifr_flags=IFF_BROADCAST|IFF_MULTICAST}) = 0
     6.629790 close(3)                  = 0
     0.004894 exit_group(0)             = ?
     0.002010 +++ exited with 0 +++

So I agree with you, it seems like a normal behaviour.

you can add my
Tested-by: Richard Genoud <richard.genoud@gmail.com>

Tanks!
Richard.
