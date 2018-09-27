Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7CCFC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:02:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B26821582
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:02:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SkATBhBf";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QZiFt6gs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B26821582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbeI0VVL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:21:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbeI0VVL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:21:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 074F660B73; Thu, 27 Sep 2018 15:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538060550;
        bh=laTMgCi+VOJDSxfI9w7gRPlOuOpCexGTN44AKVdP4/c=;
        h=From:To:Cc:Subject:Date:From;
        b=SkATBhBfjh6rkMQ8Q1q8KraW/1W5nCcdXYSnE5VY4r0r2xRx6tLrhOk27VFI6urmy
         5TRwF4quxemFJH8YKAUIad9e3eNNts6nsj/fT6pUOT/9E4TiyVw9Ei11RZyNJngLyS
         pp6FvoBJboNjyiwcOhAxfwTXnaMS5U6vHCYu3V78=
Received: from jouni.codeaurora.org (188-67-66-156.bb.dnainternet.fi [188.67.66.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7291F60116;
        Thu, 27 Sep 2018 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538060549;
        bh=laTMgCi+VOJDSxfI9w7gRPlOuOpCexGTN44AKVdP4/c=;
        h=From:To:Cc:Subject:Date:From;
        b=QZiFt6gsTzRfcmxVd63EeS1SVq+ZHWrtaiRU703HETx9ri6gjoVa11H2OZJj00KUI
         3qtnaQHOQFb3RiZSVJfVRiK+cD6i4KGT1mxrYV6JiXyfZ46xNW1+7IUZz5PJKdcLnF
         ULUQ45CcH860FsI5pa84kv8LsgFh4/zV3Rpqi/0c=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7291F60116
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Ankita Bajaj <bankita@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH] nl80211: Add per peer statistics to compute FCS error rate
Date:   Thu, 27 Sep 2018 18:01:57 +0300
Message-Id: <1538060517-32208-1-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ankita Bajaj <bankita@codeaurora.org>

Add support for drivers to report the total number of MPDUs received
and the number of MPDUs received with an FCS error from a specific
peer. These counters will be incremented only when the TA of the
frame matches the MAC address of the peer irrespective of FCS
error.

It should be noted that the TA field in the frame might be corrupted
when there is an FCS error and TA matching logic would fail in such
cases. Hence, FCS error counter might not be fully accurate, but it can
provide help in detecting bad RX links in significant number of cases.
This FCS error counter without full accuracy can be used, e.g., to
trigger a kick-out of a connected client with a bad link in AP mode to
force such a client to roam to another AP.

Signed-off-by: Ankita Bajaj <bankita@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 include/net/cfg80211.h       | 7 +++++++
 include/uapi/linux/nl80211.h | 8 ++++++++
 net/wireless/nl80211.c       | 2 ++
 3 files changed, 17 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9f3ed79..1fbb2d9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1292,6 +1292,10 @@ struct cfg80211_tid_stats {
  * @ack_signal: signal strength (in dBm) of the last ACK frame.
  * @avg_ack_signal: average rssi value of ack packet for the no of msdu's has
  *	been sent.
+ * @rx_mpdu_count: number of MPDUs received from this station
+ * @fcs_err_count: number of packets (MPDUs) received from this station with
+ *	an FCS error. This counter should be incremented only when TA of the
+ *	received packet with an FCS error matches the peer MAC address.
  */
 struct station_info {
 	u64 filled;
@@ -1338,6 +1342,9 @@ struct station_info {
 	struct cfg80211_tid_stats *pertid;
 	s8 ack_signal;
 	s8 avg_ack_signal;
+
+	u32 rx_mpdu_count;
+	u32 fcs_err_count;
 };
 
 #if IS_ENABLED(CONFIG_CFG80211)
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cfc9417..172f312 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3051,6 +3051,12 @@ enum nl80211_sta_bss_param {
  * @NL80211_STA_INFO_PAD: attribute used for padding for 64-bit alignment
  * @NL80211_STA_INFO_ACK_SIGNAL: signal strength of the last ACK frame(u8, dBm)
  * @NL80211_STA_INFO_ACK_SIGNAL_AVG: avg signal strength of ACK frames (s8, dBm)
+ * @NL80211_STA_INFO_RX_MPDUS: total number of received packets (MPDUs)
+ *	(u32, from this station)
+ * @NL80211_STA_INFO_FCS_ERROR_COUNT: total number of packets (MPDUs) received
+ *	with an FCS error (u32, from this station). This count may not include
+ *	some packets with an FCS error due to TA corruption. Hence this counter
+ *	might not be fully accurate.
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
@@ -3091,6 +3097,8 @@ enum nl80211_sta_info {
 	NL80211_STA_INFO_PAD,
 	NL80211_STA_INFO_ACK_SIGNAL,
 	NL80211_STA_INFO_ACK_SIGNAL_AVG,
+	NL80211_STA_INFO_RX_MPDUS,
+	NL80211_STA_INFO_FCS_ERROR_COUNT,
 
 	/* keep last */
 	__NL80211_STA_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0827cbd..3151171 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4719,6 +4719,8 @@ static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
 	PUT_SINFO_U64(RX_DROP_MISC, rx_dropped_misc);
 	PUT_SINFO_U64(BEACON_RX, rx_beacon);
 	PUT_SINFO(BEACON_SIGNAL_AVG, rx_beacon_signal_avg, u8);
+	PUT_SINFO(RX_MPDUS, rx_mpdu_count, u32);
+	PUT_SINFO(FCS_ERROR_COUNT, fcs_err_count, u32);
 	if (wiphy_ext_feature_isset(&rdev->wiphy,
 				    NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT)) {
 		PUT_SINFO(ACK_SIGNAL, ack_signal, u8);
-- 
2.7.4

