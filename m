Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47856 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756782Ab2KVUal (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 15:30:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1TbX5U-0005tz-As
	for linux-wireless@vger.kernel.org; Thu, 22 Nov 2012 14:45:04 +0100
Received: from ice.139.client237.youtele.com ([ice.139.client237.youtele.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 14:45:04 +0100
Received: from charvi.mehta by ice.139.client237.youtele.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 14:45:04 +0100
To: linux-wireless@vger.kernel.org
From: Charvi <charvi.mehta@einfochips.com>
Subject: hostapd with nl80211 on Realtek 8192C chipset
Date: Thu, 22 Nov 2012 13:42:52 +0000 (UTC)
Message-ID: <loom.20121122T144121-526@post.gmane.org> (sfid-20121122_213053_059043_BF1878F3)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have Airlink 101 Ultra Mini USB stick which ahs the Realtek 8192 chipset. To
make it work I got the driver RTL8188C_8192C_8192D_USB_linux_v3.4.2_3727.2012040
4. I was able to successfully use the USB stick in STA (Infrastructure) mode. We
were also successfully turn it into an access point with hostapd. But while
using with hostapd we had to use the driver rtl871xdrv, see the scaled down
(minimal) config file below:

##################
            hostapd.conf
##################
interface=wlan0
ctrl_interface=/var/run/hostapd
ssid=rtwap
channel=6
driver=rtl871xdrv

NOTE: This works.
But now I want to use the nl80211 driver in the hostapd for some reasons.
But when I compile the hostapd with the nl80211 and use it the hostapd doesn't
start. The driver initialization fails. Putting prints inside the code and libnl
debug prints show that on "nl_recvmsgs()" I get ENODEV error. What is this
supposed to mean ??

Also further digging shows the nl80211 can be used only with the devices which
use softmac and the mac80211 APIs in driver. I dont know whether the driver of
rtl8192c is based on the mac80211 framework or not ?!!
Can anybody help me confirm this ????!!!!

When I see whether the 8192c.ko module depends on the mac80211 or not I get the
following result:



for m in $(lsmod|grep "^rt\|^mac\|^cfg"|awk '{print $1}');do echo -n "$m
:";modinfo "$m"|grep depends;done
mac80211 :depends:        cfg80211
cfg80211 :depends:



Some may be useful results:

lsmod
Module Size Used by
8192cu 493872 0
mac80211 205402 0
cfg80211 126144 1 mac80211
binfmt_misc 6587 1
snd_hda_codec_realtek 203440 1
fbcon 35102 71
...

Please help.

