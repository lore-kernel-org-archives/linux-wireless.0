Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:51075 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758807AbZLJAeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 19:34:09 -0500
Message-ID: <4B204204.6000300@erley.org>
Date: Wed, 09 Dec 2009 19:34:12 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Natale Vinto <ebballon@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: SIOCSIFFLAGS: Name not unique on network with b43
References: <c6e9632c0912091546gad933ffhe8b70ee889745cb1@mail.gmail.com>
In-Reply-To: <c6e9632c0912091546gad933ffhe8b70ee889745cb1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Natale Vinto wrote:
> Hi all,
> I'm on Kubuntu 2.6.32-rc8-wl and according to lspci I have this Broadcom card:
> Broadcom Corporation BCM4312 802.11a/b/g (rev 02)
> and modinfo b43:
> 
> filename:
> /lib/modules/2.6.32-rc8-wl/kernel/drivers/net/wireless/b43/b43.ko
> firmware:       FW13
> license:        GPL
> author:         Gábor Stefanik
> author:         Michael Buesch
> author:         Stefano Brivio
> author:         Martin Langer
> description:    Broadcom B43 wireless driver
> srcversion:     77E3E0ECBCB6EA787FE05CF
> alias:          ssb:v4243id0812rev10*
> alias:          ssb:v4243id0812rev0F*
> alias:          ssb:v4243id0812rev0D*
> alias:          ssb:v4243id0812rev0B*
> alias:          ssb:v4243id0812rev0A*
> alias:          ssb:v4243id0812rev09*
> alias:          ssb:v4243id0812rev07*
> alias:          ssb:v4243id0812rev06*
> alias:          ssb:v4243id0812rev05*
> depends:        ssb,mac80211,led-class,cfg80211
> vermagic:       2.6.32-rc8-wl mod_unload modversions PENTIUMM 4KSTACKS
> parm:           bad_frames_preempt:enable(1) / disable(0) Bad Frames
> Preemption (int)
> parm:           fwpostfix:Postfix for the .fw files to load. (string)
> parm:           hwpctl:Enable hardware-side power control (default off) (int)
> parm:           nohwcrypt:Disable hardware encryption. (int)
> parm:           hwtkip:Enable hardware tkip. (int)
> parm:           qos:Enable QOS support (default on) (int)
> parm:           btcoex:Enable Bluetooth coexistence (default on) (int)
> parm:           verbose:Log message verbosity: 0=error, 1=warn,
> 2=info(default), 3=debug (int)
> 
> My problem is that I would use multiple interfaces (as mentioned here
> http://wireless.kernel.org/en/users/Drivers/b43#features ) using one
> for AP and one for station but I always get this error while trying to
> up the other interface:
> SIOCSIFFLAGS: Name not unique on network
> 
> This is the command list that I've done:
> 
> service network-manager stop
> iw phy phy0 interface add wlan1 type station (or managed)
> ifconfig wlan1 up
> 
> then I used wpa_supplicant on wlan1 and all ok. But when I try to up
> wlan0 that from iwconfig shows this:
> wlan0     Link encap:Ethernet  HWaddr 00:1a:73:xx:xx:xx
>           BROADCAST MULTICAST  MTU:1500  Metric:1
>           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
>           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
>           collisions:0 txqueuelen:1000
>           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
> 
> or when I try to use hostapd:
> Configuration file: /etc/hostapd/hostapd.conf
> ctrl_interface_group=0
> ioctl[SIOCSIFFLAGS]: Name not unique on network
> nl80211 driver initialization failed.
> wlan0: Unable to setup interface.
> rmdir[ctrl_interface]: No such file or directory
> ELOOP: remaining socket: sock=5 eloop_data=0x80f0a38 user_data=(nil)
> handler=0x80874
> 
> so how to have multiple interfaces (in my case one AP and one station) with b43?
> I haven't found a solution googling
> 
> Best Regards
> 
> 
> 
You need to change the mac address of one of the wireless interfaces.  I don't know if multiple vifs works with b43, though, only tested with ath9k.

Pat
