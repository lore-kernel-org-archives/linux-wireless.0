Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.ust.hk ([143.89.13.26]:63893 "EHLO mx4.ust.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab0BAEG1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 23:06:27 -0500
Message-ID: <49849.143.89.144.207.1264997174.squirrel@sqmail.ust.hk>
In-Reply-To: <1264786546.27755.9.camel@mj>
References: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
    <43e72e891001260853s4811bc39s2399d138d0a7da83@mail.gmail.com>
    <47088.143.89.144.207.1264589300.squirrel@sqmail.ust.hk>
    <43e72e891001271006l3422b6e2iccb89954feeaa34b@mail.gmail.com>
    <58444.143.89.144.207.1264747272.squirrel@sqmail.ust.hk>
    <1264786546.27755.9.camel@mj>
Date: Mon, 1 Feb 2010 12:06:14 +0800 (HKT)
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for
     PowerPC architecture
From: "PAN Sunny S K" <sunnypan@ust.hk>
To: "Pavel Roskin" <proski@gnu.org>
Cc: "PAN Sunny S K" <sunnypan@ust.hk>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

It is unfortunate that the ath_pci is dependent on ath. Moreover, after
some trial, found that the rfkill_backport and cfg80211 also have problem
in loading which is possibly due to the lacking of other symbolic link in
the current kernel or other modules.
Since other issues (iw, libnl... etc) makes the difficulties in
integrating ath9k into the current LTIB harder than using of OpenWrt with
the latest kernel  (although still have some problem in building of
OpenWrt for the platform). I've since moved the effort to building of
OpenWrt.
Anyhow, many thanks for the advice and below please find a snapshot of the
error output from the ath9k with kernel 2.6.25 from LTIB for your future
reference.

ath: Unknown symbol wiphy_apply_custom_regulatory

ath: Unknown symbol freq_reg_info

ath_pci: Unknown symbol ath_config_crypto_get

ath_pci: Unknown symbol ath_config_ioctl_getwscie

ath_pci: Unknown symbol ath_config_ioctl_addmac

ath_pci: Unknown symbol ath_config_ioctl_delkey

ath_pci: Unknown symbol ath_config_set_txmode

ath_pci: Unknown symbol ath_config_ioctl_getkey

ath_pci: Unknown symbol ath_config_set_rate

ath_pci: Unknown symbol ath_config_getstastats

ath_pci: Unknown symbol ath_config_ioctl_getchaninfo

ath_pci: Unknown symbol ath_config_set_phy_mode

ath_pci: Unknown symbol ath_config_setparam

ath_pci: Unknown symbol ath_config_set_ap

ath_pci: Unknown symbol ath_config_set_essid

ath_pci: Unknown symbol ath_config_crypto_set

ath_pci: Unknown symbol ath_config_set_nickn

ath_pci: Unknown symbol ath_config_getwmmparams

ath_pci: Unknown symbol ath_config_ioctl_sendaddba

ath_pci: Unknown symbol ath_config_get_chanlist

ath_pci: Unknown symbol ath_config_get_frag

ath_pci: Unknown symbol ath_config_vdev_getstats

ath_pci: Unknown symbol ath_config_getcounter

ath_pci: Unknown symbol ath_config_get_nickn

ath_pci: Unknown symbol ath_config_ioctl_setaddbaresponse

ath_pci: Unknown symbol ath_config_set_power

ath_pci: Unknown symbol ath_handler_register

ath_pci: Unknown symbol ath_config_set_remote_acl_status

ath_pci: Unknown symbol ath_config_set_chanlist

ath_pci: Unknown symbol ath_config_ioctl_setkey

ath_pci: Unknown symbol set_quality

ath_pci: Unknown symbol ath_config_get_txpow

ath_pci: Unknown symbol ath_config_getstainfo

ath_pci: Unknown symbol ath_config_get_scan

ath_pci: Unknown symbol ath_config_getstats

ath_pci: Unknown symbol ath_config_ioctl_gethwdata

ath_pci: Unknown symbol ath_config_ioctl_getaddbastatus

ath_pci: Unknown symbol ath_config_ioctl_setoptie

ath_pci: Unknown symbol ath_config_ismodesupported

ath_pci: Unknown symbol ath_config_get_rate

ath_pci: Unknown symbol ath_config_get_ap

ath_pci: Unknown symbol ath_config_set_frag

ath_pci: Unknown symbol ath_config_set_channel

ath_pci: Unknown symbol ath_config_set_cwsize

ath_pci: Unknown symbol ath_config_get_phy_mode

ath_pci: Unknown symbol ath_newstate

ath_pci: Unknown symbol ath_config_get_channel_list

ath_pci: Unknown symbol ath_config_get_essid

ath_pci: Unknown symbol ath_config_ioctl_chanswitch

ath_pci: Unknown symbol ath_config_vdev_iw_getstats

ath_pci: Unknown symbol ath_config_set_txpow

ath_pci: Unknown symbol ath_config_ioctl_senddelba

ath_pci: Unknown symbol ath_set_mac_address

ath_pci: Unknown symbol ath_config_get_opmode

ath_pci: Unknown symbol ath_config_get_rate_list

ath_pci: Unknown symbol ath_config_set_scan

ath_pci: Unknown symbol ath_config_get_rts

ath_pci: Unknown symbol ath_config_ioctl_getwpaie

ath_pci: Unknown symbol ath_config_set_rts

ath_pci: Unknown symbol ath_handler_unregister

ath_pci: Unknown symbol ath_config_get_power

ath_pci: Unknown symbol ath_config_get_txmode

ath_pci: Unknown symbol ath_config_ioctl_delmac

ath_pci: Unknown symbol ath_config_getstrparam

ath_pci: Unknown symbol ath_config_ioctl_setmlme

ath_pci: Unknown symbol ath_config_getaddrparam

ath_pci: Unknown symbol ath_config_setwmmparams

ath_pci: Unknown symbol ath_config_get_wbuf

ath_pci: Unknown symbol ath_config_get_channel

ath_pci: Unknown symbol ath_iterate_vaps

ath_pci: Unknown symbol ath_config_getparam

rfkill_backport: Unknown symbol dev_set_name

rfkill_backport: Unknown symbol input_register_handle

rfkill_backport: Unknown symbol input_open_device

rfkill_backport: Unknown symbol led_trigger_unregister

rfkill_backport: Unknown symbol input_close_device

rfkill_backport: Unknown symbol input_unregister_handler

rfkill_backport: Unknown symbol input_register_handler

rfkill_backport: Unknown symbol led_trigger_register

rfkill_backport: Unknown symbol input_unregister_handle

rfkill_backport: Unknown symbol led_trigger_event

cfg80211: Unknown symbol backport_rfkill_blocked

cfg80211: Unknown symbol backport_rfkill_register

cfg80211: Unknown symbol backport_rfkill_destroy

cfg80211: Unknown symbol backport_rfkill_unregister

cfg80211: Unknown symbol backport_rfkill_resume_polling

cfg80211: Unknown symbol backport_rfkill_set_sw_state

cfg80211: Unknown symbol backport_rfkill_pause_polling

cfg80211: Unknown symbol backport_rfkill_set_hw_state

cfg80211: Unknown symbol backport_rfkill_alloc

Best regards,
Sunny

