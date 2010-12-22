Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout023.mac.com ([17.148.16.98]:36074 "EHLO
	asmtpout023.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab0LVRa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 12:30:27 -0500
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp023.mac.com (Oracle Communications Messaging Exchange Server 7u4-20.01
 64bit (built Nov 21 2010)) with ESMTPSA id <0LDU00I37BAAJN50@asmtp023.mac.com>
 for linux-wireless@vger.kernel.org; Wed, 22 Dec 2010 09:30:15 -0800 (PST)
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4D122B8F.5090302@hauke-m.de>
Date: Wed, 22 Dec 2010 21:29:58 +0400
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Kahn, Gery" <geryk@ti.com>, Oz Krakowski <ozk@ti.com>,
	Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-id: <1813D0B1-5391-48DB-9882-A6586DAB180C@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com>
 <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com>
 <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
 <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
 <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
 <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
 <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
 <4D122B8F.5090302@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Dec 22, 2010, at 8:47 PM, Hauke Mehrtens wrote:

> On 12/22/2010 05:13 PM, Luis R. Rodriguez wrote:
>> On Wed, Dec 22, 2010 at 11:09 AM, Elvis Dowson <elvis.dowson@mac.com> wrote:
>>> netdev_alloc_skb_ip_align
>> 
>> I notice you have an android kernel, is that kernel a vanilla kernel
>> or did it get netdev_alloc_skb_ip_align() cherry picked into it?


Yes, it is an android enabled 2.6.32 kernel. It also includes the TI 
OMAP35xx/AM35xx platform support package SDK v03.00.01.06/


> netdev_alloc_skb_ip_align is not defined in the 2.6.32.27 vanilla
> kernel. Someone else (google or ti) must have backported it to this
> kernel and added it to your kernel.
> 
> I do not want to add some special handling into compat-wireless just for
> some android kernel. Just remove netdev_alloc_skb_ip_align() and
> NETDEV_POST_INIT from include/linux/compat-2.6.33.h and the compile
> problems you posted should be fixed.

I made the following modifications, but get another error:

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index c2dbc1b..468a074 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -52,19 +52,6 @@ static inline void compat_release_firmware(const struct firmware *fw)
 #define IFF_DONT_BRIDGE 0x800          /* disallow bridging this ether dev */
 /* source: include/linux/if.h */
 
-/* this will never happen on older kernels */
-#define NETDEV_POST_INIT 0xffff
-
-static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
-                unsigned int length)
-{
-       struct sk_buff *skb = netdev_alloc_skb(dev, length + NET_IP_ALIGN);
-
-       if (NET_IP_ALIGN && skb)
-               skb_reserve(skb, NET_IP_ALIGN);
-       return skb;
-}
-
 #if defined(CONFIG_PCCARD) || defined(CONFIG_PCCARD_MODULE)
 
 #if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)


CC [M]  /tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.o
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c: In function ‘ieee80211_led_init’:
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:59: error: invalid application of ‘sizeof’ to incomplete type ‘struct led_trigger’ 
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:63: error: dereferencing pointer to incomplete type
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:64: error: implicit declaration of function ‘led_trigger_register’
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:70: error: invalid application of ‘sizeof’ to incomplete type ‘struct led_trigger’ 
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:74: error: dereferencing pointer to incomplete type
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:81: error: invalid application of ‘sizeof’ to incomplete type ‘struct led_trigger’ 
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:85: error: dereferencing pointer to incomplete type
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:92: error: invalid application of ‘sizeof’ to incomplete type ‘struct led_trigger’ 
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:96: error: dereferencing pointer to incomplete type
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c: In function ‘ieee80211_led_exit’:
/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.c:107: error: implicit declaration of function ‘led_trigger_unregister’
make[3]: *** [/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211/led.o] Error 1
make[2]: *** [/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork/net/mac80211] Error 2
make[1]: *** [_module_/tool/patches/compat-wireless-2.6.37-rc6-3-patchwork] Error 2
make[1]: Leaving directory `/tool/patches/android-rowboat-2.6.32-kernel-patchwork'
make: *** [modules] Error 2


Elvis Dowson