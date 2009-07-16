Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:60398 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933623AbZGPXvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 19:51:55 -0400
Message-ID: <4A5FBD19.6000803@mandriva.org>
Date: Fri, 17 Jul 2009 02:51:53 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: unable to bring up iwlagn wireless after update from 2.6.29.6
 to 2.6.31-rc3
References: <4A5D0374.5040702@mandriva.org>	 <1247611024.1796.21.camel@johannes.local>  <4A5D0A7F.5090108@mandriva.org>	 <1247672725.17896.1974.camel@rc-desk>  <4A5FA52D.7030701@mandriva.org>	 <1247782731.31442.3.camel@johannes.local> <1247783433.31442.11.camel@johannes.local> <4A5FB957.80407@mandriva.org>
In-Reply-To: <4A5FB957.80407@mandriva.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Backlund skrev:
> Johannes Berg skrev:
>> On Fri, 2009-07-17 at 00:18 +0200, Johannes Berg wrote:
>>
>>>> And pressing it again gets this:
>>>> [root@tmb-laptop rfkill]# ./rfkill list
>>>> 0: acer-wireless: Wireless LAN
>>>>     Soft blocked: no
>>>>     Hard blocked: no
>>>> 1: acer-bluetooth: Bluetooth
>>>>     Soft blocked: yes
>>>>     Hard blocked: no
>>>> 2: phy0: Wireless LAN
>>>>     Soft blocked: yes
>>>>     Hard blocked: no
>>>>
>>>> And after that I cant get wireless back until I again do a:
>>>> ./rfkill unblock 2
>>>> (works only when acer-wireless is no/no and Wireless LAN is yes/no)
>>> Right. This is bad. The button press shouldn't have affected the
>>> soft-state of the rfkill #2.
>>>
>>>> Applying this patch:
>>>> [PATCH] rfkill: fix rfkill_set_states() to set the hw state
>>>> sent by Alan Jenkins does not help this issue either...
>>>>
>>>> Any  suggestions how to fix the rfkill ?
>>> I'll poke at the acer code to see what it's doing wrong...
>>
>> Can't see anything wrong. I wonder if the button you have sends both the
>> ACPI event _and_ an input event.
>>
>> Can you try this patch and tell us what happens?
>>
> 
> pressing rfkill when I have a working wireless gets this:
> 
> Jul 17 02:24:35 tmb-laptop klogd: rfkill_schedule_toggle(1)
> Jul 17 02:24:35 tmb-laptop klogd: iwlagn 0000:04:00.0: Error sending 
> REPLY_RXON_ASSOC: enqueue_hcmd failed: -5
> Jul 17 02:24:35 tmb-laptop klogd: iwlagn 0000:04:00.0: Error setting 
> RXON_ASSOC (-5)
> Jul 17 02:24:35 tmb-laptop klogd: iwlagn 0000:04:00.0: Error sending 
> REPLY_ADD_STA: enqueue_hcmd failed: -5
> Jul 17 02:24:35 tmb-laptop klogd: mac80211-phy0: failed to remove key 
> (0, 00:19:5b:51:dc:27) from hardware (-5)
> Jul 17 02:24:35 tmb-laptop klogd: iwlagn 0000:04:00.0: Error sending 
> REPLY_ADD_STA: enqueue_hcmd failed: -5
> Jul 17 02:24:35 tmb-laptop klogd: mac80211-phy0: failed to remove key 
> (1, ff:ff:ff:ff:ff:ff) from hardware (-5)
> Jul 17 02:24:35 tmb-laptop dhclient: receive_packet failed on wlan0: 
> Network is down
> Jul 17 02:24:35 tmb-laptop klogd: __rfkill_handle_normal_op(1, 1) [1]
> Jul 17 02:24:36 tmb-laptop ifplugd(wlan0)[1790]: Link beat lost.
> 
> 


And here is the above rfkill/ iwlagn error with "debug=0x01043fff":

Jul 17 02:41:06 tmb-laptop klogd: rfkill_schedule_toggle(1)
Jul 17 02:41:06 tmb-laptop klogd: __rfkill_handle_normal_op(1, 1) [1]
Jul 17 02:41:06 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_handle r = 
77, i = 75, REPLY_RX, 0xc3
Jul 17 02:41:06 tmb-laptop klogd: ieee80211 phy0: I iwl_dbg_report_frame 
Beacon: 0x0080, dst=0xff, src=0x27, len=228, rssi=-38, tim=2957610510 
usec, phy=0x33, chnl=8
Jul 17 02:41:06 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_handle r = 
77, i = 76, STATISTICS_NOTIFICATION, 0x9d
Jul 17 02:41:06 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_statistics 
Statistics notification received (480 vs 484).
Jul 17 02:41:06 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_handle r = 
79, i = 77, REPLY_RX, 0xc3
Jul 17 02:41:06 tmb-laptop klogd: ieee80211 phy0: I iwl_dbg_report_frame 
Beacon: 0x0080, dst=0xff, src=0x27, len=228, rssi=-34, tim=2957712910 
usec, phy=0x33, chnl=8
Jul 17 02:41:06 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_handle r = 
79, i = 78, STATISTICS_NOTIFICATION, 0x9d
Jul 17 02:41:06 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_statistics 
Statistics notification received (480 vs 484).
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_handle r = 
81, i = 79, REPLY_RX, 0xc3
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: I iwl_dbg_report_frame 
Beacon: 0x0080, dst=0xff, src=0x27, len=228, rssi=-37, tim=2957815309 
usec, phy=0x33, chnl=8
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_handle r = 
81, i = 80, STATISTICS_NOTIFICATION, 0x9d
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_statistics 
Statistics notification received (480 vs 484).
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: I iwl_rx_handle r = 
82, i = 81, CARD_STATE_NOTIFICATION, 0xa1
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: I iwl_mac_tx enter
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: I iwl_tx_skb Dropping 
- RF KILL
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: I iwl_mac_tx leave
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_conf_tx enter
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_conf_tx 
leave - RF not ready
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_conf_tx enter
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_conf_tx 
leave - RF not ready
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_conf_tx enter
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_conf_tx 
leave - RF not ready
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_conf_tx enter
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_conf_tx 
leave - RF not ready
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_config enter 
to channel 8 changed 0x100
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_set_rxon_chain 
rx_chain=0x6806 active=2 idle=2
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_config Not 
re-sending same RXON configuration.
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_config leave
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_config enter 
to channel 8 changed 0x40
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_set_rxon_chain 
rx_chain=0x2806 active=2 idle=2
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_enqueue_hcmd Not 
sending command - RF KILL
Jul 17 02:41:07 tmb-laptop klogd: iwlagn 0000:04:00.0: Error sending 
REPLY_RXON_ASSOC: enqueue_hcmd failed: -5
Jul 17 02:41:07 tmb-laptop klogd: iwlagn 0000:04:00.0: Error setting 
RXON_ASSOC (-5)
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_config leave
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_bss_info_changed 
changes = 0x8F
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_bss_info_changed 
BSSID 00:00:00:00:00:00
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_bss_info_changed 
ERP_PREAMBLE 0
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_bss_info_changed 
ERP_CTS 0
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_bss_info_changed 
ASSOC 0
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_bss_info_changed 
leave
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_set_key enter
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_enqueue_hcmd Not 
sending command - RF KILL
Jul 17 02:41:07 tmb-laptop klogd: iwlagn 0000:04:00.0: Error sending 
REPLY_ADD_STA: enqueue_hcmd failed: -5
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_set_key 
disable hwcrypto key
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_set_key leave
Jul 17 02:41:07 tmb-laptop klogd: mac80211-phy0: failed to remove key 
(0, 00:19:5b:51:dc:27) from hardware (-5)
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: I iwl_configure_filter 
Enter: changed: 0x0, total: 0x80000000
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_set_key enter
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_enqueue_hcmd Not 
sending command - RF KILL
Jul 17 02:41:07 tmb-laptop klogd: iwlagn 0000:04:00.0: Error sending 
REPLY_ADD_STA: enqueue_hcmd failed: -5
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_set_key 
disable hwcrypto key
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_set_key leave
Jul 17 02:41:07 tmb-laptop klogd: mac80211-phy0: failed to remove key 
(2, ff:ff:ff:ff:ff:ff) from hardware (-5)
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U 
iwl_mac_remove_interface enter
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U 
iwl_mac_remove_interface leave
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_stop enter
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U __iwl_down iwlagn is 
going down
Jul 17 02:41:07 tmb-laptop dhclient: receive_packet failed on wlan0: 
Network is down
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U 
iwl4965_apm_stop_master stop master
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U 
iwl_clear_free_frames 0 frames on pre-allocated heap on clear.
Jul 17 02:41:07 tmb-laptop klogd: ieee80211 phy0: U iwl_mac_stop leave
Jul 17 02:41:07 tmb-laptop ifplugd(wlan0)[27042]: Link beat lost.



Oh, btw is this below a refcounting bug?
For each time I unload & reload the iwlagn,
the number in front of phy0 gets increased:

[root@tmb-laptop rfkill]# ./rfkill list
0: acer-wireless: Wireless LAN
	Soft blocked: no
	Hard blocked: no
1: acer-bluetooth: Bluetooth
	Soft blocked: yes
	Hard blocked: no
5: phy0: Wireless LAN
	Soft blocked: no
	Hard blocked: no


--
Thomas
