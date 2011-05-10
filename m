Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45509 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1EJRW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 13:22:27 -0400
Message-ID: <4DC97450.8090905@candelatech.com> (sfid-20110510_192230_686584_1A4CA163)
Date: Tue, 10 May 2011 10:22:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.39] ath9k: fix a regression in PS frame filter handling
References: <1304972747-11775-1-git-send-email-nbd@openwrt.org>
In-Reply-To: <1304972747-11775-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2011 01:25 PM, Felix Fietkau wrote:
> Only leave filtering enabled for AP or VLAN interfaces, clear the
> destination mask for all other interfaces.

I tried removing your previous two patches and added this one.

Unfortunately, it crashes.  I upgraded to -rc7 at the same
time, so maybe it's something else..or maybe I screwed up
the build.  But, might want to hold off on this a bit until
I can debug some more.

I assume you haven't seen any such problems?

Thanks,
Ben


Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/virtual/net/rddVR10-p/address
Modules linked in: veth 8021q garp stp llc macvlan pktgen fuse coretemp hwmon nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 uinput arc4 ath9k mac]

Pid: 34, comm: kworker/u:1 Tainted: G        W   2.6.39-rc7-wl+ #68 To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M.
EIP: 0060:[<f8d620ff>] EFLAGS: 00010206 CPU: 1
EIP is at ath_tx_start+0x640/0x6ab [ath9k]
EAX: 00000000 EBX: 00000000 ECX: 0000004d EDX: f4e59de8
ESI: f3cd8000 EDI: f269e640 EBP: f4e59dd0 ESP: f4e59d88
  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process kworker/u:1 (pid: 34, ti=f4e58000 task=f4f30a50 task.ti=f4e58000)
Stack:
  f46cd640 00000000 f46ce0a8 f46ce0a8 f1023c18 f46cd640 f3c34000 0000004d
  f46cd640 f4e59de8 f1023c00 00000046 00000000 f3cd8000 f3cd8000 f46cd640
  f269e640 f4e59dfc f4e59e08 f8d5bbee f46cc480 f1023c00 f3c34000 f3c3401c
Call Trace:
  [<f8d5bbee>] ath9k_tx+0x154/0x186 [ath9k]
  [<f8bf091c>] __ieee80211_tx+0x149/0x190 [mac80211]
  [<f8bf185e>] ieee80211_tx+0x7b/0x93 [mac80211]
  [<f8bf1a2d>] ieee80211_xmit+0x1b7/0x1c4 [mac80211]
  [<c04311cf>] ? get_parent_ip+0xb/0x31
  [<f8bf1a83>] ieee80211_tx_skb+0x49/0x50 [mac80211]
  [<f8bf3f6d>] ieee80211_send_probe_req+0x29/0x2e [mac80211]
  [<f8bde320>] ieee80211_scan_work+0x32d/0x44c [mac80211]
  [<c044cff9>] ? process_one_work+0x181/0x322
  [<c044d06d>] process_one_work+0x1f5/0x322
  [<f8bddff3>] ? ieee80211_request_scan+0x41/0x41 [mac80211]
  [<c044ed1c>] worker_thread+0xfc/0x203
  [<c042d894>] ? complete+0x39/0x43
  [<c044ec20>] ? manage_workers+0x169/0x169
  [<c0451c89>] kthread+0x67/0x6c
  [<c0451c22>] ? __init_kthread_worker+0x47/0x47
  [<c07f9e3a>] kernel_thread_helper+0x6/0x10
Code: 8b 56 14 8b 80 f4 07 00 00 89 45 b8 e8 a0 70 d8 ff 8b 55 dc 80 7a 10 00 74 08 a1 40 9a 9e c0 89 46 28 83 7d d4 00 74 0f 8b 4d d4 <8b> 01 83 f8
EIP: [<f8d620ff>] ath_tx_start+0x640/0x6ab [ath9k] SS:ESP 0068:f4e59d88
CR2: 000000000000004d

>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> Reported-by: Ben Greear<greearb@candelatech.com>
> ---
>   drivers/net/wireless/ath/ath9k/main.c |    5 +++++
>   drivers/net/wireless/ath/ath9k/xmit.c |    6 +++++-
>   2 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 3de115d..3d999b7 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1778,6 +1778,11 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
>   	struct ieee80211_key_conf ps_key = { };
>
>   	ath_node_attach(sc, sta);
> +
> +	if (vif->type != NL80211_IFTYPE_AP&&
> +	    vif->type != NL80211_IFTYPE_AP_VLAN)
> +		return 0;
> +
>   	an->ps_key = ath_key_config(common, vif, sta,&ps_key);
>
>   	return 0;
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 744779d..ee71d38 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1795,6 +1795,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
>   	struct sk_buff *skb = bf->bf_mpdu;
>   	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>   	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +	struct ieee80211_vif *vif = tx_info->control.vif;
>   	struct list_head bf_head;
>   	struct ath_atx_tid *tid = NULL;
>   	u8 tidno;
> @@ -1829,7 +1830,10 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
>   		if (txctl->paprd)
>   			bf->bf_state.bfs_paprd_timestamp = jiffies;
>
> -		if (tx_info->flags&  IEEE80211_TX_CTL_CLEAR_PS_FILT)
> +		if ((vif&&  vif->type != NL80211_IFTYPE_AP&&
> +		            vif->type != NL80211_IFTYPE_AP_VLAN) ||
> +		    !ieee80211_is_data(hdr->frame_control) ||
> +		    (tx_info->flags&  IEEE80211_TX_CTL_CLEAR_PS_FILT))
>   			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, true);
>
>   		ath_tx_send_normal(sc, txctl->txq, tid,&bf_head);


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

