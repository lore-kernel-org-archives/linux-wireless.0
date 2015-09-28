Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35536 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbI1TE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 15:04:26 -0400
Received: by wicge5 with SMTP id ge5so118741429wic.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2015 12:04:24 -0700 (PDT)
In-Reply-To: <1673287.PfdWxMzLgk@debian64>
References: <1673287.PfdWxMzLgk@debian64>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] mac80211: fix oops in ieee80211_beacon_get_tim
From: Helmut Schaa <helmut.schaa@googlemail.com>
Date: Mon, 28 Sep 2015 21:04:20 +0200
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Message-ID: <c2bbeb9a-3682-4fee-9ba3-8eb4d684707b@email.android.com> (sfid-20150928_210428_892433_60EB5F9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>





Christian Lamparter <chunkeey@googlemail.com> schrieb:
>This patch fixes a crash which is triggered
>by __ieee80211_beacon_get returning NULL.

Ouch, thanks for catching this!
Helmut

>This causes sky_copy to crash later unless
>the hardware supports BEACON_TX_STATUS
>feature.
>
>Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
>---
>"mac80211: Copy tx'ed beacons to monitor mode" added the skb_copy.
>There are few other possibilities to do this. This is just one.
>---
> net/mac80211/tx.c | 3 +++
> 1 file changed, 3 insertions(+)
>
>diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>index f7317a7..666e46b 100644
>--- a/net/mac80211/tx.c
>+++ b/net/mac80211/tx.c
>@@ -3530,6 +3530,9 @@ struct sk_buff *ieee80211_beacon_get_tim(struct
>ieee80211_hw *hw,
> 	struct ieee80211_supported_band *sband;
> 	int shift;
> 
>+	if (!bcn)
>+		return bcn;
>+
> 	if (tim_offset)
> 		*tim_offset = offs.tim_offset;
> 

