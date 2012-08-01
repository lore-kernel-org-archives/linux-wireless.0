Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34768 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab2HAU6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 16:58:51 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: [PATCH 2/2] brcmsmac: use channel flags to restrict OFDM
Date: Wed,  1 Aug 2012 15:58:43 -0500
Message-Id: <1343854723-21987-3-git-send-email-seth.forshee@canonical.com> (sfid-20120801_225857_411213_C8B92258)
In-Reply-To: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
References: <1343854723-21987-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

brcmsmac cannot call freq_reg_info() during channel changes as it does
not hold cfg80211_lock, and as a result it generates a lockdep warning.
freq_reg_info() is being used to determine whether OFDM is allowed on
the current channel, so we can avoid the errant call by using the new
IEEE80211_CHAN_NO_OFDM for this purpose instead.

Reported-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    5 +----
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    3 ++-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 9a4c63f..7ed7d75 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -382,9 +382,7 @@ brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
-	const struct ieee80211_reg_rule *reg_rule;
 	struct txpwr_limits txpwr;
-	int ret;
 
 	brcms_c_channel_reg_limits(wlc_cm, chanspec, &txpwr);
 
@@ -393,8 +391,7 @@ brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	);
 
 	/* set or restore gmode as required by regulatory */
-	ret = freq_reg_info(wlc->wiphy, ch->center_freq, 0, &reg_rule);
-	if (!ret && (reg_rule->flags & NL80211_RRF_NO_OFDM))
+	if (ch->flags & IEEE80211_CHAN_NO_OFDM)
 		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
 	else
 		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 9e79d47..192ad5c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -121,7 +121,8 @@ static struct ieee80211_channel brcms_2ghz_chantable[] = {
 		 IEEE80211_CHAN_NO_HT40PLUS),
 	CHAN2GHZ(14, 2484,
 		 IEEE80211_CHAN_PASSIVE_SCAN | IEEE80211_CHAN_NO_IBSS |
-		 IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS)
+		 IEEE80211_CHAN_NO_HT40PLUS | IEEE80211_CHAN_NO_HT40MINUS |
+		 IEEE80211_CHAN_NO_OFDM)
 };
 
 static struct ieee80211_channel brcms_5ghz_nphy_chantable[] = {
-- 
1.7.9.5

