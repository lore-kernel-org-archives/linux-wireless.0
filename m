Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.ust.hk ([143.89.13.11]:65002 "EHLO mx3.ust.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142Ab0A2GlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 01:41:16 -0500
Message-ID: <58444.143.89.144.207.1264747272.squirrel@sqmail.ust.hk>
Date: Fri, 29 Jan 2010 14:41:12 +0800 (HKT)
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for      
     PowerPC architecture
From: "PAN Sunny S K" <sunnypan@ust.hk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "PAN Sunny S K" <sunnypan@ust.hk>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
References: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk>
    <43e72e891001260853s4811bc39s2399d138d0a7da83@mail.gmail.com>
    <47088.143.89.144.207.1264589300.squirrel@sqmail.ust.hk>
    <43e72e891001271006l3422b6e2iccb89954feeaa34b@mail.gmail.com>
In-Reply-To: <43e72e891001271006l3422b6e2iccb89954feeaa34b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks Luis and also thanks Pavel for the using of ARCH argument.

I've sucessfully compiled the ath9k with the 2.6 rc5 given by Luis.
However, I encounter some dependency problem when running the ath.ko,
cfg80211.ko and rfkill_backport.ko (May see the log message at the end of
this email)
At the same time, I contacted Freescale for support, they recommended me
to use the latest trunk in OpenWrt which they had uploaded a patch for
MPC8377 instead of using the LTIB. Since OpenWrt using a newer 2.6.32
kernel (ath9k inclusive) which I may get better support for the
development.
Moreover, I found that the lacking of libnl and consequently the iw in
LTIB causes difficulties in the use of ath9k. Therefore, my focus for now
will goes to building of OpenWrt for the MPC8377EWLAN. (Although get stuck
in missing of the MPC83XX selection in the building config)
Anyway, Thanks for everyone's help and the great work of ath9k.

Best regards,
Sunny

P.S. This is the message when loading the driver modules at bootup FYI

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
ath: Unknown symbol wiphy_apply_custom_regulatory
ath: Unknown symbol freq_reg_info
ath: Unknown symbol wiphy_apply_custom_regulatory
ath: Unknown symbol freq_reg_info
ath: Unknown symbol wiphy_apply_custom_regulatory
ath: Unknown symbol freq_reg_info
cfg80211: Unknown symbol backport_rfkill_blocked
cfg80211: Unknown symbol backport_rfkill_register
cfg80211: Unknown symbol backport_rfkill_destroy
cfg80211: Unknown symbol backport_rfkill_unregister
cfg80211: Unknown symbol backport_rfkill_resume_polling
cfg80211: Unknown symbol backport_rfkill_set_sw_state
cfg80211: Unknown symbol backport_rfkill_pause_polling
cfg80211: Unknown symbol backport_rfkill_set_hw_state
cfg80211: Unknown symbol backport_rfkill_alloc
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



