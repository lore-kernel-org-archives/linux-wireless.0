Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4782 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbYLIBFN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 20:05:13 -0500
Date: Mon, 8 Dec 2008 20:01:44 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>, Chr <chunkeey@web.de>,
	Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Kalle Valo <kalle.valo@nokia.com>
Subject: Re: [RFT] mac80211: clean up set_key callback
Message-ID: <20081209010144.GA8828@hash.localnet> (sfid-20081209_020523_598341_BF058E22)
References: <1228757035.22164.94.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1228757035.22164.94.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 08, 2008 at 06:23:55PM +0100, Johannes Berg wrote:
> The set_key callback now seems rather odd, passing a MAC address
> instead of a station struct, and a local address instead of a
> vif struct. Change that.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Works here... ath5k changes:

    Acked-by: Bob Copeland <me@bobcopeland.com>

But ath5k probably wants this one-liner too (feel free to just 
roll it up into yours):

From: Bob Copeland <me@bobcopeland.com>
Date: Mon, 8 Dec 2008 18:16:59 -0500
Subject: [PATCH] ath5k: remove unlikely from null check in set_key_lladdr

Default keys use NULL for the mac too, so mac == NULL really
isn't unlikely.

Changes-licensed-under: ISC

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/pcu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
index dabe422..1ab0275 100644
--- a/drivers/net/wireless/ath5k/pcu.c
+++ b/drivers/net/wireless/ath5k/pcu.c
@@ -1139,7 +1139,7 @@ int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
 
 	/* MAC may be NULL if it's a broadcast key. In this case no need to
 	 * to compute AR5K_LOW_ID and AR5K_HIGH_ID as we already know it. */
-	if (unlikely(mac == NULL)) {
+	if (mac == NULL) {
 		low_id = 0xffffffff;
 		high_id = 0xffff | AR5K_KEYTABLE_VALID;
 	} else {
-- 
1.6.0.4


-- 
Bob Copeland %% www.bobcopeland.com

