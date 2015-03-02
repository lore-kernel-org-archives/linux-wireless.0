Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:42742 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbbCBKaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 05:30:07 -0500
Received: by mail-oi0-f42.google.com with SMTP id h136so26161309oig.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 02:30:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150226170522.01605ac4@north>
References: <544DB5A8.7090405@openmailbox.org>
	<20141027152026.GB19976@tuxdriver.com>
	<544E8CB4.3000607@rempel-privat.de>
	<20141028134608.GA26283@tuxdriver.com>
	<544FA303.5060303@broadcom.com>
	<544FA627.3000004@rempel-privat.de>
	<5450BEB2.60208@openwrt.org>
	<5461F937.9060004@rempel-privat.de>
	<5463CB6C.3030204@openwrt.org>
	<5463D28F.9080106@lwfinger.net>
	<20150206182915.7467bac7@north>
	<CABikg9yw8Py59KyJ1mP6bfCrMPuup7v9xb1J=_JKC4gT_GS4rA@mail.gmail.com>
	<20150225103311.436f4321@north>
	<CABikg9xU+vj_W+TF4d7=x52u8abhkXC0qPGsOgRUMXDhRA0NFQ@mail.gmail.com>
	<20150226170522.01605ac4@north>
Date: Mon, 2 Mar 2015 11:30:06 +0100
Message-ID: <CABikg9yCgELvoTMMf5bqfQTbL=VP-yMyMo3EnGC4CiN7OANqNA@mail.gmail.com> (sfid-20150302_113021_473774_C18B7ED2)
Subject: Re: mt7601u dies during channel switch (was: MediaTek WiFi hardware
 support in upstream kernel)
From: Sergei Antonov <saproj@gmail.com>
To: =?UTF-8?Q?Jakub_Kici=C5=84ski?= <moorray3@wp.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 February 2015 at 17:05, Jakub Kiciński <moorray3@wp.pl> wrote:
> On Thu, 26 Feb 2015 00:58:59 +0100, Sergei Antonov wrote:
>> On 25 February 2015 at 10:33, Jakub Kiciński <moorray3@wp.pl> wrote:
>> > On Wed, 25 Feb 2015 01:49:02 +0100, Sergei Antonov wrote:
>> >> On 6 February 2015 at 18:29, Jakub Kiciński <moorray3@wp.pl> wrote:
>> >> > Hello everyone!
>> >> >
>> >> > I put together a mac80211 driver for Mediatek MT7601U.  It's partially
>> >> > based on Felix's mt76, but I'm not sure if it will make sense to merge
>> >> > the two together.  MT7601U is a pretty old 1x1 bgn chip for USB dongles
>> >> > and mt76 now only supports the latest and greatest ac APs.
>> >> >
>> >> > I'm testing STA functionality right now and it seems to be working ok.
>> >> > The code is very much a work in progress but if anyone is interested you
>> >> > can get it here:
>> >> >
>> >> > https://github.com/kuba-moo/mt7601u
>> >>
>> >> Hi, Jakub! I happen to have 7601 dongle, so I tested you driver. There
>> >> were some problems, see "dmesg | grep mt7" output:
>> >
>> > OK, let me start with a set of basic questions.
>> >
>> > What device do you have (brand + model or picture on ebay please;))?
>>
>> http://www.ebay.de/itm/221662285066
>>
>> > What's the device ID?
>>
>> Bus 003 Device 006: ID 148f:7601 Ralink Technology, Corp.
>>
>> > What platform are you working on?
>>
>> Linux linux64 3.19.0-05375-gd347efe #17 SMP Sun Feb 15 16:38:24 CET
>> 2015 x86_64 GNU/Linux
>>
>> > Is this error persistent or a one-time thing?
>>
>> It is persistent.
>>
>> > Does the vendor driver work with your device?
>
> Thanks for the information, I have exactly that device here and it
> works fine, including on x86_64.  You can try going back to commits
> 19cdcb583f18 ("don't allow AMPDUs with probe rates") and
> e9d7b296fea0 ("mitigate DMA problems on very poor link") from my repo.
> Maybe I did screw something up when cleaning up the MCU code.

Going back to them didn't affect the behavior.

>> Yes. I took DPO_MT7601U_LinuxSTA_3.0.0.4_20130913.tar.bz2, applied
>> rt2870-mt7601Usta-kuid_t-kgid_t.patch (can bee easily googled, it is
>> needed to compile for recent kernels) and the device was able to
>> connect to my AP. The only suspicious thing was that the output to the
>> console was very verbose. I didn't take time to see if it was just
>> trace or a sign of a problem. I can repeat this and look more closely.
>> I can also look deeper into the critical moment between ch1 and ch2
>> you mention.
>
> I would appreciate if you could set RTDebugLevel to RT_DEBUG_LOUD in
> src/os/linux/rt_linux.c of the vendor driver (line 54) and get a full
> log of it associating to an AP.  Please post it somewhere like
> pastebin.com or attach to an email.  Let me know if you need help.

I didn't do it, but I've found a way to fix your driver. See below.

>> > Can you also show content of
>> > /sys/kernel/debug/ieee80211/phy*/mt76/eeprom_param
>> > ?
>>
>> /sys/kernel/debug is empty on my machine.
>
> You can mount it by saying (as root):
> # mount -t debugfs /sys/kernel/debug/

Thanks. Now I see it:

RF freq offset: 2c
RSSI offset: 0 0
Reference temp: f9
LNA gain: 8
Reg channels: 1-14
Per rate power:
raw:05 bw20:05 bw40:05
raw:05 bw20:05 bw40:05
raw:03 bw20:03 bw40:03
raw:03 bw20:03 bw40:03
raw:04 bw20:04 bw40:04
raw:00 bw20:00 bw40:00
raw:00 bw20:00 bw40:00
raw:00 bw20:00 bw40:00
raw:02 bw20:02 bw40:02
raw:00 bw20:00 bw40:00
Per channel power:
tx_power  ch1:07 ch2:07
tx_power  ch3:07 ch4:07
tx_power  ch5:08 ch6:08
tx_power  ch7:08 ch8:08
tx_power  ch9:09 ch10:09
tx_power  ch11:09 ch12:09
tx_power  ch13:09 ch14:09


>> I did 'git pull' now, recompiled the driver, rebooted. Here is the
>> relevant piece of dmesg output:
>>
>> [   10.931816] mt7601u_add_interface idx:0
>> [   10.933012] mt7601u_bss_info_changed 0000000e
>> [   10.934126] [prot transition] mode:0000 bgprot:0 non-gf:0 non-ht:0
>> [   10.937859] mt7601u_conf_tx 03 <- 0000
>> [   10.942100] mt7601u_conf_tx 02 <- 0001
>> [   10.945173] mt7601u_conf_tx 01 <- 0002
>> [   10.949340] mt7601u_conf_tx 00 <- 0003
>> [   10.952607] mt7601u_bss_info_changed 00002000
>> [   10.953611] mt7601u_config ffffffff ch:1
>> [   10.967710] mt76_configure_filter changed:0 total:80000000
>> [   10.967725] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
>> [   10.970070] mt76_configure_filter changed:0 total:80000000
>> [   10.980384] cfg80211: Calling CRDA to update world regulatory domain
>> [   11.012397] mt76_configure_filter changed:0 total:80000000
>> [   11.080505] mt7601u_config 00000100 ch:1
>> [   11.082447] mt76_configure_filter changed:10 total:80000010
>> [   11.083827] mt7601u_config 00000040 ch:1
>> [   11.128025] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.2
>> domain=0x0007 address=0x00000000c99a6000 flags=0x0010]
>> [   11.129175] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.2
>> domain=0x0007 address=0x00000000c99a6040 flags=0x0010]
>> [   11.155951] mt7601u_config 00000040 ch:2
>> [   11.455658] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   11.755362] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   12.055067] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   12.354758] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   12.654476] mt7601u 3-5:1.0: Warning: mt7601u_mcu_wait_resp retrying
>> [   12.655597] mt7601u 3-5:1.0: Error: mt7601u_mcu_wait_resp timed out
>> [   12.656593] mt7601u_config 00000040 ch:3
>> [   13.154228] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
>> [   13.155318] mt7601u_config 00000040 ch:4
>> [   13.653709] mt7601u 3-5:1.0: Error: send MCU cmd failed:-110
>>
>> Note the two messages about IO_PAGE_FAULT in device 00:12.2. This
>> device is a USB controller:
>> [    2.181191] ehci-pci 0000:00:12.2: EHCI Host Controller
>> But this controller is not guilty :), it works fine with other USB devices.
>
> Perhaps I have some errors in DMA programming.  Can you disable all
> automatic WiFi things so they don't mess with the device (NetworkManger
> etc.), make sure the interface is not brought up, and then try (as
> root):
>
> iw dev wlan1 interface add monT type monitor
> ifconfig monT up
> iw dev monT set channel 2
> iw dev monT set channel 1
> iw dev monT set channel 2 HT40+
> iw dev monT set channel 10 HT40-
>
> (I assume wlan1 is the mt7601u.) See if after any of these commands the
> errors will appear.

I did some debugging and comparing against other USB WiFi drivers'
source code and found that this change resolves the issue:

diff --git a/dma.c b/dma.c
index b370210..9059267 100644
--- a/dma.c
+++ b/dma.c
@@ -355,7 +355,7 @@ int usb_kick_out(struct mt7601u_dev *dev, struct
sk_buff *skb, u8 ep)
  usb_fill_bulk_urb(q->e[e].urb, usb_dev, snd_pipe, skb->data, skb->len,
   mt7601u_complete_tx, q);
  q->e[e].urb->transfer_dma = q->e[e].dma;
- q->e[e].urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+ q->e[e].urb->transfer_flags |= URB_ZERO_PACKET;
  ret = usb_submit_urb(q->e[e].urb, GFP_ATOMIC);
  if (ret) {
  if (ret == -ENODEV)

I saw that drivers/net/wireless/rtlwifi/ driver uses this constant for
TX to device.

Here is my successful dmesg. The connection works. I am only slightly
worried about the last 3 lines.

[   16.277054] mt7601u_add_interface idx:0
[   16.279052] mt7601u_bss_info_changed 0000000e
[   16.281002] [prot transition] mode:0000 bgprot:0 non-gf:0 non-ht:0
[   16.286761] mt7601u_conf_tx 03 <- 0000
[   16.291166] mt7601u_conf_tx 02 <- 0001
[   16.295280] mt7601u_conf_tx 01 <- 0002
[   16.299424] mt7601u_conf_tx 00 <- 0003
[   16.303278] mt7601u_bss_info_changed 00002000
[   16.305043] mt7601u_config ffffffff ch:1
[   16.318684] IPv6: ADDRCONF(NETDEV_UP): wlan1: link is not ready
[   16.318746] mt76_configure_filter changed:0 total:80000000
[   16.331196] cfg80211: Calling CRDA to update world regulatory domain
[   16.365728] mt76_configure_filter changed:0 total:80000000
[   16.431419] mt7601u_config 00000100 ch:1
[   16.434003] mt76_configure_filter changed:10 total:80000010
[   16.436094] mt7601u_config 00000040 ch:1
[   16.502838] mt7601u_config 00000040 ch:2
[   16.574766] mt7601u_config 00000040 ch:3
[   16.646700] mt7601u_config 00000040 ch:4
[   16.718640] mt7601u_config 00000040 ch:5
[   16.790582] mt7601u_config 00000040 ch:6
[   16.862483] mt7601u_config 00000040 ch:7
[   16.934414] mt7601u_config 00000040 ch:8
[   17.006343] mt7601u_config 00000040 ch:9
[   17.074277] mt7601u_config 00000040 ch:10
[   17.146208] mt7601u_config 00000040 ch:11
[   17.218134] mt7601u_config 00000040 ch:12
[   17.342014] mt7601u_config 00000040 ch:13
[   17.465894] mt7601u_config 00000040 ch:14
[   17.585786] mt7601u_config 00000040 ch:1
[   17.586195] wlan1: authenticate with xx:xx:xx:xx:xx:xx
[   17.601957] mt76_configure_filter changed:0 total:80000000
[   17.604081] mt7601u_config 00000100 ch:1
[   17.605497] mt7601u_config 00000100 ch:1
[   17.606932] mt7601u_config 00000040 ch:8
[   17.621314] mt7601u_bss_info_changed 00040000
[   17.622639] mt7601u_bss_info_changed 00004000
[   17.623845] mt7601u_bss_info_changed 000000e0
[   17.625804] basic rates: 0000000f
[   17.629926] wlan1: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
[   17.633019] wlan1: authenticated
[   17.634571] mt7601u 3-5:1.0 wlan1: disabling HT as WMM/QoS is not
supported by the AP
[   17.635931] mt7601u 3-5:1.0 wlan1: disabling VHT as WMM/QoS is not
supported by the AP
[   17.637713] wlan1: associate with xx:xx:xx:xx:xx:xx (try 1/3)
[   17.641135] wlan1: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411
status=0 aid=3)
[   17.642546] mt7601u_sta_add
[   17.644905] mt7601u_conf_tx 03 <- 0000
[   17.648499] mt7601u_conf_tx 02 <- 0001
[   17.651974] mt7601u_conf_tx 01 <- 0002
[   17.655142] mt7601u_conf_tx 00 <- 0003
[   17.658639] mt7601u_bss_info_changed 00102009
[   17.688437] wlan1: associated
[   17.689610] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[   17.690827] mt76_configure_filter changed:0 total:80000000
[   17.694006] mt7601u_set_key cmd:0 flg:8 kid:0 wid:1
[   17.695293] setting key for idx:01
[   17.697372] mt7601u_set_key cmd:0 flg:0 kid:1 wid:7e
[   17.698623] setting key for idx:7e
[   17.700558] setting key for vif_idx:00 key_idx:01
[   21.168348] mt7601u_bss_info_changed 00001000
[  341.783017] mt7601u_set_key cmd:0 flg:0 kid:2 wid:7e
[  341.783046] setting key for idx:7e
[  341.784793] setting key for vif_idx:00 key_idx:02

My firmware binary blob is the same as yours.
