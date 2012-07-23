Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:49056 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663Ab2GWVHk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 17:07:40 -0400
Received: by ghrr11 with SMTP id r11so5977134ghr.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 14:07:38 -0700 (PDT)
Message-ID: <500DBD17.7070706@lwfinger.net> (sfid-20120723_230747_935735_CEF79BD7)
Date: Mon, 23 Jul 2012 16:07:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com>
In-Reply-To: <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/23/2012 03:31 PM, Xavier de Almeida wrote:
> Hello,
>
> I am trying to setup a wireless hotspot with my xs36v barbone. Unfortunately when I start hostapd, I have got the following error:
>
> hostapd -dd /etc/hostapd/hostapd.conf
> Configuration file: /etc/hostapd/hostapd.conf
> nl80211: Add own interface ifindex 3
> nl80211: Add own interface ifindex 4
> nl80211: New interface mon.wlan0 created: ifindex=8
> nl80211: Add own interface ifindex 8
> Could not set interface mon.wlan0 flags: Operation not possible due to RF-kill
> nl80211: Remove interface ifindex=8
> nl80211: Failed to set interface wlan0 into AP mode
> nl80211 driver initialization failed.
> ELOOP: remaining socket: sock=4 eloop_data=0x842e900 user_data=0x842eeb0 handler=0x807c5e0
> ELOOP: remaining socket: sock=6 eloop_data=0x8430cb8 user_data=(nil) handler=0x8086770
>
> I tried with different drivers like mac80211.
>
> I did install the drivers from Realtek website (rtl_92ce_92se_92de_linux_mac80211_0005.1230.2011) and the latest linux-firmware_1.84_all.deb
>
> But I can't make it work for any reason. Any help would be welcome. Do I need to move to a newest kernel to make it work?
>
> Thanks
> XabiX
>
> lspci
> 02:00.5 Ethernet controller: JMicron Technology Corp. JMC250 PCI Express Gigabit Ethernet Controller (rev 03)
> 03:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter (rev 01)
>
> lsmod
> rtl8192ce              75491  0
> rtl8192c_common        69519  1 rtl8192ce
> rtlwifi                95804  1 rtl8192ce
> mac80211              436455  3 rtl8192ce,rtl8192c_common,rtlwifi
> cfg80211              178679  2 rtlwifi,mac80211
>
> modinfo rtl8192ce
> filename:       /lib/modules/3.2.0-26-generic/kernel/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko
> firmware:       rtlwifi/rtl8192cfw.bin
> description:    Realtek 8192C/8188C 802.11n PCI wireless
> license:        GPL
> author:         Larry Finger    <Larry.Finger@lwfinger.net>
> author:         Realtek WlanFAE <wlanfae@realtek.com>
> author:         lizhaoming      <chaoming_li@realsil.com.cn>
> srcversion:     18B9D7DE9AA317668E0197D
> alias:          pci:v000010ECd00008176sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008177sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008178sv*sd*bc*sc*i*
> alias:          pci:v000010ECd00008191sv*sd*bc*sc*i*
> depends:        rtlwifi,mac80211
> vermagic:       3.2.0-26-generic SMP mod_unload modversions 686
> parm:           swlps:bool
> parm:           swenc:using hardware crypto (default 0 [hardware])
> parm:           ips:using no link power save (default 1 is open)
> parm:           fwlps:using linked fw control power save (default 1 is open)

Your main problem is that your kernel is too old. A lot of changes have been 
made since 3.2.0. If you obtain the bleeding-edge compat-wireless package for 
your system, you are likely to have more success. That will get the wireless 
code that will not be released for about 3 months, rather than using what was 
available 1 year ago.

Larry



