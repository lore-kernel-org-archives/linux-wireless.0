Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33480 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbbBEHiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 02:38:22 -0500
Received: by mail-ob0-f171.google.com with SMTP id gq1so5732383obb.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2015 23:38:22 -0800 (PST)
Message-ID: <54D31DEC.9030002@lwfinger.net> (sfid-20150205_083825_895808_C7FAE912)
Date: Thu, 05 Feb 2015 01:38:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ken D'Ambrosio <ken@jots.org>
CC: linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@gmail.com>
Subject: Re: rtl8192ee (Thinkpad T440s)
References: <10a90ab7a6c186362f339481b531832f@webmail.jots.org> <54D00FA4.2060907@lwfinger.net> <8f26bf9461a88199ef8d8c86f7ee98f9@webmail.jots.org>
In-Reply-To: <8f26bf9461a88199ef8d8c86f7ee98f9@webmail.jots.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2015 12:56 AM, Ken D'Ambrosio wrote:
> Hi!  Want to thank you for the reply.  Gave it a shot; no dice.  See comments
> below.
>
> On 2015-02-02 19:00, Larry Finger wrote:
>> On 02/02/2015 05:24 PM, Ken D'Ambrosio wrote:
>>> Hi, all.  Just got a new Thinkpad, and needless to say, tried to fire it up on
>>> the network.  Ubuntu 14.04 didn't have the driver, so I tried 14.10, which did.
>>> I thought I was good until I tried to connect; the laptop would see all the
>>> advertised WAPs, but wouldn't connect to any of them (including my security-free
>>> ones).  I then downloaded the 3.19 RC and tried that -- same deal.  I see a few
>>> extra git commits in -next; any idea if that will be of any assistance?  Is
>>> there anything I can dig through in my logs to help flesh out what the
>>> problem is?
>>
>> Logs are always helpful. As some of us do not use Ubuntu, a kernel
>> version as shown by 'uname -r' is a lot more helpful that what version
>> of Ubuntu you are using.
>
> Sorry; I'll be more specific going forward.  Current kernel I'm using is
> 3.19.0-rc7-next-20150204.  The included driver did not work:
>
> ------------------------ cut here ----------------------------------------------
>
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Activation (wlan0)
> starting connection 'whateveryouwant'
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> (wlan0): device state
> change: disconnected -> prepare (reason 'none') [30 40 0]
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> NetworkManager state is
> now CONNECTING
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Activation (wlan0) Stage
> 1 of 5 (Device Prepare) scheduled...
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Activation (wlan0) Stage
> 1 of 5 (Device Prepare) started...
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Activation (wlan0) Stage
> 2 of 5 (Device Configure) scheduled...
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Activation (wlan0) Stage
> 1 of 5 (Device Prepare) complete.
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Activation (wlan0) Stage
> 2 of 5 (Device Configure) starting...
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> (wlan0): device state
> change: prepare -> config (reason 'none') [40 50 0]
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Activation
> (wlan0/wireless): connection 'whateveryouwant' requires no security.  No secrets
> needed.
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Config: added 'ssid'
> value 'whateveryouwant'
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Config: added 'scan_ssid'
> value '1'
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Config: added 'key_mgmt'
> value 'NONE'
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Activation (wlan0) Stage
> 2 of 5 (Device Configure) complete.
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> Config: set interface
> ap_scan to 1
> Feb  5 01:05:21 minasithil NetworkManager[864]: <info> (wlan0): supplicant
> interface state: disconnected -> scanning
> Feb  5 01:05:46 minasithil NetworkManager[864]: <warn> Activation
> (wlan0/wireless): association took too long, failing activation.
> Feb  5 01:05:46 minasithil NetworkManager[864]: <info> (wlan0): device state
> change: config -> failed (reason 'SSID not found') [50 120 53]
> Feb  5 01:05:46 minasithil NetworkManager[864]: <info> NetworkManager state is
> now DISCONNECTED
> Feb  5 01:05:46 minasithil NetworkManager[864]: <warn> Activation (wlan0) failed
> for connection 'whateveryouwant'
> Feb  5 01:05:46 minasithil NetworkManager[864]: <info> (wlan0): device state
> change: failed -> disconnected (reason 'none') [120 30 0]
> Feb  5 01:05:46 minasithil NetworkManager[864]: <info> (wlan0): deactivating
> device (reason 'none') [0]
> Feb  5 01:05:46 minasithil NetworkManager[864]: <info> (wlan0): supplicant
> interface state: scanning -> disconnected
> Feb  5 01:05:46 minasithil NetworkManager[864]: <warn> Couldn't disconnect
> supplicant interface: This interface is not connected.
>
> ------------------------ cut here ----------------------------------------------
>
>> Kernel 3.19-rc4 from the wireless-drivers repo contains all those
>> commits in -next, and it works fine here. At this point, I have been
>> connected for 27 hours with a WPA2 connection.
>>
>> You can also try the repo at
>> http://github.com/lwfinger/rtlwifi-new.git. The master branch should
>> be OK. If not, try the troy branch.
>
> I tried both branches; they both failed identically:
> Feb  5 01:51:19 minasithil kernel: [ 3141.801171] rtl8192ee 0000:03:00.0:
> Refused to change power state, currently in D3
> Feb  5 01:51:19 minasithil kernel: [ 3141.801349]
> rtl8192ee:_rtl92ee_read_adapter_info():<0-0> RTL819X Not boot from eeprom, check
> it !!
> Feb  5 01:51:19 minasithil kernel: [ 3141.801375] Using firmware
> rtlwifi/rtl8192eefw_new.bin
> Feb  5 01:51:19 minasithil kernel: [ 3141.803189] ieee80211 phy2: Selected rate
> control algorithm 'rtl_rc'
> Feb  5 01:51:19 minasithil kernel: [ 3141.803855] rtlwifi: wireless switch is on
> Feb  5 01:51:19 minasithil kernel: [ 3141.825219] rtl8192ee 0000:03:00.0 wlan8:
> renamed from wlan0
> Feb  5 01:51:19 minasithil kernel: [ 3141.899361]
> rtl8192ee:rtl92ee_hw_init():<0-0> Init MAC failed
> Feb  5 01:51:19 minasithil kernel: [ 3141.977804]
> rtl8192ee:rtl92ee_hw_init():<0-0> Init MAC failed
> [repeat ad nauseum until module is removed]
> Feb  5 01:51:26 minasithil kernel: [ 3148.373955] IPv6: ADDRCONF(NETDEV_UP):
> wlan8: link is not ready
>
> Thanks for any insights...

I heard from the Realtek engineer already, and he reminded me that we know of 
this problem. One pin of the PCI interface is not correctly powered, and that 
causes a boot from efuse to fail. The troy branch has code to work around this 
condition; however it was not turned on. If you pull again, this option is now 
enabled. See https://github.com/lwfinger/rtlwifi_new/issues/3 to read what has 
previously been posted.

Larry

