Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED4DC5ACBA
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 21:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0117F2080F
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 21:21:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=pobox.com header.i=@pobox.com header.b="E+j/GWRP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0117F2080F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=pobox.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbeKUHwo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 02:52:44 -0500
Received: from pb-smtp2.pobox.com ([64.147.108.71]:53059 "EHLO
        pb-smtp2.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbeKUHwn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 02:52:43 -0500
Received: from pb-smtp2.pobox.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id E6DE512BF29;
        Tue, 20 Nov 2018 16:21:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=to:from
        :subject:message-id:date:mime-version:content-type
        :content-transfer-encoding; s=sasl; bh=2lzVvbDFxTyFby8oZWB4vObKj
        GQ=; b=E+j/GWRPTbeTMIoC1zvpH3Cmrk1pofNLFGyHkVfF5y7zz//ZA5Tc/JN83
        wGXiOFTVUpAh6cNLlJ6c5IVMEHBNgqNgh68JyuMO03Uq81yNsdmYA7PE7Dk0O8q7
        u7SYq8JXcIgt+4Ct/TJQlmvruFzDERVRD57KL1uCcyifPrk23I=
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:from:subject
        :message-id:date:mime-version:content-type
        :content-transfer-encoding; q=dns; s=sasl; b=upyZ3NV28EVpHFNy+Fo
        yIouyQql6pwETTpB2LXz3tvjEEQA4zFh/ZOo/jrMcKHhrCC+CUeaHrgJOuAXzHcP
        V69Dq7XTQVuxwhfJ7hwHMUZdgc3RbnLSYssDUP8A6aRQ6CCKYR2o2mf9RWnybo2w
        nUoNNBB1JbMQr4qqcW5YmO/A=
Received: from pb-smtp2.nyi.icgroup.com (unknown [127.0.0.1])
        by pb-smtp2.pobox.com (Postfix) with ESMTP id E00ED12BF28;
        Tue, 20 Nov 2018 16:21:31 -0500 (EST)
Received: from [10.69.183.138] (unknown [108.91.94.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by pb-smtp2.pobox.com (Postfix) with ESMTPSA id 2E77F12BF27;
        Tue, 20 Nov 2018 16:21:31 -0500 (EST)
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
From:   Daniel Santos <daniel.santos@pobox.com>
Subject: rt2800 tx frame dropping issue.
Message-ID: <bc0bc5ea-dd10-a5a5-87ff-00a93bcf814c@pobox.com>
Date:   Tue, 20 Nov 2018 15:20:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-Pobox-Relay-ID: 4001D12E-ED0A-11E8-84E2-BFB3E64BB12D-06139138!pb-smtp2.pobox.com
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I'm coming to this issue rather late and I realize there has been much
ado about it.=C2=A0 I want to follow up on a thread from 3 months ago
https://marc.info/?l=3Dlinux-wireless&m=3D153511575812945

> I get testing results from T-Bone user in bugzilla:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D82751
>
> And get this:
>
> [  781.644185] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Drop=
ping frame due \
> to full tx queue 2 [  781.662620] 2 d1 s1 p1 ms1
>
> Looks like rt2x00 correctly stop queue in mac80211, but sill get skb's.=
=20
>
> So we can do 3 things: increase queue size to 128, increase threshold
> to 16 and make the massage debug one instead of error (I checked
> some other drivers and looks most of them silently drop the frame
> in case queue is full). Especially removing the message can be
> useful since printk can somehow make mt7620 router unresponsive
> for some time resulting in connection drops.
>
> Thoughts ?
>
> Regards
> Stanislaw

I believe I have the answer as to why we're getting frames after we stop
the queue.=C2=A0 I had a little chat about this in #kernelnewbies and som=
e
other devs believe it is intentional.

There is a race in ieee80211_tx_frags (net/mac80211/tx.c) between
releasing local->queue_stop_reason_lock and calling the driver's tx
until we lock queue->tx_lock in rt2x00queue_write_tx_frame -- in between
these two points the thread can be preempted.=C2=A0 So while we stop the
queue in one thread, there can be 20 other threads in between that have
already checked that the queue was running and have a frame buffer
sitting on their stacks.=C2=A0 I think it could be fixed with the below
patch, but I'm being told that it doesn't need it and that the driver
should just *quietly* drop the frame:

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d43dab4..29009e0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1117,6 +1117,7 @@ struct ieee80211_local {
 	int q_stop_reasons[IEEE80211_MAX_QUEUES][IEEE80211_QUEUE_STOP_REASONS];
 	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
+	spinlock_t tx_path_lock;
=20
 	int open_count;
 	int monitors, cooked_mntrs;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4f8eceb..2312ac9 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -609,6 +609,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t pri=
v_data_len,
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
+	spin_lock_init(&local->tx_path_lock);
=20
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 87d807f..8d43e2a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1311,6 +1311,7 @@ static bool ieee80211_tx_frags(struct ieee80211_loc=
al *local,
 		}
 #endif
=20
+		spin_lock_bh(&local->tx_path_lock);
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		if (local->queue_stop_reasons[q] ||
 		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
@@ -1327,6 +1328,7 @@ static bool ieee80211_tx_frags(struct ieee80211_loc=
al *local,
 					spin_unlock_irqrestore(
 						&local->queue_stop_reason_lock,
 						flags);
+					spin_unlock_bh(&local->tx_path_lock);
 					ieee80211_purge_tx_queue(&local->hw,
 								 skbs);
 					return true;
@@ -1347,6 +1349,7 @@ static bool ieee80211_tx_frags(struct ieee80211_loc=
al *local,
=20
 				spin_unlock_irqrestore(&local->queue_stop_reason_lock,
 						       flags);
+				spin_unlock_bh(&local->tx_path_lock);
 				return false;
 			}
 		}
@@ -1356,6 +1359,7 @@ static bool ieee80211_tx_frags(struct ieee80211_loc=
al *local,
=20
 		__skb_unlink(skb, skbs);
 		ieee80211_drv_tx(local, vif, sta, skb);
+		spin_unlock_bh(&local->tx_path_lock);
 	}
=20
 	return true;


Could anybody illuminate for me why this isn't done?=C2=A0 I know that th=
ere
has to be a point where we realize there are too many items in the queue
and we can't keep up, but this would seem to be a terrible way to do
that.=C2=A0 Is it one of those things where it isn't worth the performanc=
e
degradation?=C2=A0 Any insights would be most appreciated!! :)

Like Stanislaw, I have not been able to reproduce the problem for
testing, but somebody who has the problem (in production) is going to
get a build where the only change is to remove the rt2x00_err message.=C2=
=A0
It makes sense that it would be the problem as you mentioned.=C2=A0 I sup=
pose
the proper thing to do is to just quietly drop it and increment the
struct net_device stats.tx_dropped?

Thanks,
Daniel

