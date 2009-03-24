Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:34125 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZCXUdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:33:32 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC] ath9k's regulatory domain code changes (for ar9170)
Date: Tue, 24 Mar 2009 21:33:27 +0100
Cc: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
References: <200903241938.47155.chunkeey@web.de> <b6c5339f0903241303y58aca745rfad05ed8ddb93e70@mail.gmail.com> <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com>
In-Reply-To: <43e72e890903241310m1c09a55ex4c47aebdb483896e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903242133.28405.chunkeey@web.de> (sfid-20090324_213334_581898_A7C12C9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 24 March 2009 21:10:21 Luis R. Rodriguez wrote:
> On Tue, Mar 24, 2009 at 1:03 PM, Bob Copeland <me@bobcopeland.com> wrote:
> > On Tue, Mar 24, 2009 at 2:41 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >> Do any of you guys have time to pick it up?
> >
> > Well my patch #2 is pretty similar to what Christian has, and I'd like to
> > upstream the first few patches soon (especially the ath.ko creation, it is a
> > beast to rebase as you saw).  That would bring up the first contentious
> > point of the merge: is "ath/ath.ko" ok with everyone?
> 
> Yes.
Yes.

> > ath5k/9k specific
> > bits can eventually go in ath/{5k,9k} subdirs... not sure where 9170
> > lives then :)
> 
> Wherever Christian wants it. If he finds re-usable bits then great.
maybe ath/9kusb ?
 
> > I probably can't get to it until the weekend, but if you have more time,
> > Christian, feel free to adopt whatever you want from mine.  Otherwise I'll
> > pick up where Luis left off on the weekend.
Done! Patch attached, please add to the tree ;)

> > I didn't push it yet because ath5k was having problems once I turned it
> > on for ath5k,
> 
> So this is why I recommend to trim the channel list down of ath5k. The
> other reason is you won't have users spending what may be 3/4 of their
> time scanning on channels that they won't ever find APs in. What can
> be done here is add  flag or command as we had reviewed a while back
> to allow the user to enable these channels if he knows what he is
> doing so that way we know we don't mind bothering scanning on the
> gazillion channels. But that is just my advice. My concern first is to
> get users working happily and quickly associated to an AP and I think
> that parallels those goals and puts as secondary the bells and
> whistles of adding every single possible channel.
> 
> > and I have no other hardware to test with so wanted to
> > figure out what was broken first.
> > Channel list is a good hint, maybe
> > it's time to fix iw/nl80211 to send back all the channels :)
> 
> So that is the other option. I tried looking at that yesterday but
> wasn't able to find a way to do this. I went through the netlink
> documenation and even tried modifying the skb on the kernel side as
> its a dump. Not sure what to do here to fix this.
> 
> So yes, both are possible options. Just keep in mind that without
> being able to see the channel list with 'iw list' debugging regulatory
> is a real royal pain in the ass. So I'd try to fix that first either
> through channel reduction (you get another bonus enhancement for
> scanning time for users) or through fixing this through iw/nl80211.
> 
> Johannes probably can advise best on the second path.
> 
>   Luis
---
From: Christian Lamparter <chunkeey@web.de>
Date: Tue, 24 Mar 2009 21:24:14 +0100
Subject: [PATCH] ar9170: use regulatory infrastructure
To: linux-wireless@vger.kernel.org

Make ar9170 select the ath module and add in the hooks to make the
eeprom regulatory hint and reg notifier take effect.

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ar9170/Kconfig b/drivers/net/wireless/ar9170/Kconfig
index de4281f..b99e326 100644
--- a/drivers/net/wireless/ar9170/Kconfig
+++ b/drivers/net/wireless/ar9170/Kconfig
@@ -2,6 +2,7 @@ config AR9170_USB
 	tristate "Atheros AR9170 802.11n USB support"
 	depends on USB && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
+	select ATH_COMMON
 	help
 	  This is a driver for the Atheros "otus" 802.11n USB devices.
 
diff --git a/drivers/net/wireless/ar9170/ar9170.h b/drivers/net/wireless/ar9170/ar9170.h
index f4fb2e9..87c1985 100644
--- a/drivers/net/wireless/ar9170/ar9170.h
+++ b/drivers/net/wireless/ar9170/ar9170.h
@@ -48,6 +48,8 @@
 #include "eeprom.h"
 #include "hw.h"
 
+#include "../ath/regd.h"
+
 #define PAYLOAD_MAX	(AR9170_MAX_CMD_LEN/4 - 1)
 
 enum ar9170_bw {
@@ -151,6 +153,7 @@ struct ar9170 {
 
 	/* EEPROM */
 	struct ar9170_eeprom eeprom;
+	struct ath_regulatory regulatory;
 
 	/* global tx status for unregistered Stations. */
 	struct sk_buff_head global_tx_status;
diff --git a/drivers/net/wireless/ar9170/main.c b/drivers/net/wireless/ar9170/main.c
index 5996ff9..4a251fc 100644
--- a/drivers/net/wireless/ar9170/main.c
+++ b/drivers/net/wireless/ar9170/main.c
@@ -1619,12 +1619,24 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 	else
 		ar->hw->channel_change_time = 80 * 1000;
 
+	ar->regulatory.current_rd = le16_to_cpu(ar->eeprom.reg_domain[0]);
+	ar->regulatory.current_rd_ext = le16_to_cpu(ar->eeprom.reg_domain[1]);
+
 	/* second part of wiphy init */
 	SET_IEEE80211_PERM_ADDR(ar->hw, addr);
 
 	return bands ? 0 : -EINVAL;
 }
 
+int ar9170_reg_notifier(struct wiphy *wiphy,
+			struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ar9170 *ar = hw->priv;
+
+	return ath_reg_notifier_apply(wiphy, request, &ar->regulatory);
+}
+
 int ar9170_register(struct ar9170 *ar, struct device *pdev)
 {
 	int err;
@@ -1634,10 +1646,16 @@ int ar9170_register(struct ar9170 *ar, struct device *pdev)
 	if (err)
 		goto err_out;
 
+	err = ath_regd_init(&ar->regulatory, ar->hw->wiphy,
+			    ar9170_reg_notifier);
+
 	err = ieee80211_register_hw(ar->hw);
 	if (err)
 		goto err_out;
 
+	if (!ath_is_world_regd(&ar->regulatory))
+		regulatory_hint(ar->hw->wiphy, ar->regulatory.alpha2);
+
 	err = ar9170_init_leds(ar);
 	if (err)
 		goto err_unreg;
