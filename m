Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49046 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2LJRBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 12:01:39 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so2645075vcd.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Dec 2012 09:01:39 -0800 (PST)
Message-ID: <50C61570.6040006@lwfinger.net> (sfid-20121210_180144_367148_34052F01)
Date: Mon, 10 Dec 2012 11:01:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Alessandro Lannocca <alessandro.lannocca@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: 8192cu misbehaviours with RTL8188RU chipset
References: <CAMfPB_wtsXjxFkY6M4cNjxDK678DV4VPjwDRzVOtgrf-4jDL-Q@mail.gmail.com>
In-Reply-To: <CAMfPB_wtsXjxFkY6M4cNjxDK678DV4VPjwDRzVOtgrf-4jDL-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2012 06:34 PM, Alessandro Lannocca wrote:
> Good morning, I recently (yesterday) bought an RTL8188RU-based wifi
> card, the Alfa AWUS036NHR <0bda:817f>, and proceeded to compile
> compat-wireless 3.6.8-1 to have it working.
>
> I'm using this card for penetration testing purposes, so I applied
> this this patch to be able to switch channels in monitor mode and to
> prevent the driver from overwriting QoS headers:
>
> <snip>
>
> --- a/net/mac80211/tx.c  Sat Sep 29 20:29:54 2012 -0400
> +++ b/net/mac80211/tx.c  Sat Sep 29 20:37:29 2012 -0400
> @@ -1487,7 +1487,10 @@
>     /* Older kernels do not have the select_queue callback */
>     skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, skb));
>   #endif
> -  ieee80211_set_qos_hdr(sdata, skb);
> +  // Don't overwrite QoS header in monitor mode
> +  if (likely(info->control.vif->
> type != NL80211_IFTYPE_MONITOR)) {
> +    ieee80211_set_qos_hdr(sdata, skb);
> +  }
>     ieee80211_tx(sdata, skb, false);
>     rcu_read_unlock();
>   }
> diff -r 0de05c2ae1be net/wireless/chan.c
> --- a/net/wireless/chan.c  Sat Sep 29 20:29:54 2012 -0400
> +++ b/net/wireless/chan.c  Sat Sep 29 20:37:29 2012 -0400
> @@ -85,8 +85,8 @@
>
>     if (!rdev->ops->set_monitor_channel)
>       return -EOPNOTSUPP;
> -  if (!cfg80211_has_monitors_only(rdev))
> -    return -EBUSY;
> +  //if (!cfg80211_has_monitors_only(rdev))
> +  //  return -EBUSY;
>
>     chan = rdev_freq_to_chan(rdev, freq, chantype);
>     if (!chan)
>
> </snip>
>
> Now, it works almost perfectly, I can use my card for regular surfing
> with all kinds of AP (WEP/WPA/OPN), monitor mode works and injection
> too; however, when in monitor mode, it detects associated WPA clients
> as non-associated (exept for itself, it detects its own association
> and its own generated wpa-handshake), and I'm unable to get any WPA
> handshake.
>
> Also, after the first succesfull connection and disconnection, the
> card goes 'mute', it just stops responding, scanning etc, until
> unplugged and replugged.
>
> For this purpose I'm using the latest aircrack-ng suite, other
> equipment I have, correctly reports all the clients in my own wireless
> network as being associated, but not this rtl8188ru card; I think some
> unicast frames are being filtered out while in monitor mode.
> It's worth noting that injection works and I'm currently able to
> effectively deauth wpa clients, but the card doesn't pick up their
> (re-)association nor the wpa handshake.
>
> I tried also compat-wireless from linux-next and compat-drivers
> aswell; all exhibit this behaviour, unfortunately compat-drivers
> exposes some other bugs.
>
> I'm willing to patch/test/recompile to get this bugs ironed out,
> unfortunately loading rtl8192cu with "options debug=5" doesn't seem to
> have any effect on my logs, however I'm attaching a .pcap capture and
> I'm willing to follow your instructions to get you useful info from my
> system.
>
> Also, this bug/problem seems to be a regression, beacuse using an
> ancient 2.6.34 kernel with compat-wireless-backport.2.6.39-1 the
> problem doesn't exist, all works perfectly.
>
> In the attached .pcap file, you'll find a 2-3 APs, including my own,
> and 2-3 clients (all connected on my network - CCC), the only
> associated client shown is the alfa card itself, the handshake has
> been captured aswell, but the other clients (my phone and my tablet)
> are show not-associated, when in reality they are
> connected/reconnecting and their 4-way handshake shoud be visible
> aswell; this is kinda weird.
>
> My system is Ubuntu 12.10
> kernel 3.5.0-19
> compat-wireless 3.6.8-1
> Alfa AWUS036NHR device id 0bda:817f
> dmesg output (I know it's probably useless, but it's all it gives me)
> <snip>
> Dec  6 15:43:26 rothor kernel: [ 1562.960110] rtl8192cu: Chip version 0x10
> Dec  6 15:43:26 rothor kernel: [ 1563.036520] rtl8192cu: MAC address:
> 00:c0:ca:6a:e2:38
> Dec  6 15:43:26 rothor kernel: [ 1563.036523] rtl8192cu: Board Type 1
> Dec  6 15:43:26 rothor kernel: [ 1563.036822] rtl8192cu: Loading
> firmware rtlwifi/rtl8192cufw.bin
> Dec  6 15:43:26 rothor kernel: [ 1563.036901] usbcore: registered new
> interface driver rtl8192cu
> Dec  6 15:43:35 rothor kernel: [ 1571.216096] rtl8192cu: MAC auto ON okay!
> Dec  6 15:43:35 rothor kernel: [ 1571.248809] rtl8192cu: Tx queue select: 0x05
> </snip>
>
> Any help being appreciated, thank you in advance for your time.

Are you sure your patches are correct? The location that you used affects 
*every* driver that uses mac80211, not just rtl8192cu.

I just tested by having rtl8192cu unloaded, then I loaded it with 'sudo modprobe 
-v rtl8192cu debug=5'. When I did that and plugged in the device, my log was 
immediately "flooded" with the following:

[ 3269.706508] rtl8192cu: Chip version 0x10
[ 3270.130396] rtl8192cu: MAC address: 00:1f:1f:c8:8e:cb
[ 3270.130423] rtl8192cu: Board Type 0
[ 3270.131246] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[ 3270.131827] rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
[ 3270.132914] rtlwifi:rtl_fw_cb():<0-0> Firmware callback routine entered!
[ 3270.137746] ieee80211 phy2: Selected rate control algorithm 'rtl_rc'
[ 3270.150347] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=0b
[ 3270.150366] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> N-SS RF =0
[ 3270.150373] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> 
pHalData->bHwRadioOff and eRfPowerStateToSet do not match: pHalData->bHwRadioOff 
0, eRfPowerStateToSet 0
[ 3270.150379] rtlwifi: wireless switch is on
[ 3270.150977] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> GPIO_IN=0b
[ 3270.150984] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> N-SS RF =0
[ 3270.150990] rtl8192cu:rtl92cu_gpio_radio_on_off_checking():<0-0> 
pHalData->bHwRadioOff and eRfPowerStateToSet do not match: pHalData->bHwRadioOff 
0, eRfPowerStateToSet 0
[ 3270.608096] rtl8192cu:_rtl92cu_init_power_on():<0-0> Autoload Done!
[ 3270.617855] rtl8192cu: MAC auto ON okay!
[ 3270.723379] rtl8192cu: Tx queue select: 0x05
[ 3270.723591] rtl8192cu:rtl92c_set_network_type():<0-0> Set Network type to NO 
LINK!
[ 3270.726441] rtl8192c_common:rtl92c_phy_set_bw_mode():<0-0> FALSE driver sleep 
or unload
[ 3270.727029] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(63), 
Signature(0x88c1),Size(32)
[ 3270.727251] rtl8192c_common:_rtl92c_write_fw():<0-0> FW size is 15982 bytes
[ 3270.745940] rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Checksum report OK 
! REG_MCUFWDL:0x00030004
[ 3270.751440] rtl8192c_common:_rtl92c_fw_free_to_go():<0-0> Polling FW ready 
success!! REG_MCUFWDL:0x000300c6
[ 3270.751443] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware is ready to run!
[ 3270.751446] rtl8192cu:_rtl92cu_phy_config_mac_with_headerfile():<0-0> Read 
Rtl819XMACPHY_Array
[ 3270.751448] rtl8192cu:_rtl92cu_phy_config_mac_with_headerfile():<0-0> 
Img:RTL8192CEMAC_2T_ARRAY
[ 3270.757884] rtl8192c_common:_rtl92c_phy_bb8192c_config_parafile():<0-0> ==>
[ 3270.757889] rtl8192c_common:rtl92c_phy_set_bb_reg():<0-0> regaddr(0x24), 
bitmask(0xffffffff), data(0x11800f)
[ 3270.757968] rtl8192c_common:rtl92c_phy_set_bb_reg():<0-0> regaddr(0x24), 
bitmask(0xffffffff), data(0x11800f)

As you can see, that is about 1 second worth of logging. I suggest that you use 
"debug=4" to start with. It is a lot less like "drinking from a firehose".

Larry

