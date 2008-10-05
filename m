Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:32774 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbYJEHeh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Oct 2008 03:34:37 -0400
Date: Sun, 5 Oct 2008 09:34:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>
Subject: [PATCH] ath9k: fix oops on trying to hold the wrong spinlock
Message-ID: <20081005073422.GA16819@elte.hu> (sfid-20081005_093546_942214_73C6BD3B)
References: <1223073927-16266-1-git-send-email-lrodriguez@atheros.com> <1223073927-16266-2-git-send-email-lrodriguez@atheros.com> <1223073927-16266-3-git-send-email-lrodriguez@atheros.com> <43e72e890810041932n4034f3c6gbd5c64100338f61e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890810041932n4034f3c6gbd5c64100338f61e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


* Luis R. Rodriguez <lrodriguez@atheros.com> wrote:

> On Fri, Oct 3, 2008 at 3:45 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > We were trying to hold the wrong spinlock due to a typo
> > on IEEE80211_BAR_CTL_TID_S's definition. We use this to
> > compute the tid number and then hold this this tid number's
> > spinlock.
> >
> > Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> 
> Just a head up John -- Ingo has already sucked this into his tree with 
> a proper Reported-by. We still need it in wireless-testing though, not 
> sure how that will be handled.

Small sidenote: in terms of upstream merging tip/out-of-tree is a 
dead-end (as its name implies) - it's a special temporary throw-away 
branch for hot fixes that fall outside the normal scope of -tip. We 
periodically rebase tip/out-of-tree against -git and throw away patches 
that go upstream via other routes. It's never merged directly to Linus. 
Perhaps we should rename it tip/not-for-linus ?

So we are glad to test out patches, but John please apply the patch 
below to the wireless tree so that it's not lost. (probably for 
v2.6.27.1) We are just helping out with testing and we do not want to 
interfere in any way with the wireless git workflow.

	Ingo

------------------>
>From fff3ddac71cf05dda8501a3449c167340e46b755 Mon Sep 17 00:00:00 2001
From: Luis R. Rodriguez <lrodriguez@atheros.com>
Date: Fri, 3 Oct 2008 04:49:21 -0700
Subject: [PATCH] ath9k: fix oops on trying to hold the wrong spinlock

Steven Noonan reported a crash that occurs during ath9k module load.

We were trying to hold the wrong spinlock due to a typo
on IEEE80211_BAR_CTL_TID_S's definition. We use this to
compute the tid number and then hold this this tid number's
spinlock during ath_bar_rx().

Reported-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Tested-by: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/wireless/ath9k/core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 2f84093..88f4cc3 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -316,7 +316,7 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 #define ATH_RX_TIMEOUT           40      /* 40 milliseconds */
 #define WME_NUM_TID              16
 #define IEEE80211_BAR_CTL_TID_M  0xF000  /* tid mask */
-#define IEEE80211_BAR_CTL_TID_S  2       /* tid shift */
+#define IEEE80211_BAR_CTL_TID_S  12      /* tid shift */
 
 enum ATH_RX_TYPE {
 	ATH_RX_NON_CONSUMED = 0,
