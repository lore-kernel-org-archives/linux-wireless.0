Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:57295 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3K2CrA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Nov 2013 21:47:00 -0500
Received: by mail-oa0-f41.google.com with SMTP id j17so9961275oag.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 Nov 2013 18:46:59 -0800 (PST)
Message-ID: <5298001F.2050508@lwfinger.net> (sfid-20131129_034704_574895_16B08E4F)
Date: Thu, 28 Nov 2013 20:46:55 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Nikita N." <nikitan@operamail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8187 bugs
References: <1385589961.19021.52907237.3EE33E5B@webmail.messagingengine.com> <52966D64.2030805@lwfinger.net> <1385593188.3627.52911717.4E0712D9@webmail.messagingengine.com> <529680A3.8070103@lwfinger.net> <1385660680.14556.53217809.32CDF136@webmail.messagingengine.com>
In-Reply-To: <1385660680.14556.53217809.32CDF136@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/28/2013 11:44 AM, Nikita N. wrote:
> answers follow
>
> On Wed, Nov 27, 2013, at 03:30 PM, Larry Finger wrote:
>
>>
>> On my system, my RTL8187B shows the following for kernel 13.1-rc1:
>>
>> [11213.196114] usb 1-5: new high-speed USB device number 5 using ehci-pci
>> [11214.663577] rtl8187: inconsistency between id with OEM info!
>> [11214.666105] cfg80211: Updating information on frequency 2412 MHz with
>> regulatory rule:
>> [11214.666114] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (300
>> mBi, 2700 mBm)
>> [11214.666118] cfg80211: Updating information on frequency 2417 MHz with
>> regulatory rule:
>>
>> --snip--
>>
>> ieee80211 phy2: Selected rate control algorithm 'minstrel_ht'
>> ieee80211 phy2: hwaddr 00:11:6b:3e:c4:0a, RTL8187BvB(early) V0 +
>> rtl8225z2,
>> rfkill mask 2
>> rtl8187: Customer ID is 0x00
>> rtl8187: wireless switch is on
>> usbcore: registered new interface driver rtl8187
>> systemd-udevd[5796]: renamed network interface wlan1 to wlp0s2f1u5
>>
>
> Thanks for your answer again Larry, I finding impossible to bring
> back monitor mode in my two, yes TWO different rtl8187 devices.
> They BOTH started malfunction in monitor mode the same day after
> installing 3.11, isnt it strange?
> I repeat, they always worked no problem before 3.11.
>>From your report you have a "RTL8187BvB(early) V0".
> I have a different interface, a "RTL8187vB (default) V1".
> So we are talking about different hardware, isnt it?
> Do you have a RTL8187vB for test too?

Mine is a B model. It is coded with an RTL8187L USB ID, but it needs the 
RTL8187B code. My two other devices are both RTL8187L.

> Here follows the lsusb output, if that can help to see the differences
> between your and mine interface:
> "
> Bus 002 Device 002: ID 0bda:8187 Realtek Semiconductor Corp. RTL8187
> Wireless Adapter
> Device Descriptor:
>    bLength                18
>    bDescriptorType         1
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    idVendor           0x0bda Realtek Semiconductor Corp.
>    idProduct          0x8187 RTL8187 Wireless Adapter
>    bcdDevice            1.00
>    iManufacturer           1 Realtek
>    iProduct                2 RTL8187 Wireless LAN Adapter
>    iSerial                 3 00e04c000001
>    bNumConfigurations      1
>    Configuration Descriptor:
>      bLength                 9
>      bDescriptorType         2
>      wTotalLength           39
>      bNumInterfaces          1
>      bConfigurationValue     1
>      iConfiguration          4 Wireless Network Card
>      bmAttributes         0x80
>        (Bus Powered)
>      MaxPower              500mA
>      Interface Descriptor:
>        bLength                 9
>        bDescriptorType         4
>        bInterfaceNumber        0
>        bAlternateSetting       0
>        bNumEndpoints           3
>        bInterfaceClass         0 (Defined at Interface level)
>        bInterfaceSubClass      0
>        bInterfaceProtocol      0
>        iInterface              5 Bulk-IN,Bulk-OUT,Bulk-OUT
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x81  EP 1 IN
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x02  EP 2 OUT
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
>        Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType         5
>          bEndpointAddress     0x03  EP 3 OUT
>          bmAttributes            2
>            Transfer Type            Bulk
>            Synch Type               None
>            Usage Type               Data
>          wMaxPacketSize     0x0200  1x 512 bytes
>          bInterval               0
> Device Qualifier (for other device speed):
>    bLength                10
>    bDescriptorType         6
>    bcdUSB               2.00
>    bDeviceClass            0 (Defined at Interface level)
>    bDeviceSubClass         0
>    bDeviceProtocol         0
>    bMaxPacketSize0        64
>    bNumConfigurations      1
> Device Status:     0x0002
>    (Bus Powered)
>    Remote Wakeup Enabled
> "
>
>
> Unfortunately, reverting back to original distro kernel didnt work.
> Thats why I think something was "written" in the interface.
> Thats why I suspect backports 3.11 has such a bug.
> I use distros ONLY in live-RAM mode, I dont use distro permanently
> installed, exactly for the reason I can always rollback.
> The only distros I use are the following: BT5,Kali,Weaknet and Slitaz4 -
> the issue now
> appears in all of them!
> Before 3.11 it did *NOT* appear in any of them!
> As for updates, I only apply updates in Slitaz4.
> FYI, I create a dedicated cpio fs at every new version, containing the
> "updates" modules, so to load them at kernel runtime by syslinux.
> I use this method from the early times of compat-wireless, even at job,
> I have automated scripts for that, always works.
> So I can e.g. switch between drivers version every time just applying
> the cpio file I want at kernel runtime.

There is nothing in the code that will or can rewrite the EEPROM. In fact, the 
necessary circuits are not built into the devices.
>
> And thats what I did when "installed" 3.11: make install, created
> cpio, reboot & loaded the 3.11 cpio, tested the interfaces, saw the
> issues (mac and frames), removed the cpio from loading and put the 3.9
> cpio back.
> I do that all the times, its a no-fail procedure.
> Unfortunately applying back 3.9 didnt solve the issue, my two rtl8187
> remained STUCK in monitor malfunction.
> As for managed mode, it still works perfectly.
> As for the programs I use to test, here a list: airmon-ng, airbase-ng,
> airodump-ng, apache2, dnsspoof, dnsmasq, iptables, iw, wireshark.. the
> usual wifi net tools.
> That was for historic background, so you understand the situation.
>
>>
>> The rtlwifi package only includes the drivers that use rtlwifi for their
>> basic
>> communications. Driver rtl8187 is *NOT* one of them. You have to
>> configure it
>> separately. This is not a bug.
>
> As for compiling rtl modules you say dont use rtlwifi, ok, infact that
> was the first time I tried, just because defconfig-wifi did *NOT* work.
> I repeat, I always used make defconfig-wifi & make install, even for
> 3.11 worked.
> This time for 3.13, is *NOT* compiling rtl818x modules.
> Any functionality change not documented?
> If so, how can I instruct make to compile&install rtl8187 modules in new
> 3.13?

Use 'make menuconfig' and select wireless networking, mac80211, and the rtl8187 
driver. That is what I did.

Larry


