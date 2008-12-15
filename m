Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:52749 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbYLOVza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 16:55:30 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1356373wah.21
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 13:55:29 -0800 (PST)
Message-ID: <69e28c910812151355l6549e8c2mea381a12663c7cb5@mail.gmail.com> (sfid-20081215_225533_991689_D52807F0)
Date: Mon, 15 Dec 2008 22:55:29 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Jason Self" <jason.self@gmail.com>
Subject: Re: Realtek wireless 8187se
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <b76df900812151329x4309b264u7a017e4b4c2d8451@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <b76df900812151329x4309b264u7a017e4b4c2d8451@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 15, 2008 at 10:29 PM, Jason Self <jason.self@gmail.com> wro=
te:
> On Tue, Nov 4, 2008 at 4:52 PM, Stefanik G=E1bor <netroller.3d@gmail.=
com> wrote:
>
>> Can you check the actual print on the chip itself? "RTL8187L" and "R=
TL8187B" are supported currently. Also, what is the USB device ID of th=
e chip? 0x8187, 0x8189, 0x8197 and 0x8198 are known to work in the late=
st preview kernels.
>
> The RTL8187SE is a Mini PCIe version of the Realtek 8187 wireless
> chipset. I just purchased my MSI Wind a few days ago and I'd rather
> not void the warranty by taking it apart just yet. Here is an image
> from someone that was:
> http://images.bit-tech.net/content_images/2008/07/breaking-wind/10-8.=
jpg.
> It looks to say RTL8102E.

The RTL8102E is the wired Ethernet chip. (Lspci misidentifies it as RTL=
8101E.)

>
> Running lspci -nn returns:
>
> 00:00.0 Host bridge [0600]: Intel Corporation Mobile 945GME Express
> Memory Controller Hub [8086:27ac] (rev 03)
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile
> 945GME Express Integrated Graphics Controller [8086:27ae] (rev 03)
> 00:02.1 Display controller [0380]: Intel Corporation Mobile
> 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller
> [8086:27a6] (rev 03)
> 00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family)
> High Definition Audio Controller [8086:27d8] (rev 02)
> 00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI
> Express Port 1 [8086:27d0] (rev 02)
> 00:1c.1 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI
> Express Port 2 [8086:27d2] (rev 02)
> 00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
> USB UHCI Controller #1 [8086:27c8] (rev 02)
> 00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
> USB UHCI Controller #2 [8086:27c9] (rev 02)
> 00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
> USB UHCI Controller #3 [8086:27ca] (rev 02)
> 00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
> USB UHCI Controller #4 [8086:27cb] (rev 02)
> 00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family)
> USB2 EHCI Controller [8086:27cc] (rev 02)
> 00:1e.0 PCI bridge [0604]: Intel Corporation 82801 Mobile PCI Bridge
> [8086:2448] (rev e2)
> 00:1f.0 ISA bridge [0601]: Intel Corporation 82801GBM (ICH7-M) LPC
> Interface Bridge [8086:27b9] (rev 02)
> 00:1f.2 IDE interface [0101]: Intel Corporation 82801GBM/GHM (ICH7
> Family) SATA IDE Controller [8086:27c4] (rev 02)
> 00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus
> Controller [8086:27da] (rev 02)
> 01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> RTL8101E PCI Express Fast Ethernet controller [10ec:8136] (rev 02)
> 02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
> Device [10ec:8199] (rev 22)
>
> More information about the RTL8187SE can be obtained from their websi=
te:
> http://www.realtek.com.tw/products/productsView.aspx?Langid=3D1&PFid=3D=
40&Level=3D5&Conn=3D4&ProdID=3D172
>
> Some people have reported getting it to work with ndiswrapper. I have
> not tried this as I do not want to load propreitary software on my
> machine.
>
> Until the last few months it had no Linux driver. A user on the
> msiwind.net forums emailed Realtek about this, and they received a
> driver that was not listed on their site. The driver didn't compile
> for the 2.6.24 kernel included in ubuntu hardy, but with some
> modifications it compiles and is reported to work, although some
> report problems. Their current version is available here:
> http://launchpadlibrarian.net/20052864/rtl8187se_linux_26.1023.1118.2=
008.tar.gz
>
> Bug # 246141 on Ubuntu Launchpad has lots more information.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Looks like this is a MiniPCIE card, so the chip is essentially an
RTL8187 or RTL8187B with the USB communication part replaced with a
PCI Express one. Given the existence of this open-source driver,
adding support for it into rtl818x should not really be a problem.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
