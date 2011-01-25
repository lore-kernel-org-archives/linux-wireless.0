Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:33509 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752559Ab1AYEPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 23:15:37 -0500
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0848848934
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 13:15:35 +0900 (JST)
Subject: [PATCH 3/6] ath: Add function to check if 4.9GHz channels are allowed
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 25 Jan 2011 13:15:33 +0900
Message-ID: <20110125041533.6944.79709.stgit@localhost6.localdomain6>
In-Reply-To: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a helper function to ath/regd.c which can be asked if 4.9GHz channels
are allowed for a given regulatory domain code. This keeps the knowledge of
regdomains and defines like MKK9_MKKC in one place. I'm passing the regdomain
code instead of the ath_regulatory structure because this needs to be called
quite early in the driver inititalization where ath_regulatory is not available
yet in ath5k.

I'm using MKK9_MKKC only because this is the regdomain in the 802.11j enabled
sample cards we got from our vendor. I found some hints in HAL code that this
is used by Atheros to indicate 4.9GHz channels support and that there might be
other domain codes as well, but as I don't have any documentation I'm just
putting in what I need right now. It can be extended later.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/regd.c |    7 +++++++
 drivers/net/wireless/ath/regd.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 2b14775..f828f29 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -158,6 +158,13 @@ ieee80211_regdomain *ath_world_regdomain(struct ath_regulatory *reg)
 	}
 }
 
+bool ath_is_49ghz_allowed(u16 regdomain)
+{
+	/* possibly more */
+	return regdomain == MKK9_MKKC;
+}
+EXPORT_SYMBOL(ath_is_49ghz_allowed);
+
 /* Frequency is one where radar detection is required */
 static bool ath_is_radar_freq(u16 center_freq)
 {
diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 345dd97..172f63f 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -250,6 +250,7 @@ enum CountryCode {
 };
 
 bool ath_is_world_regd(struct ath_regulatory *reg);
+bool ath_is_49ghz_allowed(u16 redomain);
 int ath_regd_init(struct ath_regulatory *reg, struct wiphy *wiphy,
 		  int (*reg_notifier)(struct wiphy *wiphy,
 		  struct regulatory_request *request));

