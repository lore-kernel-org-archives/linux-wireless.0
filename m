Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:39359 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932801Ab3CYUFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 16:05:37 -0400
Received: by mail-ob0-f172.google.com with SMTP id tb18so6393166obb.17
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 13:05:37 -0700 (PDT)
Message-ID: <5150AE0F.2040306@lwfinger.net> (sfid-20130325_210543_017536_74B56428)
Date: Mon, 25 Mar 2013 15:05:35 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Brillault <gentoo@lerya.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
References: <20130307192920.GB8668@Fea.lerya.net> <20130308215833.GA2829@Fea.lerya.net> <513A960B.2020304@lwfinger.net> <20130309113222.GA3009@Fea.lerya.net> <513B7E58.9000505@lwfinger.net> <20130311183825.GG3009@Fea.lerya.net> <20130313080048.GB3484@Fea.lerya.net> <20130317141201.GA2557@Fea.lerya.net> <20130325182910.GA10274@Fea.lerya.net> <5150A15F.20600@lwfinger.net> <20130325195104.GA11212@Fea.lerya.net>
In-Reply-To: <20130325195104.GA11212@Fea.lerya.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/25/2013 02:51 PM, Vincent Brillault wrote:
> Thanks for your quick response, comments inline.
>
> On Mon 25.Mar'13 at 14:11:27 -0500, Larry Finger wrote:
>> I think the difference in our two systems is in the use of NetworkManager and
>> the associated applet. With it, rtl_op_bss_info_changed() does not seem to be
>> called before sta is ready.
>>
>> Attached is a patch that will force mac->mode when sta has not been established.
>> Perhaps that will be enough.
> I does work. I don't have any warning when loading the module and
> establishing the connection. What will happen if the network is not
> really a WIRELESS_MODE_G but a WIRELESS_MODE_B ?

It should not matter, but I will make it B instead of G. Once the connection is 
established, then the handshaking with the AP will set sta and the mode to 
whatever the AP supports.

>> It not, I will need to set up your distro and run the wireless exactly the way
>> you do to duplicate your results. Please provide the distro name and version,
>> the architecture, the sequence of commands, and the contents of any special
>> scripts you run.
> If you want to duplicate my system, here are those information:
> Distribution: Gentoo Linux (profile hardened/linux/x86)
> Architecture: i686
> Current Kernel: manually installed wireless-testing 3.9.0-rc3+ with your
> patches
>
> I've attached my kernel .config, a emerge --info (contains
> information about my system configuration). It's a stable gentoo system,
> with the following unstables packages:
> '''
> =sys-kernel/linux-firmware-99999999 **
> =net-wireless/wpa_supplicant-2.0 ~x86
> =dev-libs/libnl-3.2.21 ~x86
> '''
>
> wpa_supplicant is using the following USE flags:
> '''
> net-wireless/wpa_supplicant -ssl fasteap wps ap wimax p2p eap-sim
> '''
>
> I did not modified the standard init scripts from Gentoo, my
> configuration of the interface (/etc/conf.d/net) is:
> '''
> config_wlan0="dhcp"
> wpa_supplicant_wlan0="-f /var/log/wpa_supplicant.log -W nl80211 -t"
> '''
>
> The uncommented part of my wpa_supplicant configuration file only
> contains the following:
> '''
> ctrl_interface=/var/run/wpa_supplicant
> eapol_version=1
> ap_scan=1
> fast_reauth=1
> country=FR
> network={
>    ssid="${myssid}"
>    scan_ssid=1
>    proto=WPA RSN
>    key_mgmt=WPA-PSK
>    pairwise=CCMP
>    group=TKIP
>    psk=${mypsk}
> }
> '''
>
> In order to have the errors I mention, I run the following:
> (inside a compat-drivers pull, just for unloading the module)
> '''
> /etc/init.d/net.wlan0 stop && make wlunload; dmesg -c > /dev/null;
> modprobe rtl8192ce; /etc/init.d/net.wlan0 start;
> '''
>
>
> I know this is not a standard distribution and that's why, if you have
> any idea of things I can do to help you, please tell me.

I will let you change that G to a B and test some more. If all goes well, then I 
will not need to set up that test bed, but at least I have the necessary details 
if ever required.

Larry


