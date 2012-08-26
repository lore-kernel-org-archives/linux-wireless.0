Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15158 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab2HZGHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Aug 2012 02:07:55 -0400
Date: Sun, 26 Aug 2012 11:39:34 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Sherwin Soltani <sherwin@wybc.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k: AR9462 btcoex doesn't appear to work
Message-ID: <20120826060932.GB6979@vmraj-lnx.qca.qualcomm.com> (sfid-20120826_080759_226838_7DAE8876)
References: <50394BE4.3000508@wybc.com>
 <20537.33465.256314.716102@gargle.gargle.HOWL>
 <5039B192.3000206@wybc.com>
 <20120826060550.GA6979@vmraj-lnx.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120826060550.GA6979@vmraj-lnx.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 26, 2012 at 11:35:52AM +0530, Rajkumar Manoharan wrote:
> On Sun, Aug 26, 2012 at 01:18:10AM -0400, Sherwin Soltani wrote:
> > On 08/25/2012 09:58 PM, Sujith Manoharan wrote:
> > >Sherwin Soltani wrote:
> > >>I have an Acer Aspire V5-571 which contains the AR9462 chipset (PCI ID
> > >>168c:0034), supported by the ath9k driver. This chipset claims to
> > >>support Bluetooth coexistence. However, after booting up, my kernel does
> > >>not register any Bluetooth devices.
> > >>
> > >>I am using kernel version 3.6.0-999-generic (apw@gomeisa) (gcc version
> > >>4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5)). I also tried 3.4 and 3.2 kernels
> > >>without success. Additionally, I can try to do
> > >>
> > >>rmmod ath9k && modprobe ath9k btcoex_enable=1
> > >>
> > >>In the message log, I can see this:
> > >>
> > >>[ 1204.643120] ath9k: ath9k: Driver unloaded
> > >>[ 1214.203099] ath: phy1: Disabling ASPM since BTCOEX is enabled
> > >>[ 1214.203105] ath: EEPROM regdomain: 0x6a
> > >>[ 1214.203106] ath: EEPROM indicates we should expect a direct regpair map
> > >>[ 1214.203108] ath: Country alpha2 being used: 00
> > >>[ 1214.203109] ath: Regpair used: 0x6a
> > >>
> > >>However 'hcitool dev' shows no devices after this operation.
> > >What does lsusb -v show ?
> >
> I hope it is lspci's output not lsusb?

I mean the below message. 
> > It shows:
> > 
> > 03:00.0 Network controller: Atheros Communications Inc. AR9462
> > Wireless Network Adapter (rev 01)
> >     Subsystem: Lite-On Communications Inc Device 6621
> >     Flags: bus master, fast devsel, latency 0, IRQ 19
> >     Memory at f0500000 (64-bit, non-prefetchable) [size=512K]
> >     Expansion ROM at dfa00000 [disabled] [size=64K]
> >     Capabilities: [40] Power Management version 2
> >     Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
> >     Capabilities: [70] Express Endpoint, MSI 00
> >     Capabilities: [100] Advanced Error Reporting
> >     Capabilities: [140] Virtual Channel
> >     Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
> >     Kernel driver in use: ath9k
> >     Kernel modules: ath9k
> >  
> > >...
> > >
> > >Reload ath3k and something like this should be seen:
> > >
> > >root@linux-test ~# hciconfig hci1 up
> > >root@linux-test ~# hcitool dev
> > >Devices:
> > >         hci1    00:03:7F:44:84:8A
> > 
> > By ath3k, I assume you meant ath9k since that is the driver I was
> > using. After loading up the new firmware, I still have no devices
> > shown (and 'hciconfig hci1 up' replies with 'No such device').
> > Rebooting doesn't help.
> > 
> No. ath3k is BT firmware downloader that loads BT firmware into the target.
> Can you please confirm whether you have ath3k driver or not? BT device will be
> enumerated as usb device. Can you you share lsusb list and complete kernel log?
> 
> --
> Rajkumar
> > Here is what I see in the message buffer after re-inserting ath9k:
> > [19157.961388] ath9k: ath9k: Driver unloaded
> > [19178.196366] ath: phy2: ASPM enabled: 0x43
> > [19178.196371] ath: EEPROM regdomain: 0x6a
> > [19178.196372] ath: EEPROM indicates we should expect a direct regpair map
> > [19178.196375] ath: Country alpha2 being used: 00
> > [19178.196376] ath: Regpair used: 0x6a
> > 
> > ... lots of cfg80211 info ...
> > 
> > [19178.197491] Registered led device: ath9k-phy2
> > [19178.197500] ieee80211 phy2: Atheros AR9462 Rev:2
> > mem=0xffffc90016300000, irq=19
> > [19178.211376] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > [19186.703984] wlan0: authenticate with 2c:b0:5d:45:33:58
> > [19186.708760] wlan0: send auth to 2c:b0:5d:45:33:58 (try 1/3)
> > [19186.759145] wlan0: authenticated
> > [19186.765888] wlan0: associate with 2c:b0:5d:45:33:58 (try 1/3)
> > [19186.863455] wlan0: RX AssocResp from 2c:b0:5d:45:33:58
> > (capab=0x411 status=0 aid=2)
> > [19186.863561] wlan0: associated
> > 
> > >Coexistence testing is ongoing and bugs are still being ironed out,
> > >but basic support is mostly done.
> > >
> > >>Aside from the Bluetooth problems, there are also problems with
> > >>frequently dropping signals (even when I am very close to the access
> > >>point), but right now that's a secondary concern to Bluetooth for me.
> > >Can you try with the latest driver (using compat-wireless) and see if the
> > >problem persists ? If it does, please post the kernel log with driver
> > >debugging set to 0x8f49.
> > 
> > I will take a look at what happens with compat-wireless.
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
