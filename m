Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.ust.hk ([143.89.13.26]:56571 "EHLO mx4.ust.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab0BBMPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 07:15:03 -0500
References: <51523.143.89.144.207.1264488274.squirrel@sqmail.ust.hk> <43e72e891001260853s4811bc39s2399d138d0a7da83@mail.gmail.com> <47088.143.89.144.207.1264589300.squirrel@sqmail.ust.hk> <43e72e891001271006l3422b6e2iccb89954feeaa34b@mail.gmail.com> <58444.143.89.144.207.1264747272.squirrel@sqmail.ust.hk> <1264786546.27755.9.camel@mj> <49849.143.89.144.207.1264997174.squirrel@sqmail.ust.hk> <69e28c911001312014r552f6947pccda2e6c8d2b5e5e@mail.gmail.com> <55076.143.89.144.207.1264998571.squirrel@sqmail.ust.hk> <69e28c911002011003v50a2482paf59e0fd62a1e450@mail.gmail.com>
Message-Id: <98AA7355-EFBD-4FF6-8A69-B50B631C2C8E@ust.hk>
From: Sunny Pan <sunnypan@ust.hk>
To: =?GB2312?Q?G=A8=A2bor_Stefanik?= <netrolller.3d@gmail.com>
In-Reply-To: <69e28c911002011003v50a2482paf59e0fd62a1e450@mail.gmail.com>
Content-Type: text/plain;
	charset=GB2312;
	format=flowed;
	delsp=yes
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: Building of compat-wireless-old in 2.6.25 BSP kernel for PowerPC architecture
Date: Tue, 2 Feb 2010 20:15:07 +0800
Cc: Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Pavel,
I compiled it (cross compile) for the powerpc MPC8377 platform so it  
is even more trickier as the things may not works as much same as for  
the pc

Best regards
Sunny

On 2 Feb 2010, at 2:03 AM, G¨¢bor Stefanik <netrolller.3d@gmail.com>  
wrote:

> On Mon, Feb 1, 2010 at 5:29 AM, PAN Sunny S K <sunnypan@ust.hk> wrote:
>>> On Mon, Feb 1, 2010 at 5:06 AM, PAN Sunny S K <sunnypan@ust.hk>  
>>> wrote:
>>>> Hi Pavel,
>>>>
>>>> It is unfortunate that the ath_pci is dependent on ath.
>>>
>>> No, you shouldn't even try to load ath_pci - ath_pci is part of
>>> Madwifi, you need to load ath9k instead.
>>>
>>> BTW are you loading the modules using modprobe or insmod?
>>>
>>
>> Thanks, both insmod and modprobe for ath produces the same result:
>>
>> ath: Unknown symbol wiphy_apply_custom_regulatory
>> ath: Unknown symbol freq_reg_info
>>
>> modprobe for rfkill_backport and cfg80211 even produce not found  
>> error and
>> only insmod will produce the provided snapshot.
>
> Did you install compat-wireless, or only compile it? Also, try running
> depmod. (Modprobe not finding modules is a sign of an incorrectly
> installed module.)
>
>>
>>>> Moreover, after
>>>> some trial, found that the rfkill_backport and cfg80211 also have
>>>> problem
>>>> in loading which is possibly due to the lacking of other symbolic  
>>>> link
>>>> in
>>>> the current kernel or other modules.
>>>> Since other issues (iw, libnl... etc) makes the difficulties in
>>>> integrating ath9k into the current LTIB harder than using of  
>>>> OpenWrt
>>>> with
>>>> the latest kernel  (although still have some problem in building of
>>>> OpenWrt for the platform). I've since moved the effort to  
>>>> building of
>>>> OpenWrt.
>>>> Anyhow, many thanks for the advice and below please find a  
>>>> snapshot of
>>>> the
>>>> error output from the ath9k with kernel 2.6.25 from LTIB for your  
>>>> future
>>>> reference.
>>>>
>>>> ath: Unknown symbol wiphy_apply_custom_regulatory
>>>>
>>>> ath: Unknown symbol freq_reg_info
>>>>
>>>> ath_pci: Unknown symbol ath_config_crypto_get
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_getwscie
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_addmac
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_delkey
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_txmode
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_getkey
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_rate
>>>>
>>>> ath_pci: Unknown symbol ath_config_getstastats
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_getchaninfo
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_phy_mode
>>>>
>>>> ath_pci: Unknown symbol ath_config_setparam
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_ap
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_essid
>>>>
>>>> ath_pci: Unknown symbol ath_config_crypto_set
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_nickn
>>>>
>>>> ath_pci: Unknown symbol ath_config_getwmmparams
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_sendaddba
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_chanlist
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_frag
>>>>
>>>> ath_pci: Unknown symbol ath_config_vdev_getstats
>>>>
>>>> ath_pci: Unknown symbol ath_config_getcounter
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_nickn
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_setaddbaresponse
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_power
>>>>
>>>> ath_pci: Unknown symbol ath_handler_register
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_remote_acl_status
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_chanlist
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_setkey
>>>>
>>>> ath_pci: Unknown symbol set_quality
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_txpow
>>>>
>>>> ath_pci: Unknown symbol ath_config_getstainfo
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_scan
>>>>
>>>> ath_pci: Unknown symbol ath_config_getstats
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_gethwdata
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_getaddbastatus
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_setoptie
>>>>
>>>> ath_pci: Unknown symbol ath_config_ismodesupported
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_rate
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_ap
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_frag
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_channel
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_cwsize
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_phy_mode
>>>>
>>>> ath_pci: Unknown symbol ath_newstate
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_channel_list
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_essid
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_chanswitch
>>>>
>>>> ath_pci: Unknown symbol ath_config_vdev_iw_getstats
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_txpow
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_senddelba
>>>>
>>>> ath_pci: Unknown symbol ath_set_mac_address
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_opmode
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_rate_list
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_scan
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_rts
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_getwpaie
>>>>
>>>> ath_pci: Unknown symbol ath_config_set_rts
>>>>
>>>> ath_pci: Unknown symbol ath_handler_unregister
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_power
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_txmode
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_delmac
>>>>
>>>> ath_pci: Unknown symbol ath_config_getstrparam
>>>>
>>>> ath_pci: Unknown symbol ath_config_ioctl_setmlme
>>>>
>>>> ath_pci: Unknown symbol ath_config_getaddrparam
>>>>
>>>> ath_pci: Unknown symbol ath_config_setwmmparams
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_wbuf
>>>>
>>>> ath_pci: Unknown symbol ath_config_get_channel
>>>>
>>>> ath_pci: Unknown symbol ath_iterate_vaps
>>>>
>>>> ath_pci: Unknown symbol ath_config_getparam
>>>>
>>>> rfkill_backport: Unknown symbol dev_set_name
>>>>
>>>> rfkill_backport: Unknown symbol input_register_handle
>>>>
>>>> rfkill_backport: Unknown symbol input_open_device
>>>>
>>>> rfkill_backport: Unknown symbol led_trigger_unregister
>>>>
>>>> rfkill_backport: Unknown symbol input_close_device
>>>>
>>>> rfkill_backport: Unknown symbol input_unregister_handler
>>>>
>>>> rfkill_backport: Unknown symbol input_register_handler
>>>>
>>>> rfkill_backport: Unknown symbol led_trigger_register
>>>>
>>>> rfkill_backport: Unknown symbol input_unregister_handle
>>>>
>>>> rfkill_backport: Unknown symbol led_trigger_event
>>>>
>>>> cfg80211: Unknown symbol backport_rfkill_blocked
>>>>
>>>> cfg80211: Unknown symbol backport_rfkill_register
>>>>
>>>> cfg80211: Unknown symbol backport_rfkill_destroy
>>>>
>>>> cfg80211: Unknown symbol backport_rfkill_unregister
>>>>
>>>> cfg80211: Unknown symbol backport_rfkill_resume_polling
>>>>
>>>> cfg80211: Unknown symbol backport_rfkill_set_sw_state
>>>>
>>>> cfg80211: Unknown symbol backport_rfkill_pause_polling
>>>>
>>>> cfg80211: Unknown symbol backport_rfkill_set_hw_state
>>>>
>>>> cfg80211: Unknown symbol backport_rfkill_alloc
>>>>
>>>> Best regards,
>>>> Sunny
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-wireless" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>>
>>> --
>>> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A] 
>>> dware. :-)
>>>
>>
>>
>>
>
>
>
> -- 
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
