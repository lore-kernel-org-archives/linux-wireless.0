Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:56894 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbYJ2NZx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 09:25:53 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
References: <87prlr9mna.fsf@denkblock.local>
	<40f31dec0810251621l3d720a69mf21b5253e9135010@mail.gmail.com>
	<87abcrtfa8.fsf@denkblock.local>
	<40f31dec0810261132w2747d66em2a2a53ff9e1ecc04@mail.gmail.com>
	<87wsfvt76q.fsf@denkblock.local>
	<40f31dec0810261533g3143bd9bue0f3eff88c6936e9@mail.gmail.com>
	<87r663t1ds.fsf@denkblock.local>
	<40f31dec0810271331n7f374562x77da8ae55b9032db@mail.gmail.com>
Date: Wed, 29 Oct 2008 14:25:42 +0100
Message-ID: <873aifsfc9.fsf@denkblock.local> (sfid-20081029_142558_316588_11E36B7E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Nick Kossifidis" <mickflemm@gmail.com> wrote:
> 2008/10/27 Elias Oltmanns <eo@nebensachen.de>:
>> "Nick Kossifidis" <mickflemm@gmail.com> wrote:
>
>>> 2008/10/26 Elias Oltmanns <eo@nebensachen.de>:
>>>>
>>>
>>>>                /*
>>>>                 * Write some more initial register settings
>>>>                 */
>>>> -               if (ah->ah_version == AR5K_AR5212) {
>>>> +               if (ah->ah_version == AR5K_AR5212 &&
>>>> +                   ah->ah_radio > AR5K_RF5111) {
>>>
>>> even better: ah->ah_phy_revision > AR5K_SREV_PHY_5212
>>
>> Just to be absolutely sure: ah->ah_phy_revision >= AR5K_SREV_PHY_5212
>> right?
>>
>
> AR5K_SREV_PHY_5212 is bb rev 1 so its
>
> ah->ah_phy > AR5K_SREV_PHY_5212

I see, thanks for clarifying.

>
>>
>> Well, I'm always happy to leave the work to others ;-). The only reason
>> why I kept resending patches was to make sure that a minimal fix would
>> get merged into a stable release eventually. Presumably, a rework of the
>> reset sequence in itself would not be appropriate for stable. Still, if
>> you'll take care get something into stable, that's fine with me.
>> Otherwise, just let me know and I'll keep those patches coming and you
>> occupied reviewing them ;-).
>>
>> Regards,
>>
>> Elias
>>
>
> O.K. then we 'll include your patch on stable and my work will go on
> wireless-dev for further testing ;-)

Right, so here is another attempt. Unfortunately, in 2.6.27 no constants
have been defined for the phy revisions, nor the 0xa228 register and the
bit masks involved in resetting this register. Perhaps we should consult
the stable team on this matter because the minimal approach, as
presented below, certainly lacks even the smallest degree of readability
even though we actually know reasonably well what we are doing here. The
changelog, by the way, will be adapted to quote your changeset fixing
this in mainline once it has been committed. What do you think?

Regards,

Elias
--------
From: Elias Oltmanns <eo@nebensachen.de>
Subject: ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular

Take care to handle register 0xa228 exactly as in the HAL released by
Atheros. This change is required to make ath5k work again on my system
since commit 2203d6be (ath5k: Misc hw_reset updates), thus fixing a
regression in 2.6.27 and therefore hopefully eligible for inclusion into
a stable release.

v2: Only overwrite initial register values on later revisions of AR5212
    chips.
v3: Use standard macros to manipulate the register.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/net/wireless/ath5k/hw.c       |   22 +++++++---------------
 drivers/net/wireless/ath5k/initvals.c |    2 ++
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index ad1a5b4..67b71e7 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -826,9 +826,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 		mdelay(1);
 
 		/*
-		 * Write some more initial register settings
+		 * Write some more initial register settings for revised chips
 		 */
-		if (ah->ah_version == AR5K_AR5212) {
+		if (ah->ah_version == AR5K_AR5212 &&
+		    ah->ah_phy_revision > 0x41) {
 			ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
 
 			if (channel->hw_value == CHANNEL_G)
@@ -847,19 +848,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum ieee80211_if_types op_mode,
 			else
 				ath5k_hw_reg_write(ah, 0x00000000, 0x994c);
 
-			/* Some bits are disabled here, we know nothing about
-			 * register 0xa228 yet, most of the times this ends up
-			 * with a value 0x9b5 -haven't seen any dump with
-			 * a different value- */
-			/* Got this from decompiling binary HAL */
-			data = ath5k_hw_reg_read(ah, 0xa228);
-			data &= 0xfffffdff;
-			ath5k_hw_reg_write(ah, data, 0xa228);
-
-			data = ath5k_hw_reg_read(ah, 0xa228);
-			data &= 0xfffe03ff;
-			ath5k_hw_reg_write(ah, data, 0xa228);
-			data = 0;
+			/* Got this from legacy-hal */
+			AR5K_REG_DISABLE_BITS(ah, 0xa228, 0x200);
+
+			AR5K_REG_MASKED_BITS(ah, 0xa228, 0x800, 0xfffe03ff);
 
 			/* Just write 0x9b5 ? */
 			/* ath5k_hw_reg_write(ah, 0x000009b5, 0xa228); */
diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index 2806b21..cf7ebd1 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -810,6 +810,8 @@ static const struct ath5k_ini_mode ar5212_rf5111_ini_mode_end[] = {
 		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY(642),
 		{ 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	{ 0xa228,
+		{ 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5 } },
 	{ 0xa23c,
 		{ 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af } },
 };
