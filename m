Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12444 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3GGHvR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jul 2013 03:51:17 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Chang Liu <liuchang.ee@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<erez.kirshenbaum@wilocity.com>, <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: User-level question: on wil6210
Date: Sun, 7 Jul 2013 10:51:13 +0300
Message-ID: <10406584.EhSc0OYPT7@lx-vladimir> (sfid-20130707_095134_951854_77C1F2B8)
In-Reply-To: <CAGvsL42j1S-EFjQRn4hM3zf5s=MKJf9MVTNqOpyqJEp1DAMQ-Q@mail.gmail.com>
References: <CAGvsL42OLgD2hYKAd_uwLr+Np_SYu6yuasEK=BdU0YbZphB-jQ@mail.gmail.com> <5387010.IR5Cfn11iz@lx-vladimir> <CAGvsL42j1S-EFjQRn4hM3zf5s=MKJf9MVTNqOpyqJEp1DAMQ-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Friday, July 05, 2013 12:38:39 PM Chang Liu wrote:
> 
> Dear Vladimir, and also John, Sujith and Vladimir,
> 
> Thanks, thanks you all for such a kind help! I was wondering you are too
> busy to deal with this, but you do help a lot! I wish you could help me
> through this when you get a little free time. Currently I am a student and
> I am doing a project related with 60GHz communication. Now I have got the
> DELL 5000 Wireless Dock (WIFIg)  and a Dell 6430u laptop, and I am trying
> to build up the 60GHz WIFI link (not the WIFI on 2.4G or 5G, and to make it
> clear, i will just call it 60G link) between the Dock and the laptop.
> 
> 
> This week I got all the devices and I find that, with the driver Dell
> offers, the link is successfully built in win7 platform. Dell offers a
> software to automatically detects the Dock and build the link. A snapshot
> of the link status is as follows:
> 
> 
> Status: SSID: D5000_C5907B; Channel: 2(60.48GHz); Security Mode: open;
> Firmware Version: 0.0.1.2989; BSSID: 04:ce:14:04:98:26
This is for WBE (not WiFi) link. It uses same infrastructure, but you can't
get WiFi connection.

> 
> According to this, the hardware is working well. I tried this after I sent
> you the mail last time, so I didn't have chance to mention it.
> 
> 
> When I turn to Linux environment, I got problems building up the same link.
> My idea is to install the driver wil6210 as stated in
> (http://wireless.kernel.org/en/users/Drivers/wil6210) and follow the
> instructions on the page to set up the link between the laptop and the
> Dock.
> 
> 
> 0. Here comes the first question.
> In the webpage it also says
> 
>  "Chip consists of the root bridge 1ae9:0101, with 4 ports 1ae9:0201. One
>  port routed to separate Atheros card 168c:0034, it is handled by the ath9k
>  driver. Another port connected to the wil6210 device 1ae9:0301, that is on
>  the same chip. 2 empty ports may be populated when connecting in WBE
>  (PCIE-over-60g) mode. "> 
> Does this mean that the wil6210 1ae9:0301 is actually for 60Gwifi while the
> atheros card 168c:0034 is for 2.4G/5G wifi?
Yes, exactly

> Since I can build the link in
> Windows platform, I believe I have the device wil6210 1ae9:0301 inside the
> laptop.
No. Device 1ae9:0301 may be hidden by firmware. Run "lspci -d 1ae9:0301"
to see whether device is present.

> Also you mentioned last time:
> 
> On this card, there is firmware that is stored in the on-card flash memory,
> and is not loaded by the driver. Unfortunately, firmware on your laptop
> (and all laptops like this) flashed with device 1ae9:0301 disabled. This
> firmware support only so called WBE, that is essentially PCIE over 60g, for
> wireless docking. Wireless docking stations that are used with WBE are NOT
> access points; as far as I know there is no 60g access points available at
> this moment. You can run AP on another Linux laptop with wil6210.
> 
> In order to support wifi, appropriate firmware need to be flashed on this
> card, and then you will see wi-fi device 1ae9:0301. To flash firmware, you
> need to contact Wilocity (adding Erez).
> 
> 
> 
> You emphasized that the Dock is NOT an access point. You mean it's not an AP
> for 2.4GWIFI or 5GWIFI connection, right?
No, I mean it is not AP for 60g connection. Again, WBE is _NOT_ WiFi, and WBE
dock is not 60g AP.

> If I just want to build the 60G
> link, or WBE(do you mean wireless bus extension?), I don't need to ask for
> a new firmware, is it what you mean? With the current device (I mean the
> Dock and the laptop), I can build the 60G link between the laptop and the
> Dock as long as I get the driver (wil6210) installed in the laptop while do
> nothing to the Dock itself, is it right?
With your current firmware, you can establish WBE link; on Windows only since
WBE is not supported on Linux yet. You can not establish WiFi link with your
firmware with neither Linux nor Windows.
> 
> 1. Have I installed the driver correctly?
I'd suggest to use latest kernel. At this moment, 3.10. I am not working on
back-porting, it is not tested. You are on your own if you want to use backport.

<skip>

> Does this mean that I have installed the driver wil6210 correctly?
Looks like it is compiled without errors. Without device present, I can't say
whether it works properly.

> (I didn't
> reload the module iwl4965, for I don't want WIFI, just 60G link).
> 
> 
> 2. About the network interface name and physical name <devname><phyname>.
> I assumed I installed the driver correctly. so I tried to build the link. My
> plan was to follow the webpage I mentioned above. First as I said in last
> letter, the identity (1ae9:0301) representing wil6210 is not shown with the
> command lspci -nn:
> 
> 
> root@george:/home/george# lspci -nn
<skip>
> [8086:1e22] (rev 04) 02:00.0 PCI bridge [0604]: Device [1ae9:0101] (rev 03)
> 03:00.0 PCI bridge [0604]: Device [1ae9:0200] (rev 03)
> 03:02.0 PCI bridge [0604]: Device [1ae9:0201] (rev 13)
> 03:03.0 PCI bridge [0604]: Device [1ae9:0201] (rev 13)
> 04:00.0 Network controller [0280]: Atheros Communications Inc. AR9462
> Wireless Network Adapter [168c:0034] (rev 01) 07:00.0 SD Host controller
> [0805]: O2 Micro, Inc. Device [1217:8221] (rev 05)
you have no 1ae9:301 device
> 
> 
> You mentioned the reason is because the firmware. We are contacting Wilocity
> now to get the firmware.
> 
> 
> What confuses me most now is the "network interface name". As shown on the
> page (http://wireless.kernel.org/en/users/Drivers/wil6210), I need to find
> the network interface name to execute the commands, which it represents
> with $WLAN. I cannot find where the interface comes from. I think it should
> be something like wlan*, when I tried ifconfig, it shows:
It comes from driver when it initializes its device. Without device, you will
not see network interface. Name will be like wlan0.

<skip>

> so there is no wlan*. Also these commands with iw shows nothing:
> 
> 
> root@george:/home/george# iw --version
> iw version 3.4
> root@george:/home/george# iw list
> root@george:/home/george# iw phy
> root@george:/home/george# iw dev
> 
> 
> So my biggest problem, what is the <phyname> , and what is the <devname>?
> Could you give me an example of the format? Where could I find it, or
> should set it myself? I searched google and they say wlan0 for 2.4G/5Gwifi
> will show up as long as the device and the driver are installed correctly.
> Is it the same situation for this case? If so, is the reason that I cannot
> see the interface the firmware you mentioned?
Yes, you have WBE-only firmware, so you have no device. No device - driver
don't bind to it - no network interface registered.

> Another little request is about the configuration instruction. Could you
> gave me some links on how to configure the driver wil6210? The only source
> I have now is the webpage I mentioned above and the help file for iw,
> wpa_supplicant. I lack experience, and I'm glad to learn more.
Read wiki for wpa_supplicant and iw

> 
> 
> Also, you mentioned I should download the latest iw and wpa_supplicant from
> Git, but I found a lot of folders I have no idea which could be a preferred
> choice. Could I beg you to give me a little more clue?
wpa_supplicant:
git clone git://w1.fi/srv/git/hostap.git
iw:
git clone http://git.sipsolutions.net/iw.git
> About the kernel, I
> would prefer to compile it and add it to the kernel because I may need to
> look inside the code later, so i keep the kernel version as 3.5 now.
Exactly for this reason, you better get kernel 3.10; then you have driver merged
into the kernel.

Thanks, Vladimir
