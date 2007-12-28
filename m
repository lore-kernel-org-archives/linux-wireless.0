Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbXL1PdZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2007 10:33:25 -0500
Subject: Re: Bug or am I too stupid for installing the Intel Wirelss
	drivers for Linux?
From: Dan Williams <dcbw@redhat.com>
To: Marco =?ISO-8859-1?Q?H=F6fle?= <Marco.Hoefle@web.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <54984095@web.de>
References: <54984095@web.de>
Content-Type: text/plain; charset=utf-8
Date: Fri, 28 Dec 2007 10:32:07 -0500
Message-Id: <1198855928.23441.8.camel@localhost.localdomain> (sfid-20071228_153329_491181_E2FFA0D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-12-28 at 14:35 +0100, Marco H=C3=B6fle wrote:
> Hello,
> I am trying to get the Intel PRO wireless 3945 adapter running on Red=
Hat Linux Enterprise 5. I think there might be a bug or something in th=
e HOW-TO is missing.
> (http://intellinuxwireless.org/?p=3Dmac80211&n=3DHOWTO-mac80211)
>=20
> I am stuck in installing the MAC80211 subsystem, these are the steps =
I am doing (according to HOW-TO). The errors I get are:

Any particular reason you're doing this?  Do you just want to play with
it, or do you just want to get iwl3945 working on RHEL5?  I ask because
RHEL5 includes ipw3945 which should work already for you if you just
want to get the card to work.

In any case, since RHEL5 runs 2.6.18, you'll need to work a bit to
backport mac80211 and iwl3945.  There were some heavy crypto changes
around 2.6.18/2.6.19, and there may be quite a lot of lower level
network stack churn that you'll have to deal with.

Dan

> [root@localhost build]# make moules modules_install
> scripts/kconfig/conf -s arch/i386/Kconfig
> net/mac80211/Kconfig:5:warning: 'select' used by config symbol 'MAC80=
211' refer to undefined symbol 'CRYPTO_ECB'
> net/mac80211/Kconfig:11:warning: 'select' used by config symbol 'MAC8=
0211' refer to undefined symbol 'NET_SCH_FIFO'
> make: *** No rule to make target `moules'.  Stop.
> [root@localhost build]#=20
>=20
> [root@localhost build]# make all
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
> make[1]: *** No rule to make target `init/main.o', needed by `init/bu=
ilt-in.o'.  Stop.
> make: *** [init] Error 2
> [root@localhost build]#=20
>=20
>=20
>=20
>=20
> These are all steps I did:
>=20
> [root@localhost ~]# ls /lib/modules/$(uname -r)/build/Makefile
> /lib/modules/2.6.18-8.el5/build/Makefile
> [root@localhost ~]# uname -r
> 2.6.18-8.el5
> [root@localhost ~]#=20
>=20
>=20
> Then I opened a terminal in the /home/downloads/drivers/mac80211-10.0=
=2E3 directory and issued the make command, this is the terminal output=
:
>=20
>=20
> [root@localhost mac80211-10.0.3]# make
> Building modified version in 'modified/' directory:
> Copying modified/ from origin/...done
> Applying patches and scripts from pending/.
>  + Applying: pending/0001-mac80211-Add-basic-IEEE-802.11n-support.pat=
ch
>         From 26e77a5fef845edcb5c27db52f413e7558db0e20 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0002-mac80211-add-IEEE802.11e-WMM-structures.pat=
ch
>         From f5af9c4fdfbcc2b8ecb60d9d93657a3e2437c909 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0003-mac80211-IEEE802.11e-WMM-TS-management-and-=
DLS-supp.patch
>         From 78e5e6d438cb6ec7ba929293b112b12cf0d9042c Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0004-mac80211-debugfs-support-for-TSM-and-DLS.pa=
tch
>         From 88b531cc1ce8bd1f9681a4cbcd11bb61de3c6ca1 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0005-mac80211-IEEE802.11e-WMM-misc-fix-and-clean=
up.patch
>         From 503a88f99457be47979874f2a9a5c3454104519e Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0006-mac80211-add-WE-nick-power-and-txpower-capa=
bilitie.patch
>         From 37515341129948f6f8391cd0c8bb0028f7929c98 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0007-mac80211-Fix-user-specified-TXPOWER-from-be=
ing-over.patch
>         From aa958786201069f0a857251a777f687fc9d42219 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0008-mac80211-HT-IEEE_802.11n_TX_AMPDU-send-actf=
rames.patch
>         From 70fb3487d26d431401e4b659e520177eb434e343 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0009-mac80211-HT-add-IEEE-802.11n-TX_AMPDU-API.p=
atch
>         From fc5dcdadd03063981268f4df8ef7ffd9519e25f9 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0010-mac80211-HT-add-TX-AMPDU-MLME-data.patch
>         From 51bc2c9e296a5f6ec210eee04c882fdb4997c130 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0011-mac80211-HT-IEEE-802.11n-TX-AMPDU-MLME-impl=
ementa.patch
>         From a2c09ed2b5cc19d3fdee0b4d3a25ac82c973cd77 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0012-mac80211-HT-IEEE-802.11n-debugfs-support.pa=
tch
>         From 915fb0b275fae6748a38ece9a67a99129fcf3cc8 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0013-mac80211-HT-IEEE-802.11n-block-ack-support.=
patch
>         From 0d1fde009eb108f3f379e0868b600c12f7cd943d Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0014-mac80211-HT-IEEE-802.11n-block-ack-debugfs-=
suppor.patch
>         From 18fcded749fc76222844afc055128da88dbc03d8 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0015-mac80211-HT-add-IEEE-802.11n-qos-queues.pat=
ch
>         From 1fa8243b4711e74d3158e396f3f3971ed103d482 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0016-mac80211-HT-IEEE-802.11n-RX-aggregation-BAR=
-supor.patch
>         From e410f6580a9462480cbf3a8f3ecc601e1d8b5fb5 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0017-mac80211-HT-IEEE-802.11n-RX-aggregation-API=
-and-M.patch
>         From 428ee27143824bc868a301bb46d9cc34e76a17b6 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0018-mac80211-HT-add-addtional-type-parameter-fo=
r-ieee.patch
>         From 454d6bf4ab1a52a73fe9d5c7940588c84e7fbf5b Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0019-mac80211-HT-fix-ieee80211_send_addba_resp-i=
nterfa.patch
>         From 26c1abde043c8186b483fd29715d2a03e864ac4e Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0020-mac80211-HT-fix-master-mode-net-type.patch
>         From 0081fcc92918c45b914158219d255454e0c3bc4a Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0021-mac80211-HT-IEEE-802.11n-RX-aggregation-MLM=
E-supp.patch
>         From 8f997ba42d5da45841bb8178f5f8978c48ef2c0e Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0022-mac80211-HT-IEEE-802.11n-RX-aggregation-deb=
ugfs-s.patch
>         From 657427a497a5fd912251740ec4ee9c3b3bad0f49 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0023-mac80211-HT-AP-mode-block-ack-MLME-support.=
patch
>         From 8aff6ff750cb985bafa982b4b1ffc37029e8f013 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0024-mac80211-HT-fix-wrong-param-used-for-ieee80=
211_ht.patch
>         From 55d47cff2f5944f3f70fbee5f2b41beccbed2762 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0025-mac80211-HT-use-KERN_DEBUG-for-HT-debugging=
-messa.patch
>         From f597c02bc8814aa0ba5b3b9fd1aa14d521b284b8 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0026-mac80211-rssi-averaging-filter.patch
>         From 4f10cf6269ce9a96d21dd220bf8991716d1be24f Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0027-mac80211-add-802.11h-channel-switch-packet-=
handling.patch
>         From 534b03cd79f6de5cb3c364289cb5fa158bef6632 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0028-mac80211-fix-compile-error-if-CONFIG_NET_SC=
HED-unde.patch
>         From 16d350730af21442636dc3ab822a8ae230fecffa Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0029-mac80211-add-rate-scaling-algorithm-selecti=
on-capab.patch
>         From 0f936737d9f8cc3a8886f4590c73b20918df213c Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0030-mac80211-fix-monitor-mode.patch
>         From c334da6f6fe935e278ad5fde78e192d16d3c1603 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0031-mac80211-fix-an-printk-warning-for-size_t.p=
atch
>         From 465d7fb3ee021c8fe50a49432dfc461a4e4595d9 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0032-mac80211-fix-kernel-panic-during-shutdown-t=
ime.patch
>         From a8f8bdd27fbac5f91aabe206f829592facb486a3 Mon Sep 17 00:0=
0:00 2001
>  + Applying: pending/0033-mac80211-fix-a-msdu-header.patch
> =20
>  + Applying: pending/0090-mac80211-IPv6-fix.patch
>         The patch below seems to work for me w/ an otherwise stock F-=
7 kernel
>  + Applying: pending/0091-mac80211-fix-hidden-ssid.patch
>         diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ie=
ee80211_ioctl.c
>  + Applying: pending/0092-mac80211-sta-hw-scanning.patch
>         diff -urp mac80211/ieee80211.c /home/chuyee/mac80211/ieee8021=
1.c
>  + Applying: pending/0093-mac80211-clean-extra-ie.patch
>         --- a/net/mac80211/ieee80211.c  2007-11-15 19:49:57.000000000=
 +0800
>  + Applying: pending/0094-mac80211-hw-scan-fix-1.patch
>         diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee=
80211_sta.c
>  + Applying: pending/0095-mac80211-hw-scan-fix-2.patch
>         diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee=
80211_sta.c
>  + Applying: pending/0096-mac80211-workaround-wpa-reassoc.patch
>         diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ie=
ee80211_ioctl.c
>  + Applying: pending/0097-mac80211-ht-agg-teardown-fix.patch
>         diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.=
c
>  + Applying: pending/0098-mac80211-tasklet_enable-fix.patch
>         diff -urp origin/net/mac80211/ieee80211.c new/net/mac80211/ie=
ee80211.c
> Checking kernel compatibility in:
>         /lib/modules/2.6.18-8.el5/source//
> grep: /lib/modules/2.6.18-8.el5/source//drivers/base/core.c: No such =
file or directory
> grep: /lib/modules/2.6.18-8.el5/source//fs/debugfs/inode.c: No such f=
ile or directory
>  * Kernel requires compatibility version:
>    - Requires qdisc API compat
>    - Requires non-block crypto compat
>    - Requires debugfs_create_symlink compat
>    - Requires delayed_work compat
>    - Requires rtnl_notify API compat
>    - Requires class_dev -> dev API compat
>    - Requires to_net_dev API compat
>    - Requires dev_release API compat
>    - Requires genetlink removal compat
>    - Requires device_rename compat
>    - Requires net_sch_fifo compat
>    - Requires skb_{mac,transport,network}_header compat
>    - Requires ilog2 compat
>    - Requires seq_open() const parameter compat
>    - Requires tcf_destroy_chain() compat
>    - Requires debugfs_rename() compat
> Building compatibility version in 'compatible/' directory:
> Copying compatible/ from modified/...done
>  + Applying: patches/qdisc-api.patch
>         Use older qdisc API for qdisc_create_dflt
>  + Applying: patches/block-cipher.patch
>         Switch crypto system to older non-block cipher algorithms.
>  + Applying: patches/debugfs_create_symlink.patch
>         diff -upr pre/net/mac80211/debugfs_key.c post/net/mac80211/de=
bugfs_key.c
>  + Applying: patches/delayed_work.patch
>         Add delayed_work structure compatibility.
>  + Running: delayed_work.sh
>         Use compat_ delayed_work functions to fix argument issues.
>  + Applying: patches/rtnl_notify.patch
>         Use netlink_broadcast vs. rtnl_notify
>  + Applying: patches/class_dev_to_dev-wireless.patch
>         Reverse class_dev to dev changes
>  + Applying: patches/dev_release.patch
>         Legacy device.h API (dev_uevent, dev_release, dev_attrs)
>  + Applying: patches/net_sch_fifo.patch
>         Add pfifo_qdisc if kernel doesn't support explicit CONFIG_NET=
_SCHED_FIFO
>  + Applying: patches/skb_mac_header.patch
>         diff -upr origin/net/mac80211/ieee80211.c update/net/mac80211=
/ieee80211.c
>  + Running: ilog2.sh
>         IEEE80211_STYPE_QOS_DATA's mask is 0x0080
>  + Applying: patches/seq_open_const.patch
>         diff -upr linux-2.6.18-gentoo-r6/net/wireless/wext.c linux-2.=
6.18-gentoo-r6-building/net/wireless/wext.c
>  + Applying: patches/tcf_destroy_chain.patch
>         Add tcf_destroy_chain to mac80211's wme.c
>  + Applying: patches/debugfs_rename.patch
>         diff -urp origin/net/mac80211/debugfs_netdev.c new/net/mac802=
11/debugfs_netdev.c
> [root@localhost mac80211-10.0.3]#=20
>=20
> Afterwards I configured the Kernel ans saved the new configuration:
>=20
> Linux Kernel v2.6.18-8.el5 Configuration
>  &#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#947=
2;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472=
;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;=
&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&=
#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#=
9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9=
472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#94=
72;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;
>   &#9484;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#94=
72;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#947=
2;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472=
;&#9472; Networking &#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#=
9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9=
472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#94=
72;&#9472;&#9472;&#9472;&#9488;
>   &#9474;  Arrow keys navigate the menu.  <Enter> selects submenus --=
->.          &#9474; =20
>   &#9474;  Highlighted letters are hotkeys.  Pressing <Y> includes, <=
N> excludes, &#9474; =20
>   &#9474;  <M> modularizes features.  Press <Esc><Esc> to exit, <?> f=
or Help, </> &#9474; =20
>   &#9474;  for Search.  Legend: [*] built-in  [ ] excluded  <M> modul=
e  < >       &#9474; =20
>   &#9474; &#9484;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9=
472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#94=
72;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#947=
2;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472=
;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;=
&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&=
#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#=
9472;&#9488; &#9474; =20
>   &#9474; &#9474;--- Networking support                              =
                 &#9474; &#9474; =20
>   &#9474; &#9474;      Networking options  --->                      =
                 &#9474; &#9474; =20
>   &#9474; &#9474;[ ]   Amateur Radio support  --->                   =
                 &#9474; &#9474; =20
>   &#9474; &#9474;< >   IrDA (infrared) subsystem support  --->       =
                 &#9474; &#9474; =20
>   &#9474; &#9474;<M>   Bluetooth subsystem support  --->             =
                 &#9474; &#9474; =20
>   &#9474; &#9474;<M>   Improved wireless configuration API           =
                 &#9474; &#9474; =20
>   &#9474; &#9474;---   Wireless extensions                           =
                 &#9474; &#9474; =20
>   &#9474; &#9474;<M>   Generic IEEE 802.11 Networking Stack (mac80211=
)                &#9474; &#9474; =20
>   &#9474; &#9474;[ ]     Enable LED triggers                         =
                 &#9474; &#9474; =20
>   &#9474; &#9474;[ ]     Export mac80211 internals in DebugFS        =
                 &#9474; &#9474; =20
>   &#9474; &#9474;[ ]     Enable debugging output                     =
                 &#9474; &#9474; =20
>   &#9474; &#9474;<M>   Generic IEEE 802.11 Networking Stack          =
                 &#9474; &#9474; =20
>   &#9474; &#9474;[ ]     Enable full debugging output                =
                 &#9474; &#9474; =20
>   &#9474; &#9474;---     IEEE 802.11 WEP encryption (802.1x)         =
                 &#9474; &#9474; =20
>   &#9474; &#9474;<M>     IEEE 802.11i CCMP support                   =
                 &#9474; &#9474; =20
>   &#9474; &#9474;<M>     IEEE 802.11i TKIP encryption                =
                 &#9474; &#9474; =20
>   &#9474; &#9474;<M>     Software MAC add-on to the IEEE 802.11 netwo=
rking stack      &#9474; &#9474; =20
>   &#9474; &#9474;[*]       Enable full debugging output              =
                 &#9474; &#9474; =20
>   &#9474; &#9474;<M>   TUX: Threaded linUX application protocol accel=
erator layer     &#9474; &#9474; =20
>   &#9474; &#9474;        TUX options  --->                           =
                 &#9474; &#9474; =20
>   &#9474; &#9474;[*]   NetLabel subsystem support                    =
                 &#9474; &#9474; =20
>   &#9474; &#9474;                                                    =
                 &#9474; &#9474; =20
>   &#9474; &#9474;                                                    =
                 &#9474; &#9474; =20
>   &#9474; &#9474;                                                    =
                 &#9474; &#9474; =20
>   &#9474; &#9474;                                                    =
                 &#9474; &#9474; =20
>   &#9474; &#9492;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9=
472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#94=
72;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#947=
2;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472=
;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;=
&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&=
#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#=
9472;&#9496; &#9474; =20
>   &#9500;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#94=
72;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#947=
2;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472=
;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;=
&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&=
#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#=
9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9=
472;&#9472;&#9472;&#9472;&#9508; =20
>   &#9474;                    <Select>    < Exit >    < Help >        =
             &#9474; =20
>   &#9492;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#94=
72;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#947=
2;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472=
;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;=
&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&=
#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#=
9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9472;&#9=
472;&#9472;&#9472;&#9472;&#9496; =20
>    =20
>=20
> [root@localhost build]# make moules modules_install
> scripts/kconfig/conf -s arch/i386/Kconfig
> net/mac80211/Kconfig:5:warning: 'select' used by config symbol 'MAC80=
211' refer to undefined symbol 'CRYPTO_ECB'
> net/mac80211/Kconfig:11:warning: 'select' used by config symbol 'MAC8=
0211' refer to undefined symbol 'NET_SCH_FIFO'
> make: *** No rule to make target `moules'.  Stop.
> [root@localhost build]#=20
>=20
> [root@localhost build]# make all
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
> make[1]: *** No rule to make target `init/main.o', needed by `init/bu=
ilt-in.o'.  Stop.
> make: *** [init] Error 2
> [root@localhost build]#=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
