Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:45240 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbbBGMZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2015 07:25:17 -0500
Message-ID: <54D6042A.1020404@broadcom.com> (sfid-20150207_132625_408968_6D273E73)
Date: Sat, 7 Feb 2015 13:25:14 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Naveen Singh <naveen@nestlabs.com>
CC: <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WPA Supplicant not able to listen to events from driver
References: <CAFK1zRDiMcKZWgU=DGh4bzjyV07STuKKyHi2az_s-=KCDiEK8A@mail.gmail.com>	<54D47FB5.3000303@broadcom.com> <CAFK1zRADFhojfB_3RsPaPi9WBdQ9RPgrzbwewYgE2nqWmS+vdQ@mail.gmail.com>
In-Reply-To: <CAFK1zRADFhojfB_3RsPaPi9WBdQ9RPgrzbwewYgE2nqWmS+vdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/15 22:24, Naveen Singh wrote:
> Thanks it worked. But looks like every time we load the driver, phy
> index kept on incrementing.

That is expected. If I recall correctly it is a static counter in 
cfg80211 that is used for assigning phy index upon wiphy_register call.

Regards,
Arend

> Regards
> Naveen
>
> On Fri, Feb 6, 2015 at 12:47 AM, Arend van Spriel <arend@broadcom.com
> <mailto:arend@broadcom.com>> wrote:
>
>     On 02/06/15 04:22, Naveen Singh wrote:
>
>         Hi All
>         For my system we have cfg80211 built as loadable module. When we
>         unload
>         our WLAN driver cfg80211 gets unloaded as well.
>
>
>     So how is your WLAN driver unloaded. When unloading cfg80211 the
>     nl80211 netlink family is unregistered from the kernel probably
>     closing all user-space netlink sockets.
>
>     If you only 'rmmod' your WLAN driver than supplicant should be fine
>     handling it as cfg80211 is not unloaded. If you use 'modprobe -r' it
>     will unload dependent modules if their refcount is zero.
>
>     Regards,
>     Arend
>
>         After reloading the
>         driver I found that none of the events from driver never makes to
>         supplicant. I see that connect command from supplicant makes to
>         driver
>         but the NL_CONNECT_CMD netlink message from the driver is
>         dropped. On
>         further debugging I found that the messages are dropped in the
>         following
>         function sd it does not call *do_one_broadcast*. Looks like all the
>         previous bindings were lost. After killing the supplicant and
>         restarting
>         the supplicant I can see that the subscriptions are updated and
>         connection succeeded.
>
>         int netlink_broadcast_filtered(__struct sock *ssk, struct
>         sk_buff *skb,
>         u32 portid,
>         u32 group, gfp_t allocation,
>         int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
>         void *filter_data)
>         {
>         struct net *net = sock_net(ssk);
>         struct netlink_broadcast_data info;
>         struct sock *sk;
>
>         skb = netlink_trim(skb, allocation);
>
>         info.exclude_sk = ssk;
>         info.net <http://info.net> <http://info.net> = net;
>         info.portid = portid;
>         info.group = group;
>         info.failure = 0;
>         info.delivery_failure = 0;
>         info.congested = 0;
>         info.delivered = 0;
>         info.allocation = allocation;
>         info.skb = skb;
>         info.skb2 = NULL;
>         info.tx_filter = filter;
>         info.tx_data = filter_data;
>
>         /* While we sleep in clone, do not allow to change socket list */
>
>         netlink_lock_table();
>
>         sk_for_each_bound(sk, &nl_table[ssk->sk_protocol].__mc_list)
>         d*o_one_broadcast(sk, &info); ==> This function is not called at
>         all as
>         it does not find any subscription at all. *
>
>         consume_skb(skb);
>
>         netlink_unlock_table();
>
>         if (info.delivery_failure) {
>         kfree_skb(info.skb2);
>         return -ENOBUFS;
>         }
>         consume_skb(info.skb2);
>
>         if (info.delivered) {
>         if (info.congested && (allocation & __GFP_WAIT))
>         yield();
>         My feeling is that as cfg80211 gets unloaded as well when driver is
>         unloaded, it loses all the subscription and hence none of the
>         message
>         from driver gets ever delivered to supplicant. But what
>         surprises me is
>         that although we cannot send messages from driver to supplicant
>         it is
>         not true in reverse direction. Connect command from supplicant
>         lands in
>         driver. Has anyone seen something similar? I have a workaround
>         right now
>         where i restart the supplicant whenever i unload and load the
>         driver.
>         But I would like to have a cleaner solution.
>
>
>         Regards
>         Naveen
>
>
>
>         _________________________________________________
>         HostAP mailing list
>         HostAP@lists.shmoo.com <mailto:HostAP@lists.shmoo.com>
>         http://lists.shmoo.com/__mailman/listinfo/hostap
>         <http://lists.shmoo.com/mailman/listinfo/hostap>
>
>
>     _________________________________________________
>     HostAP mailing list
>     HostAP@lists.shmoo.com <mailto:HostAP@lists.shmoo.com>
>     http://lists.shmoo.com/__mailman/listinfo/hostap
>     <http://lists.shmoo.com/mailman/listinfo/hostap>
>
>

