Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46088 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2DBQ6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 12:58:25 -0400
Message-ID: <4F79DAAC.6080705@candelatech.com> (sfid-20120402_185837_452845_C6543532)
Date: Mon, 02 Apr 2012 09:58:20 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Manoharan, Sujith" <c_manoha@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: deadlock in ath9k, 3.3.0+ kernel.
References: <4F79D0C5.6090601@candelatech.com> <506697F5827BD842B7CB80D046EBE618929925@aphydexd01b>
In-Reply-To: <506697F5827BD842B7CB80D046EBE618929925@aphydexd01b>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2012 09:34 AM, Manoharan, Sujith wrote:
> Patch sent:  http://marc.info/?l=linux-wireless&m=133282325727326&w=2

My 3.3.0 ath9k code doesn't look like that patch at all.  Is some
extra back-porting needed for 3.3.0???


static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
			    struct ieee80211_vif *vif)
{
	struct ath_node *an;
	an = (struct ath_node *)sta->drv_priv;

#ifdef CONFIG_ATH9K_DEBUGFS
	spin_lock(&sc->nodes_lock);
	list_add(&an->list, &sc->nodes);
	spin_unlock(&sc->nodes_lock);
#endif
	an->sta = sta;
	an->vif = vif;
	if (sc->sc_flags & SC_OP_TXAGGR) {
		ath_tx_node_init(sc, an);
		an->maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
				     sta->ht_cap.ampdu_factor);
		an->mpdudensity = parse_mpdudensity(sta->ht_cap.ampdu_density);
	}
}


Thanks,
Ben

>
> Sujith
> ________________________________________
> From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Ben Greear [greearb@candelatech.com]
> Sent: Monday, April 02, 2012 9:46 PM
> To: linux-wireless@vger.kernel.org; ath9k-devel@lists.ath9k.org
> Subject: deadlock in ath9k, 3.3.0+ kernel.
>
> Looks like my ath9k AP locked up over the weekend.  This is
> spewing on the console every so often.  The tainting comes from
> a non-wireless related module that is very unlikely to be
> related to this bug.
>
> I had around 200 stations trying to connect, and probably getting
> resarted every few minutes due to idle timer.
>
>
> BUG: soft lockup - CPU#1 stuck for 22s! [dhcpd:20435]
> Modules linked in: bluetooth xt_CT iptable_raw veth 8021q garp stp llc macvlan wanlink(PO) pktgen nfs f]
> Modules linked in: bluetooth xt_CT iptable_raw veth 8021q garp stp llc macvlan wanlink(PO) pktgen nfs f]
>
> Pid: 20435, comm: dhcpd Tainted: P        W  O 3.3.0+ #41 To Be Filled By O.E.M. To Be Filled By O.E.M..
> EIP: 0060:[<c05986b0>] EFLAGS: 00200287 CPU: 1
> EIP is at do_raw_spin_lock+0x89/0xf9
> EAX: 000000d8 EBX: f6fd1e04 ECX: 00000000 EDX: 0000d8d7
> ESI: 571a3e1f EDI: 00000000 EBP: f20f9b84 ESP: f20f9b68
>    DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process dhcpd (pid: 20435, ti=f20f8000 task=f2091480 task.ti=f20f8000)
> Stack:
>    00000000 f20507a0 5f20a170 00000003 00000002 f2050780 f6fd1e04 f20f9b90
>    c07a917c f6fd1e04 f20f9bcc f8f1b034 00000000 00000000 0000016e f2f5883a
>    f6fd1df0 f20507b0 f20f9be4 f6fd1320 f8e9f757 f20f9c1c f6fd1320 f2f5883c
> Call Trace:
>    [<c07a917c>] _raw_spin_lock_bh+0x16/0x18
>    [<f8f1b034>] ath_tx_start+0x190/0x406 [ath9k]
>    [<f8e9f757>] ? rate_control_get_rate+0x8f/0x132 [mac80211]
>    [<f8f141c9>] ath9k_tx+0x159/0x18b [ath9k]
>    [<f8ea8ac1>] __ieee80211_tx+0x1ce/0x248 [mac80211]
>    [<f8ea8ba4>] ieee80211_tx+0x69/0x77 [mac80211]
>    [<f8ea8f04>] ieee80211_xmit+0xae/0xb6 [mac80211]
>    [<f8ea9886>] ieee80211_subif_start_xmit+0x92a/0x93d [mac80211]
>    [<c0709c30>] ? netif_skb_features+0x7b/0x85
>    [<c070c44a>] dev_hard_start_xmit+0x37a/0x43e
>    [<c071ea4a>] sch_direct_xmit+0x52/0x102
>    [<c070c7d7>] try_dev_queue_xmit+0x2c9/0x47b
>    [<c070c993>] dev_queue_xmit+0xa/0xc
>    [<c077d362>] packet_sendmsg+0x888/0x8e4
>    [<c06fead5>] ? sock_sendmsg+0x93/0xa7
>    [<c06fe57e>] __sock_sendmsg_nosec+0x4a/0x52
>    [<c06fe5b0>] __sock_sendmsg+0x2a/0x33
>    [<c06fe68e>] sock_aio_write+0xd5/0xde
>    [<c04bdfc6>] do_sync_write+0x8d/0xc8
>    [<c0547f56>] ? jbd2_log_wait_commit+0x12b/0x14a
>    [<c055c582>] ? security_file_permission+0x22/0x26
>    [<c04be18e>] ? rw_verify_area+0xc5/0xe8
>    [<c04be8e4>] vfs_write+0x8e/0xde
>    [<c04be9cb>] sys_write+0x3b/0x60
>    [<c07adb58>] sysenter_do_call+0x12/0x28
> Code: f0 66 0f b1 0b 66 39 d0 74 76 69 05 80 cd 96 c0 e8 03 00 00 b9 01 00 00 00 89 45 ec 31 f6 31 ff 8
> Call Trace:
>    [<c07a917c>] _raw_spin_lock_bh+0x16/0x18
>    [<f8f1b034>] ath_tx_start+0x190/0x406 [ath9k]
>    [<f8e9f757>] ? rate_control_get_rate+0x8f/0x132 [mac80211]
>    [<f8f141c9>] ath9k_tx+0x159/0x18b [ath9k]
>    [<f8ea8ac1>] __ieee80211_tx+0x1ce/0x248 [mac80211]
>    [<f8ea8ba4>] ieee80211_tx+0x69/0x77 [mac80211]
>    [<f8ea8f04>] ieee80211_xmit+0xae/0xb6 [mac80211]
>    [<f8ea9886>] ieee80211_subif_start_xmit+0x92a/0x93d [mac80211]
>    [<c0709c30>] ? netif_skb_features+0x7b/0x85
>    [<c070c44a>] dev_hard_start_xmit+0x37a/0x43e
>    [<c071ea4a>] sch_direct_xmit+0x52/0x102
>    [<c070c7d7>] try_dev_queue_xmit+0x2c9/0x47b
>    [<c070c993>] dev_queue_xmit+0xa/0xc
>    [<c077d362>] packet_sendmsg+0x888/0x8e4
>    [<c06fead5>] ? sock_sendmsg+0x93/0xa7
>    [<c06fe57e>] __sock_sendmsg_nosec+0x4a/0x52
>    [<c06fe5b0>] __sock_sendmsg+0x2a/0x33
>    [<c06fe68e>] sock_aio_write+0xd5/0xde
>    [<c04bdfc6>] do_sync_write+0x8d/0xc8
>    [<c0547f56>] ? jbd2_log_wait_commit+0x12b/0x14a
>    [<c055c582>] ? security_file_permission+0x22/0x26
>    [<c04be18e>] ? rw_verify_area+0xc5/0xe8
>    [<c04be8e4>] vfs_write+0x8e/0xde
>    [<c04be9cb>] sys_write+0x3b/0x60
>    [<c07adb58>] sysenter_do_call+0x12/0x28
>
>    CTRL-A Z for help |115200 8N1 | NOR | Minicom 2.5    | VT102 | Online 113:34
>
> --
> Ben Greear<greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

