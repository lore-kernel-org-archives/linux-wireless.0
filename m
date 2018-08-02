Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:55795 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbeHBWN3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Aug 2018 18:13:29 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: use-after free bug in hacked 4.16 kernel, related to fq_flow_dequeue
In-Reply-To: <cbfd3c11-6896-ff43-2434-7c29b04f8a79@candelatech.com>
References: <a5e579a2-5c20-5438-83c6-1eb5ae3e5630@candelatech.com> <87in4sy2ks.fsf@toke.dk> <cbfd3c11-6896-ff43-2434-7c29b04f8a79@candelatech.com>
Date: Thu, 02 Aug 2018 22:20:47 +0200
Message-ID: <877el8y0yo.fsf@toke.dk> (sfid-20180802_222049_971773_528A5D42)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 08/02/2018 12:45 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Ben Greear <greearb@candelatech.com> writes:
>>
>>> This is from my hacked kernel, could be my fault. I thought the fq
>>> guys might want to know however...
>>
>> Hmm, nothing obvious comes to mind; fq_flow_dequeue() just dequeues a
>> packet from the queue; it only has two memory derefs, to fq->lock and
>> flow->queue. Don't see why either of those should be freed at this
>> point.
>>
>> Unless fq_adjust_removal() is being inlined, perhaps? Then I suppose the
>> flow->tin reference could be the problem, if the txq_info struct was
>> already freed; did you change anything around the handling of TXQs?
>
> I have worked on some stuff to fix other leaks and corruptions in ath10k =
related
> to txqs, maybe that is part of this problem.  My full tree is here:
>
> https://github.com/greearb/linux-ct-4.16
>
> This bug in question is fairly repeatable on my current setup, which
> is high speed tx + rx on a 9984 NIC, with buggy firmware that crashes
> often in the tx path. I think the crash only happens when I rmmod the
> driver under load, but possibly some of the fw crash cleanup logic
> that ran previously is also involved.

Yeah, if it happens under load that is consistent with packets being
queued.

It seems that mac80211 frees the netdevs of an interface before flushing
the TXQs, which may be the cause of the bug you are seeing. Could you
try the patch below and see if that fixes the issue?

-Toke


diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e65c2abb2a54..d21ef14d327d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1213,6 +1213,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 #if IS_ENABLED(CONFIG_IPV6)
 	unregister_inet6addr_notifier(&local->ifa6_notifier);
 #endif
+	ieee80211_txq_teardown_flows(local);
=20
 	rtnl_lock();
=20
@@ -1241,7 +1242,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
 	skb_queue_purge(&local->skb_queue_tdls_chsw);
-	ieee80211_txq_teardown_flows(local);
=20
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
