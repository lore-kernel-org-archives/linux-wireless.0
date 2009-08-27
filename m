Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1381 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZH0TSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:12 -0400
Date: Thu, 27 Aug 2009 15:17:15 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 4/4] ath5k: add hardware CCMP encyption support
Message-ID: <20090827191715.GA30419@hash.localnet>
References: <1251169233-24169-1-git-send-email-me@bobcopeland.com> <1251169233-24169-5-git-send-email-me@bobcopeland.com> <1251338971.17295.17.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1251338971.17295.17.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject: [PATCH] ath5k: clarify srev comparison for CCMP check

As Pavel Roskin noted, the check for mac version as copied from
legacy_hal made no sense.  This replaces it with the equivalent
and makes up a suitable #define for the mac version legacy_hal
checked.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

On Wed, Aug 26, 2009 at 10:09:31PM -0400, Pavel Roskin wrote:
> On Mon, 2009-08-24 at 23:00 -0400, Bob Copeland wrote:
> > +	ah->ah_aes_support =
> > +		(ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
> > +		 !AR5K_EEPROM_AES_DIS(ee->ee_misc5) &&
> > +		 (ah->ah_mac_version > (AR5K_SREV_AR5212 >> 4) ||
> > +		  (ah->ah_mac_version == (AR5K_SREV_AR5212 >> 4) &&
> > +		   ah->ah_mac_revision >= (AR5K_SREV_AR5211 >> 4))));
> 
> The above use of ah->ah_mac_revision is clearly incorrect.  You are
> comparing a revision with a symbol for a version.
> 
> I suggest that you use ah_mac_srev instead.  Before this patch,
> ah_mac_revision was a write-only variable and was a good candidate for
> removal.
> 
> The last three quoted lines are equivalent to (ah->ah_mac_srev >= 0x54)

Ok, here's a fixup.  I'm not sure if 0x54 was really intended since we
don't know what srev that is, but this assumes legacy hal is correct.

 drivers/net/wireless/ath/ath5k/ath5k.h  |    1 +
 drivers/net/wireless/ath/ath5k/attach.c |    7 ++-----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index cdc79cd..1275ba0 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -306,6 +306,7 @@ struct ath5k_srev_name {
 #define AR5K_SREV_AR5311B	0x30 /* Spirit */
 #define AR5K_SREV_AR5211	0x40 /* Oahu */
 #define AR5K_SREV_AR5212	0x50 /* Venice */
+#define AR5K_SREV_AR5212_V4	0x54 /* ??? */
 #define AR5K_SREV_AR5213	0x55 /* ??? */
 #define AR5K_SREV_AR5213A	0x59 /* Hainan */
 #define AR5K_SREV_AR2413	0x78 /* Griffin lite */
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 109ab7b..4819f39 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -318,12 +318,9 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 
 	/* Crypto settings */
 	ee = &ah->ah_capabilities.cap_eeprom;
-	ah->ah_aes_support =
+	ah->ah_aes_support = srev >= AR5K_SREV_AR5212_V4 &&
 		(ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
-		 !AR5K_EEPROM_AES_DIS(ee->ee_misc5) &&
-		 (ah->ah_mac_version > (AR5K_SREV_AR5212 >> 4) ||
-		  (ah->ah_mac_version == (AR5K_SREV_AR5212 >> 4) &&
-		   ah->ah_mac_revision >= (AR5K_SREV_AR5211 >> 4))));
+		 !AR5K_EEPROM_AES_DIS(ee->ee_misc5));
 
 	if (srev >= AR5K_SREV_AR2414) {
 		ah->ah_combined_mic = true;
-- 
1.6.2.5



-- 
Bob Copeland %% www.bobcopeland.com

