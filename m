Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2FGKBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 06:01:36 -0400
Received: by pbbrp8 with SMTP id rp8so851118pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 03:01:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20120607T100950-564@post.gmane.org>
References: <loom.20120607T100950-564@post.gmane.org>
Date: Thu, 7 Jun 2012 15:31:35 +0530
Message-ID: <CAJwzM1mTyOv6cUjTQ00-Q-5aW872kwyBPgnH9Pnk82fLZ+-J2w@mail.gmail.com> (sfid-20120607_120140_117771_AA5E3889)
Subject: Re: mwifiex:Testing AP functionality with hostapd
From: Avinash Patil <avinashapatil@gmail.com>
To: =?ISO-8859-1?Q?Hans_Kr=F6ner?= <hanskroner@gmail.com>
Cc: linux-wireless@vger.kernel.org, Avinash Patil <patila@marvell.com>,
	bzhao@marvell.com, frankh@marvell.com, yogeshp@marvell.com,
	Kiran Divekar <dkiran@marvell.com>, akarwar@marvell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Hans,

Can you please let me know:
i. mwifiex FW version: you can get this value while loading driver in dmesg.
ii. hostapd version
iii. Also can you please put extended logs by -ddd command line parameter.

mwifiex AP mode is supported for hostapd develv2 only.


Regards,
Avinash

On Thu, Jun 7, 2012 at 1:48 PM, Hans Kröner <hanskroner@gmail.com> wrote:
> I wanted to test the new "AP mode" functionality in the mwifiex driver so I
> built a kernel off the wireless-testing tree and hostapd v2.0-devel from git.
> I tried this on a "DreamPlug" that uses the SD8787.
>
> "Client mode" is working fine, but I can't seem to be able to get "AP mode"
> working. No matter what I do I get this output from hostapd:
>
> random: Trying to read entropy from /dev/random
> Configuration file: hostapd-minimal.conf
> nl80211: interface uap0 in phy phy0
> rfkill: initial event: idx=0 type=2 op=0 soft=0 hard=0
> rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
> nl80211: Disable use_monitor with device_ap_sme since no monitor mode support d
> etected
> nl80211: Add own interface ifindex 5
> nl80211: Set mode ifindex 5 iftype 3 (AP)
> nl80211: Setup AP - device_ap_sme=1 use_monitor=0
> nl80211: Subscribe to mgmt frames with AP handle 0x74608 (device SME)
> nl80211: Register frame type=0xd0 nl_handle=0x74608
> nl80211: Register frame match - hexdump(len=0): [NULL]
> nl80211: Register frame command failed (type=208): ret=-95 (Operation not suppo
> rted)
> nl80211: Register frame match - hexdump(len=0): [NULL]
> nl80211: Failed to set interface uap0 into AP mode
> netlink: Operstate: linkmode=0, operstate=6
> nl80211: Set mode ifindex 5 iftype 2 (STATION)
> nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
> nl80211: Try mode change after setting interface down
> nl80211: Set mode ifindex 5 iftype 2 (STATION)
> nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
> nl80211: Set mode ifindex 5 iftype 2 (STATION)
> nl80211: Failed to set interface 5 to mode 2: -16 (Device or resource busy)
> [ ... ]
> nl80211: Interface mode change to 2 from 3 failed
> nl80211 driver initialization failed.
>
> I've tried bringing both mlan0 and uap0 interfaces down/up and different
> combinations of both to no avail. The patches for "AP mode" support mention
> that is has been tested against hostapd v2.0-devel. Is there anything I should
> be aware of when building hostapd? I'm also not sure if I'm running the correct
> firmware for the SD8787.
>
> Thanks in advance for any input!!!
>
> Hans
>
>
> --- mwifiex_sdio firmware ---
>
> mwifiex_sdio mmc0:0001:1: WLAN FW already running! Skip FW dnld
> mwifiex_sdio mmc0:0001:1: WLAN FW is active
> mwifiex_sdio mmc0:0001:1: driver_version = mwifiex 1.0 (14.57.5.p69)
>
> --- hostapd .config ---
>
> CONFIG_DRIVER_HOSTAP=y
> CONFIG_DRIVER_NL80211=y
> CONFIG_LIBNL32=y
> CFLAGS += -I/usr/include/libnl3
> CONFIG_IAPP=y
> CONFIG_RSN_PREAUTH=y
> CONFIG_PEERKEY=y
> CONFIG_EAP=y
> CONFIG_EAP_MD5=y
> CONFIG_EAP_TLS=y
> CONFIG_EAP_MSCHAPV2=y
> CONFIG_EAP_PEAP=y
> CONFIG_EAP_GTC=y
> CONFIG_EAP_TTLS=y
> CONFIG_PKCS12=y
> CONFIG_IPV6=y
> CONFIG_IEEE80211N=y
>
> --- hostatp-minimal.conf ---
>
> interface=uap0
> driver=nl80211
> ssid=DreamPlug
> hw_mode=g
> channel=1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
