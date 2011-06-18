Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49460 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1FRFki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 01:40:38 -0400
Received: by pvg12 with SMTP id 12so2341146pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 22:40:38 -0700 (PDT)
MIME-Version: 1.0
From: Jim Cromie <jim.cromie@gmail.com>
Date: Fri, 17 Jun 2011 23:40:08 -0600
Message-ID: <BANLkTi=wXpJdUV8+uiuhr=v2wcOhhjYB6Q@mail.gmail.com> (sfid-20110618_074042_469834_7A6733CA)
Subject: help with net device, udev
To: nishants@marvell.com, Yogesh Powar <yogeshp@marvell.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi folks,

I harvested a mini-pci wifi card with a marvell chip, and plugged it
into my soekris net4801.
I patched the mwl8k driver:

    mwl8k: add support for MWL8361P

    patch from here, with tweaks to apply:
    https://dev.openwrt.org/attachment/ticket/7209/mwl8k_8361p.patch

    firmware is obtainable following recipe here:
    https://dev.openwrt.org/ticket/7209#comment:5
    Firmware extraction from Windows driver was described in
    https://forum.openwrt.org/viewtopic.php?pid=103243#p103243

The patch is small & straightforward,
it just adds DEVICE-ID and struct recording firmware names.

I followed the recipe to get fw files,
moprobe mwl8k works, module appears in lsmod output,
and it increases use-count on its dependencies,
so things look sort-of ok.

root@voyage:/var/log# lsmod | grep mwl8k
mwl8k                  29691  0
mac80211              159120  2 mwl8k,rtl8180
cfg80211              106017  3 mwl8k,rtl8180,mac80211

However, nothing else happens with card, driver:

- lspci -k  fails to show driver operating the card.
- no network device shows up in ifconfig
- udev logs some activity, below compares working wifi card to non-working.

Best I can tell, mwl8k driver is not populating /sys/ the same way rtl8180 is:

root@voyage:/var/log# ls /sys/devices/pci0000\:00/0000\:00\:0{a,e}.0/
/sys/devices/pci0000:00/0000:00:0a.0/:
broken_parity_status	  enable	 net	    resource1
class			  ieee80211	 power	    subsystem
config			  irq		 remove     subsystem_device
consistent_dma_mask_bits  local_cpulist  rescan     subsystem_vendor
device			  local_cpus	 reset	    uevent
dma_mask_bits		  modalias	 resource   vendor
driver			  msi_bus	 resource0

/sys/devices/pci0000:00/0000:00:0e.0/:
broken_parity_status	  dma_mask_bits  modalias  reset      subsystem_device
class			  enable	 msi_bus   resource   subsystem_vendor
config			  irq		 power	   resource0  uevent
consistent_dma_mask_bits  local_cpulist  remove    resource1  vendor
device			  local_cpus	 rescan    subsystem


and consequently, udev is missing critical elements, so cant add a net-device

root@voyage:/var/log# jobs
[1]+  Running                 tail -f daemon.log | grep devpath &

root@voyage:/var/log# for m in mwl8k rtl8180 ; do modprobe $m; done
Jun 18 05:21:40 loading mwl8k_init emerg
voyage udevd-work[4955]: device loading mwl8k_init alert
0xb77b1188 has devpath '/module/mwl8k'
loading mwl8k_init crit
loading mwl8k_init err
loading mwl8k_init warn
loading mwl8k_init info
loading mwl8k_init default

Message from syslogd@voyage at Sat Jun 18 05:21:40 2011 ...
voyage kernel: loading mwl8k_init emerg
Jun 18 05:21:40 voyage udevd-work[4955]: device 0xb77b1188 has devpath
'/bus/pci/drivers/mwl8k'
Jun 18 05:21:40 voyage udevd-work[4955]: device 0xb77b1188 has devpath
'/module/rtl8180'
Jun 18 05:21:40 voyage udevd-work[4955]: device 0xb77b1188 has devpath
'/devices/pci0000:00/0000:00:0a.0/ieee80211/phy1'
Jun 18 05:21:40 voyage udevd-work[5171]: device 0xb779c050 has devpath
'/devices/pci0000:00/0000:00:0a.0/net/wlan0'
Jun 18 05:21:40 voyage udevd-work[5171]: device 0xb77b1198 has devpath
'/devices/pci0000:00/0000:00:0a.0'
Jun 18 05:21:40 voyage udevd-work[5171]: device 0xb77b2ee8 has devpath
'/devices/pci0000:00'
Jun 18 05:21:40 voyage udevd-work[5171]: '/lib/udev/pci-db' (stderr)
'device 0xb778b108 has devpath '/devices/pci0000:00/0000:00ieee80211
phy1: hwaddr 0030bd4de247, RTL8180 + Philips
:0a.0/net/wlan0''
Jun 18 05:21:40 voyage udevd-work[5171]: '/lib/udev/pci-db' (stderr)
'device 0xb778b2c0 has devpath '/devices/pci0000:00/0000:00:0a.0''
root@voyage:/var/log# Jun 18 05:21:40 voyage udevd-work[4955]: device
0xb77b1188 has devpath
'/devices/pci0000:00/0000:00:0a.0/ieee80211/phy1/rfkill5'
Jun 18 05:21:40 voyage udevd-work[5183]: device 0xb779c050 has devpath
'/bus/pci/drivers/rtl8180'
Jun 18 05:21:40 voyage udevd-work[4955]: device 0xb77b1188 has devpath
'/devices/pci0000:00/0000:00:0a.0/ieee80211/phy1/rfkill5'


Q. is does this interpretation make sense ?
Am I missing anything ?
what to try next ?
any other hints ?

thanks in advance
Jim Cromie
