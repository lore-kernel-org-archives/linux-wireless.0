Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm5-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.165]:48679 "EHLO
	nm5-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755283Ab3BWKr7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Feb 2013 05:47:59 -0500
Message-ID: <1361616101.52110.YahooMailNeo@web124704.mail.ne1.yahoo.com> (sfid-20130223_114811_450470_C0BF7262)
Date: Sat, 23 Feb 2013 02:41:41 -0800 (PST)
From: Walter Goldens <goldenstranger@yahoo.com>
Reply-To: Walter Goldens <goldenstranger@yahoo.com>
Subject: compat-wireless/drivers - slew of warnings and issues (older kernel)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recent (stable) compat-wireless/drivers compilation exhibited a great deal of warnings on an older kernel (2.6.24  to 2.6.30 I think). Is 2.6.24 still supported?

Also, there was an issue with 50-compat_firmware.rules. Ubuntu 8.04 looks for it at /lib/udev/rules.d/ which gave me severe problems with firmware loading and system freezes. I had to copy/symlink 50-compat_firmware.rules from /lib/udev/rules.d/ to /etc/udev/rules.d/.

Warning log (partial). It compiles, but warnings galore. Is anyone up for backporting?


  CC [M]  /drivers/net/wireless/rt2x00/rt2x00dev.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt2x00mac.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt2x00config.o
  CC [M]  /drivers/net/wireless/rt2x00/rt2x00queue.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt2x00link.o
  CC [M]  /drivers/net/wireless/rt2x00/rt2x00crypto.o
  CC [M]  /drivers/net/wireless/rt2x00/rt2x00firmware.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  LD [M]  /drivers/net/wireless/rt2x00/rt2x00lib.o
  CC [M]  /drivers/net/wireless/rt2x00/rt2x00pci.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt2x00usb.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt2800lib.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
/drivers/net/wireless/rt2x00/rt2800lib.c: In function ‘rt2800_config_erp’:
/drivers/net/wireless/rt2x00/rt2800lib.c:1383: warning: ‘gf40_mode’ may be used uninitialized in this function
/drivers/net/wireless/rt2x00/rt2800lib.c:1383: note: ‘gf40_mode’ was declared here
/drivers/net/wireless/rt2x00/rt2800lib.c:1383: warning: ‘gf20_mode’ may be used uninitialized in this function
/drivers/net/wireless/rt2x00/rt2800lib.c:1383: note: ‘gf20_mode’ was declared here
/drivers/net/wireless/rt2x00/rt2800lib.c:1383: warning: ‘mm40_mode’ may be used uninitialized in this function
/drivers/net/wireless/rt2x00/rt2800lib.c:1383: note: ‘mm40_mode’ was declared here
/drivers/net/wireless/rt2x00/rt2800lib.c:1383: warning: ‘mm20_mode’ may be used uninitialized in this function
/drivers/net/wireless/rt2x00/rt2800lib.c:1383: note: ‘mm20_mode’ was declared here
  CC [M]  /drivers/net/wireless/rt2x00/rt2400pci.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt2500pci.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt61pci.o
/drivers/net/wireless/rt2x00/rt61pci.c: In function ‘__check_nohwcrypt’:
/drivers/net/wireless/rt2x00/rt61pci.c:45: warning: return from incompatible pointer type
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt2800pci.o
/drivers/net/wireless/rt2x00/rt2800pci.c: In function ‘__check_nohwcrypt’:
/drivers/net/wireless/rt2x00/rt2800pci.c:54: warning: return from incompatible pointer type
include/asm/io_32.h: In function ‘memcpy_fromio’:
include/asm/io_32.h:211: warning: passing argument 2 of ‘__memcpy’ discards qualifiers from pointer target type
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt2500usb.o
/drivers/net/wireless/rt2x00/rt2500usb.c: In function ‘__check_nohwcrypt’:
/drivers/net/wireless/rt2x00/rt2500usb.c:43: warning: return from incompatible pointer type
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt73usb.o
/drivers/net/wireless/rt2x00/rt73usb.c: In function ‘__check_nohwcrypt’:
/drivers/net/wireless/rt2x00/rt73usb.c:44: warning: return from incompatible pointer type
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rt2x00/rt2800usb.o
/drivers/net/wireless/rt2x00/rt2800usb.c: In function ‘__check_nohwcrypt’:
/drivers/net/wireless/rt2x00/rt2800usb.c:49: warning: return from incompatible pointer type
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /drivers/net/wireless/rtl818x/rtl8187/leds.o
/drivers/net/wireless/rtl818x/rtl8187/leds.c: In function ‘rtl8187_register_led’:
/drivers/net/wireless/rtl818x/rtl8187/leds.c:152: warning: assignment discards qualifiers from pointer target type
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /net/mac80211/main.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /net/mac80211/ht.o
/net/mac80211/ht.c: In function ‘ieee80211_ht_cap_ie_to_sta_ht_cap’:
/net/mac80211/ht.c:105: warning: ‘smps_mode’ may be used uninitialized in this function
  CC [M]  /net/mac80211/iface.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /net/mac80211/cfg.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /net/mac80211/rx.o
  CC [M]  /net/mac80211/spectmgmt.o
  CC [M]  /net/mac80211/tx.o
/net/mac80211/tx.c: In function ‘ieee80211_subif_start_xmit’:
/net/mac80211/tx.c:1778: warning: ‘chanctx_conf’ may be used uninitialized in this function
  CC [M]  /net/mac80211/mlme.o
/net/mac80211/mlme.c: In function ‘ieee80211_prep_connection’:
/net/mac80211/mlme.c:3780: warning: ‘have_higher_than_11mbit’ may be used uninitialized in this function
  CC [M]  /net/mac80211/led.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /net/mac80211/debugfs.o
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /net/mac80211/debugfs_sta.o
  CC [M]  /net/mac80211/debugfs_netdev.o
/net/mac80211/debugfs_netdev.c: In function ‘ieee80211_if_fmt_tsf’:
/net/mac80211/debugfs_netdev.c:415: warning: passing argument 2 of ‘drv_get_tsf’ discards qualifiers from pointer target type
  CC [M]  /net/mac80211/debugfs_key.o
/net/mac80211/debugfs_key.c:37:1: warning: "KEY_FILE" redefined
In file included from /include/linux/compat-2.6.28.h:15,
                 from /include/linux/compat-2.6.h:51,
                 from <command-line>:0:
include/linux/input.h:267:1: warning: this is the location of the previous definition
  CC [M]  /net/wireless/core.o
/net/wireless/core.c: In function ‘__check_cfg80211_disable_40mhz_24ghz’:
/net/wireless/core.c:53: warning: return from incompatible pointer type
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
  CC [M]  /net/wireless/nl80211.o
/net/wireless/nl80211.c: In function ‘nl80211_parse_mesh_config’:
/net/wireless/nl80211.c:4383: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4386: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4389: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4391: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4394: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4401: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4401: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4407: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4414: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4418: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4422: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4427: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4430: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4433: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4437: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4443: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4450: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4453: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4463: warning: comparison is always false due to limited range of data type
/net/wireless/nl80211.c:4463: warning: comparison is always false due to limited range of data type
/include/net/cfg80211.h: In function ‘wiphy_name’:
/include/net/cfg80211.h:2676: warning: passing argument 1 of ‘dev_name’ discards qualifiers from pointer target type
/net/wireless/nl80211.c: In function ‘nl80211_parse_wowlan_tcp’:
/net/wireless/nl80211.c:7416: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/nl80211.c:7416: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
/net/wireless/nl80211.c:7424: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/nl80211.c:7424: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
/net/wireless/nl80211.c:7429: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/nl80211.c:7429: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
/net/wireless/nl80211.c: In function ‘nl80211_pre_doit’:
/net/wireless/nl80211.c:58: warning: ‘wdev_id’ may be used uninitialized in this function
/net/wireless/nl80211.c:58: note: ‘wdev_id’ was declared here
/net/wireless/nl80211.c: In function ‘nl80211_trigger_scan’:
/net/wireless/nl80211.c:4874: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/nl80211.c:4874: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
/net/wireless/nl80211.c: In function ‘nl80211_start_sched_scan’:
/net/wireless/nl80211.c:5142: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/nl80211.c:5142: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
  CC [M]  /net/wireless/mlme.o
  CC [M]  /net/wireless/ibss.o
  CC [M]  /net/wireless/sme.o
/net/wireless/sme.c: In function ‘cfg80211_roamed_bss’:
/net/wireless/sme.c:673: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/sme.c:673: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
/net/wireless/sme.c:676: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/sme.c:676: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
/net/wireless/sme.c: In function ‘cfg80211_disconnected’:
/net/wireless/sme.c:758: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/sme.c:758: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
/net/wireless/sme.c: In function ‘cfg80211_connect_result’:
/net/wireless/sme.c:550: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/sme.c:550: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type
/net/wireless/sme.c:555: warning: passing argument 1 of ‘__constant_memcpy’ discards qualifiers from pointer target type
/net/wireless/sme.c:555: warning: passing argument 1 of ‘__memcpy’ discards qualifiers from pointer target type

-- Walter
