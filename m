Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:34828 "EHLO
	mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbbEZSGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 14:06:25 -0400
Received: by qkdn188 with SMTP id n188so96215882qkd.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2015 11:06:24 -0700 (PDT)
From: Jesse Jones <jjones@cococorp.com>
References: <CAAnMG+OgtSzFXqLOoZ-JbOr7xnexC3P0+M0fFLWTBtWru=4SKg@mail.gmail.com>
 <20150525161542.GA14318@localhost>
In-Reply-To: <20150525161542.GA14318@localhost>
MIME-Version: 1.0
Date: Tue, 26 May 2015 11:06:23 -0700
Message-ID: <3d7668c929311fbebc3309a3fc0c27d8@mail.gmail.com> (sfid-20150526_200629_997468_A0D710A7)
Subject: RE: [PATCH] mac80211: fix a NULL dereference in ath9k (and likely
 other drivers) when fixed mesh paths are used
To: Bob Copeland <me@bobcopeland.com>,
	Alexis Green <agreen@cococorp.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sounds good to me and I will try this though unfortunately not until next
week when I get back from vacation.

Thanks,
Jesse

-----Original Message-----
From: Bob Copeland [mailto:me@bobcopeland.com]
Sent: Monday, May 25, 2015 9:16 AM
To: Alexis Green
Cc: Johannes Berg; linux-wireless; Jesse Jones
Subject: Re: [PATCH] mac80211: fix a NULL dereference in ath9k (and likely
other drivers) when fixed mesh paths are used

On Thu, May 21, 2015 at 06:05:13PM -0700, Alexis Green wrote:
> This patch fixes a NULL dereference in ath9k (and likely other
> drivers) when fixed mesh paths are used. The problem is that when a
> station comes up sta_info_alloc allocates ath_node implicitly via
> hw->sta_data_size. When it does that the ath_node is zeroed out. The
> ath_node isn’t actually initialized until the station becomes associated
> and ath9k_sta_state is called.

Good catch.

I wonder if we should instead remove the mesh special case in
ieee80211_tx_h_check_assoc() -- given that we require an assoc station in
peering before we send data frames to that RA, and userspace should also be
setting assoc flag after MPM completes, I can't think of a reason offhand
why we'd need to bail out there.

Does this also fix the problem for you?  It passed the wpa_supplicant test
cases at least (but we aren't fixing mpaths in any of those...)

>From 246febaa51d555fda437cc8064798db06c5f4d6e Mon Sep 17 00:00:00 2001
From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 25 May 2015 12:01:52 -0400
Subject: [PATCH] mac80211: enable assoc check for mesh interfaces

We already set a station to be associated when peering completes, both in
user space and in the kernel.  Thus we should always have an associated sta
before sending data frames to that station.

Failure to do this can cause crashes in the lower-level driver due to
transmitting unicast data frames before driver sta structures (e.g. ampdu
state in ath9k) are initialized.  This could have happened if fixing mpaths,
which could then allow TX to stations with whom we haven't yet completed
peering.

Reported-by: Alexis Green <agreen@cococorp.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/tx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c index
667111ee6a20..5787f15a3a12 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -301,9 +301,6 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	if (tx->sdata->vif.type == NL80211_IFTYPE_WDS)
 		return TX_CONTINUE;

-	if (tx->sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-		return TX_CONTINUE;
-
 	if (tx->flags & IEEE80211_TX_PS_BUFFERED)
 		return TX_CONTINUE;

--
2.1.4



-- 
Bob Copeland %% http://bobcopeland.com/
