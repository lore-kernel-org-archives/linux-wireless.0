Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D934CC10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:05:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A50A72075B
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 17:05:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="q8kUkFoV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfDORFp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:05:45 -0400
Received: from [208.74.158.174] ([208.74.158.174]:44362 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfDORFp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 13:05:45 -0400
Received: from ben-dt4.candelatech.com (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        by mail3.candelatech.com (Postfix) with ESMTP id 16CD4DD3B;
        Mon, 15 Apr 2019 10:05:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 16CD4DD3B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1555347945;
        bh=Tsdtoegx8Xf+NjyHMUbDftA0IC02iuhNOhfDBP5lwFs=;
        h=From:To:Cc:Subject:Date:From;
        b=q8kUkFoVfmQHAFm49gg3UPwXuLRCkbv6ZWO58QVlDZbT4bUSCFQS4PYuVyyPmQ2RI
         FDTlcDeCSRUGpMKnXuplWnmTbwa5fN7vrXfcR20QGdDegPKoAs1BofjxfdbOqI73Wi
         n1ih/KnBqQOwd4jAp1A2tB9z3bHC/jNJP4EcNrw8=
From:   greearb@candelatech.com
To:     linux-wireless@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>
Subject: [PATCH-v2 1/2] wireless:  Support assoc-at-ms timer in sta-info
Date:   Mon, 15 Apr 2019 10:05:42 -0700
Message-Id: <20190415170543.21728-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

Report time stamp of when sta became associated.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 include/net/cfg80211.h       | 2 ++
 include/uapi/linux/nl80211.h | 2 ++
 net/wireless/nl80211.c       | 1 +
 3 files changed, 5 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f49eb1464b7a..430501c09c01 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1268,6 +1268,7 @@ struct cfg80211_tid_stats {
  *	indicate the relevant values in this struct for them
  * @connected_time: time(in secs) since a station is last connected
  * @inactive_time: time since last station activity (tx/rx) in milliseconds
+ * @auth_at_ms: time in ms of the last assoc -> auth transition.
  * @rx_bytes: bytes (size of MPDUs) received from this station
  * @tx_bytes: bytes (size of MPDUs) transmitted to this station
  * @llid: mesh local link id
@@ -1324,6 +1325,7 @@ struct station_info {
 	u64 filled;
 	u32 connected_time;
 	u32 inactive_time;
+	u64 auth_at_ms;
 	u64 rx_bytes;
 	u64 tx_bytes;
 	u16 llid;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 0f03cfcda965..8d0b7a88877c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3079,6 +3079,7 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_TX_DURATION: aggregate PPDU duration for all frames
  *	sent to the station (u64, usec)
  * @NL80211_STA_INFO_AIRTIME_WEIGHT: current airtime weight for station (u16)
+ * @NL80211_STA_INFO_AUTH_AT_MS: Timestamp of last assoc -> auth transition, in ms
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3124,6 +3125,7 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_CONNECTED_TO_GATE,
 	NL80211_STA_INFO_TX_DURATION,
 	NL80211_STA_INFO_AIRTIME_WEIGHT,
+	NL80211_STA_INFO_AUTH_AT_MS,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bcb432815c64..74be48c1ae02 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4763,6 +4763,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 
 	PUT_SINFO(CONNECTED_TIME, connected_time, u32);
 	PUT_SINFO(INACTIVE_TIME, inactive_time, u32);
+	PUT_SINFO_U64(AUTH_AT_MS, auth_at_ms);
 
 	if (sinfo->filled & (BIT_ULL(NL80211_STA_INFO_RX_BYTES) |
 			     BIT_ULL(NL80211_STA_INFO_RX_BYTES64)) &&
-- 
2.20.1

