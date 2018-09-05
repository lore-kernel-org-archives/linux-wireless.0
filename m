Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:43448 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbeIEQHd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 12:07:33 -0400
Message-ID: <1536147453.3528.11.camel@sipsolutions.net> (sfid-20180905_133746_077808_693CD045)
Subject: Re: [PATCH] mac80211: TDLS: fix skb queue/priority assignment
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Felix Fietkau <nbd@nbd.name>
Date: Wed, 05 Sep 2018 13:37:33 +0200
In-Reply-To: <20180905113402.7665-1-johannes@sipsolutions.net> (sfid-20180905_133416_297971_AFC86F42)
References: <20180905113402.7665-1-johannes@sipsolutions.net>
         (sfid-20180905_133416_297971_AFC86F42)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-05 at 13:34 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If the TDLS setup happens over a connection to an AP that
> doesn't have QoS, we nevertheless assign a non-zero TID
> (skb->priority) and queue mapping, which may confuse us or
> drivers later.
> 
> Fix it by just assigning the special skb->priority and then
> using ieee80211_select_queue() just like other data frames
> would go through.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> OK, this addresses the case I was worried about - perhaps
> better take this than the txq patch?

I really only found this. All the other cases aren't doing real data
frames, only null-data and management. So I guess for those we're OK,
and this was the only special case after all.

johannes
