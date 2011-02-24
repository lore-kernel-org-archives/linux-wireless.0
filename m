Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:43810 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab1BXSU1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Feb 2011 13:20:27 -0500
Date: Thu, 24 Feb 2011 18:20:22 +0000
From: Tony Houghton <h@realh.co.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: 611946@bugs.debian.org
Subject: ath9k causes lockups since kernel 2.6.33
Message-ID: <20110224182022.57e32862@toddler>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Posted to linux-wireless and 611946@bugs.debian.org. Sorry about the
repost, I got the bug number wrong before]

After upgrading my netbook's kernel from 2.6.32 in Debian squeeze I
found it could not reliably shut down the wireless connection eg when
suspending. It would almost always completely lock up. Ubuntu's 2.6.35
kernel is also affected, and so are certain versions pulled from git,
compiled with a config based on the Debian default.

While testing different kernels I found it would crash at different
times, usually before the screen turned off for suspending, but
sometimes it would crash on resuming and occasionally it locked up while
booting, but it's always a complete lock-up ie the keyboard is
completely responsive, including caps lock, the mouse won't move if the
display is still on, and the only way out is to hold down the power
button.

The adaptor is an AR9285:

84: udi = '/org/freedesktop/Hal/devices/pci_168c_2b'
  pci.device_protocol = 0  (0x0)  (int)
  pci.vendor = 'Atheros Communications Inc.'  (string)
  info.vendor = 'Atheros Communications Inc.'  (string)
  pci.product = 'AR9285 Wireless Network Adapter
(PCI-Express)'  (string) linux.sysfs_path =
'/sys/devices/pci0000:00/0000:00:15.0/0000:03:00.0'  (strin g)
  info.parent = '/org/freedesktop/Hal/devices/pci_10de_ac6'  (string)
  info.linux.driver = 'ath9k'  (string)
  pci.subsys_vendor = 'Hewlett-Packard Company'  (string)
  linux.hotplug_type = 2  (0x2)  (int)
  linux.subsystem = 'pci'  (string)
  info.subsystem = 'pci'  (string)
  info.product = 'AR9285 Wireless Network Adapter
(PCI-Express)'  (string) info.udi =
'/org/freedesktop/Hal/devices/pci_168c_2b'  (string)
pci.linux.sysfs_path =
'/sys/devices/pci0000:00/0000:00:15.0/0000:03:00.0'  (string)
pci.product_id = 43  (0x2b)  (int) pci.vendor_id = 5772  (0x168c)
(int) pci.subsys_product_id = 12352  (0x3040)  (int)
pci.subsys_vendor_id = 4156  (0x103c)  (int) pci.device_class = 2
(0x2)  (int) pci.device_subclass = 128  (0x80)  (int)

I haven't tried looking in logs because the crashes are so severe I
don't think they'd be able to record anything useful. But using git
bisect I think I have tracked down the change that started causing this
problem:

53bc7aa08b48e5cd745f986731cc7dc24eef2a9f is the first bad commit
commit 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f
Author: Vivek Natarajan <vnatarajan@atheros.com>
Date:   Mon Apr 5 14:48:04 2010 +0530

    ath9k: Add support for newer AR9285 chipsets.
    
    This patch adds support for a modified newer version of AR9285
    chipsets.
    
    Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 2ceb3a80ec957f3304308169c4ab9e5356622a95
14b6922350867c88d7ba6823408a9ce9aa15ddf5 M	drivers

git bisect start
# good: [66f41d4c5c8a5deed66fdcc84509376c9a0bf9d8] Linux 2.6.34-rc6
git bisect good 66f41d4c5c8a5deed66fdcc84509376c9a0bf9d8
# bad: [9fe6206f400646a2322096b56c59891d530e8d51] Linux 2.6.35
git bisect bad 9fe6206f400646a2322096b56c59891d530e8d51
# bad: [c316ba3b518bc35ce5aef5421135220389f4eb98] Merge branch
'linux-next' of git://git.infradead.org/ubi-2.6 git bisect bad
c316ba3b518bc35ce5aef5421135220389f4eb98 # good:
[fb091be08d1acf184e8801dfdcace6e0cb19b1fe] Merge branch
'v4l_for_2.6.35' of
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6 git
bisect good fb091be08d1acf184e8801dfdcace6e0cb19b1fe # bad:
[b56f2d55c6c22b0c5774b3b22e336fb6cc5f4094] netfilter: use
rcu_dereference_protected() git bisect bad
b56f2d55c6c22b0c5774b3b22e336fb6cc5f4094 # bad:
[adfba3c7c026a6a5560d2a43fefc9b198cb74462] mac80211: use fixed channel
in ibss join when appropriate git bisect bad
adfba3c7c026a6a5560d2a43fefc9b198cb74462 # bad:
[1968cc78d91c79857089713bf3f3cceb5e9c63ae] ath5k: correct channel
setting for 2.5 mhz spacing git bisect bad
1968cc78d91c79857089713bf3f3cceb5e9c63ae # good:
[56b632e8cc7a13cece861d890deb2843116f9372] drivers/net: Remove local
#define IW_IOCTL, use IW_HANDLER git bisect good
56b632e8cc7a13cece861d890deb2843116f9372 # good:
[ecdf94b81237d272b1514b76f27a5d22782bcaa6] iwlwifi: remove
skb_linearize for rx frames git bisect good
ecdf94b81237d272b1514b76f27a5d22782bcaa6 # skip:
[c81494d548d0735f13c04dd2c336cde470d1a5ae] ath9k: rename symbols in
enum ath9k_internal_frame_type to avoid confusion git bisect skip
c81494d548d0735f13c04dd2c336cde470d1a5ae # skip:
[f9ea3eb44218b0e12a190f222400f8d56136915f] include/net/iw_handler.h:
Use SIOCIWFIRST not SIOCSIWCOMMIT in comment git bisect skip
f9ea3eb44218b0e12a190f222400f8d56136915f # skip:
[152d530d9edbb08424dc1b6561252597a7932c49] ath9k: remove ah->mask_reg,
it's never used properly git bisect skip
152d530d9edbb08424dc1b6561252597a7932c49 # skip:
[879999cec9489f8942ebce3ec1b5f23ef948dda7] ar9170usb: fix panic
triggered by undersized rxstream buffer git bisect skip
879999cec9489f8942ebce3ec1b5f23ef948dda7 # skip:
[b409894f9d6961bd5feffb86ba1d8dbbebfb5b72] ath: fix coding
style/readability in ath/ar9170 git bisect skip
b409894f9d6961bd5feffb86ba1d8dbbebfb5b72 # skip:
[9fd1ea428590cf6e35e5a7df32ff6bccfd371db2] wireless/ipw2x00: remove
trailing space in messages git bisect skip
9fd1ea428590cf6e35e5a7df32ff6bccfd371db2 # skip:
[3069168c82d65f88e4ac76eda09baff02adfd743] ath9k: move imask from sc to
ah git bisect skip 3069168c82d65f88e4ac76eda09baff02adfd743 # good:
[7590a550b88b8c3cb025f0a8ed58e279ad62e4c1] wl1251: use DRIVER_NAME
macro in wl1251_spi_driver git bisect good
7590a550b88b8c3cb025f0a8ed58e279ad62e4c1 # bad:
[0f2df9eac70423838a1f8d410fd3899ddd88317b] Merge branch 'master' of
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6
into merge git bisect bad 0f2df9eac70423838a1f8d410fd3899ddd88317b #
bad: [2b43ae6daf26f29cec49fa3a3f18025355495500] mac80211: remove irq
disabling for sta lock git bisect bad
2b43ae6daf26f29cec49fa3a3f18025355495500 # bad:
[bde748a40d4d5a9915def6772e208848c105e616] ath9k_htc: Add support for
power save. git bisect bad bde748a40d4d5a9915def6772e208848c105e616 #
bad: [53bc7aa08b48e5cd745f986731cc7dc24eef2a9f] ath9k: Add support for
newer AR9285 chipsets. git bisect bad
53bc7aa08b48e5cd745f986731cc7dc24eef2a9f # good:
[d5cdfacb35ed886271d1ccfffbded98d3447da17] cfg80211: Add
local-state-change-only auth/deauth/disassoc git bisect good
d5cdfacb35ed886271d1ccfffbded98d3447da17
