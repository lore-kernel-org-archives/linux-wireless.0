Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36211 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2AQETQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 23:19:16 -0500
Received: by ghbg16 with SMTP id g16so2131998ghb.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 20:19:15 -0800 (PST)
Message-ID: <4F14F6C1.2070709@lwfinger.net> (sfid-20120117_051925_257080_B1775CA7)
Date: Mon, 16 Jan 2012 22:19:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gerhard J Norkus <gnorkus@comcast.net>
CC: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>,
	'georgia' <georgia@realtek.com>
Subject: Re: RTL8192CU problems with EAPOL
References: <loom.20120117T033430-62@post.gmane.org>
In-Reply-To: <loom.20120117T033430-62@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/16/2012 08:54 PM, Gerhard J Norkus wrote:
> I'm using a BeagleBoard-xM with Ubuntu 11.10 on it.  The problem is with a
> NetGear WNA1000M using the RTL8192CU firwmare.  I'm quite new to Linux, so
> treat me gently please!  I'd really like Larry Finger to reply if possible,
> since he seems to have done the most work on this.
>
> What happens is I cannot connect to my wireless access point that has been
> setup using the following hostapd.conf:
>
> interface=wlan1
> driver=nl80211
> ssid=EnvisicAccessPoint
> hw_mode=g
> channel=1
> auth_algs=3
> wpa=3
> wpa_passphrase=GoofyPhrase
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP CCMP
> rsn_pairwise=CCMP
> macaddr_acl=0
> ignore_broadcast_ssid=0
> ctrl_interface=/var/run/hostapd
> ctrl_interface_group=0
> eapol_key_index_workaround=0
>
> I already have isc-dhcp-server running in the background pointing to wlan1.  I
> launch hostapd using the following command:
>
> hostapd -dd /etc/hostapd/hostapd.conf
>
> I get a bunch of output to the console, and when I try to connect using my
> Windows 7 machine, it seems like it's trying to negotiate a connection, however
> it does not succeed and repeatedly gives me the following in the output log:
>
> WPA:  00:1a:73:bb:f8:11 WPA_PTK entering state PTKSTART
> wlan1:  STA 00:1a:73:bb:f8:11 WPA: sending 1/4 msg of 4-Way handshake
> WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8...
> wlan1: STA 00:1a:73:bb:f8:11 WPA:  EAPOL-Key timeout
>
> Eventually it unauthorizes the port and deauthenticates it.  I'm not sure how
> to proceed so as to get a proper connection.  My BeagleBoard has the drivers
> stored at /lib/modules/3.1.6-x6/kernel/drivers/net/wireless/rtlwifi/rtl8192cu
> and the firmware stored at /lib/firmware/rtlwifi.
>
> A dump of lsmod yields the following:
> Module               Size  Used by
> arc4                 1195  2
> rtl8192cu           89347  0
> rtl8192cu_common    62334  1 rtl8192cu
> rtlwifi             71274  1 rtl8192cu
> mac80211           259211  3 rtl8192cu,rtl8192c_common,rtlwifi
> cfg80211           164606  2 rtlwifi,mac80211
> rfkill              17026  1 cfg80211
> smsc95xx            10950  0
> usbhid              34524  0
> gpio_keys            6801  0
> rtc_ds1307           6350  0
> rtc_twl              4402  0
>
> Can you point me in the right direction?  I've burned many hours on this and
> would like to use this dongle for a 3D scanner we're building...

I was the person that took the Realtek vendor driver, and reworked it to meet 
Linux standards for kernel code; however, I have never seen any documentation on 
the hardware, thus my ability to fix things are limited.

I know that rtl8192cu does not work in AP mode, and I have spent some time 
trying to find out why, but I have had limited success. The driver transmits 
beacons, and starts the association process, but it never really transmits data 
packets. I'm certain that it is only a minor point, but so far there is no solution.

It is possible that the drivers on the Realtek site might work in AP mode, but I 
have no experience with that. I would certainly recommend that you try them to 
get your product working. As I recall, there are two varieties - one that has 
its own MAC layer, and the one that uses mac80211, which is the one that I 
converted. To use hostapd, you will need the latter.

I added my contacts at Realtek to the Cc.

Larry
