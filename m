Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F78C10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 09:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C162C2084D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 09:00:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BASUZvp3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfDKJAI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 05:00:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51562 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfDKJAH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 05:00:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B8xxDh189980;
        Thu, 11 Apr 2019 09:00:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=/VqD0+RwRK8+OTAHVmDXPJeTV7P9HQ2JyJtLcbYaLjE=;
 b=BASUZvp3Yd1FKqVx4ve7KdMcGo5bPNZeph3C9PWkuSggA8yaMcaGlIFQ7HCvvRXZvTIO
 drU6LbVsgEYrV55jNn7hcL188ZL0C47RkR7r16GlLMPEkz13bOvUuIKA093fKRVUqtaJ
 PbUXhHrNW/qVTo6O9hxzHZdaqHk83dLvSRCLpr66VGuWEtdI33BQBMAPia3qRxqU5ZWk
 sH+uikbq8/VAMH56DQD11MljWPIOkWjYHzHukdZ//g1k3/OMAUDmd2IRmnAb00o+KzRU
 +KB0gqesq0oOR3B1AP0UOIMXKlp0SHBWxw6YqAthMqlQRMSpq6GbtSj/MwFTEl4ZnONL FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2rpkht7uen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Apr 2019 09:00:00 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3B8xwqu143570;
        Thu, 11 Apr 2019 09:00:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2rpkekb8b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Apr 2019 09:00:00 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3B8xxr0004440;
        Thu, 11 Apr 2019 08:59:59 GMT
Received: from kadam (/41.202.241.15)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 11 Apr 2019 01:59:58 -0700
Date:   Thu, 11 Apr 2019 11:59:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Sara Sharon <sara.sharon@intel.com>
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] cfg80211: don't pass pointer to pointer unnecessarily
Message-ID: <20190411085950.GA27567@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9223 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904110063
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9223 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904110064
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The cfg80211_merge_profile() and ieee802_11_find_bssid_profile() are
a bit cleaner if we just pass the merged_ie pointer instead of a pointer
to the pointer.

This isn't a functional change, it's just a clean up.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 include/net/cfg80211.h | 2 +-
 net/mac80211/util.c    | 8 ++++----
 net/wireless/scan.c    | 8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e42604533c99..7c01a5fe2300 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5556,7 +5556,7 @@ bool cfg80211_is_element_inherited(const struct element *element,
 size_t cfg80211_merge_profile(const u8 *ie, size_t ielen,
 			      const struct element *mbssid_elem,
 			      const struct element *sub_elem,
-			      u8 **merged_ie, size_t max_copy_len);
+			      u8 *merged_ie, size_t max_copy_len);
 
 /**
  * enum cfg80211_bss_frame_type - frame type that the BSS data came from
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index da93f6898bb6..d63b6f4937fb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1258,7 +1258,7 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 					    struct ieee802_11_elems *elems,
 					    u8 *transmitter_bssid,
 					    u8 *bss_bssid,
-					    u8 **nontransmitted_profile)
+					    u8 *nontransmitted_profile)
 {
 	const struct element *elem, *sub;
 	size_t profile_len = 0;
@@ -1290,7 +1290,7 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 				continue;
 			}
 
-			memset(*nontransmitted_profile, 0, len);
+			memset(nontransmitted_profile, 0, len);
 			profile_len = cfg80211_merge_profile(start, len,
 							     elem,
 							     sub,
@@ -1299,7 +1299,7 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 
 			/* found a Nontransmitted BSSID Profile */
 			index = cfg80211_find_ie(WLAN_EID_MULTI_BSSID_IDX,
-						 *nontransmitted_profile,
+						 nontransmitted_profile,
 						 profile_len);
 			if (!index || index[1] < 1 || index[2] == 0) {
 				/* Invalid MBSSID Index element */
@@ -1341,7 +1341,7 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			ieee802_11_find_bssid_profile(start, len, elems,
 						      transmitter_bssid,
 						      bss_bssid,
-						      &nontransmitted_profile);
+						      nontransmitted_profile);
 		non_inherit =
 			cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
 					       nontransmitted_profile,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 6956eb4bf917..c04f5451f89b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1501,7 +1501,7 @@ static const struct element
 size_t cfg80211_merge_profile(const u8 *ie, size_t ielen,
 			      const struct element *mbssid_elem,
 			      const struct element *sub_elem,
-			      u8 **merged_ie, size_t max_copy_len)
+			      u8 *merged_ie, size_t max_copy_len)
 {
 	size_t copied_len = sub_elem->datalen;
 	const struct element *next_mbssid;
@@ -1509,7 +1509,7 @@ size_t cfg80211_merge_profile(const u8 *ie, size_t ielen,
 	if (sub_elem->datalen > max_copy_len)
 		return 0;
 
-	memcpy(*merged_ie, sub_elem->data, sub_elem->datalen);
+	memcpy(merged_ie, sub_elem->data, sub_elem->datalen);
 
 	while ((next_mbssid = cfg80211_get_profile_continuation(ie, ielen,
 								mbssid_elem,
@@ -1518,7 +1518,7 @@ size_t cfg80211_merge_profile(const u8 *ie, size_t ielen,
 
 		if (copied_len + next_sub->datalen > max_copy_len)
 			break;
-		memcpy(*merged_ie + copied_len, next_sub->data,
+		memcpy(merged_ie + copied_len, next_sub->data,
 		       next_sub->datalen);
 		copied_len += next_sub->datalen;
 	}
@@ -1587,7 +1587,7 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 			profile_len = cfg80211_merge_profile(ie, ielen,
 							     elem,
 							     sub,
-							     &profile,
+							     profile,
 							     ielen);
 
 			/* found a Nontransmitted BSSID Profile */
-- 
2.17.1

