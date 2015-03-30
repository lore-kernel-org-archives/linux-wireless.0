Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35853 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbbC3K5T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 06:57:19 -0400
Received: by wibg7 with SMTP id g7so98066719wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2015 03:57:18 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH] iw: handle NL80211_ATTR_EXT_FEATURES attribute
Date: Mon, 30 Mar 2015 12:56:31 +0200
Message-Id: <1427712991-26839-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20150330_125736_656311_85301602)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print if VHT-IBSS is supported.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 info.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/info.c b/info.c
index 66887e3..91dff15 100644
--- a/info.c
+++ b/info.c
@@ -63,6 +63,18 @@ static char *dfs_state_name(enum nl80211_dfs_state state)
 	}
 }
 
+static int ext_feature_isset(const unsigned char *ext_features, int ext_features_len,
+			     enum nl80211_ext_feature_index ftidx)
+{
+	unsigned char ft_byte;
+
+	if ((int) ftidx / 8 >= ext_features_len)
+		return 0;
+
+	ft_byte = ext_features[ftidx / 8];
+	return (ft_byte & BIT(ftidx % 8)) != 0;
+}
+
 static int print_phy_handler(struct nl_msg *msg, void *arg)
 {
 	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
@@ -601,6 +613,14 @@ broken_combination:
 			printf("\tDevice supports TDLS channel switching\n");
 	}
 
+	if (tb_msg[NL80211_ATTR_EXT_FEATURES]) {
+		struct nlattr *tb = tb_msg[NL80211_ATTR_EXT_FEATURES];
+
+		if (ext_feature_isset(nla_data(tb), nla_len(tb),
+				      NL80211_EXT_FEATURE_VHT_IBSS))
+			printf("\tDevice supports VHT-IBSS.\n");
+	}
+
 	if (tb_msg[NL80211_ATTR_TDLS_SUPPORT])
 		printf("\tDevice supports T-DLS.\n");
 
-- 
1.9.1

