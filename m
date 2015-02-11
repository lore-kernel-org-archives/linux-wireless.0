Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub004-omc2s12.hotmail.com ([157.55.1.151]:54155 "EHLO
	DUB004-OMC2S12.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbbBKNfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2015 08:35:46 -0500
Message-ID: <DUB122-DS107601B4556EAFBD994B738C250@phx.gbl> (sfid-20150211_143550_599038_DB0545B4)
From: Matti Laakso <matti.laakso@outlook.com>
To: "'Michal Kazior'" <michal.kazior@tieto.com>,
	<ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <malaakso@elisanet.fi>,
	<greearb@candelatech.com>
References: <1423224354-24955-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1423224354-24955-1-git-send-email-michal.kazior@tieto.com>
Subject: RE: [RFT] ath10k: restart fw on tx-credit timeout
Date: Wed, 11 Feb 2015 15:30:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Michal Kazior [mailto:michal.kazior@tieto.com]
> Sent: 6. helmikuuta 2015 14:06
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org; malaakso@elisanet.fi;
> greearb@candelatech.com; Michal Kazior
> Subject: [RFT] ath10k: restart fw on tx-credit timeout
> 
> It makes little sense to continue and let firmware-host state become
> inconsistent if a WMI command can't be submitted to firmware.
> 
> This effectively prevents after-affects of tx-credit starvation bug which
> include spurious sta kickout events and inability to associate new
stations
> after some time when acting as AP.
> 
> This should also speed up recovery/teardown in some cases when firmware
> stops responding for some reason.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c
> b/drivers/net/wireless/ath/ath10k/wmi.c
> index aeea1c7..776b257 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1045,9 +1045,15 @@ int ath10k_wmi_cmd_send(struct ath10k *ar,
> struct sk_buff *skb, u32 cmd_id)
>  		(ret != -EAGAIN);
>  	}), 3*HZ);
> 
> -	if (ret)
> +	if (ret) {
>  		dev_kfree_skb_any(skb);
> 
> +		if (ret == -EAGAIN) {
> +			ath10k_warn(ar, "firmware
> unresponsive, restarting..\n");
> +			queue_work(ar->workqueue,
> &ar->restart_work);
> +		}
> +	}
> +
>  	return ret;
>  }
> 
> --
> 1.8.5.3

(Re-sending due to E-mail client messing up formatting)

Hi Michal,

I've been running OpenWrt with this patch (applied on top of backports from
2014-11-04) since last Friday, and today after one mobile phone left the
building,

Wed Feb 11 14:00:11 2015 daemon.info hostapd: wlan0: STA bc:c6:db:14:83:cc
IEEE 802.11: disassociated due to inactivity
Wed Feb 11 14:00:12 2015 daemon.info hostapd: wlan0: STA bc:c6:db:14:83:cc
IEEE 802.11: deauthenticated due to inactivity (timer DEAUTH/REMOVE)
Wed Feb 11 14:00:12 2015 kern.warn kernel: [ 2800.890000] ath10k_pci
0000:01:00.0: SWBA overrun on vdev 0

I got this:

[ 2800.890000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2800.990000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2801.090000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2801.200000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2801.300000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2801.400000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2801.500000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2801.610000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2801.710000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2801.810000] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0
[ 2803.760000] ------------[ cut here ]------------
[ 2803.760000] WARNING: CPU: 0 PID: 2531 at
/home/matti/Projects/openwrt/trunk/openwrt/build_dir/target-mips_34kc_uClibc
-0.9.33.2/linux-ar71xx_generic/compat-wireless-2014-11-04/net/mac80211/sta_i
nfo.c:916 sta_info_move_state+0x580/0x604 [mac80211]()
[ 2803.780000] Modules linked in: ifb pppoe ppp_async iptable_nat ath9k
pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4
ipt_MASQUERADE ath9k_common xt_time xt_tcpudp xt_tcpmss xt_string
xt_statistic xt_state xt_recent xt_nat xt_multiport xt_mark xt_mac xt_limit
xt_length xt_id xt_hl xt_helper xt_ecn xt_dscp xt_conntrack xt_connmark
xt_connlimit xt_connbytes xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_HL
xt_DSCP xt_CT xt_CLASSIFY ts_kmp ts_fsm ts_bm slhc nf_nat_irc nf_nat_ftp
nf_nat nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache nf_conntrack_irc
nf_conntrack_ftp iptable_raw iptable_mangle iptable_filter ipt_REJECT
ipt_ECN ip_tables crc_ccitt ath9k_hw act_connmark nf_conntrack act_skbedit
act_mirred em_u32 cls_u32 cls_tcindex cls_flow cls_route cls_fw sch_hfsc
sch_ingress ath10k_pci ath10k_core ath mac80211 cfg80211 compat
ledtrig_usbdev ip6t_REJECT ip6table_raw ip6table_mangle ip6table_filter
ip6_tables x_tables ipv6 arc4 crypto_blkcipher usb_storage ehci_platform
ehci_hcd sd_mod scsi_mod gpio_button_hotplug ext4 crc16 jbd2 mbcache usbcore
nls_base usb_common mii crypto_hash [last unloaded: ifb]
[ 2803.880000] CPU: 0 PID: 2531 Comm: hostapd Not tainted 3.14.30 #1
[ 2803.890000] Stack : 00000006 00000000 00000000 00000000 00000000 00000000
803bc98e 00000035
[ 2803.890000]    873576d8 00000000 802fcad8 80347623 000009e3 803b3b5c
873576d8 00000000
[ 2803.890000]    00000004 00000000 00000008 8029e880 00000003 8020040c
00000394 00000000
[ 2803.890000]    802ffc9c 85265abc 00000000 00000000 00000000 00000000
00000000 00000000
[ 2803.890000]    00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000000
[ 2803.890000]    ...
[ 2803.930000] Call Trace:
[ 2803.930000] [<80242644>] show_stack+0x48/0x70
[ 2803.930000] [<802aee18>] warn_slowpath_common+0x84/0xb4
[ 2803.940000] [<802aeed0>] warn_slowpath_null+0x18/0x24
[ 2803.940000] [<872051e0>] sta_info_move_state+0x580/0x604 [mac80211]
[ 2803.950000]
[ 2803.950000] ---[ end trace bd86e18a7ac162bc ]---
[ 2804.260000] ieee80211 phy0: Hardware restart was requested
[ 2807.260000] ath10k_warn: 22 callbacks suppressed
[ 2807.260000] ath10k_pci 0000:01:00.0: firmware unresponsive, restarting..
[ 2807.270000] ath10k_pci 0000:01:00.0: failed to set beacon mode for vdev
0: -11
[ 2810.270000] ath10k_pci 0000:01:00.0: firmware unresponsive, restarting..
[ 2810.270000] ath10k_pci 0000:01:00.0: failed to put down monitor vdev 1:
-11
[ 2813.280000] ath10k_pci 0000:01:00.0: firmware unresponsive, restarting..
[ 2813.280000] ath10k_pci 0000:01:00.0: failed to to request monitor vdev 1
stop: -11
[ 2818.290000] ath10k_pci 0000:01:00.0: failed to synchronise monitor vdev
1: -145
[ 2818.290000] ath10k_pci 0000:01:00.0: failed to stop monitor vdev: -145
[ 2821.300000] ath10k_pci 0000:01:00.0: firmware unresponsive, restarting..
[ 2824.410000] ath10k_pci 0000:01:00.0: device successfully recovered
[ 2824.710000] ieee80211 phy0: Hardware restart was requested
[ 2827.710000] ath10k_pci 0000:01:00.0: firmware unresponsive, restarting..
[ 2830.820000] ath10k_pci 0000:01:00.0: device successfully recovered
[ 2831.120000] ieee80211 phy0: Hardware restart was requested
[ 2834.220000] ath10k_pci 0000:01:00.0: device successfully recovered

Afterwards everything seems to be working normally. There was also an
unexpected router reboot yesterday, but I didn't get any logs from that and
don't know if it's related. I'll keep testing.

Matti

