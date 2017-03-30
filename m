Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39120 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932345AbdC3HPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Mar 2017 03:15:32 -0400
Date: Thu, 30 Mar 2017 09:15:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: Add rtl8723bs sdio wifi driver
Message-ID: <20170330071515.GA4945@kroah.com> (sfid-20170330_091536_350896_FC1222DC)
References: <20170329174751.13184-1-hdegoede@redhat.com>
 <2266f69c-2eda-fb94-e1c7-cf1bafeb7ad7@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2266f69c-2eda-fb94-e1c7-cf1bafeb7ad7@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 29, 2017 at 08:20:19PM -0500, Larry Finger wrote:
> On 03/29/2017 12:47 PM, Hans de Goede wrote:
> > The rtl8723bs is found on quite a few systems used by Linux users,
> > such as on Atom systems (Intel Computestick and various other
> > Atom based devices) and on many (budget) ARM boards such as
> > the CHIP.
> > 
> > The plan moving forward with this is for the new clean,
> > written from scratch, rtl8xxxu driver to eventually gain
> > support for sdio devices. But there is no clear timeline
> > for that, so lets add this driver included in staging for now.
> > 
> > Cc: Bastien Nocera <hadess@hadess.net>
> > Cc: Larry Finger <Larry.Finger@lwfinger.net>
> > Cc: Jes Sorensen <jes.sorensen@gmail.com>
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> Hans,
> 
> I am still building the driver on my CherryTrail tablet, but I did see some
> warnings and errors listed by Smatch as follows:
> 
> finger@linux-4v1g:~/wireless-drivers-next> make CHECK=~/smatch/smatch C=2
> drivers/staging/rtl8723bs/
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CHECK   arch/x86/purgatory/purgatory.c
>   CHECK   arch/x86/purgatory/sha256.c
>   CHECK   arch/x86/purgatory/string.c
>   CHK     include/generated/bounds.h
>   CHK     include/generated/timeconst.h
>   CHK     include/generated/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   CHECK   scripts/mod/empty.c
>   CHECK   drivers/staging/rtl8723bs/core/rtw_ap.c
> drivers/staging/rtl8723bs/core/rtw_ap.c:382 expire_timeout_chk() warn:
> inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/core/rtw_btcoex.c
>   CHECK   drivers/staging/rtl8723bs/core/rtw_cmd.c
>   CHECK   drivers/staging/rtl8723bs/core/rtw_debug.c
> drivers/staging/rtl8723bs/core/rtw_debug.c:454 proc_get_survey_info() error:
> we previously assumed 'phead' could be null (see line 453)
> drivers/staging/rtl8723bs/core/rtw_debug.c:455 proc_get_survey_info() warn:
> variable dereferenced before check 'phead' (see line 454)
>   CHECK   drivers/staging/rtl8723bs/core/rtw_efuse.c
>   CHECK   drivers/staging/rtl8723bs/core/rtw_io.c
>   CHECK   drivers/staging/rtl8723bs/core/rtw_ioctl_set.c
>   CHECK   drivers/staging/rtl8723bs/core/rtw_ieee80211.c
> drivers/staging/rtl8723bs/core/rtw_ieee80211.c:83 rtw_is_cckrates_included()
> warn: if statement not indented
> drivers/staging/rtl8723bs/core/rtw_ieee80211.c:98
> rtw_is_cckratesonly_included() warn: if statement not indented
>   CHECK   drivers/staging/rtl8723bs/core/rtw_mlme.c
> drivers/staging/rtl8723bs/core/rtw_mlme.c:862 rtw_survey_event_callback()
> warn: inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_mlme.c:1102 rtw_free_assoc_resources()
> warn: if statement not indented
> drivers/staging/rtl8723bs/core/rtw_mlme.c:1165 rtw_indicate_disconnect()
> warn: inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_mlme.c:2830 rtw_restructure_ht_ie() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_mlme.c:2991 rtw_update_ht_cap() warn:
> inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
> drivers/staging/rtl8723bs/core/rtw_mlme_ext.c:525 _mgt_dispatcher() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_mlme_ext.c:1595 OnAssocReq() error:
> buffer overflow 'pstapriv->sta_aid' 32 <= 32
> drivers/staging/rtl8723bs/core/rtw_mlme_ext.c:2391 dump_mgntframe_and_wait()
> warn: inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_mlme_ext.c:2420
> dump_mgntframe_and_wait_ack() warn: inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_mlme_ext.c:4969 process_80211d() error:
> testing array offset 'i' after use.
> drivers/staging/rtl8723bs/core/rtw_mlme_ext.c:5738 linked_status_chk() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_mlme_ext.c:6459 sitesurvey_cmd_hdl()
> warn: inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/core/rtw_odm.c
> drivers/staging/rtl8723bs/core/rtw_odm.c:109 rtw_odm_dbg_comp_msg() warn: if
> statement not indented
> drivers/staging/rtl8723bs/core/rtw_odm.c:146 rtw_odm_ability_msg() warn: if
> statement not indented
>   CHECK   drivers/staging/rtl8723bs/core/rtw_pwrctrl.c
> drivers/staging/rtl8723bs/core/rtw_pwrctrl.c:641
> LeaveAllPowerSaveModeDirect() warn: inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/core/rtw_recv.c
> drivers/staging/rtl8723bs/core/rtw_recv.c:598 portctrl() warn: inconsistent
> indenting
> drivers/staging/rtl8723bs/core/rtw_recv.c:838 sta2sta_data_frame() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_recv.c:1547 validate_recv_frame() warn:
> inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/core/rtw_rf.c
>   CHECK   drivers/staging/rtl8723bs/core/rtw_security.c
> drivers/staging/rtl8723bs/core/rtw_security.c:266 rtw_wep_encrypt() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:433 rtw_seccalctkipmic() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:749 rtw_tkip_encrypt() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:865 rtw_tkip_decrypt() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:1383 aes_cipher() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:1415 aes_cipher() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:1430 aes_cipher() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:1582 rtw_aes_encrypt() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:1651 aes_decipher() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:1739 aes_decipher() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_security.c:1792 aes_decipher() warn:
> curly braces intended?
> drivers/staging/rtl8723bs/core/rtw_security.c:1809 aes_decipher() warn:
> inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/core/rtw_sta_mgt.c
> drivers/staging/rtl8723bs/core/rtw_sta_mgt.c:25 _rtw_init_stainfo() warn:
> inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/core/rtw_wlan_util.c
> drivers/staging/rtl8723bs/core/rtw_wlan_util.c:67 cckrates_included() warn:
> if statement not indented
> drivers/staging/rtl8723bs/core/rtw_wlan_util.c:81 cckratesonly_included()
> warn: if statement not indented
> drivers/staging/rtl8723bs/core/rtw_wlan_util.c:815 rtw_camid_alloc() warn:
> should '1 << (cam_id)' be a 64 bit type?
>   CHECK   drivers/staging/rtl8723bs/core/rtw_xmit.c
> drivers/staging/rtl8723bs/core/rtw_xmit.c:277 _rtw_init_xmit_priv() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_xmit.c:294 _rtw_free_xmit_priv() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_xmit.c:295 _rtw_free_xmit_priv() warn:
> inconsistent indenting
> drivers/staging/rtl8723bs/core/rtw_xmit.c:946 xmitframe_addmic() warn:
> inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/hal/hal_intf.c
>   CHECK   drivers/staging/rtl8723bs/hal/hal_com.c
> drivers/staging/rtl8723bs/hal/hal_com.c:1734 rtw_bb_rf_gain_offset() warn:
> inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/hal/hal_com_phycfg.c
> drivers/staging/rtl8723bs/hal/hal_com_phycfg.c:2090
> Hal_ChannelPlanToRegulation() warn: inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/hal/hal_btcoex.c
>   CHECK   drivers/staging/rtl8723bs/hal/hal_sdio.c
>   CHECK   drivers/staging/rtl8723bs/hal/Hal8723BPwrSeq.c
>   CHECK   drivers/staging/rtl8723bs/hal/HalPhyRf.c
>   CHECK   drivers/staging/rtl8723bs/hal/HalPwrSeqCmd.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_CfoTracking.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_debug.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_DIG.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_DynamicBBPowerSaving.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_DynamicTxPower.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_EdcaTurboCheck.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_HWConfig.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_NoiseMonitor.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_PathDiv.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_RegConfig8723B.c
>   CHECK   drivers/staging/rtl8723bs/hal/odm_RTL8723B.c
>   CHECK   drivers/staging/rtl8723bs/hal/rtl8723b_cmd.c
>   CHECK   drivers/staging/rtl8723bs/hal/rtl8723b_dm.c
>   CHECK   drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c
> drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c:518
> rtl8723b_FirmwareDownload() error: we previously assumed 'pFirmware' could
> be null (see line 382)
>   CHECK   drivers/staging/rtl8723bs/hal/rtl8723b_phycfg.c
>   CHECK   drivers/staging/rtl8723bs/hal/rtl8723b_rf6052.c
>   CHECK   drivers/staging/rtl8723bs/hal/rtl8723b_rxdesc.c
>   CHECK   drivers/staging/rtl8723bs/hal/rtl8723bs_recv.c
>   CHECK   drivers/staging/rtl8723bs/hal/rtl8723bs_xmit.c
>   CHECK   drivers/staging/rtl8723bs/hal/sdio_halinit.c
>   CHECK   drivers/staging/rtl8723bs/hal/sdio_ops.c
>   CHECK   drivers/staging/rtl8723bs/hal/HalBtc8723b1Ant.c
>   CHECK   drivers/staging/rtl8723bs/hal/HalBtc8723b2Ant.c
>   CHECK   drivers/staging/rtl8723bs/hal/HalHWImg8723B_BB.c
> drivers/staging/rtl8723bs/hal/HalHWImg8723B_BB.c:314
> ODM_ReadAndConfig_MP_8723B_AGC_TAB() warn: for statement not indented
> drivers/staging/rtl8723bs/hal/HalHWImg8723B_BB.c:583
> ODM_ReadAndConfig_MP_8723B_PHY_REG() warn: for statement not indented
> drivers/staging/rtl8723bs/hal/HalHWImg8723B_BB.c:586
> ODM_ReadAndConfig_MP_8723B_PHY_REG() warn: inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/hal/HalHWImg8723B_MAC.c
>   CHECK   drivers/staging/rtl8723bs/hal/HalHWImg8723B_RF.c
>   CHECK   drivers/staging/rtl8723bs/hal/HalPhyRf_8723B.c
>   CHECK   drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:470
> rtw_cfg80211_ibss_indicate_connect() error: we previously assumed 'scanned'
> could be null (see line 466)
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:942
> rtw_cfg80211_set_encryption() warn: inconsistent indenting
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:955
> rtw_cfg80211_set_encryption() error: buffer overflow
> 'psecuritypriv->dot11DefKey' 4 <= 4
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:1017
> rtw_cfg80211_set_encryption() error: buffer overflow
> 'padapter->securitypriv.dot118021XGrpKey' 5 <= 5
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:1216
> cfg80211_rtw_set_default_key() warn: inconsistent indenting
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:2498
> rtw_cfg80211_monitor_if_xmit_entry() error: we previously assumed 'skb'
> could be null (see line 2495)
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:2850
> cfg80211_rtw_start_ap() warn: if statement not indented
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:2860
> cfg80211_rtw_start_ap() warn: if statement not indented
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:3417
> rtw_cfg80211_preinit_wiphy() warn: inconsistent indenting
> drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:3547 rtw_wdev_alloc()
> info: ignoring unreachable code.
>   CHECK   drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
>   CHECK   drivers/staging/rtl8723bs/os_dep/mlme_linux.c
> drivers/staging/rtl8723bs/os_dep/mlme_linux.c:149
> rtw_os_indicate_disconnect() warn: inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/os_dep/osdep_service.c
>   CHECK   drivers/staging/rtl8723bs/os_dep/os_intfs.c
> drivers/staging/rtl8723bs/os_dep/os_intfs.c:1082 ips_netdrv_open() warn:
> inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/os_dep/recv_linux.c
> drivers/staging/rtl8723bs/os_dep/recv_linux.c:353 rtw_recv_indicatepkt()
> warn: variable dereferenced before check 'precv_frame' (see line 312)
>   CHECK   drivers/staging/rtl8723bs/os_dep/rtw_proc.c
> drivers/staging/rtl8723bs/os_dep/rtw_proc.c:102 rtw_drv_proc_open() warn:
> inconsistent indenting
>   CHECK   drivers/staging/rtl8723bs/os_dep/sdio_intf.c
>   CHECK   drivers/staging/rtl8723bs/os_dep/sdio_ops_linux.c
>   CHECK   drivers/staging/rtl8723bs/os_dep/wifi_regd.c
>   CHECK   drivers/staging/rtl8723bs/os_dep/xmit_linux.c
> drivers/staging/rtl8723bs/os_dep/xmit_linux.c:42 _rtw_pktfile_read() warn:
> inconsistent indenting
> 
> The indent problems can probably be ignored, but many of the others are
> serious enough to be addressed now.
> 
> Once this driver is merged into staging, the Outreachy folks will be really busy.
> 
> Thanks for posting this driver,

So, no objection from you?  Great, I'll go queue it up later today...

thanks,

greg k-h
