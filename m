Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51456 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbeH3Mkz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 08:40:55 -0400
Message-ID: <1535618382.5215.44.camel@sipsolutions.net> (sfid-20180830_103955_947668_1C449E6A)
Subject: Re: [PATCH v2] mac80211: do not aggregate frames if max_frags is
 set to one
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 30 Aug 2018 10:39:42 +0200
In-Reply-To: <20180830083115.GA9867@localhost.localdomain> (sfid-20180830_103119_772533_DDBBD09F)
References: <cover.1535567864.git.lorenzo.bianconi@redhat.com>
         <d016cad18842b71c6f06710cbc71cb3d55466a2e.1535567864.git.lorenzo.bianconi@redhat.com>
         <1535569548.5215.33.camel@sipsolutions.net>
         <CAJ0CqmVv=FYEb1ARMvoUZHbwCUtAxuO6-c6U-nvi+c-s_63C-Q@mail.gmail.com>
         <1535570007.5215.34.camel@sipsolutions.net>
         <CAJ0CqmWVi2QiP=V3i+_6Gxz18muyOD2+FiFrx=OJgK2CHcdM3Q@mail.gmail.com>
         <1535616192.5215.37.camel@sipsolutions.net>
         <20180830083115.GA9867@localhost.localdomain>
         (sfid-20180830_103119_772533_DDBBD09F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-08-30 at 10:31 +0200, Lorenzo Bianconi wrote:

> Reviewing the code I guess it is not necessary since pskb_expand_head routine
> does not modify head->len (or skb->len). 

True.

> Packet len (if we consider padding) is only modified in:
> 
> memset(skb_push(skb, pad), 0, pad);
> 
> and if we hit that point, we will account new skb->len in flow backlog. Do you
> agree?

Right, but that's the *pad*. I was thinking about the header conversion.

Let's say you decided to add the second frame to the A-MSDU, at which
point the first one isn't really an A-MSDU yet. So we get to:

        if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))

which changes the header of "head" to be 14 bytes longer:

	skb_push(skb, sizeof(*amsdu_hdr));

But now let's say we get a failure here when reallocating the second
subframe:

        if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(rfc1042_header) +
                                                     2 + pad))
                goto out;

Now we have changed "head", which is on the FQ, but we haven't changed
the FQ accounting. So I *think* we still need this:

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3239,7 +3239,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 
 	if (!ieee80211_amsdu_realloc_pad(local, skb, sizeof(rfc1042_header) +
 						     2 + pad))
-		goto out;
+		goto out_recalc;
 
 	ret = true;
 	data = skb_push(skb, ETH_ALEN + 2);
@@ -3256,11 +3256,13 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	head->data_len += skb->len;
 	*frag_tail = skb;
 
-	flow->backlog += head->len - orig_len;
-	tin->backlog_bytes += head->len - orig_len;
-
-	fq_recalc_backlog(fq, tin, flow);
+out_recalc:
+	if (head->len != orig_len) {
+		flow->backlog += head->len - orig_len;
+		tin->backlog_bytes += head->len - orig_len;
 
+		fq_recalc_backlog(fq, tin, flow);
+	}
 out:
 	spin_unlock_bh(&fq->lock);
 


> Looking at the code maybe I spotted another issue, I guess there is an
> off-by-one issue in 'n' estimation since it does not take into account
> the first frame. We hit the line:
> 
> while (*frag_tail) {
> }
> 
> starting from the second subframe, but if the head does not have packet in the
> fraglist we will end up having n = 1, while it is actually the second frame.

Hmm, not sure I follow? "head" is the A-MSDU, containing the A-MSDU
header and the first subframe in skb->data (and/or frags), with the
subframes 2..N in the fraglist.

So I think this is right?

johannes
