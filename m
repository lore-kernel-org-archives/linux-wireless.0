Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:27822 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354AbYG2LXb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:23:31 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1649667nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 04:23:29 -0700 (PDT)
Subject: Re: [PATCH] mac80211: partially fix skb->cb use
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1217323927.10489.9.camel@johannes.berg>
References: <1217323927.10489.9.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 13:23:24 +0200
Message-Id: <1217330604.6379.12.camel@localhost> (sfid-20080729_132350_957464_FCEE3DC5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-29 at 11:32 +0200, Johannes Berg wrote:
> This patch fixes mac80211 to not use the skb->cb over the queue step
> from virtual interfaces to the master. The patch also, for now,
> disables aggregation because that would still require requeuing,
> will fix that in a separate patch. There are two other places (software
> requeue and powersaving stations) where requeue can happen, but that is
> not currently used by any drivers/not possible to use respectively.

On net/mac80211/rx.c:ieee80211_data_to_8023() cb is used for mesh frames
to save the original mesh header. Then if the frame has to be forwarded,
the frame is queued on the virtual interface and
net/mac80211/tx.c:ieee80211_subif_start_xmit() expects the mesh header
to remain in the cb if the frame is not originally from the local host.
It's a different step from the one you mention, but as I understand it
it may suffer the same problem right?

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


