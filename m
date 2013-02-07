Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:52262 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759277Ab3BGSik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 13:38:40 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCH 1/2] iw: add radar detect widths to phy info
Date: Thu,  7 Feb 2013 19:38:23 +0100
Message-Id: <1360262304-28362-5-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130207_193847_102644_3B056C0C)
In-Reply-To: <1360262304-28362-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1360262304-28362-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
 info.c      |   22 +++++++++++++++++++++-
 interface.c |    2 +-
 iw.h        |    1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/info.c b/info.c
index 08dbfc0..14db37f 100644
--- a/info.c
+++ b/info.c
@@ -245,6 +245,7 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 				[NL80211_IFACE_COMB_MAXNUM] = { .type = NLA_U32 },
 				[NL80211_IFACE_COMB_STA_AP_BI_MATCH] = { .type = NLA_FLAG },
 				[NL80211_IFACE_COMB_NUM_CHANNELS] = { .type = NLA_U32 },
+				[NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS] = { .type = NLA_U32 },
 			};
 			struct nlattr *tb_comb[NUM_NL80211_IFACE_COMB];
 			static struct nla_policy iface_limit_policy[NUM_NL80211_IFACE_LIMIT] = {
@@ -296,11 +297,30 @@ static int print_phy_handler(struct nl_msg *msg, void *arg)
 			}
 			printf(",\n\t\t   ");
 
-			printf("total <= %d, #channels <= %d%s\n",
+			printf("total <= %d, #channels <= %d%s",
 				nla_get_u32(tb_comb[NL80211_IFACE_COMB_MAXNUM]),
 				nla_get_u32(tb_comb[NL80211_IFACE_COMB_NUM_CHANNELS]),
 				tb_comb[NL80211_IFACE_COMB_STA_AP_BI_MATCH] ?
 					", STA/AP BI must match" : "");
+			if (tb_comb[NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS]) {
+				unsigned long widths = nla_get_u32(tb_comb[NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS]);
+
+				if (widths) {
+					int width;
+					bool first = true;
+
+					printf(", radar detect widths: {");
+					for (width = 0; width < 32; width++)
+						if (widths & (1 << width)) {
+							printf("%s %s",
+							       first ? "":",",
+							       channel_width_name(width));
+							first = false;
+						}
+					printf(" }\n");
+				}
+			}
+			printf("\n");
 broken_combination:
 			;
 		}
diff --git a/interface.c b/interface.c
index 26e72dc..b52c8dd 100644
--- a/interface.c
+++ b/interface.c
@@ -262,7 +262,7 @@ static char *channel_type_name(enum nl80211_channel_type channel_type)
 	}
 }
 
-static char *channel_width_name(enum nl80211_chan_width width)
+char *channel_width_name(enum nl80211_chan_width width)
 {
 	switch (width) {
 	case NL80211_CHAN_WIDTH_20_NOHT:
diff --git a/iw.h b/iw.h
index 3e83bd2..d56e358 100644
--- a/iw.h
+++ b/iw.h
@@ -145,6 +145,7 @@ void print_ampdu_spacing(__u8 spacing);
 void print_ht_capability(__u16 cap);
 void print_vht_info(__u32 capa, const __u8 *mcs);
 
+char *channel_width_name(enum nl80211_chan_width width);
 const char *iftype_name(enum nl80211_iftype iftype);
 const char *command_name(enum nl80211_commands cmd);
 int ieee80211_channel_to_frequency(int chan);
-- 
1.7.10.4

