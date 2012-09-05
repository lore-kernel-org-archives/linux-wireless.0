Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:46479 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab2IERi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 13:38:28 -0400
Received: by ieje11 with SMTP id e11so1509829iej.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2012 10:38:27 -0700 (PDT)
Message-ID: <50478E10.6030808@lwfinger.net> (sfid-20120905_193833_351879_2790384D)
Date: Wed, 05 Sep 2012 12:38:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Anisse Astier <anisse@astier.eu>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ce: activation problem with rtl8188ce pci card
References: <20120905185510.2ab501cd@destiny.ordissimo>
In-Reply-To: <20120905185510.2ab501cd@destiny.ordissimo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 11:55 AM, Anisse Astier wrote:
> Hi,
>
> On a toshiba laptop (see dmesg attached), with a wireless-next kernel,
> this card doesn't seem to turn on:
> 01:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller [10ec:8136] (rev 02)
>

Unfortunately, the above is not a wireless device. It is your wired device.

> # modprobe rtl8192ce debug=4
> [ 6184.995319] cfg80211: Calling CRDA to update world regulatory domain
> [ 6185.103824] rtl8192ce: rtl8192ce: FW Power Save off (module option)

The above line is unexpected. Do you have a module option set in /etc/module.d/?

> [ 6185.103881] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
> [ 6185.150488] rtlwifi:rtl_fw_cb():<0-0> Firmware callback routine entered!
> [ 6185.216834] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
> [ 6185.224729] rtlwifi: wireless switch is on
> [ 6185.289544] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
> [ 6185.289649] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
> [ 6185.289797] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
> [ 6185.289944] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
> [ 6185.290092] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
> [ 6185.290250] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
> [ 6185.290398] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
> [ 6185.290545] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:18051d59:11
> [ 6185.290693] rtl8192ce:_rtl92ce_init_mac():<0-0> reg0xec:98053f15:10
> [ 6185.291829] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)

That is the firmware that I use.

> [ 6185.513223] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> PairwiseEncAlgorithm = 0 GroupEncAlgorithm = 0
> [ 6185.513237] rtl8192ce:rtl92ce_enable_hw_security_config():<0-0> The SECR-value cc
> [ 6185.622274] rtl8192c_common:rtl92c_dm_initialize_txpower_tracking_thermalmeter():<0-0> pMgntInfo->txpower_tracking = 1
> [ 6185.623129] rtlwifi:rtl_pci_start():<0-0> enable_interrupt OK
> [ 6185.623140] rtlwifi:rtl_pci_start():<0-0> OK
> [ 6185.624061] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> Not connected to any
> [ 6185.624073] rtl8192c_common:rtl92c_dm_dynamic_bb_powersaving():<0-0> AP Ext Port PWDB = 0x0
> [ 6185.624123] rtl8192c_common:rtl92c_dm_check_txpower_tracking_thermal_meter():<0-0> Trigger 92S Thermal Meter!!
> [ 6185.632970] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
> [ 6185.632987] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
> [ 6185.633028] rtlwifi:rtl_op_bss_info_changed():<0-0> BSS_CHANGED_ERP_PREAMBLE use short preamble:0
> [ 6185.633040] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
> [ 6185.633989] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_LISTEN_INTERVAL
> [ 6185.634281] rtlwifi:rtl_op_config():<0-0> IEEE80211_CONF_CHANGE_RETRY_LIMITS 4
> [ 6185.644434] rtl8192c_common:rtl92c_phy_sw_chnl():<0-0> sw_chnl_inprogress false schdule workitem
> [ 6185.644445] rtl8192ce:rtl92ce_set_hw_reg():<0-0> HW_VAR_SLOT_TIME 14
> [ 6185.655245] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [ 6185.734598] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
> [ 6185.735117] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
> [ 6185.735129] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
> [ 6185.852489] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
> [ 6185.852504] rtlwifi:_rtl_pci_interrupt():<10000-1> rx overflow !
> [ 6185.853211] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
> [ 6185.853221] rtlwifi:_rtl_pci_interrupt():<10000-1> rx overflow !
> [ 6185.853823] rtlwifi:_rtl_pci_interrupt():<10000-1> rx descriptor unavailable!
> [ 6185.853833] rtlwifi:_rtl_pci_interrupt():<10000-1> rx overflow !
> [...] this is repeated
>
> After a modprobe -r:
> [ 6187.127706] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
> [ 6187.127724] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
> [ 6187.130614] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 2
> [ 6187.130626] rtl8192ce:rtl92ce_sw_led_on():<0-0> LedAddr:4E ledpin=1
> [ 6187.130638] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
> [ 6187.130646] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
> [ 6187.139353] rtl8192c_common:rtl92c_firmware_selfreset(): 8051 reset fail
> [ 6187.139373] rtl8192ce:rtl92ce_led_control():<0-0> ledaction 7
> [ 6187.139382] rtl8192ce:rtl92ce_sw_led_off():<0-0> LedAddr:4E ledpin=1
>
>
> After inserting the module, the PCI information is scrambled:
> 06:00.0 Network controller: Realtek Semiconductor Co., Ltd. Device 8176 (rev ff) (prog-if ff)
>          !!! Unknown header type 7f

This listing is likely for your wireless card.

> After a few seconds, the computer will freeze if the module isn't removed.
> The card works on Windows.
>
> This looks like a hidden rfkill, or maybe it is a different revision of
> the card. What do you think ?

Without a full 'sudo lspci -nnv' listing for the wireless, it is hard to tell if 
it is a different revision. The rx descriptor unavailable message is a new one 
for me.

I have two different revisions of the RTL8188CE card. The newer one, marked 
RTL8188CE-VL, gives the following lspci output:

06:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 
802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
         Subsystem: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi 
Adapter [10ec:8176]
         Flags: bus master, fast devsel, latency 0, IRQ 20
         I/O ports at 4000 [size=256]
         Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: [40] Power Management version 3
         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
         Capabilities: [70] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Virtual Channel
         Capabilities: [160] Device Serial Number 01-91-81-fe-ff-4c-e0-00
         Kernel driver in use: rtl8192ce

It certainly does not yield the rx descriptor problem. Please send the lspci 
output when the driver has not been loaded.

Larry



