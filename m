Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:44925 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaJBPEb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 11:04:31 -0400
Received: by mail-wg0-f46.google.com with SMTP id l18so584562wgh.29
        for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2014 08:04:29 -0700 (PDT)
Message-ID: <542D697B.40502@gmail.com> (sfid-20141002_170434_952229_84431FE8)
Date: Thu, 02 Oct 2014 17:04:27 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Joshua Roys <Joshua.Roys@gtri.gatech.edu>,
	Dan Williams <dcbw@redhat.com>,
	Network Manager <networkmanager-list@gnome.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	lizhaoming <chaoming_li@realsil.com.cn>,
	Realtek WlanFAE <wlanfae@realtek.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8188SU(rtl8192su) - unavailable
References: <54292675.4090607@gmail.com>	<1412019981.5379.2.camel@dcbw.local>	<542CCA4B.7030201@gmail.com> <CAAd0S9ARKg4RSQ_CYrEu8ggm3mWqL8a3ODgJDMnaKbHXpMZPCA@mail.gmail.com>
In-Reply-To: <CAAd0S9ARKg4RSQ_CYrEu8ggm3mWqL8a3ODgJDMnaKbHXpMZPCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02.10.2014 12:44, Christian Lamparter wrote:
> Am 02.10.2014 05:45 schrieb "poma" <pomidorabelisima@gmail.com>:
>>
>> On 29.09.2014 21:46, Dan Williams wrote:
>>> On Mon, 2014-09-29 at 11:29 +0200, poma wrote:
>>>> [platform/nm-platform.c:806] nm_platform_link_set_up(): link: setting
> up 'wlp0s4f1u1' (4)
>>>> [platform/nm-linux-platform.c:2356] link_change_flags(): link: change
> 4: flags set 'up' (1)
>>>> [platform/nm-linux-platform.c:2250] link_change(): Netlink error
> changing link 4:  <UP> mtu 0 (1) driver 'rtl8192su' udi
> '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1.0/net/wlp0s4f1u1': No
> such device
>>>> (wlp0s4f1u1): preparing device
>>>
>>> This is likely the core problem, and it's also probably the cause of the
>>> wpa_supplicant failures too.  You can test this out without NM running
>>> by simply doing:
>>>
>>> ifconfig wlp0s4f1u1 up
>>>
>>> and see if it returns an error or not.  Does it?  Does anything show up
>>> in 'dmesg'?  If we can't get 'ifconfig up' working for the device,
>>> clearly NM won't work either...
>>>
>>> Dan
>>>
>>
>> It's OK Dan, NM ain't problem.
>>
>> WIP encore party
>>
> This driver doesn't work with the rtl8712 Firmware. You have to use the
> real rtl8192sufw.
> 
> Regards,
> chr
> 

# file /usr/lib/firmware/rtlwifi/rtl8192sufw.bin
/usr/lib/firmware/rtlwifi/rtl8192sufw.bin: symbolic link to `rtl8192sufw-windows.bin'

# modprobe -v rtl8192su debug=5
insmod /lib/modules/3.17.0-0.rc7.git1.1.fc22.x86_64/kernel/net/mac80211/mac80211.ko.xz 
insmod /lib/modules/3.17.0-0.rc7.git1.1.fc22.x86_64/updates/rtlwifi.ko 
insmod /lib/modules/3.17.0-0.rc7.git1.1.fc22.x86_64/updates/rtl_usb.ko 
insmod /lib/modules/3.17.0-0.rc7.git1.1.fc22.x86_64/updates/rtl8192s-common.ko 
insmod /lib/modules/3.17.0-0.rc7.git1.1.fc22.x86_64/updates/rtl8192su.ko debug=5

# dmesg
..
[  186.147953] rtlwifi: module verification failed: signature and/or  required key missing - tainting kernel
[  186.152677] rtl8192s_common: Chip version 0x3
[  186.154167] rtl_usb: rx_max_size 9100, rx_urb_num 8, in_ep 3
[  186.154191] rtl8192su: Power Save off (module option)
[  186.154193] rtl8192su: FW Power Save off (module option)
[  186.154255] rtl8192su: Driver for Realtek RTL8192SU/RTL8191SU
Loading firmware rtlwifi/rtl8192sufw.bin
[  186.154340] usbcore: registered new interface driver rtl8192su
[  186.193423] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  186.207885] rtl8192su 1-4:1.0 wlp0s2f1u4: renamed from wlan0
[  186.218983] systemd-udevd[3674]: renamed network interface wlan0 to wlp0s2f1u4
[  187.615108] cfg80211: Calling CRDA for country: SI
[  187.620745] cfg80211: Regulatory domain changed to country: SI
[  187.620755] cfg80211:  DFS Master region: ETSI
[  187.620760] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[  187.620768] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[  187.620775] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[  187.620781] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz), (N/A, 2000 mBm), (0 s)
[  187.620786] cfg80211:   (5490000 KHz - 5710000 KHz @ 80000 KHz), (N/A, 2700 mBm), (0 s)
[  187.620791] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm), (N/A)

# iwconfig wlp0s2f1u4 
wlp0s2f1u4  IEEE 802.11bgn  ESSID:off/any  
          Mode:Managed  Access Point: Not-Associated   Tx-Power=0 dBm   
          Retry short limit:7   RTS thr=2347 B   Fragment thr:off
          Encryption key:off
          Power Management:on

# iw wlp0s2f1u4 info
Interface wlp0s2f1u4
	ifindex 5
	wdev 0x1
	addr 00:e0:4c:81:92:9b
	type managed
	wiphy 0

# ethtool wlp0s2f1u4
Settings for wlp0s2f1u4:
	Link detected: no

# ethtool -i wlp0s2f1u4
driver: rtl8192su
version: 3.17.0-0.rc7.git1.1.fc22.x86_64
firmware-version: N/A
bus-info: 1-4:1.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no

# ifconfig -v wlp0s2f1u4 up
SIOCSIFFLAGS: No such device
WARNING: at least one error occured. (-1)

# nmcli device 
DEVICE      TYPE      STATE        CONNECTION 
wlp0s2f1u4  wifi      unavailable  --         


poma


