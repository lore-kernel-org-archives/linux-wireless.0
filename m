Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:62742 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbaGIIQT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2014 04:16:19 -0400
Received: by mail-lb0-f175.google.com with SMTP id n15so4707485lbi.20
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2014 01:16:17 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Jul 2014 10:16:17 +0200
Message-ID: <CALhHN=ofbPoy6z+Bj2L4vTroYDde+2+VWY6f6FVgzrY9ZC+xEA@mail.gmail.com> (sfid-20140709_101631_458522_5EF15E9D)
Subject: mac80211: A-MPDU reordering issue when RX_FLAG_AMSDU_MORE
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes,

Seems current mac80211 A-MPDU reordering implementation don't work
correctly with drivers that prefer to report separate A-MSDU subframes
instead of one huge frame (using RX_FLAG_AMSDU_MORE). Seems there is a
table where index is a sequence number (ampdu sn), so don't work
correctly while we report few A-MSDU frames with the same SN.

We see this problem with ath10k driver. As I understand correctly, we
will have to change/rewrite mac80211 reordering code to support
correctly A-MSDU packets with RX_FLAG_AMSDU_MORE?

Or

Maybe we should report A-MSDU frames as a list to the mac80211 (skb->next set).
Queue such frame like this in mac80211 more or less:
    while(skb->next && RX_FLAG_AMSDU_MORE)
          __skb_queue_tail(frames, skb);

And dequeue into skb (mpdu) again:
     while (RX_FLAG_AMSDU_MORE)
           skb->next = __skb_dequeue(frames);

In such case we will have one skb (mpdu) that will contain all amsdu
subframes, so more or less no changes in reordering code will be
required. Insert will be "atomic" while we will add whole mpdu in one
step.
For sure we will have to handle this skb list in
ieee80211_amsdu_to_8023s() + dev_kfree_skb_any() + some more work I
think

What do you think?

As a temporary workaround we build one AMSDU big frame, but this is a
lot of memcp and looks odd when
few skb in driver --> one_big_skb --> amsdu_to_8023s again split this
big frame into skb list (almost the same we already have in the
driver).

BR
Janusz
