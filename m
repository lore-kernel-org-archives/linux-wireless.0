Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.225]:8226 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753077AbYCZWPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 18:15:15 -0400
Received: by wr-out-0506.google.com with SMTP id c48so3020559wra.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Mar 2008 15:15:13 -0700 (PDT)
Message-ID: <183c1cc10803261515t5589e656w3e3e248dd516cc6e@mail.gmail.com> (sfid-20080326_221521_951151_E403C130)
Date: Wed, 26 Mar 2008 18:15:12 -0400
From: "John Goulah" <jgoulah@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: problem with iwl4965 and kernel 2.6.24.4
In-Reply-To: <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <183c1cc10803261031p6e7e16bdme000416095de9b7f@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004073B0C@orsmsx416.amr.corp.intel.com>
	 <183c1cc10803261149r2f518772j2ea3a1b5df55b2cc@mail.gmail.com>
	 <D936D925018D154694D8A362EEB0892004073D90@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 26, 2008 at 5:04 PM, Chatre, Reinette
<reinette.chatre@intel.com> wrote:
> On Wednesday, March 26, 2008 11:49 AM, John Goulah  wrote:
>
>  >
>  > $ iwconfig
>  > lo        no wireless extensions.
>  >
>  > eth1      no wireless extensions.
>  >
>  > sit0      no wireless extensions.
>  >
>  > wmaster0  no wireless extensions.
>  >
>  > Warning: Driver for device wlan0 has been compiled with version 22
>  > of Wireless Extension, while this program supports up to version 20.
>  > Some things may be broken...
>  >
>  > wlan0     IEEE 802.11  ESSID:"goulahnet"
>  >          Mode:Managed  Frequency:2.412 GHz  Access Point:
>  >          Not-Associated Tx-Power=0 dBm
>  >          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
>  >          Link Quality:0  Signal level:0  Noise level:0
>  >          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>  >          Tx excessive retries:0  Invalid misc:0   Missed beacon:0
>  >
>  >
>  >
>  > Is this warning a problem?  Does this mean I need to get a newer
>  > iwconfig (I'm on debian etch, Wireless-Tools version 28)
>
>  I don't know if it is necessary. In the above iwconfig output it does
>  not look as though you are associated though.
>
>



For some reason this helped with the association problem:

 sudo iwconfig wlan0 ap any



>
>
>  >
>  > Also, is this driver known to work with wpa_supplicant?
>
>  yes
>
>


great, wpa_supplicant is also working fine now, I did get a few
warnings and I wasn't sure if this was ok to ignore, fixable, or would
need to go to their list with it:

sudo wpa_supplicant -i wlan0 -D wext -c /etc/wpa_supplicant/wpa_supplicant.conf
ioctl[SIOCSIWENCODEEXT]: No such file or directory
ioctl[SIOCSIWENCODEEXT]: No such file or directory
ioctl[SIOCSIWENCODEEXT]: No such file or directory
ioctl[SIOCSIWENCODEEXT]: No such file or directory
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - Trying to associate with
00:15:e9:fa:e2:db (SSID='goulahnet' freq=2462 MHz)
Associated with 00:15:e9:fa:e2:db
WPA: Key negotiation completed with 00:15:e9:fa:e2:db [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:15:e9:fa:e2:db completed
(auth) [id=0 id_str=]





In any case, my wirless card is now working!

Thanks so much,
John
