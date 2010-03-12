Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:53905 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab0CLTHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 14:07:11 -0500
Message-ID: <4B9A90B4.2030801@fami-braun.de>
Date: Fri, 12 Mar 2010 20:06:28 +0100
From: michael-dev@fami-braun.de
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless-2.6 with cfg80211 is broken on 2.6.33
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCD6154AC50CCF0E1F6732F49"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCD6154AC50CCF0E1F6732F49
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I've been trying to use bleeding edge wireless-testing on a stable
2.6.33 with a ath9k card. The kernel is x86 (AMD Geode LX) and
all wireless modules are build as .ko-files as far as possible.
Hostapd also starts fine and offers connectivity, though
some simple commands such is iwconfig a causing OOPSses and
some more sophisticated things like wireless vlan separation just does
not work (packages show up in the wrong vlan).

Debugging the OOPs with kgdb turned out that the struct wiphy has been
changed in cfg80211.h since 2.6.33 has been released. The newly build
cfg80211 correctly uses the new definition, though some core
functionality of the kernel still uses the old wiphy struct and
therefore fails to dereference the wext pointer in the wiphy struct.

Please find extracts of .config and kgdb output attached, more
information can be provided upon request.
I'm currently stuck on how to build a 2.6.33 kernel compatible to
wireless-testing drivers. If possible, I'd like to avoid replacing the
entire kernel with an unstable build.

Thanks a lot in advance,
Michael

--
=2E..
>> .config >>
CONFIG_WIRELESS=3Dy
CONFIG_WIRELESS_EXT=3Dy
CONFIG_WEXT_CORE=3Dy
CONFIG_WEXT_PROC=3Dy
CONFIG_WEXT_SPY=3Dy
CONFIG_WEXT_PRIV=3Dy
CONFIG_CFG80211=3Dm
CONFIG_NL80211_TESTMODE=3Dy
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=3Dy
CONFIG_CFG80211_DEFAULT_PS=3Dy
CONFIG_CFG80211_DEBUGFS=3Dy
# CONFIG_WIRELESS_OLD_REGULATORY is not set
CONFIG_CFG80211_WEXT=3Dy
CONFIG_WIRELESS_EXT_SYSFS=3Dy
CONFIG_LIB80211=3Dm
CONFIG_LIB80211_CRYPT_WEP=3Dm
CONFIG_LIB80211_CRYPT_CCMP=3Dm
CONFIG_LIB80211_CRYPT_TKIP=3Dm
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=3Dm
CONFIG_MAC80211_RC_PID=3Dy
CONFIG_MAC80211_RC_MINSTREL=3Dy
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=3Dy
CONFIG_MAC80211_RC_DEFAULT=3D"minstrel"
CONFIG_MAC80211_MESH=3Dy
CONFIG_MAC80211_LEDS=3Dy
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_WIMAX is not set
CONFIG_RFKILL=3Dm
CONFIG_RFKILL_LEDS=3Dy
# CONFIG_RFKILL_INPUT is not set
# CONFIG_NET_9P is not set

=2E..
CONFIG_WLAN=3Dy
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_MAC80211_HWSIM is not set
# CONFIG_MWL8K is not set
CONFIG_ATH_COMMON=3Dm
CONFIG_ATH_DEBUG=3Dy
CONFIG_ATH5K=3Dm
CONFIG_ATH5K_DEBUG=3Dy
CONFIG_ATH9K_HW=3Dm
CONFIG_ATH9K_COMMON=3Dm
CONFIG_ATH9K=3Dm
CONFIG_ATH9K_DEBUGFS=3Dy
CONFIG_AR9170_USB=3Dm
CONFIG_AR9170_LEDS=3Dy
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_HOSTAP=3Dm
CONFIG_HOSTAP_FIRMWARE=3Dy
CONFIG_HOSTAP_FIRMWARE_NVRAM=3Dy
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_HOSTAP_CS is not set
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_IWLWIFI is not set
# CONFIG_LIBERTAS is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_RT2X00 is not set
# CONFIG_WL12XX is not set
# CONFIG_ZD1211RW is not set
=2E..

>> kgdb >>
[  192.125780] BUG: unable to handle kernel NULL pointer dereference at
00000005
[  192.126320] IP: [<c03d81bb>] wext_handle_ioctl+0xfb/0x1e7
[  192.126320] *pde =3D 00000000
[  192.126320] Oops: 0000 [#1] PREEMPT
[  192.126320] last sysfs file: /sys/class/net/lo/operstate
[  192.126320] KGDB: Waiting for remote debugger

Remote debugging using /dev/ttyS0
get_handler (net=3D<value optimized out>, ifr=3D0xcfa77eb8, cmd=3D35585,
    arg=3D0xbfc59490) at net/wireless/wext-core.c:666
666		if (index < handlers->num_standard)
(gdb) bt full
#0  get_handler (net=3D<value optimized out>, ifr=3D0xcfa77eb8, cmd=3D355=
85,
    arg=3D0xbfc59490) at net/wireless/wext-core.c:666
        index =3D 1
        handlers =3D 0x1
#1  wireless_process_ioctl (net=3D<value optimized out>, ifr=3D0xcfa77eb8=
,
    cmd=3D35585, arg=3D0xbfc59490) at net/wireless/wext-core.c:896
        iwr =3D 0xcfa77eb8
        dev =3D 0xcfd01820
        handler =3D <value optimized out>
#2  wext_ioctl_dispatch (net=3D<value optimized out>, ifr=3D0xcfa77eb8,
cmd=3D35585,
    arg=3D0xbfc59490) at net/wireless/wext-core.c:936
No locals.
#3  wext_handle_ioctl (net=3D<value optimized out>, ifr=3D0xcfa77eb8,
cmd=3D35585,
    arg=3D0xbfc59490) at net/wireless/wext-core.c:992
        info =3D {cmd =3D 35585, flags =3D 0}
        ret =3D 1
#4  0xc035ac2d in dev_ioctl (net=3D0xc0588e80, cmd=3D35585,
    arg=3D<value optimized out>) at net/core/dev.c:4739
        ifr =3D {ifr_ifrn =3D {
            ifrn_name =3D "wlan0\000=C5=BF\000\000\000\000\000\000\000"},=

          ifr_ifru =3D {ifru_addr =3D {sa_family =3D 0,
              sa_data =3D '\000' <repeats 13 times>}, ifru_dstaddr =3D {
              sa_family =3D 0, sa_data =3D '\000' <repeats 13 times>},
---Type <return> to continue, or q <return> to quit---
            ifru_broadaddr =3D {sa_family =3D 0,
              sa_data =3D '\000' <repeats 13 times>}, ifru_netmask =3D {
              sa_family =3D 0, sa_data =3D '\000' <repeats 13 times>},
            ifru_hwaddr =3D {sa_family =3D 0,
              sa_data =3D '\000' <repeats 13 times>}, ifru_flags =3D 0,
            ifru_ivalue =3D 0, ifru_mtu =3D 0, ifru_map =3D {mem_start =3D=
 0,
              mem_end =3D 0, base_addr =3D 0, irq =3D 0 '\000', dma =3D 0=
 '\000',
              port =3D 0 '\000'}, ifru_slave =3D '\000' <repeats 15 times=
>,
            ifru_newname =3D '\000' <repeats 15 times>, ifru_data =3D 0x0=
,
            ifru_settings =3D {type =3D 0, size =3D 0, ifs_ifsu =3D {raw_=
hdlc =3D
0x0,
                cisco =3D 0x0, fr =3D 0x0, fr_pvc =3D 0x0, fr_pvc_info =3D=
 0x0,
                sync =3D 0x0, te1 =3D 0x0}}}}
        ret =3D <value optimized out>
        colon =3D 0x0
#5  0xc03498dc in sock_ioctl (file=3D<value optimized out>, cmd=3D35585, =
arg=3D1)
    at net/socket.c:941
        sock =3D 0xcfedd000
        argp =3D 0xbfc59490
        err =3D <value optimized out>
#6  0xc0185b09 in vfs_ioctl (filp=3D0xcfef1740, cmd=3D35585, arg=3D321739=
6880)
    at fs/ioctl.c:46
        error =3D <value optimized out>
        __func__ =3D "vfs_ioctl"
---Type <return> to continue, or q <return> to quit---
#7  0xc0186179 in do_vfs_ioctl (filp=3D0xcfef1740, fd=3D<value optimized =
out>,
    cmd=3D3483860664, arg=3D3217396880) at fs/ioctl.c:604
        error =3D <value optimized out>
        argp =3D 0xbfc59490
#8  0xc01861e5 in sys_ioctl (fd=3D5, cmd=3D35585, arg=3D3217396880) at
fs/ioctl.c:624
        filp =3D 0xcfef1740
        error =3D -9
        fput_needed =3D 0
#9  0xc03e0971 in ?? () at arch/x86/kernel/entry_32.S:541
No locals.
Backtrace stopped: previous frame inner to this frame (corrupt stack?)

(gdb) print *dev
$8 =3D {name =3D "wlan0\000\000\000\000\000\000\000\000\000\000", name_hl=
ist =3D {
    next =3D 0x0, pprev =3D 0xcf81ecc4}, ifalias =3D 0x0, mem_end =3D 0,
  mem_start =3D 0, base_addr =3D 0, irq =3D 0, if_port =3D 0 '\000', dma =
=3D 0
'\000',
  state =3D 3, dev_list =3D {next =3D 0xcf8b0554, prev =3D 0xcfcb8ad4},
napi_list =3D {
    next =3D 0xcfd0185c, prev =3D 0xcfd0185c}, unreg_list =3D {next =3D 0=
xcfd01864,
    prev =3D 0xcfd01864}, features =3D 8192, ifindex =3D 8, iflink =3D 8,=
 stats =3D {
    rx_packets =3D 0, tx_packets =3D 74, rx_bytes =3D 0, tx_bytes =3D 506=
8,
    rx_errors =3D 0, tx_errors =3D 0, rx_dropped =3D 0, tx_dropped =3D 0,=

    multicast =3D 0, collisions =3D 0, rx_length_errors =3D 0, rx_over_er=
rors
=3D 0,
    rx_crc_errors =3D 0, rx_frame_errors =3D 0, rx_fifo_errors =3D 0,
    rx_missed_errors =3D 0, tx_aborted_errors =3D 0, tx_carrier_errors =3D=
 0,
    tx_fifo_errors =3D 0, tx_heartbeat_errors =3D 0, tx_window_errors =3D=
 0,
    rx_compressed =3D 0, tx_compressed =3D 0}, wireless_handlers =3D 0x0,=

  wireless_data =3D 0x0, netdev_ops =3D 0xd1690c60, ethtool_ops =3D 0xd0d=
b5140,
  header_ops =3D 0xc0412b00, flags =3D 4355, gflags =3D 0, priv_flags =3D=
 1024,
  padded =3D 24, operstate =3D 0 '\000', link_mode =3D 0 '\000', mtu =3D =
1500,
  type =3D 1, hard_header_len =3D 14, needed_headroom =3D 53, needed_tail=
room
=3D 18,
  master =3D 0x0,
  perm_addr =3D "\000\016\216\031\356v", '\000' <repeats 25 times>,
  addr_len =3D 6 '\006', dev_id =3D 0, uc =3D {list =3D {next =3D 0xcfd01=
928,
      prev =3D 0xcfd01928}, count =3D 0}, uc_promisc =3D 0, addr_list_loc=
k =3D {{
      rlock =3D {raw_lock =3D {<No data fields>}}}}, mc_list =3D 0xcfa4f6=
0c,
  mc_count =3D 3, promiscuity =3D 1, allmulti =3D 0, atalk_ptr =3D 0x0,
---Type <return> to continue, or q <return> to quit---
  ip_ptr =3D 0xcf9910a0, dn_ptr =3D 0x0, ip6_ptr =3D 0xcf9904e8, ec_ptr =3D=
 0x0,
  ax25_ptr =3D 0x0, ieee80211_ptr =3D 0xcfd01ae8, last_rx =3D 0,
  dev_addr =3D 0xcf999404 "", dev_addrs =3D {list =3D {next =3D 0xcf9993f=
c,
      prev =3D 0xcf9993fc}, count =3D 1},
  broadcast =3D "\377\377\377\377\377\377", '\000' <repeats 25 times>,
  rx_queue =3D {dev =3D 0xcfd01820, qdisc =3D 0xc04f5620, state =3D 0,
    qdisc_sleeping =3D 0xc04f5620, _xmit_lock =3D {{rlock =3D {
          raw_lock =3D {<No data fields>}}}}, xmit_lock_owner =3D -1,
    trans_start =3D 0, tx_bytes =3D 0, tx_packets =3D 0, tx_dropped =3D 0=
},
  _tx =3D 0xcf999368, num_tx_queues =3D 4, real_num_tx_queues =3D 4,
  qdisc =3D 0xcf91d040, tx_queue_len =3D 1000, tx_global_lock =3D {{rlock=
 =3D {
        raw_lock =3D {<No data fields>}}}}, trans_start =3D 4294828304,
  watchdog_timeo =3D 0, watchdog_timer =3D {entry =3D {next =3D 0x0, prev=
 =3D 0x0},
    expires =3D 0, function =3D 0xc036631a <dev_watchdog>, data =3D 34865=
21376,
    base =3D 0xc056e400}, refcnt =3D {counter =3D 13}, todo_list =3D {nex=
t =3D 0x0,
    prev =3D 0x0}, index_hlist =3D {next =3D 0x0, pprev =3D 0xcf844024},
  link_watch_list =3D {next =3D 0xcfd01a04, prev =3D 0xcfd01a04},
  reg_state =3D NETREG_REGISTERED, destructor =3D 0xc0356fef <free_netdev=
>,
  ml_priv =3D 0x0, br_port =3D 0xcfa06e78, macvlan_port =3D 0x0, garp_por=
t =3D 0x0,
  dev =3D {parent =3D 0xcf845374, p =3D 0xcf99949c, kobj =3D {
      name =3D 0xcf999130 "wlan0", entry =3D {next =3D 0xcf9fbdd8,
        prev =3D 0xcf905478}, parent =3D 0xcf843ed4, kset =3D 0xcf808b04,=

      ktype =3D 0xc04f0cac, sd =3D 0xcf9991cc, kref =3D {refcount =3D {co=
unter =3D
4}},
---Type <return> to continue, or q <return> to quit---
      state_initialized =3D 1, state_in_sysfs =3D 1, state_add_uevent_sen=
t =3D 1,
      state_remove_uevent_sent =3D 0, uevent_suppress =3D 0}, init_name =3D=
 0x0,
    type =3D 0xd0db787c, sem =3D {lock =3D {{rlock =3D {
            raw_lock =3D {<No data fields>}}}}, count =3D 1, wait_list =3D=
 {
        next =3D 0xcfd01a5c, prev =3D 0xcfd01a5c}}, bus =3D 0x0, driver =3D=
 0x0,
    platform_data =3D 0xcfd01820, power =3D {power_state =3D {event =3D 0=
},
      can_wakeup =3D 0, should_wakeup =3D 0, status =3D DPM_INVALID},
    dma_mask =3D 0x0, coherent_dma_mask =3D 0, dma_parms =3D 0x0, dma_poo=
ls =3D {
      next =3D 0xcfd01a8c, prev =3D 0xcfd01a8c}, dma_mem =3D 0x0, archdat=
a =3D {
      acpi_handle =3D 0x0}, devt =3D 0, devres_lock =3D {{rlock =3D {
          raw_lock =3D {<No data fields>}}}}, devres_head =3D {next =3D
0xcfd01aa0,
      prev =3D 0xcfd01aa0}, knode_class =3D {n_klist =3D 0xcf843efc, n_no=
de =3D {
        next =3D 0xcf8b07ac, prev =3D 0xcfcb8d2c}, n_ref =3D {refcount =3D=
 {
          counter =3D 1}}}, class =3D 0xc04f50e0, groups =3D 0xcfd01ac4,
    release =3D 0}, sysfs_groups =3D {0xc04f5114, 0xc04f5120, 0x0, 0x0},
  rtnl_link_ops =3D 0x0, vlan_features =3D 0, gso_max_size =3D 65536}

(gdb) print *dev->ieee80211_ptr
$10 =3D {wiphy =3D 0xcf0440c0, iftype =3D NL80211_IFTYPE_AP, list =3D {
    next =3D 0xcf044050, prev =3D 0xcfc36a70}, netdev =3D 0xcfd01820, mtx=
 =3D {
    count =3D {counter =3D -811498776}, wait_lock =3D {{rlock =3D {
          raw_lock =3D {<No data fields>}}}}, wait_list =3D {next =3D 0xc=
fa182e8,
      prev =3D 0x1}}, cleanup_work =3D {data =3D {counter =3D -808445176}=
, entry =3D {
      next =3D 0xcfd01b08, prev =3D 0x0}, func =3D 0xcfd01b14}, use_4addr=
 =3D 20,
  ssid =3D "\033\320=CF=BE\344\331\320", '\000' <repeats 24 times>,
  ssid_len =3D 0 '\000', sme_state =3D CFG80211_SME_IDLE, conn =3D 0x0,
  connect_keys =3D 0x0, event_list =3D {next =3D 0x0, prev =3D 0x0}, even=
t_lock =3D {{
      rlock =3D {raw_lock =3D {<No data fields>}}}}, authtry_bsses =3D
{0xcfd01b50,
    0xcfd01b50, 0x0, 0x0}, auth_bsses =3D {0x0, 0x0, 0x0, 0x0},
  current_bss =3D 0x0, wext =3D {ibss =3D {ssid =3D 0x0, bssid =3D 0x0, c=
hannel =3D
0x0,
      ie =3D 0x64 <Address 0x64 out of bounds>, ssid_len =3D 0 '\000',
      ie_len =3D 0 '\000', beacon_interval =3D 0, channel_fixed =3D false=
,
      privacy =3D false}, connect =3D {channel =3D 0x0, bssid =3D 0x0, ss=
id =3D 0x0,
      ssid_len =3D 0, auth_type =3D NL80211_AUTHTYPE_OPEN_SYSTEM, ie =3D =
0x0,
      ie_len =3D 0, privacy =3D false, crypto =3D {wpa_versions =3D 4,
        cipher_group =3D 0, n_ciphers_pairwise =3D 0, ciphers_pairwise =3D=
 {0,
0, 0,
          0, 0}, n_akm_suites =3D 0, akm_suites =3D {0, 0}, control_port =
=3D
false},
      key =3D 0x0, key_len =3D 0 '\000', key_idx =3D 0 '\000'}, keys =3D =
0x0,
    ie =3D 0x0, ie_len =3D 0, bssid =3D "\000\000\000\000\000",
    prev_bssid =3D "\000\000\000\000\000", ssid =3D '\000' <repeats 31 ti=
mes>,
    default_key =3D 0 '\000', default_mgmt_key =3D 0 '\000', ps =3D false=
,
---Type <return> to continue, or q <return> to quit---
    prev_bssid_valid =3D false, ps_timeout =3D 0}}

(gdb) print *dev->ieee80211_ptr->wiphy
$12 =3D {perm_addr =3D "\000\016\216\031\356v", interface_modes =3D 0, fl=
ags =3D 0,
  signal_type =3D CFG80211_SIGNAL_TYPE_NONE, bss_priv_size =3D 0,
  max_scan_ssids =3D 222 '\336', max_scan_ie_len =3D 0, n_cipher_suites =3D=
 106,
  cipher_suites =3D 0x1, retry_short =3D 96 '`', retry_long =3D 0 '\000',=

  frag_threshold =3D 148111364, rts_threshold =3D 5,
  fw_version =3D "@\vi\321\a\004\000\000\377\377\377\377\377\377\377\377"=
,
'\000' <repeats 15 times>, hw_version =3D 0, max_num_pmkids =3D 0 '\000',=

privid =3D 0x0,
  bands =3D {0x0, 0x0}, reg_notifier =3D 0, regd =3D 0x0, dev =3D {
    parent =3D 0xd1693734, p =3D 0xcf044cd8, kobj =3D {name =3D 0xcf044d0=
4 "",
      entry =3D {next =3D 0xd18dc5a5, prev =3D 0xcf9f3508}, parent =3D 0x=
cf845374,
      kset =3D 0xcf9976b0, ktype =3D 0xcf8ee8cc, sd =3D 0xcf905478, kref =
=3D {
        refcount =3D {counter =3D -812108172}}, state_initialized =3D 0,
      state_in_sysfs =3D 0, state_add_uevent_sent =3D 1,
      state_remove_uevent_sent =3D 0, uevent_suppress =3D 1},
    init_name =3D 0xcf808b04
"\f\016O\300\200\032\301\316t\201\200\317\020\213\200\317\020\213\200",
<incomplete sequence \317>, type =3D 0xc04f0cac, sem =3D {
      lock =3D {{rlock =3D {raw_lock =3D {<No data fields>}}}}, count =3D=

3482941176,
      wait_list =3D {next =3D 0x4, prev =3D 0x7}}, bus =3D 0x0, driver =3D=
 0x0,
    platform_data =3D 0x1, power =3D {power_state =3D {event =3D -8218046=
84},
      can_wakeup =3D 0, should_wakeup =3D 0, status =3D DPM_INVALID},
    dma_mask =3D 0x0, coherent_dma_mask =3D 3473162240, dma_parms =3D 0x0=
,
    dma_pools =3D {next =3D 0x0, prev =3D 0x0}, dma_mem =3D 0x0, archdata=
 =3D {
      acpi_handle =3D 0x0}, devt =3D 0, devres_lock =3D {{rlock =3D {
---Type <return> to continue, or q <return> to quit---
          raw_lock =3D {<No data fields>}}}}, devres_head =3D {next =3D
0xcf0441a4,
      prev =3D 0xcf0441a4}, knode_class =3D {n_klist =3D 0x0, n_node =3D =
{next =3D
0x0,
        prev =3D 0x0}, n_ref =3D {refcount =3D {counter =3D -821804616}}}=
,
    class =3D 0xcf0441b8, groups =3D 0xcf98ac3c, release =3D 0xcf98ac3c},=

  debugfsdir =3D 0xcf98ac3c, wext =3D 0x1,
  priv =3D 0xcf0441e0 "\350T\333", <incomplete sequence \320>}


Please not the missing addr_mask field in wiphy.


--------------enigCD6154AC50CCF0E1F6732F49
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkuakLkACgkQ+6sI4XSM4u3NRACbBTmtFAEC21wZHuNgrAjOSwFB
93cAn30KX9zBVNOaETmFgL52CtMENF1Q
=JdlF
-----END PGP SIGNATURE-----

--------------enigCD6154AC50CCF0E1F6732F49--
