Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:51802 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYJ2X26 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 19:28:58 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: "Bob Copeland" <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Jiri Slaby" <jirislaby@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: Fix reset sequence for AR5212 in general and RF5111 in particular
References: <87prlr9mna.fsf@denkblock.local>
	<40f31dec0810261132w2747d66em2a2a53ff9e1ecc04@mail.gmail.com>
	<87wsfvt76q.fsf@denkblock.local>
	<40f31dec0810261533g3143bd9bue0f3eff88c6936e9@mail.gmail.com>
	<87r663t1ds.fsf@denkblock.local>
	<40f31dec0810271331n7f374562x77da8ae55b9032db@mail.gmail.com>
	<873aifsfc9.fsf@denkblock.local>
	<40f31dec0810290749u2c065d17g5788eb22cf508142@mail.gmail.com>
	<87wsfrqw2t.fsf@denkblock.local>
	<b6c5339f0810290828g2c600d5cm9f78df9d427f5c1f@mail.gmail.com>
	<40f31dec0810291051j605a281dg641d873bd0e3bbc1@mail.gmail.com>
Date: Thu, 30 Oct 2008 00:25:08 +0100
In-Reply-To: <40f31dec0810291051j605a281dg641d873bd0e3bbc1@mail.gmail.com>
	(Nick Kossifidis's message of "Wed, 29 Oct 2008 19:51:37 +0200")
Message-ID: <87mygn2dd7.fsf@denkblock.local> (sfid-20081030_002907_652182_89916352)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Nick Kossifidis" <mickflemm@gmail.com> wrote:
> 2008/10/29 Bob Copeland <me@bobcopeland.com>:
>> On Wed, Oct 29, 2008 at 11:07 AM, Elias Oltmanns <eo@nebensachen.de> wrote:
>
>>>>
>>>> Patch looks OK, thanks a lot ;-)
>>>>
>>>> John can we get this get in stable until i update reset.c on wireless-testing ?
>>>> Would it be possible later to update mainline from wireless-testing ?
>>>
>>> Reading Documentation/stable_kernel_rules.txt, I very much doubt that
>>> this patch will go in unless we can at least point out something
>>> equivalent in mainline. So, we'll have to wait until your changes to
>>> reset.c have reached mainline, I'm afraid.
>>
>> Or, we could just send your patch to both stable and for 2.6.28.  Then Nick
>> can fix up the difference or revert it in his rework.  The rework is 2.6.29
>> material, right?
>>
>
> ACK

In that case, I'd suggest the following patch for 2.6.28-rc2. Once it
has been merged, I'll send the previous one off to the stable team.

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
v4: Use appropriate constants (new to 2.6.28) for register access.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/net/wireless/ath5k/initvals.c |    2 ++
 drivers/net/wireless/ath5k/reset.c    |   25 ++++++++++---------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index ea2e1a2..ceaa6c4 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -806,6 +806,8 @@ static const struct ath5k_ini_mode ar5212_rf5111_ini_mode_end[] = {
 		{ 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY(642),
 		{ 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	{ 0xa228,
+		{ 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5, 0x000001b5 } },
 	{ 0xa23c,
 		{ 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af, 0x13c889af } },
 };
diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
index 8f18868..8fdb092 100644
--- a/drivers/net/wireless/ath5k/reset.c
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -537,9 +537,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		mdelay(1);
 
 		/*
-		 * Write some more initial register settings
+		 * Write some more initial register settings for revised chips
 		 */
-		if (ah->ah_version == AR5K_AR5212) {
+		if (ah->ah_version == AR5K_AR5212 &&
+		    ah->ah_phy_revision > AR5K_SREV_PHY_5212) {
 			ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
 
 			if (channel->hw_value == CHANNEL_G)
@@ -558,19 +559,13 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
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
+			AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_DAG_CCK_CTL,
+					      AR5K_PHY_DAG_CCK_CTL_EN_RSSI_THR);
+
+			AR5K_REG_MASKED_BITS(ah, AR5K_PHY_DAG_CCK_CTL,
+					     2 << AR5K_PHY_DAG_CCK_CTL_RSSI_THR_S,
+					     ~AR5K_PHY_DAG_CCK_CTL_RSSI_THR);
 
 			/* Just write 0x9b5 ? */
 			/* ath5k_hw_reg_write(ah, 0x000009b5, 0xa228); */
