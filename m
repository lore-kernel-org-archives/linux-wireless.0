Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3728 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbcAGJeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 04:34:22 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u079TKXD014224
	for <linux-wireless@vger.kernel.org>; Thu, 7 Jan 2016 01:34:21 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 208ynrkk5j-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 01:34:21 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	chunfan chen <jeffc@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 2/6] mwifiex: add wowlan info messages
Date: Thu, 7 Jan 2016 01:31:27 -0800
Message-ID: <1452159091-30997-3-git-send-email-akarwar@marvell.com> (sfid-20160107_103430_889112_7DFB481B)
In-Reply-To: <1452159091-30997-1-git-send-email-akarwar@marvell.com>
References: <1452159091-30997-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: chunfan chen <jeffc@marvell.com>

This patch adds informative messages in wake up on
magic packet, disconnect, pattern configuration paths.

Signed-off-by: chunfan chen <jeffc@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index c27c6cc..6d36d08 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3171,10 +3171,12 @@ static int mwifiex_set_wowlan_mef_entry(struct mwifiex_private *priv,
 				sizeof(byte_seq));
 		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
 
-		if (first_pat)
+		if (first_pat) {
 			first_pat = false;
-		else
+			mwifiex_dbg(priv->adapter, INFO, "Wake on patterns\n");
+		} else {
 			mef_entry->filter[filt_num].filt_action = TYPE_AND;
+		}
 
 		filt_num++;
 	}
@@ -3200,6 +3202,7 @@ static int mwifiex_set_wowlan_mef_entry(struct mwifiex_private *priv,
 		mef_entry->filter[filt_num].offset = 56;
 		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
 		mef_entry->filter[filt_num].filt_action = TYPE_OR;
+		mwifiex_dbg(priv->adapter, INFO, "Wake on magic packet\n");
 	}
 	return ret;
 }
@@ -3295,6 +3298,7 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
 				    "Failed to set HS params\n");
 			return ret;
 		}
+		mwifiex_dbg(priv->adapter, INFO, "Wake on device disconnect\n");
 	}
 
 	return ret;
-- 
1.8.1.4

