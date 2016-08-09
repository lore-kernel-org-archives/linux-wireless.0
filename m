Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51697 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948AbcHIOvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 10:51:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u79EnTps002701
	for <linux-wireless@vger.kernel.org>; Tue, 9 Aug 2016 07:51:37 -0700
Received: from sc-exch01.marvell.com ([199.233.58.181])
	by mx0b-0016f401.pphosted.com with ESMTP id 24nfdkd6hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2016 07:51:37 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/3] mwifiex: add custom regulatory domain support
Date: Tue, 9 Aug 2016 20:20:46 +0530
Message-ID: <1470754246-635-3-git-send-email-akarwar@marvell.com> (sfid-20160809_165141_694964_C767ED32)
In-Reply-To: <1470754246-635-1-git-send-email-akarwar@marvell.com>
References: <1470754246-635-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch creates custom regulatory rules based on the information
received from firmware and enable them during wiphy registration.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    | 39 ++++++----
 drivers/net/wireless/marvell/mwifiex/fw.h          |  8 ++
 drivers/net/wireless/marvell/mwifiex/main.c        |  2 +
 drivers/net/wireless/marvell/mwifiex/main.h        |  1 +
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 91 ++++++++++++++++++++++
 5 files changed, 127 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 86b31b1..a91d442 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4224,9 +4224,12 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 	wiphy->cipher_suites = mwifiex_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
 
-	if (adapter->region_code)
-		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
+	if (adapter->regd) {
+		wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
+					   REGULATORY_DISABLE_BEACON_HINTS |
 					   REGULATORY_COUNTRY_IE_IGNORE;
+		wiphy_apply_custom_regulatory(wiphy, adapter->regd);
+	}
 
 	ether_addr_copy(wiphy->perm_addr, adapter->perm_addr);
 	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
@@ -4292,19 +4295,27 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 		return ret;
 	}
 
-	if (reg_alpha2 && mwifiex_is_valid_alpha2(reg_alpha2)) {
-		mwifiex_dbg(adapter, INFO,
-			    "driver hint alpha2: %2.2s\n", reg_alpha2);
-		regulatory_hint(wiphy, reg_alpha2);
-	} else {
-		if (adapter->region_code == 0x00) {
-			mwifiex_dbg(adapter, WARN, "Ignore world regulatory domain\n");
+	if (!adapter->regd) {
+		if (reg_alpha2 && mwifiex_is_valid_alpha2(reg_alpha2)) {
+			mwifiex_dbg(adapter, INFO,
+				    "driver hint alpha2: %2.2s\n", reg_alpha2);
+			regulatory_hint(wiphy, reg_alpha2);
 		} else {
-			country_code =
-				mwifiex_11d_code_2_region(adapter->region_code);
-			if (country_code &&
-			    regulatory_hint(wiphy, country_code))
-				mwifiex_dbg(priv->adapter, ERROR, "regulatory_hint() failed\n");
+			if (adapter->region_code == 0x00) {
+				mwifiex_dbg(adapter, WARN,
+					    "Ignore world regulatory domain\n");
+			} else {
+				wiphy->regulatory_flags |=
+					REGULATORY_DISABLE_BEACON_HINTS |
+					REGULATORY_COUNTRY_IE_IGNORE;
+				country_code =
+					mwifiex_11d_code_2_region(
+						adapter->region_code);
+				if (country_code &&
+				    regulatory_hint(wiphy, country_code))
+					mwifiex_dbg(priv->adapter, ERROR,
+						    "regulatory_hint() failed\n");
+			}
 		}
 	}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 085db99..18aa525 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -416,6 +416,14 @@ enum P2P_MODES {
 	P2P_MODE_CLIENT = 3,
 };
 
+enum mwifiex_channel_flags {
+	MWIFIEX_CHANNEL_PASSIVE = BIT(0),
+	MWIFIEX_CHANNEL_DFS = BIT(1),
+	MWIFIEX_CHANNEL_NOHT40 = BIT(2),
+	MWIFIEX_CHANNEL_NOHT80 = BIT(3),
+	MWIFIEX_CHANNEL_DISABLED = BIT(7),
+};
+
 #define HostCmd_RET_BIT                       0x8000
 #define HostCmd_ACT_GEN_GET                   0x0000
 #define HostCmd_ACT_GEN_SET                   0x0001
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 0181247..7f2fb81 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -143,6 +143,8 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 		adapter->nd_info = NULL;
 	}
 
+	kfree(adapter->regd);
+
 	vfree(adapter->chan_stats);
 	kfree(adapter);
 	return 0;
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 2d32768..26df28f 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1009,6 +1009,7 @@ struct mwifiex_adapter {
 	bool usb_mc_status;
 	bool usb_mc_setup;
 	struct cfg80211_wowlan_nd_info *nd_info;
+	struct ieee80211_regdomain *regd;
 };
 
 void mwifiex_process_tx_queue(struct mwifiex_adapter *adapter);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index db85330..3344a26 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -1022,6 +1022,93 @@ static int mwifiex_ret_robust_coex(struct mwifiex_private *priv,
 	return 0;
 }
 
+static struct ieee80211_regdomain *
+mwifiex_create_custom_regdomain(struct mwifiex_private *priv,
+				u8 *buf, u16 buf_len)
+{
+	u16 num_chan = buf_len / 2;
+	struct ieee80211_regdomain *regd;
+	struct ieee80211_reg_rule *rule;
+	bool new_rule;
+	int regd_size, idx, freq, prev_freq = 0;
+	u32 bw, prev_bw = 0;
+	u8 chflags, prev_chflags = 0, valid_rules = 0;
+
+	if (WARN_ON_ONCE(num_chan > NL80211_MAX_SUPP_REG_RULES))
+		return ERR_PTR(-EINVAL);
+
+	regd_size = sizeof(struct ieee80211_regdomain) +
+		    num_chan * sizeof(struct ieee80211_reg_rule);
+
+	regd = kzalloc(regd_size, GFP_KERNEL);
+	if (!regd)
+		return ERR_PTR(-ENOMEM);
+
+	for (idx = 0; idx < num_chan; idx++) {
+		u8 chan;
+		enum nl80211_band band;
+
+		chan = *buf++;
+		if (!chan)
+			return NULL;
+		chflags = *buf++;
+		band = (chan <= 14) ? NL80211_BAND_2GHZ : NL80211_BAND_5GHZ;
+		freq = ieee80211_channel_to_frequency(chan, band);
+		new_rule = false;
+
+		if (chflags & MWIFIEX_CHANNEL_DISABLED)
+			continue;
+
+		if (band == NL80211_BAND_5GHZ) {
+			if (!(chflags & MWIFIEX_CHANNEL_NOHT80))
+				bw = MHZ_TO_KHZ(80);
+			else if (!(chflags & MWIFIEX_CHANNEL_NOHT40))
+				bw = MHZ_TO_KHZ(40);
+			else
+				bw = MHZ_TO_KHZ(20);
+		} else {
+			if (!(chflags & MWIFIEX_CHANNEL_NOHT40))
+				bw = MHZ_TO_KHZ(40);
+			else
+				bw = MHZ_TO_KHZ(20);
+		}
+
+		if (idx == 0 || prev_chflags != chflags || prev_bw != bw ||
+		    freq - prev_freq > 20) {
+			valid_rules++;
+			new_rule = true;
+		}
+
+		rule = &regd->reg_rules[valid_rules - 1];
+
+		rule->freq_range.end_freq_khz = MHZ_TO_KHZ(freq + 10);
+
+		prev_chflags = chflags;
+		prev_freq = freq;
+		prev_bw = bw;
+
+		if (!new_rule)
+			continue;
+
+		rule->freq_range.start_freq_khz = MHZ_TO_KHZ(freq - 10);
+		rule->power_rule.max_eirp = DBM_TO_MBM(19);
+
+		if (chflags & MWIFIEX_CHANNEL_PASSIVE)
+			rule->flags = NL80211_RRF_NO_IR;
+
+		if (chflags & MWIFIEX_CHANNEL_DFS)
+			rule->flags = NL80211_RRF_DFS;
+
+		rule->freq_range.max_bandwidth_khz = bw;
+	}
+
+	regd->n_reg_rules = valid_rules;
+	regd->alpha2[0] = '9';
+	regd->alpha2[1] = '9';
+
+	return regd;
+}
+
 static int mwifiex_ret_chan_region_cfg(struct mwifiex_private *priv,
 				       struct host_cmd_ds_command *resp)
 {
@@ -1050,6 +1137,10 @@ static int mwifiex_ret_chan_region_cfg(struct mwifiex_private *priv,
 			mwifiex_dbg_dump(priv->adapter, CMD_D, "CHAN:",
 					 (u8 *)head + sizeof(*head),
 					 tlv_buf_len);
+			priv->adapter->regd =
+				mwifiex_create_custom_regdomain(priv,
+								(u8 *)head +
+						sizeof(*head), tlv_buf_len);
 			break;
 		}
 
-- 
1.9.1

