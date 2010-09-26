Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:49317 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754013Ab0IZBRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Sep 2010 21:17:11 -0400
Message-ID: <4C9E9717.8090008@redfish-solutions.com>
Date: Sat, 25 Sep 2010 18:43:03 -0600
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Subject: Re: [PATCH] compat: fix build error in init_dummy_netdev
References: <1285413737-782-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1285413737-782-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 9/25/10 5:22 AM, Hauke Mehrtens wrote:
> In kernel<= 2.6.28 the member napi_list in struct net_device is only
> availabe if CONFIG_NETPOLL is set. We should initialize it only if it
> is available.
>
> This should fix the problem reported by Philip.
>
> This should also go into stable.
>
> CC: philipp_subx@redfish-solutions.com
> Signed-off-by: Hauke Mehrtens<hauke@hauke-m.de>
> ---
>   compat/compat-2.6.29.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/compat/compat-2.6.29.c b/compat/compat-2.6.29.c
> index bc4288f..cded3cc 100644
> --- a/compat/compat-2.6.29.c
> +++ b/compat/compat-2.6.29.c
> @@ -153,8 +153,10 @@ int init_dummy_netdev(struct net_device *dev)
>   	/* initialize the ref count */
>   	atomic_set(&dev->refcnt, 1);
>
> +#ifdef CONFIG_NETPOLL
>   	/* NAPI wants this */
>   	INIT_LIST_HEAD(&dev->napi_list);
> +#endif
>
>   	/* a dummy interface is started by default */
>   	set_bit(__LINK_STATE_PRESENT,&dev->state);

Testing...

It built.

Ok, reconnected.

Seeing a lot of the following (hundreds over 1 hour):

Sep 25 18:39:48 pbx user.warn kernel: ------------[ cut here ]------------
Sep 25 18:39:48 pbx user.warn kernel: WARNING: at /home/philipp/kernel2/build_i586/compat-wireless-2010-09-23/net/mac80211/util.c:287 ieee80211_wake_queue_by_reason+0x15/0x31 [mac80211]()
Sep 25 18:39:48 pbx user.warn kernel: Modules linked in: binfmt_misc twofish twofish_common xcbc esp4 aead ah4 af_key aes_i586 aes_generic act_police cls_u32 sch_ingress sch_sfq sch_htb xt_dscp xt_CLASSIFY xt_length ipt_recent nf_nat_sip nf_conntrack_sip xt_policy
Sep 25 18:39:48 pbx user.warn kernel: Pid: 17613, comm: sshd Tainted: P        W 2.6.27.49-astlinux #1
Sep 25 18:39:48 pbx user.warn kernel:  [<c01153de>] warn_on_slowpath+0x40/0x63
Sep 25 18:39:48 pbx user.warn kernel:  [<e0989878>] ieee80211_invoke_rx_handlers+0x402/0x418 [mac80211]
Sep 25 18:39:48 pbx user.warn kernel:  [<e098a0ba>] mac80211_ieee80211_rx+0x77f/0x82d [mac80211]
Sep 25 18:39:48 pbx user.warn kernel:  [<e09793c9>] ieee80211_tx_status+0x458/0x62b [mac80211]
Sep 25 18:39:48 pbx user.warn kernel:  [<e08fd21d>] ath5k_rxbuf_setup+0x49/0xa8 [ath5k]
Sep 25 18:39:48 pbx user.warn kernel:  [<e098e741>] ieee80211_wake_queue_by_reason+0x15/0x31 [mac80211]
Sep 25 18:39:48 pbx user.warn kernel:  [<e08fe8aa>] ath5k_tasklet_tx+0x32e/0x34a [ath5k]
Sep 25 18:39:48 pbx user.warn kernel:  [<c0118df2
Sep 25 18:39:48 pbx user.info kernel: 211_wake_queue_by_reason+0x15/0x31 [mac80211]
Sep 25 18:39:48 pbx user.warn kernel:  [<e08fe8aa>] ath5k_tasklet_tx+0x32e/0x34a [ath5k]
Sep 25 18:39:48 pbx user.warn kernel:  [<c0118df2>] tasklet_action+0x3c/0x62
Sep 25 18:39:48 pbx user.warn kernel:  [<c0118cdc>] __do_softirq+0x35/0x75
Sep 25 18:39:48 pbx user.warn kernel:  [<c0118d3e>] do_softirq+0x22/0x26
Sep 25 18:39:48 pbx user.warn kernel:  [<c011918c>] local_bh_enable+0x5e/0x76
Sep 25 18:39:48 pbx user.warn kernel:  [<c02546c9>] dev_queue_xmit+0x254/0x283
Sep 25 18:39:48 pbx user.warn kernel:  [<c026eb94>] ip_finish_output+0x1e8/0x220
Sep 25 18:39:48 pbx user.warn kernel:  [<c026f25e>] ip_output+0x79/0x8d
Sep 25 18:39:48 pbx user.warn kernel:  [<c026e6f7>] ip_local_out+0x15/0x17
Sep 25 18:39:48 pbx user.warn kernel:  [<c026f4f3>] ip_queue_xmit+0x281/0x2cf
Sep 25 18:39:48 pbx user.warn kernel:  [<c0281b93>] tcp_v4_send_check+0x7a/0xb0
Sep 25 18:39:48 pbx user.warn kernel:  [<c027d0ec>] tcp_transmit_skb+0x584/0x5be
Sep 25 18:39:48 pbx user.warn kernel:  [<c027e8ea>] tcp_push_one+0x84/0xa2
Sep 25 18:39:48 pbx user.warn kernel:  [<c027533b>] tcp_sendmsg+0x6dc/0x8e0
Sep 25 18:39:48 pbx user.warn kernel:  [<c02481d9>] sock_aio_write+0xb2/0xbb
Sep 25 18:39:48 pbx user.warn kernel:  [<c01113aa>] pick_next_task_fair+0xba/0xc4
Sep 25 18:39:48 pbx user.warn kernel:  [<c01501b9>] do_sync_write+0xbd/0x104
Sep 25 18:39:48 pbx user.warn kernel:  [<c02a726e>] preempt_schedule+0x27/0x3c
Sep 25 18:39:48 pbx user.warn kernel:  [<c01e0972>] tty_wakeup+0x40/0x44
Sep 25 18:39:48 pbx user.warn kernel:  [<c0123c5a>] autoremove_wake_function+0x0/0x2b
Sep 25 18:39:48 pbx user.warn kernel:  [<c01e40e4>] read_chan+0x0/0x578
Sep 25 18:39:48 pbx user.warn kernel:  [<c01e1759>] tty_read+0x7e/0x99
Sep 25 18:39:48 pbx user.warn kernel:  [<c01508e6>] vfs_write+0x94/0xfc
Sep 25 18:39:48 pbx user.warn kernel:  [<c0150d0e>] sys_write+0x3c/0x63
Sep 25 18:39:48 pbx user.warn kernel:  [<c01037e6>] syscall_call+0x7/0xb
Sep 25 18:39:48 pbx user.warn kernel:  =======================
Sep 25 18:39:48 pbx user.warn kernel: ---[ end trace d35f5e21a6e60fb4 ]---


I'd previously been running 2010-07-23.





