Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:30356 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbYLOV3t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 16:29:49 -0500
Received: by rn-out-0910.google.com with SMTP id k40so2326974rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 13:29:47 -0800 (PST)
Message-ID: <b76df900812151329x4309b264u7a017e4b4c2d8451@mail.gmail.com> (sfid-20081215_222954_697047_4913C95A)
Date: Mon, 15 Dec 2008 13:29:47 -0800
From: "Jason Self" <jason.self@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Realtek wireless 8187se
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 4, 2008 at 4:52 PM, Stefanik G=E1bor <netroller.3d@gmail.co=
m> wrote:

> Can you check the actual print on the chip itself? "RTL8187L" and "RT=
L8187B" are supported currently. Also, what is the USB device ID of the=
 chip? 0x8187, 0x8189, 0x8197 and 0x8198 are known to work in the lates=
t preview kernels.

The RTL8187SE is a Mini PCIe version of the Realtek 8187 wireless
chipset. I just purchased my MSI Wind a few days ago and I'd rather
not void the warranty by taking it apart just yet. Here is an image
from someone that was:
http://images.bit-tech.net/content_images/2008/07/breaking-wind/10-8.jp=
g.
It looks to say RTL8102E.

Running lspci -nn returns:

00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GME Express
Memory Controller Hub [8086:27ac] (rev 03)
00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
945GME Express Integrated Graphics Controller [8086:27ae] (rev 03)
00:02.1 Display controller [0380]: Intel Corporation Mobile
945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller
[8086:27a6] (rev 03)
00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family)
High Definition Audio Controller [8086:27d8] (rev 02)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI
Express Port 1 [8086:27d0] (rev 02)
00:1c.1 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI
Express Port 2 [8086:27d2] (rev 02)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB UHCI Controller #1 [8086:27c8] (rev 02)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB UHCI Controller #2 [8086:27c9] (rev 02)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB UHCI Controller #3 [8086:27ca] (rev 02)
00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB UHCI Controller #4 [8086:27cb] (rev 02)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
USB2 EHCI Controller [8086:27cc] (rev 02)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge
[8086:2448] (rev e2)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC
Interface Bridge [8086:27b9] (rev 02)
00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7
=46amily) SATA IDE Controller [8086:27c4] (rev 02)
00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus
Controller [8086:27da] (rev 02)
01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL8101E PCI Express Fast Ethernet controller [10ec:8136] (rev 02)
02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
Device [10ec:8199] (rev 22)

More information about the RTL8187SE can be obtained from their website=
:
http://www.realtek.com.tw/products/productsView.aspx?Langid=3D1&PFid=3D=
40&Level=3D5&Conn=3D4&ProdID=3D172

Some people have reported getting it to work with ndiswrapper. I have
not tried this as I do not want to load propreitary software on my
machine.

Until the last few months it had no Linux driver. A user on the
msiwind.net forums emailed Realtek about this, and they received a
driver that was not listed on their site. The driver didn't compile
for the 2.6.24 kernel included in ubuntu hardy, but with some
modifications it compiles and is reported to work, although some
report problems. Their current version is available here:
http://launchpadlibrarian.net/20052864/rtl8187se_linux_26.1023.1118.200=
8.tar.gz

Bug # 246141 on Ubuntu Launchpad has lots more information.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
