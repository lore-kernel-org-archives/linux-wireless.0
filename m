Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49393 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0IJVX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 17:23:26 -0400
Message-ID: <4C8AA1C5.8080906@candelatech.com>
Date: Fri, 10 Sep 2010 14:23:17 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: RFC:  v3: Support multiple STA on same AP with ath9k
References: <4C8A8FF8.4030900@candelatech.com> <fc41890c0792e7440941448d5b8b9169@localhost>
In-Reply-To: <fc41890c0792e7440941448d5b8b9169@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2010 02:12 PM, Johannes Berg wrote:
>
> On Fri, 10 Sep 2010 13:07:20 -0700, Ben Greear<greearb@candelatech.com>
> wrote:
>> It also consolidates some of the util.c iterator logic in
>> mac80211.
>
> That really ought to be a different patch.
>
> And I don't think I like the counting in mac80211 -- it's just overhead
> (EXPORT_SYMBOL etc) and a very simple implementation in the driver itself.

I can just use the helper method by itself if you don't want another
new method exposed to explicitly count interfaces.

As for counting, as far as I can tell, ath9k doesn't keep a list of
interfaces, but rather calls those iterator methods when it wants to
know them, so one way or another I need to call back into mac80211.

I'll break the patches apart for the next posting.

Did you get a chance to think more about this part of the patch?

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 687077e..db751f1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -440,7 +440,7 @@ int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)

         spin_lock_irqsave(&local->sta_lock, flags);
         /* check if STA exists already */
-       if (sta_info_get_bss(sdata, sta->sta.addr)) {
+       if (sta_info_get(sdata, sta->sta.addr)) {
                 spin_unlock_irqrestore(&local->sta_lock, flags);
                 mutex_unlock(&local->sta_mtx);
                 rcu_read_lock();

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

