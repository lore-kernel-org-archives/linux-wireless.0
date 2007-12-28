Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate07.web.de ([217.72.192.248]:55139 "EHLO
	fmmailgate07.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbXL1N44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 08:56:56 -0500
Received: from web.de
	by fmmailgate07.web.de (Postfix) with SMTP id 8A17C2D20
	for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2007 14:35:14 +0100 (CET)
Date: Fri, 28 Dec 2007 14:35:14 +0100
Message-Id: <54984095@web.de> (sfid-20071228_135702_356145_B747D92C)
MIME-Version: 1.0
From: =?iso-8859-15?Q?Marco_H=F6fle?= <Marco.Hoefle@web.de>
To: linux-wireless@vger.kernel.org
Subject: =?iso-8859-15?Q?Bug_or_am_I_too_stupid_for_installing_the_Intel_Wirels?=
 =?iso-8859-15?Q?s_drivers_for_Linux=3F?=
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I am trying to get the Intel PRO wireless 3945 adapter running on RedHat Linux Enterprise 5. I think there might be a bug or something in the HOW-TO is missing.
(http://intellinuxwireless.org/?p=mac80211&n=HOWTO-mac80211)

I am stuck in installing the MAC80211 subsystem, these are the steps I am doing (according to HOW-TO). The errors I get are:

[root@localhost build]# make moules modules_install
scripts/kconfig/conf -s arch/i386/Kconfig
net/mac80211/Kconfig:5:warning: 'select' used by config symbol 'MAC80211' refer to undefined symbol 'CRYPTO_ECB'
net/mac80211/Kconfig:11:warning: 'select' used by config symbol 'MAC80211' refer to undefined symbol 'NET_SCH_FIFO'
make: *** No rule to make target `moules'.  Stop.
[root@localhost build]# 

[root@localhost build]# make all
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
make[1]: *** No rule to make target `init/main.o', needed by `init/built-in.o'.  Stop.
make: *** [init] Error 2
[root@localhost build]# 




These are all steps I did:

[root@localhost ~]# ls /lib/modules/$(uname -r)/build/Makefile
/lib/modules/2.6.18-8.el5/build/Makefile
[root@localhost ~]# uname -r
2.6.18-8.el5
[root@localhost ~]# 


Then I opened a terminal in the /home/downloads/drivers/mac80211-10.0.3 directory and issued the make command, this is the terminal output:


[root@localhost mac80211-10.0.3]# make
Building modified version in 'modified/' directory:
Copying modified/ from origin/...done
Applying patches and scripts from pending/.
 + Applying: pending/0001-mac80211-Add-basic-IEEE-802.11n-support.patch
        From 26e77a5fef845edcb5c27db52f413e7558db0e20 Mon Sep 17 00:00:00 2001
 + Applying: pending/0002-mac80211-add-IEEE802.11e-WMM-structures.patch
        From f5af9c4fdfbcc2b8ecb60d9d93657a3e2437c909 Mon Sep 17 00:00:00 2001
 + Applying: pending/0003-mac80211-IEEE802.11e-WMM-TS-management-and-DLS-supp.patch
        From 78e5e6d438cb6ec7ba929293b112b12cf0d9042c Mon Sep 17 00:00:00 2001
 + Applying: pending/0004-mac80211-debugfs-support-for-TSM-and-DLS.patch
        From 88b531cc1ce8bd1f9681a4cbcd11bb61de3c6ca1 Mon Sep 17 00:00:00 2001
 + Applying: pending/0005-mac80211-IEEE802.11e-WMM-misc-fix-and-cleanup.patch
        From 503a88f99457be47979874f2a9a5c3454104519e Mon Sep 17 00:00:00 2001
 + Applying: pending/0006-mac80211-add-WE-nick-power-and-txpower-capabilitie.patch
        From 37515341129948f6f8391cd0c8bb0028f7929c98 Mon Sep 17 00:00:00 2001
 + Applying: pending/0007-mac80211-Fix-user-specified-TXPOWER-from-being-over.patch
        From aa958786201069f0a857251a777f687fc9d42219 Mon Sep 17 00:00:00 2001
 + Applying: pending/0008-mac80211-HT-IEEE_802.11n_TX_AMPDU-send-actframes.patch
        From 70fb3487d26d431401e4b659e520177eb434e343 Mon Sep 17 00:00:00 2001
 + Applying: pending/0009-mac80211-HT-add-IEEE-802.11n-TX_AMPDU-API.patch
        From fc5dcdadd03063981268f4df8ef7ffd9519e25f9 Mon Sep 17 00:00:00 2001
 + Applying: pending/0010-mac80211-HT-add-TX-AMPDU-MLME-data.patch
        From 51bc2c9e296a5f6ec210eee04c882fdb4997c130 Mon Sep 17 00:00:00 2001
 + Applying: pending/0011-mac80211-HT-IEEE-802.11n-TX-AMPDU-MLME-implementa.patch
        From a2c09ed2b5cc19d3fdee0b4d3a25ac82c973cd77 Mon Sep 17 00:00:00 2001
 + Applying: pending/0012-mac80211-HT-IEEE-802.11n-debugfs-support.patch
        From 915fb0b275fae6748a38ece9a67a99129fcf3cc8 Mon Sep 17 00:00:00 2001
 + Applying: pending/0013-mac80211-HT-IEEE-802.11n-block-ack-support.patch
        From 0d1fde009eb108f3f379e0868b600c12f7cd943d Mon Sep 17 00:00:00 2001
 + Applying: pending/0014-mac80211-HT-IEEE-802.11n-block-ack-debugfs-suppor.patch
        From 18fcded749fc76222844afc055128da88dbc03d8 Mon Sep 17 00:00:00 2001
 + Applying: pending/0015-mac80211-HT-add-IEEE-802.11n-qos-queues.patch
        From 1fa8243b4711e74d3158e396f3f3971ed103d482 Mon Sep 17 00:00:00 2001
 + Applying: pending/0016-mac80211-HT-IEEE-802.11n-RX-aggregation-BAR-supor.patch
        From e410f6580a9462480cbf3a8f3ecc601e1d8b5fb5 Mon Sep 17 00:00:00 2001
 + Applying: pending/0017-mac80211-HT-IEEE-802.11n-RX-aggregation-API-and-M.patch
        From 428ee27143824bc868a301bb46d9cc34e76a17b6 Mon Sep 17 00:00:00 2001
 + Applying: pending/0018-mac80211-HT-add-addtional-type-parameter-for-ieee.patch
        From 454d6bf4ab1a52a73fe9d5c7940588c84e7fbf5b Mon Sep 17 00:00:00 2001
 + Applying: pending/0019-mac80211-HT-fix-ieee80211_send_addba_resp-interfa.patch
        From 26c1abde043c8186b483fd29715d2a03e864ac4e Mon Sep 17 00:00:00 2001
 + Applying: pending/0020-mac80211-HT-fix-master-mode-net-type.patch
        From 0081fcc92918c45b914158219d255454e0c3bc4a Mon Sep 17 00:00:00 2001
 + Applying: pending/0021-mac80211-HT-IEEE-802.11n-RX-aggregation-MLME-supp.patch
        From 8f997ba42d5da45841bb8178f5f8978c48ef2c0e Mon Sep 17 00:00:00 2001
 + Applying: pending/0022-mac80211-HT-IEEE-802.11n-RX-aggregation-debugfs-s.patch
        From 657427a497a5fd912251740ec4ee9c3b3bad0f49 Mon Sep 17 00:00:00 2001
 + Applying: pending/0023-mac80211-HT-AP-mode-block-ack-MLME-support.patch
        From 8aff6ff750cb985bafa982b4b1ffc37029e8f013 Mon Sep 17 00:00:00 2001
 + Applying: pending/0024-mac80211-HT-fix-wrong-param-used-for-ieee80211_ht.patch
        From 55d47cff2f5944f3f70fbee5f2b41beccbed2762 Mon Sep 17 00:00:00 2001
 + Applying: pending/0025-mac80211-HT-use-KERN_DEBUG-for-HT-debugging-messa.patch
        From f597c02bc8814aa0ba5b3b9fd1aa14d521b284b8 Mon Sep 17 00:00:00 2001
 + Applying: pending/0026-mac80211-rssi-averaging-filter.patch
        From 4f10cf6269ce9a96d21dd220bf8991716d1be24f Mon Sep 17 00:00:00 2001
 + Applying: pending/0027-mac80211-add-802.11h-channel-switch-packet-handling.patch
        From 534b03cd79f6de5cb3c364289cb5fa158bef6632 Mon Sep 17 00:00:00 2001
 + Applying: pending/0028-mac80211-fix-compile-error-if-CONFIG_NET_SCHED-unde.patch
        From 16d350730af21442636dc3ab822a8ae230fecffa Mon Sep 17 00:00:00 2001
 + Applying: pending/0029-mac80211-add-rate-scaling-algorithm-selection-capab.patch
        From 0f936737d9f8cc3a8886f4590c73b20918df213c Mon Sep 17 00:00:00 2001
 + Applying: pending/0030-mac80211-fix-monitor-mode.patch
        From c334da6f6fe935e278ad5fde78e192d16d3c1603 Mon Sep 17 00:00:00 2001
 + Applying: pending/0031-mac80211-fix-an-printk-warning-for-size_t.patch
        From 465d7fb3ee021c8fe50a49432dfc461a4e4595d9 Mon Sep 17 00:00:00 2001
 + Applying: pending/0032-mac80211-fix-kernel-panic-during-shutdown-time.patch
        From a8f8bdd27fbac5f91aabe206f829592facb486a3 Mon Sep 17 00:00:00 2001
 + Applying: pending/0033-mac80211-fix-a-msdu-header.patch
 
 + Applying: pending/0090-mac80211-IPv6-fix.patch
        The patch below seems to work for me w/ an otherwise stock F-7 kernel
 + Applying: pending/0091-mac80211-fix-hidden-ssid.patch
        diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
 + Applying: pending/0092-mac80211-sta-hw-scanning.patch
        diff -urp mac80211/ieee80211.c /home/chuyee/mac80211/ieee80211.c
 + Applying: pending/0093-mac80211-clean-extra-ie.patch
        --- a/net/mac80211/ieee80211.c  2007-11-15 19:49:57.000000000 +0800
 + Applying: pending/0094-mac80211-hw-scan-fix-1.patch
        diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
 + Applying: pending/0095-mac80211-hw-scan-fix-2.patch
        diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
 + Applying: pending/0096-mac80211-workaround-wpa-reassoc.patch
        diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
 + Applying: pending/0097-mac80211-ht-agg-teardown-fix.patch
        diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
 + Applying: pending/0098-mac80211-tasklet_enable-fix.patch
        diff -urp origin/net/mac80211/ieee80211.c new/net/mac80211/ieee80211.c
Checking kernel compatibility in:
        /lib/modules/2.6.18-8.el5/source//
grep: /lib/modules/2.6.18-8.el5/source//drivers/base/core.c: No such file or directory
grep: /lib/modules/2.6.18-8.el5/source//fs/debugfs/inode.c: No such file or directory
 * Kernel requires compatibility version:
   - Requires qdisc API compat
   - Requires non-block crypto compat
   - Requires debugfs_create_symlink compat
   - Requires delayed_work compat
   - Requires rtnl_notify API compat
   - Requires class_dev -> dev API compat
   - Requires to_net_dev API compat
   - Requires dev_release API compat
   - Requires genetlink removal compat
   - Requires device_rename compat
   - Requires net_sch_fifo compat
   - Requires skb_{mac,transport,network}_header compat
   - Requires ilog2 compat
   - Requires seq_open() const parameter compat
   - Requires tcf_destroy_chain() compat
   - Requires debugfs_rename() compat
Building compatibility version in 'compatible/' directory:
Copying compatible/ from modified/...done
 + Applying: patches/qdisc-api.patch
        Use older qdisc API for qdisc_create_dflt
 + Applying: patches/block-cipher.patch
        Switch crypto system to older non-block cipher algorithms.
 + Applying: patches/debugfs_create_symlink.patch
        diff -upr pre/net/mac80211/debugfs_key.c post/net/mac80211/debugfs_key.c
 + Applying: patches/delayed_work.patch
        Add delayed_work structure compatibility.
 + Running: delayed_work.sh
        Use compat_ delayed_work functions to fix argument issues.
 + Applying: patches/rtnl_notify.patch
        Use netlink_broadcast vs. rtnl_notify
 + Applying: patches/class_dev_to_dev-wireless.patch
        Reverse class_dev to dev changes
 + Applying: patches/dev_release.patch
        Legacy device.h API (dev_uevent, dev_release, dev_attrs)
 + Applying: patches/net_sch_fifo.patch
        Add pfifo_qdisc if kernel doesn't support explicit CONFIG_NET_SCHED_FIFO
 + Applying: patches/skb_mac_header.patch
        diff -upr origin/net/mac80211/ieee80211.c update/net/mac80211/ieee80211.c
 + Running: ilog2.sh
        IEEE80211_STYPE_QOS_DATA's mask is 0x0080
 + Applying: patches/seq_open_const.patch
        diff -upr linux-2.6.18-gentoo-r6/net/wireless/wext.c linux-2.6.18-gentoo-r6-building/net/wireless/wext.c
 + Applying: patches/tcf_destroy_chain.patch
        Add tcf_destroy_chain to mac80211's wme.c
 + Applying: patches/debugfs_rename.patch
        diff -urp origin/net/mac80211/debugfs_netdev.c new/net/mac80211/debugfs_netdev.c
[root@localhost mac80211-10.0.3]# 

Afterwards I configured the Kernel ans saved the new configuration:

Linux Kernel v2.6.18-8.el5 Configuration
 &#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;
  &#9484;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472; Networking &#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9488;
  &#9474;  Arrow keys navigate the menu.  <Enter> selects submenus --->.          &#9474;  
  &#9474;  Highlighted letters are hotkeys.  Pressing <Y> includes, <N> excludes, &#9474;  
  &#9474;  <M> modularizes features.  Press <Esc><Esc> to exit, <?> for Help, </> &#9474;  
  &#9474;  for Search.  Legend: [*] built-in  [ ] excluded  <M> module  < >       &#9474;  
  &#9474; &#9484;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9488; &#9474;  
  &#9474; &#9474;--- Networking support                                               &#9474; &#9474;  
  &#9474; &#9474;      Networking options  --->                                       &#9474; &#9474;  
  &#9474; &#9474;[ ]   Amateur Radio support  --->                                    &#9474; &#9474;  
  &#9474; &#9474;< >   IrDA (infrared) subsystem support  --->                        &#9474; &#9474;  
  &#9474; &#9474;<M>   Bluetooth subsystem support  --->                              &#9474; &#9474;  
  &#9474; &#9474;<M>   Improved wireless configuration API                            &#9474; &#9474;  
  &#9474; &#9474;---   Wireless extensions                                            &#9474; &#9474;  
  &#9474; &#9474;<M>   Generic IEEE 802.11 Networking Stack (mac80211)                &#9474; &#9474;  
  &#9474; &#9474;[ ]     Enable LED triggers                                          &#9474; &#9474;  
  &#9474; &#9474;[ ]     Export mac80211 internals in DebugFS                         &#9474; &#9474;  
  &#9474; &#9474;[ ]     Enable debugging output                                      &#9474; &#9474;  
  &#9474; &#9474;<M>   Generic IEEE 802.11 Networking Stack                           &#9474; &#9474;  
  &#9474; &#9474;[ ]     Enable full debugging output                                 &#9474; &#9474;  
  &#9474; &#9474;---     IEEE 802.11 WEP encryption (802.1x)                          &#9474; &#9474;  
  &#9474; &#9474;<M>     IEEE 802.11i CCMP support                                    &#9474; &#9474;  
  &#9474; &#9474;<M>     IEEE 802.11i TKIP encryption                                 &#9474; &#9474;  
  &#9474; &#9474;<M>     Software MAC add-on to the IEEE 802.11 networking stack      &#9474; &#9474;  
  &#9474; &#9474;[*]       Enable full debugging output                               &#9474; &#9474;  
  &#9474; &#9474;<M>   TUX: Threaded linUX application protocol accelerator layer     &#9474; &#9474;  
  &#9474; &#9474;        TUX options  --->                                            &#9474; &#9474;  
  &#9474; &#9474;[*]   NetLabel subsystem support                                     &#9474; &#9474;  
  &#9474; &#9474;                                                                     &#9474; &#9474;  
  &#9474; &#9474;                                                                     &#9474; &#9474;  
  &#9474; &#9474;                                                                     &#9474; &#9474;  
  &#9474; &#9474;                                                                     &#9474; &#9474;  
  &#9474; &#9492;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9496; &#9474;  
  &#9500;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9508;  
  &#9474;                    <Select>    < Exit >    < Help >                     &#9474;  
  &#9492;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9496;  
    

[root@localhost build]# make moules modules_install
scripts/kconfig/conf -s arch/i386/Kconfig
net/mac80211/Kconfig:5:warning: 'select' used by config symbol 'MAC80211' refer to undefined symbol 'CRYPTO_ECB'
net/mac80211/Kconfig:11:warning: 'select' used by config symbol 'MAC80211' refer to undefined symbol 'NET_SCH_FIFO'
make: *** No rule to make target `moules'.  Stop.
[root@localhost build]# 

[root@localhost build]# make all
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
make[1]: *** No rule to make target `init/main.o', needed by `init/built-in.o'.  Stop.
make: *** [init] Error 2
[root@localhost build]# 









