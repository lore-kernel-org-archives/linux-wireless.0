Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab1BOMfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 07:35:32 -0500
Subject: ath9k htc bug?
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Sujith <Sujith.Manoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 13:35:08 +0100
Message-ID: <1297773308.3935.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code in ath9k_ht_tx looks buggy:

        if (padsize && skb->len > padpos) {
                if (skb_headroom(skb) < padsize)
                        return -1;
                skb_push(skb, padsize);
                memmove(skb->data, skb->data + padsize, padpos);
        }

-1 isn't a valid netdev tx status code -- I think this should just be
"goto fail_tx;" instead?

johannes

