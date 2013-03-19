Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:35348 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab3CSSOb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 14:14:31 -0400
Received: by mail-oa0-f51.google.com with SMTP id h2so831720oag.24
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 11:14:31 -0700 (PDT)
Message-ID: <5148AB04.2070003@lwfinger.net> (sfid-20130319_191436_411664_3339CCEF)
Date: Tue, 19 Mar 2013 13:14:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: vishnu <vishnu.kopparapu@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: problem connecting to AP on new kernel (disassociating continuously
 after associating ) . Can some one please comment on the issue I am facing
References: <loom.20130315T140953-940@post.gmane.org> <5144A184.1060900@iki.fi> <loom.20130318T191350-236@post.gmane.org> <51475D23.70108@lwfinger.net> <loom.20130319T163402-330@post.gmane.org>
In-Reply-To: <loom.20130319T163402-330@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/2013 10:40 AM, vishnu wrote:
> Larry Finger <Larry.Finger@...> writes:
>
>>
>> On 03/18/2013 01:20 PM, vishnu wrote:
>>>
>>> Hello Jussi,
>>>
>>> I have applied the patch to kernel 3.7.8 and it doesn't fix my issue. I have
>>> started testing the latest 3.9.0-rc2 version. I will let you know once I
> have
>>> tested.
>>
>> Please be aware that the patch is not in 3.9-rc2 from Linus's git tree (yet),
>> but it is in the wireless-testing git repo.
>>
>> Larry
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@...
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
> Hello Larry,
>
> I have tried with 3.9-rc2 wireless-testing kernel and it is working fine . But
> it is taking around 10 to 15 minutes , until which it is continuously
> disassociating after association.  Is this behaviour expected? Please find the
> log if it is useful (Please discard the dates). This continuous for about 10 to
> 15 minutes and finally it doesn't disassociate with the AP.
>
>
> Feb 25 05:20:06 buildroot kern.info kernel: wlan0: RX AssocResp from
> 00:17:3f:15:8f:55 (capab=0x411 status=0 aid=3)^M
> wlan0: associated^M
> Feb 25 05:20:06 buildroot kern.info kernel: wlan0: associated^M
> wlan0: deauthenticating from 00:17:3f:15:8f:55 by local choice (reason=3)^M
> Feb 25 05:20:16 buildroot kern.info kernel: wlan0: deauthenticating from
> 00:17:3f:15:8f:55 by local choice (reason=3)^M
> cfg80211: Calling CRDA to update world regulatory domain^M
> Feb 25 05:20:16 buildroot kern.debug kernel: cfg80211: All devices are
> disconnected, going to restore regulatory settings^M
> Feb 25 05:20:16 buildroot kern.debug kernel: cfg80211: Restoring regulatory
> settings^M
> Feb 25 05:20:16 buildroot kern.debug kernel: cfg80211: Kicking the queue^M
> Feb 25 05:20:16 buildroot kern.info kernel: cfg80211: Calling CRDA to update
> world regulatory domain^M
> wlan0: authenticate with 00:17:3f:15:8f:55^M
> Feb 25 05:21:18 buildroot kern.info kernel: wlan0: authenticate with
> 00:17:3f:15:8f:55^M
> wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)^M
> Feb 25 05:21:18 buildroot kern.info kerwlan0: authenticated^M
> nel: wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)^M
> Feb 25 05:21:18 buildroot kern.info kernel: wlan0: authenticated^M
> rtl8192cu 1-1:1.0 wlan0: disabling HT/VHT due to WEP/TKIP use^M
> rtl8192cu 1-1:1.0 wlan0: disabling HT as WMM/QoS is not supported by the AP^M
> Feb 25 05:21:18 buildroot kern.info kernel: rtl8192cu 1-1:1.0 wlan0: disabling
> HT/VHT due to WEP/TKIP use^M
> rtl8192cu 1-1:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP^M
> Feb 25 05:21:18 buildroot kern.info kernel: rtl8192cu 1-1:1.0 wlan0: disabling
> HT as WMM/QoS is not supported by the AP^M
> wlan0: associate with 00:17:3f:15:8f:55 (try 1/3)^M
> Feb 25 05:21:18 buildroot kern.info kernel: wlan0: associate with
> 00:17:3f:15:8f:55 (try 1/3)^M
> wlan0: RX AssocResp from 00:17:3f:15:8f:55 (capab=0x411 status=0 aid=3)^M
> Feb 25 05:21:18 buildroot kern.info kernel: wlan0: RX AssocResp from
> 00:17:3f:15:8f:55 (capab=0x411 status=0 aidwlan0: associated^M
> =3)^M
> Feb 25 05:21:18 buildroot kern.info kernel: wlan0: associated^M
> wlan0: deauthenticating from 00:17:3f:15:8f:55 by local choice (reason=3)^M
> Feb 25 05:21:28 buildroot kern.info kernel: wlan0: deauthenticating from
> 00:17:3f:15:8f:55 by local choice (reason=3)^M
> cfg80211: Calling CRDA to update world regulatory domain^M
> Feb 25 05:21:28 buildroot kern.debug kernel: cfg80211: All devices are
> disconnected, going to restore regulatory settings^M
> Feb 25 05:21:28 buildroot kern.debug kernel: cfg80211: Restoring regulatory
> settings^M
> Feb 25 05:21:28 buildroot kern.debug kernel: cfg80211: Kicking the queue^M
> Feb 25 05:21:28 buildroot kern.info kernel: cfg80211: Calling CRDA to update
> world regulatory domain^M
> wlan0: authenticate with 00:17:3f:15:8f:55^M
> Feb 25 05:22:30 buildroot kern.info kernel: wlan0: authenticate with
> 00:17:3f:15:8f:55^M
> wlan0: send auth to 00:17:3f:15:8f:55 (try 1/3)^M
> Feb 25 05:22:30 buildroot kern.info kernel: wlan0: send auth to
> 00:17:3f:15:8f:55 (trwlan0: authenticated^M
> y 1/3)^M
> Feb 25 05:22:30 buildroot kern.info kernel:rtl8192cu 1-1:1.0 wlan0: disabling
> HT/VHT due to WEP/TKIP use^M
>   wlan0: authenticated^M
> Feb 25 05:22:31 buildroot kern.info kernel: rtl8192cu 1-1:1.0 wlan0: disabling
> HT/VHT due to WEP/TKIP use^M
> rtl8192cu 1-1:1.0 wlan0: disabling HT as WMM/QoS is not supported by the AP^M
> Feb 25 05:22:31 buildroot kern.info kernel: rtl8192cu 1-1:1.0 wlan0rtl8192cu 1-
> 1:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP^M
> : disabling HT as WMM/QoS is not supported by the AP^M
> Feb 25 05wlan0: associate with 00:17:3f:15:8f:55 (try 1/3)^M
> :22:31 buildroot kern.info kernwlan0: RX AssocResp from 00:17:3f:15:8f:55
> (capab=0x411 status=0 aid=3)^M
> el: rtl8192cu 1-1:1.0 wlan0: disabling VHT as WMM/QoS is not supported by the
> AP^M
> Feb 25 05:22:31 buildroot kern.info kernel: wlan0: associate with 00:1wlan0:
> associated^M

That does not match my system. From the time I plug in my rtl8192cu device which 
is shown by lsusb to be "Bus 001 Device 003: ID 7392:7811 Edimax Technology Co., 
Ltd EW-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]", the dmesg output 
is as follows:

[47975.929602] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
[47975.930889] usbcore: registered new interface driver rtl8192cu
[47975.977981] cfg80211: Ignoring regulatory request Set by core since the 
driver uses its own custom regulatory domain
[47975.979893] ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
[47975.986236] rtlwifi: wireless switch is on
[47976.821468] rtl8192cu: MAC auto ON okay!
[47976.899584] rtl8192cu: Tx queue select: 0x05
[47977.359377] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[47991.649505] wlan1: authenticate with 20:e5:2a:01:f7:ea
[47991.678097] wlan1: send auth to 20:e5:2a:01:f7:ea (try 1/3)
[47991.698862] wlan1: authenticated
[47991.700496] wlan1: associate with 20:e5:2a:01:f7:ea (try 1/3)
[47991.722112] wlan1: RX AssocResp from 20:e5:2a:01:f7:ea (capab=0x411 status=0 
aid=2)
[47991.724125] wlan1: associated
[47991.724270] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[47991.732272] wlan1: dropped frame to 20:e5:2a:01:f7:ea (unauthorized port)

As I write this, the system is at 48246.72, and no drops. My AP is a Netgear 
WNDR3400 running 802.11n with WPA2. What are the details for your AP?

Larry


