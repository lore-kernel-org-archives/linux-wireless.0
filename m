Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36349 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab1IUTTx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 15:19:53 -0400
Received: by fxe4 with SMTP id 4so1942358fxe.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 12:19:52 -0700 (PDT)
Message-ID: <4E7A38D0.7070304@googlemail.com> (sfid-20110921_211957_597717_17C2B07B)
Date: Wed, 21 Sep 2011 21:19:44 +0200
From: Chiefdome <chiefdome@googlemail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: george0505@realtek.com, linux-wireless@vger.kernel.org
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net>
In-Reply-To: <4E79F87F.1050402@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2011 04:45 PM, Larry Finger wrote:
> On 09/21/2011 04:43 AM, Chiefdome wrote:
>> I tried the latest git repo from
>> git://git.infradead.org/users/linville/wireless-next.
>> Same story here.
>> After disconnecting to the network, I have to reload the module only 
>> then
>> networks are seen.
>
> I just cloned the wireless-next tree. The two patches mentioned in my 
> previous Email are included.
>
> Please run the following command sequence and send us the dmesg output 
> after your failure occurs:
>
> modprobe -rv rtl8192cu
> modprobe -v rtlwifi debug=3
> modprobe -v rtl8192cu
>
> Larry
I have found another bug - it is impossible to me to connect a 
WPA2-network - here is the dmesg output for that - will send you the 
output for a WEP-network later then:

[  194.011573] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  194.230135] rtl8192cu: MAC auto ON okay!
[  194.263015] rtl8192cu: Tx queue select: 0x05
[  194.263820] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  194.670927] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  237.379814] rtl8192cu: MAC auto ON okay!
[  237.413488] rtl8192cu: Tx queue select: 0x05
[  237.414243] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  237.821229] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  238.160462] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  238.220187] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  238.221641] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  278.340442] usbcore: deregistering interface driver rtl8192cu
[  326.145824] rtl8192cu:rtl92cu_read_eeprom_info():<0-0> Boot from EFUSE
[  326.223617] rtl8192cu: MAC address: [MAC-ADDRESS]
[  326.223629] rtl8192cu:_rtl92cu_read_adapter_info():<0-0>  VID = 0xbda 
PID = 0x817f
[  326.223636] rtl8192cu: Board Type 1
[  326.223641] rtl8192cu:_rtl92cu_hal_customized_behavior():<0-0> RT 
Customized ID: 0x00
[  326.227751] rtlwifi:_rtl_usb_init():<0-0> USB EP(0x81), 
MaxPacketSize=512 ,Interval=0.
[  326.227762] rtlwifi:_rtl_usb_init():<0-0> USB EP(0x02), 
MaxPacketSize=512 ,Interval=0.
[  326.227770] rtlwifi:_rtl_usb_init():<0-0> USB EP(0x03), 
MaxPacketSize=512 ,Interval=0.
[  326.227777] rtlwifi:_rtl_usb_init():<0-0> USB EP(0x84), 
MaxPacketSize=64 ,Interval=1.
[  326.228202] rtl8192cu:_TwoOutEpMapping():<0-0> USB typical Setting.....
[  326.228209] rtlwifi:_rtl_usb_init_tx():<0-0> USB Max Bulk-out Size=512
[  326.228217] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  326.228223] rtlwifi:_rtl_init_hw_ht_capab():<0-0> 1T1R
[  326.228234] cfg80211: Updating information on frequency 2412 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228241] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228247] cfg80211: Updating information on frequency 2417 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228253] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228259] cfg80211: Updating information on frequency 2422 
MH00:1c:4a:03:b9:64z for a 20 MHz width channel with regulatory rule:
[  326.228266] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228271] cfg80211: Updating information on frequency 2427 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228278] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228284] cfg80211: Updating information on frequency 2432 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228290] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228296] cfg80211: Updating information on frequency 2437 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228302] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228308] cfg80211: Updating information on frequency 2442 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228314] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228320] cfg80211: Updating information on frequency 2447 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228327] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228332] cfg80211: Updating information on frequency 2452 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228339] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228344] cfg80211: Updating information on frequency 2457 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228351] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228356] cfg80211: Updating information on frequency 2462 MHz for 
a 20 MHz width channel with regulatory rule:
[  326.228363] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A 
mBi, 2000 mBm)
[  326.228369] cfg80211: Disabling freq 2467 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  326.228374] cfg80211: Disabling freq 2472 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  326.228380] cfg80211: Disabling freq 2484 MHz as custom regd has no 
rule that fits a 20 MHz wide channel
[  326.228554] cfg80211: Ignoring regulatory request Set by core since 
the driver uses its own custom regulatory domain
[  326.228881] ieee80211 phy2: Selected rate control algorithm 'rtl_rc'
[  326.234614] usbcore: registered new interface driver rtl8192cu
[  330.227015] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
[  330.228731] rtl8192cu: MAC auto ON okay!
[  330.264497] rtl8192cu: Tx queue select: 0x05
[  330.264507] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network 
type to NO LINK!
[  330.265249] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE 
driver sleep or unload
[  330.265265] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  330.265269] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware 
Version(63), Signature(0x88c1),Size(32)
[  330.658702] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set 
RCR(0xf0002a0e) ###
[  330.658734] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set 
HW_VAR_RETRY_LIMIT(0x00000004)
[  330.670568] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  340.000671] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set 
RCR(0xf0002a0e) ###
[  340.016768] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
[  340.018500] rtl8192cu: MAC auto ON okay!
[  340.051808] rtl8192cu: Tx queue select: 0x05
[  340.051828] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network 
type to NO LINK!
[  340.052543] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE 
driver sleep or unload
[  340.052583] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  340.052590] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware 
Version(63), Signature(0x88c1),Size(32)
[  340.450345] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set 
RCR(0xf0002ace) ###
[  340.450367] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set 
HW_VAR_RETRY_LIMIT(0x00000004)
[  340.462324] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  340.810935] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  340.870239] e1000e 0000:00:19.0: irq 45 for MSI/MSI-X
[  340.871685] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  340.960624] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set 
RCR(0xf0002a0e) ###
[  341.088320] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
[  341.091812] rtl8192cu: MAC auto ON okay!
[  341.128338] rtl8192cu: Tx queue select: 0x05
[  341.128356] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network 
type to NO LINK!
[  341.129072] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE 
driver sleep or unload
[  341.129112] rtl8192c_common: Loading firmware file 
rtlwifi/rtl8192cufw.bin
[  341.129119] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware 
Version(63), Signature(0x88c1),Size(32)
[  341.523259] rtl8192cu:rtl92cu_set_hw_reg():<0-0> ### Set 
RCR(0xf0002ace) ###
[  341.523296] rtl8192cu:rtl92cu_set_hw_reg():<0-0> Set 
HW_VAR_RETRY_LIMIT(0x00000004)
[  341.535132] ADDRCONF(NETDEV_UP): wlan1: link is not ready
[  344.553546] wlan1: direct probe to [MAC-ADDRESS] (try 1/3)
[  344.750275] wlan1: direct probe to [MAC-ADDRESS] (try 2/3)
[  344.950061] wlan1: direct probe to [MAC-ADDRESS] (try 3/3)
[  345.150150] wlan1: direct probe to [MAC-ADDRESS] timed out

