Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:32881 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab3A3Qg1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 11:36:27 -0500
Message-ID: <1359563688.14894.54.camel@cumari.coelho.fi> (sfid-20130130_173631_780529_7DF785A6)
Subject: Re: [PATCHv6 2/6] cfg80211: check radar interface combinations
From: Luciano Coelho <coelho@ti.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<victorg@ti.com>, <linville@tuxdriver.com>,
	<kgiori@qca.qualcomm.com>, <zefir.kurtisi@neratec.com>,
	<adrian@freebsd.org>, <j@w1.fi>, <igalc@ti.com>, <nbd@nbd.name>,
	<mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 30 Jan 2013 18:34:48 +0200
In-Reply-To: <1357650251-17425-3-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1357650251-17425-3-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, 2013-01-08 at 14:04 +0100, Simon Wunderlich wrote:
> To ease further DFS development regarding interface combinations, use
> the interface combinations structure to test for radar capabilities.
> Drivers can specify which channel widths they support, and in which
> modes. Drivers should first allow AP mode only, but can later allow
> MultiSSID APs, AP+Ad-Hoc, etc.
> 
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> ---

[...]

> diff --git a/net/wireless/util.c b/net/wireless/util.c
> index 16d76a8..72476e8 100644
> --- a/net/wireless/util.c
> +++ b/net/wireless/util.c

[...]

> @@ -1195,14 +1196,36 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
>  	enum cfg80211_chan_mode chmode;
>  	int num_different_channels = 0;
>  	int total = 1;
> +	bool radar_required;
>  	int i, j;
>  
>  	ASSERT_RTNL();
>  	lockdep_assert_held(&rdev->devlist_mtx);
>  
> +	if (WARN_ON(hweight32(radar_detect) > 1))
> +		return -EINVAL;
> +
> +	switch (iftype) {
> +	case NL80211_IFTYPE_ADHOC:
> +	case NL80211_IFTYPE_AP:
> +	case NL80211_IFTYPE_AP_VLAN:
> +	case NL80211_IFTYPE_MESH_POINT:
> +	case NL80211_IFTYPE_P2P_GO:
> +		radar_required = !!(chan->flags & IEEE80211_CHAN_RADAR);
> +		break;

This code is causing an oops with the wl18xx driver in AP mode.  The
problem is that cfg80211_can_change_interface() calls
cfg80211_can_use_iftype_chan() with chan == NULL.  This code doesn't
check if chan is NULL, so this dereference causes the oops.

I don't have the time right now to fix this, but I'll look into it
tomorrow (unless someone comes with a fix before that :P).

This code is currently in wireless-next as commit
11c4a075db2f8774d37544342c8cb9752b4db9e1.

Here's the full oops report:

[ 1869.594970] Unable to handle kernel NULL pointer dereference at virtual address 00000008                                                                                                                        
[ 1869.604675] pgd = ebc0c000                                                                                                                                                                                      
[ 1869.608886] [00000008] *pgd=abd73831, *pte=00000000, *ppte=00000000                                                                                                                                             
[ 1869.621276] Internal error: Oops: 17 [#1] SMP ARM                                                                                                                                                               
[ 1869.627532] Modules linked in: wl18xx wlcore mac80211 cfg80211 rfkill wlcore_sdio                                                                                                                               
[ 1869.635467] CPU: 0    Not tainted  (3.8.0-rc4-wl+ #990)                                                                                                                                                         
[ 1869.641387] PC is at cfg80211_can_use_iftype_chan+0xb0/0x598 [cfg80211]                                                                                                                                         
[ 1869.648468] LR is at cfg80211_can_use_iftype_chan+0x58/0x598 [cfg80211]                                                                                                                                         
[ 1869.655426] pc : [<bf01ac10>]    lr : [<bf01abb8>]    psr: 80000113                                                                                                                                             
[ 1869.655426] sp : ebe09ca8  ip : 00000000  fp : ebe09d4c                                                                                                                                                         
[ 1869.667480] r10: 0000000d  r9 : c0c6ba4a  r8 : 0000000c                                                                                                                                                         
[ 1869.672973] r7 : 00000000  r6 : 00000000  r5 : 00000003  r4 : 00000000                                                                                                                                          
[ 1869.679840] r3 : ea000000  r2 : 5d400000  r1 : 00000000  r0 : 00000000                                                                                                                                          
[ 1869.686706] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user                                                                                                                                   
[ 1869.694213] Control: 10c53c7d  Table: abc0c04a  DAC: 00000015                                                                                                                                                   
[ 1869.700256] Process hostapd (pid: 4627, stack limit = 0xebe08240)                                                                                                                                               
[ 1869.706665] Stack: (0xebe09ca8 to 0xebe0a000)                                                                                                                                                                   
[ 1869.711273] 9ca0:                   00000000 ebd5db80 ebe09cdc 00000000 c00b0870 eb944000                                                                                                                       
[ 1869.719879] 9cc0: eb9440a8 c0c7f8d4 ebe08000 eb9440ac ebe09cec c00ac864 c0bc6de8 eb9440a8                                                                                                                       
[ 1869.728485] 9ce0: ebe09d4c ebe09cf0 c071fe04 c00ac834 00000002 00000000 bf017628 edf60000                                                                                                                       
[ 1869.737091] 9d00: ebe09d1c eb9440d4 bf017628 eb9440e8 22222222 22222222 22222222 22222222                                                                                                                       
[ 1869.745697] 9d20: 00000000 eb9440a8 eb944000 edf60648 00000000 0000000c c0c6ba4a 0000000d                                                                                                                       
[ 1869.754302] 9d40: ebe09d8c ebe09d50 bf017644 bf01ab6c 00000000 00000000 ebe09d7c ebe09d68                                                                                                                       
[ 1869.762908] 9d60: c00c3f8c edf60000 fffffff2 00000000 bf01722c bf135ed4 c0c6ba4a 0000000d                                                                                                                       
[ 1869.771484] 9d80: ebe09dc4 ebe09d90 c0725514 bf017238 c00b0870 bf06b398 ebe08000 edf60000                                                                                                                       
[ 1869.780090] 9da0: 0000000d 00001002 00000001 ebe08000 00000000 ecca400c ebe09ddc ebe09dc8                                                                                                                       
[ 1869.788696] 9dc0: c00823c0 c0725470 00000000 c05411c8 ebe09df4 ebe09de0 c05411e0 c00823a4                                                                                                                       
[ 1869.797302] 9de0: edf60000 bf1254c8 ebe09e14 ebe09df8 c05451e8 c05411b4 edf60000 00001003                                                                                                                       
[ 1869.805908] 9e00: 00001002 00000001 ebe09e34 ebe09e18 c05454c4 c05451b0 edf60000 00001002                                                                                                                       
[ 1869.814514] 9e20: 00000001 00008914 ebe09e54 ebe09e38 c0545614 c0545448 ebd5db80 00000000                                                                                                                       
[ 1869.823120] 9e40: 00000000 00000001 ebe09ebc ebe09e58 c06483b0 c0545600 c0526d24 c01319a8                                                                                                                       
[ 1869.831726] 9e60: edf60000 00000014 ecca4000 bea7fa90 6e616c77 00000030 00000000 00000000                                                                                                                       
[ 1869.840332] 9e80: 00001003 00000000 00000000 00000000 00000000 00008914 bea7fa90 c0649e88                                                                                                                       
[ 1869.848937] 9ea0: bea7fa90 0000c000 ebe08000 00000000 ebe09ecc ebe09ec0 c064a044 c0647d30                                                                                                                       
[ 1869.857543] 9ec0: ebe09eec ebe09ed0 c0527ddc c0649e94 c0527d70 ee3fcd20 ebc76000 00000006                                                                                                                       
[ 1869.866149] 9ee0: ebe09f74 ebe09ef0 c0169954 c0527d7c c0c6bc60 ec5a8380 ebe09f3c ebe09f08                                                                                                                       
[ 1869.874755] 9f00: ebd5db80 ebe08000 00000000 60000113 ebe09f3c ebe09f20 c00b1770 c00b16bc                                                                                                                       
[ 1869.883361] 9f20: c0c6bc60 ec0b5340 c0c6bc60 ebc76000 ebe09f74 ebe09f40 c0175bb8 c00b172c                                                                                                                       
[ 1869.891967] 9f40: c00155a4 ebd5db80 00000001 60000110 00000000 ebc76000 bea7fa90 00008914                                                                                                                       
[ 1869.900573] 9f60: 00000006 ebe08000 ebe09fa4 ebe09f78 c0169f60 c01698d0 ebe09f94 00000000                                                                                                                       
[ 1869.909179] 9f80: bea7fb38 bea7fa90 00000006 00000036 c0015648 00000000 00000000 ebe09fa8                                                                                                                       
[ 1869.917785] 9fa0: c00153e0 c0169eec bea7fb38 bea7fa90 00000006 00008914 bea7fa90 00001003                                                                                                                       
[ 1869.926391] 9fc0: bea7fb38 bea7fa90 00000006 00000036 00000001 00000001 00000000 00000000                                                                                                                       
[ 1869.934997] 9fe0: 0008e4d8 bea7fa88 000454fc b6ca6bcc 60000110 00000006 726f7720 72702064                                                                                                                       
[ 1869.943847] [<bf01ac10>] (cfg80211_can_use_iftype_chan+0xb0/0x598 [cfg80211]) from [<bf017644>] (cfg80211_netdev_notifier_call+0x418/0x84c [cfg80211])                                                          
[ 1869.958160] [<bf017644>] (cfg80211_netdev_notifier_call+0x418/0x84c [cfg80211]) from [<c0725514>] (notifier_call_chain+0xb0/0x184)                                                                              
[ 1869.970520] [<c0725514>] (notifier_call_chain+0xb0/0x184) from [<c00823c0>] (raw_notifier_call_chain+0x28/0x30)                                                                                                 
[ 1869.981170] [<c00823c0>] (raw_notifier_call_chain+0x28/0x30) from [<c05411e0>] (call_netdevice_notifiers+0x38/0x64)                                                                                             
[ 1869.992156] [<c05411e0>] (call_netdevice_notifiers+0x38/0x64) from [<c05451e8>] (__dev_open+0x44/0x110)                                                                                                         
[ 1870.002044] [<c05451e8>] (__dev_open+0x44/0x110) from [<c05454c4>] (__dev_change_flags+0x88/0x14c)                                                                                                              
[ 1870.011474] [<c05454c4>] (__dev_change_flags+0x88/0x14c) from [<c0545614>] (dev_change_flags+0x20/0x58)                                                                                                         
[ 1870.021362] [<c0545614>] (dev_change_flags+0x20/0x58) from [<c06483b0>] (devinet_ioctl+0x68c/0x79c)                                                                                                             
[ 1870.030883] [<c06483b0>] (devinet_ioctl+0x68c/0x79c) from [<c064a044>] (inet_ioctl+0x1bc/0x1d0)                                                                                                                 
[ 1870.040069] [<c064a044>] (inet_ioctl+0x1bc/0x1d0) from [<c0527ddc>] (sock_ioctl+0x6c/0x2bc)                                                                                                                     
[ 1870.048858] [<c0527ddc>] (sock_ioctl+0x6c/0x2bc) from [<c0169954>] (do_vfs_ioctl+0x90/0x61c)                                                                                                                    
[ 1870.057739] [<c0169954>] (do_vfs_ioctl+0x90/0x61c) from [<c0169f60>] (sys_ioctl+0x80/0x88)                                                                                                                      
[ 1870.066436] [<c0169f60>] (sys_ioctl+0x80/0x88) from [<c00153e0>] (ret_fast_syscall+0x0/0x3c)                                                                                                                    
[ 1870.075317] Code: e1a00003 13e00015 e24bd028 e89daff0 (e5963008)                                                                                                                                                
[ 1870.081909] ---[ end trace 10620d4073c27977 ]--- 

--
Cheers,
Luca.

