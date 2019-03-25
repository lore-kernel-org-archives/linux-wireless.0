Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625DBC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:50:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D71120863
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 08:50:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="NfgHjjZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfCYIuT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 04:50:19 -0400
Received: from nbd.name ([46.4.11.11]:38570 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729996AbfCYIuT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 04:50:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=f9fQSoPhwIBnlgSNqgAtbVX01571SNbkgQXh1EI8snU=; b=NfgHjjZMb//T99QNUFc6DU4M8i
        xbUvy35+1BynNkZPz3F69JEMt84li+qk6S0/i0QdYGhH1VA/+xwYsr49HJcmkJctkrIXoBQ7+8sI/
        fuDZ8OpTlmn5rKL0YHRzoahU65T9l5nWhMNG66ADNYJgZiz1O5rqQmJMy+vsLcLzDt2Y=;
Received: from p4ff13338.dip0.t-ipconnect.de ([79.241.51.56] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h8LJB-0003Jn-Cs; Mon, 25 Mar 2019 09:50:17 +0100
Received: by maeck-2.local (Postfix, from userid 501)
        id C0B1F556BFB8; Mon, 25 Mar 2019 09:50:16 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: minstrel_ht: automatically calculate rate duration shift
Date:   Mon, 25 Mar 2019 09:50:16 +0100
Message-Id: <20190325085016.53727-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190325085016.53727-1-nbd@nbd.name>
References: <20190325085016.53727-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A per-group shift was added to reduce the size of the per-rate transmit
duration field to u16 without sacrificing a lot of precision
This patch changes the macros to automatically calculate the best value for
this shift based on the lowest rate within the group.
This simplifies adding more groups and slightly improves accuracy for some of
the existing groups.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rc80211_minstrel_ht.c | 134 +++++++++++++++++------------
 1 file changed, 80 insertions(+), 54 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 00a3a8ce27fe..8b168724c5e7 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -51,8 +51,13 @@
 	MINSTREL_MAX_STREAMS * _sgi +	\
 	_streams - 1
 
+#define _MAX(a, b) (((a)>(b))?(a):(b))
+
+#define GROUP_SHIFT(duration)						\
+	_MAX(0, 16 - __builtin_clz(duration))
+
 /* MCS rate information for an MCS group */
-#define MCS_GROUP(_streams, _sgi, _ht40, _s)				\
+#define __MCS_GROUP(_streams, _sgi, _ht40, _s)				\
 	[GROUP_IDX(_streams, _sgi, _ht40)] = {				\
 	.streams = _streams,						\
 	.shift = _s,							\
@@ -72,6 +77,13 @@
 	}								\
 }
 
+#define MCS_GROUP_SHIFT(_streams, _sgi, _ht40)				\
+	GROUP_SHIFT(MCS_DURATION(_streams, _sgi, _ht40 ? 54 : 26))
+
+#define MCS_GROUP(_streams, _sgi, _ht40)				\
+	__MCS_GROUP(_streams, _sgi, _ht40,				\
+		    MCS_GROUP_SHIFT(_streams, _sgi, _ht40))
+
 #define VHT_GROUP_IDX(_streams, _sgi, _bw)				\
 	(MINSTREL_VHT_GROUP_0 +						\
 	 MINSTREL_MAX_STREAMS * 2 * (_bw) +				\
@@ -81,7 +93,7 @@
 #define BW2VBPS(_bw, r3, r2, r1)					\
 	(_bw == BW_80 ? r3 : _bw == BW_40 ? r2 : r1)
 
-#define VHT_GROUP(_streams, _sgi, _bw, _s)				\
+#define __VHT_GROUP(_streams, _sgi, _bw, _s)				\
 	[VHT_GROUP_IDX(_streams, _sgi, _bw)] = {			\
 	.streams = _streams,						\
 	.shift = _s,							\
@@ -114,6 +126,14 @@
 	}								\
 }
 
+#define VHT_GROUP_SHIFT(_streams, _sgi, _bw)				\
+	GROUP_SHIFT(MCS_DURATION(_streams, _sgi,			\
+				 BW2VBPS(_bw,  117,  54,  26)))
+
+#define VHT_GROUP(_streams, _sgi, _bw)					\
+	__VHT_GROUP(_streams, _sgi, _bw,				\
+		    VHT_GROUP_SHIFT(_streams, _sgi, _bw))
+
 #define CCK_DURATION(_bitrate, _short, _len)		\
 	(1000 * (10 /* SIFS */ +			\
 	 (_short ? 72 + 24 : 144 + 48) +		\
@@ -129,7 +149,7 @@
 	CCK_ACK_DURATION(55, _short) >> _s,		\
 	CCK_ACK_DURATION(110, _short) >> _s
 
-#define CCK_GROUP(_s)					\
+#define __CCK_GROUP(_s)					\
 	[MINSTREL_CCK_GROUP] = {			\
 		.streams = 1,				\
 		.flags = 0,				\
@@ -140,6 +160,12 @@
 		}					\
 	}
 
+#define CCK_GROUP_SHIFT					\
+	GROUP_SHIFT(CCK_ACK_DURATION(10, false))
+
+#define CCK_GROUP __CCK_GROUP(CCK_GROUP_SHIFT)
+
+
 static bool minstrel_vht_only = true;
 module_param(minstrel_vht_only, bool, 0644);
 MODULE_PARM_DESC(minstrel_vht_only,
@@ -154,57 +180,57 @@ MODULE_PARM_DESC(minstrel_vht_only,
  * BW -> SGI -> #streams
  */
 const struct mcs_group minstrel_mcs_groups[] = {
-	MCS_GROUP(1, 0, BW_20, 5),
-	MCS_GROUP(2, 0, BW_20, 4),
-	MCS_GROUP(3, 0, BW_20, 4),
-	MCS_GROUP(4, 0, BW_20, 4),
-
-	MCS_GROUP(1, 1, BW_20, 5),
-	MCS_GROUP(2, 1, BW_20, 4),
-	MCS_GROUP(3, 1, BW_20, 4),
-	MCS_GROUP(4, 1, BW_20, 4),
-
-	MCS_GROUP(1, 0, BW_40, 4),
-	MCS_GROUP(2, 0, BW_40, 4),
-	MCS_GROUP(3, 0, BW_40, 4),
-	MCS_GROUP(4, 0, BW_40, 4),
-
-	MCS_GROUP(1, 1, BW_40, 4),
-	MCS_GROUP(2, 1, BW_40, 4),
-	MCS_GROUP(3, 1, BW_40, 4),
-	MCS_GROUP(4, 1, BW_40, 4),
-
-	CCK_GROUP(8),
-
-	VHT_GROUP(1, 0, BW_20, 5),
-	VHT_GROUP(2, 0, BW_20, 4),
-	VHT_GROUP(3, 0, BW_20, 4),
-	VHT_GROUP(4, 0, BW_20, 4),
-
-	VHT_GROUP(1, 1, BW_20, 5),
-	VHT_GROUP(2, 1, BW_20, 4),
-	VHT_GROUP(3, 1, BW_20, 4),
-	VHT_GROUP(4, 1, BW_20, 4),
-
-	VHT_GROUP(1, 0, BW_40, 4),
-	VHT_GROUP(2, 0, BW_40, 4),
-	VHT_GROUP(3, 0, BW_40, 4),
-	VHT_GROUP(4, 0, BW_40, 3),
-
-	VHT_GROUP(1, 1, BW_40, 4),
-	VHT_GROUP(2, 1, BW_40, 4),
-	VHT_GROUP(3, 1, BW_40, 4),
-	VHT_GROUP(4, 1, BW_40, 3),
-
-	VHT_GROUP(1, 0, BW_80, 4),
-	VHT_GROUP(2, 0, BW_80, 4),
-	VHT_GROUP(3, 0, BW_80, 4),
-	VHT_GROUP(4, 0, BW_80, 2),
-
-	VHT_GROUP(1, 1, BW_80, 4),
-	VHT_GROUP(2, 1, BW_80, 4),
-	VHT_GROUP(3, 1, BW_80, 4),
-	VHT_GROUP(4, 1, BW_80, 2),
+	MCS_GROUP(1, 0, BW_20),
+	MCS_GROUP(2, 0, BW_20),
+	MCS_GROUP(3, 0, BW_20),
+	MCS_GROUP(4, 0, BW_20),
+
+	MCS_GROUP(1, 1, BW_20),
+	MCS_GROUP(2, 1, BW_20),
+	MCS_GROUP(3, 1, BW_20),
+	MCS_GROUP(4, 1, BW_20),
+
+	MCS_GROUP(1, 0, BW_40),
+	MCS_GROUP(2, 0, BW_40),
+	MCS_GROUP(3, 0, BW_40),
+	MCS_GROUP(4, 0, BW_40),
+
+	MCS_GROUP(1, 1, BW_40),
+	MCS_GROUP(2, 1, BW_40),
+	MCS_GROUP(3, 1, BW_40),
+	MCS_GROUP(4, 1, BW_40),
+
+	CCK_GROUP,
+
+	VHT_GROUP(1, 0, BW_20),
+	VHT_GROUP(2, 0, BW_20),
+	VHT_GROUP(3, 0, BW_20),
+	VHT_GROUP(4, 0, BW_20),
+
+	VHT_GROUP(1, 1, BW_20),
+	VHT_GROUP(2, 1, BW_20),
+	VHT_GROUP(3, 1, BW_20),
+	VHT_GROUP(4, 1, BW_20),
+
+	VHT_GROUP(1, 0, BW_40),
+	VHT_GROUP(2, 0, BW_40),
+	VHT_GROUP(3, 0, BW_40),
+	VHT_GROUP(4, 0, BW_40),
+
+	VHT_GROUP(1, 1, BW_40),
+	VHT_GROUP(2, 1, BW_40),
+	VHT_GROUP(3, 1, BW_40),
+	VHT_GROUP(4, 1, BW_40),
+
+	VHT_GROUP(1, 0, BW_80),
+	VHT_GROUP(2, 0, BW_80),
+	VHT_GROUP(3, 0, BW_80),
+	VHT_GROUP(4, 0, BW_80),
+
+	VHT_GROUP(1, 1, BW_80),
+	VHT_GROUP(2, 1, BW_80),
+	VHT_GROUP(3, 1, BW_80),
+	VHT_GROUP(4, 1, BW_80),
 };
 
 static u8 sample_table[SAMPLE_COLUMNS][MCS_GROUP_RATES] __read_mostly;
-- 
2.17.0

