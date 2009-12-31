Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:37598 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbZLaNiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2009 08:38:00 -0500
Subject: [RFC PATCH v5 5/7] ieee80211: add struct ieee80211_hdr_qos
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: johannes@sipsolutions.net, a.young.jason@gmail.com
Date: Thu, 31 Dec 2009 15:37:41 +0200
Message-ID: <20091231133741.29899.5256.stgit@tikku>
In-Reply-To: <20091231133626.29899.95683.stgit@tikku>
References: <20091231133626.29899.95683.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

The header can be used to create qos nullfunc frames, for example.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 include/linux/ieee80211.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 27eb5dc..57859c4 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -147,6 +147,16 @@ struct ieee80211_hdr {
 	u8 addr4[6];
 } __attribute__ ((packed));
 
+struct ieee80211_qos_hdr {
+	__le16 frame_control;
+	__le16 duration_id;
+	u8 addr1[6];
+	u8 addr2[6];
+	u8 addr3[6];
+	__le16 seq_ctrl;
+	__le16 qos_ctrl;
+} __attribute__ ((packed));
+
 /**
  * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
  * @fc: frame control bytes in little-endian byteorder

