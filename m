Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.237]:16782 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbXGTC4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 22:56:36 -0400
Received: by nz-out-0506.google.com with SMTP id s18so666811nze
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2007 19:56:36 -0700 (PDT)
Message-ID: <1197ff4c0707191956t433558aat6194065b668906b9@mail.gmail.com>
Date: Fri, 20 Jul 2007 10:56:35 +0800
From: "Li YanBo" <dreamfly281@gmail.com>
To: "Jiri Benc" <jbenc@suse.cz>
Subject: Re: Airgo MIMO Wireless card mac80211 driver (unfinished)
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jeff willam" <angelbane@gmail.com>
In-Reply-To: <20070719173205.622e2223@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <1197ff4c0707190820s26f28fafy784900d41f6b1ad4@mail.gmail.com>
	 <20070719173205.622e2223@griffin.suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/19/07, Jiri Benc <jbenc@suse.cz> wrote:
> On Thu, 19 Jul 2007 23:20:35 +0800, Li YanBo wrote:
> > BTW, I find a problem in the file ieee80211.c it locals in the
> > function "static int __ieee80211_tx()", I think the if (i ==
> > tx->u.tx.num_extra_frag)  is ineffective, because 'i' always lower
> > than tx->u.tx.num_extra_frag. I guess maybe it should be if (i ==
> > (tx->u.tx.num_extra_frag - 1)), below is the patch, CMIIW.
>
> You're right. Could you add your Signed-off-by?
>
> Thanks,
>
>  Jiri
>
Sorry for late response.

commit 800bbaa941213e8a7297d7fb9265f77f5a7b76af
Author: Li YanBo <dreamfly281@gmail.com>
Date:   Fri Jul 20 10:53:25 2007 +0800

    [PATCH] mac80211: Fix change (i == tx->u.tx.num_extra_frag) to
        (i == (tx->u.tx.num_extra_frag - 1)) then it can deal
        the last frag correctly.

    Signed-off-by: Li YanBo <dreamfly281@gmail.com>

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index fcad801..48c51bf 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -1406,7 +1406,7 @@ static int __ieee80211_tx(struct ieee80211_local
*local, struct sk_buff
                                continue;
                        if (__ieee80211_queue_stopped(local, control->queue))
                                return IEEE80211_TX_FRAG_AGAIN;
-                       if (i == tx->u.tx.num_extra_frag) {
+                       if (i == (tx->u.tx.num_extra_frag - 1)) {
                                control->tx_rate = tx->u.tx.last_frag_hwrate;
                                control->rate = tx->u.tx.last_frag_rate;
                                if (tx->u.tx.probe_last_frag)
