Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828A0C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 00:14:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D15D21934
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 00:14:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Exk+lPR6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jtmw/zJ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbfBOAO6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 19:14:58 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:54782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbfBOAO5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 19:14:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9D5C460770; Fri, 15 Feb 2019 00:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550189695;
        bh=tpOCh8mXc6FBsEXbKmsAxdwZuO1W1Vfqnvqng97KFk8=;
        h=From:To:Cc:Subject:Date:From;
        b=Exk+lPR6m7Ht9K/b7zE1ZX9iKZmFk9l+l2NYX+CtqA+ki5VK9YWjbOQzZZUQc7A2L
         nCs6Q++Oa93ZBD9XNN2tpKFEGHYrDREl35oIwrRwYPZZctjOdSMME9kwPzbSDgL1A0
         pjPdo0rRVCkco+6oCbro+cF78nFdr64uIeLdQrns=
Received: from jouni.codeaurora.org (37-33-130-87.bb.dnainternet.fi [37.33.130.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 780E960854;
        Fri, 15 Feb 2019 00:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550189694;
        bh=tpOCh8mXc6FBsEXbKmsAxdwZuO1W1Vfqnvqng97KFk8=;
        h=From:To:Cc:Subject:Date:From;
        b=jtmw/zJ3GeCZwUAeQQIGl6To1CWvECS/Rk0pQhRyRqtEaryo3sVrNUO/5nhTNfh3Q
         EcqQ6qhVstfqYE5+d8htZ/F/T1ufFSevW4Yrws9AZEPHxf1R+nonoHaY5pptk+11Qp
         rjcB8lj8gJN0dH+Z87xwnV4e2Tc02mvjsAKvmlQA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 780E960854
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH v2] cfg80211: Report Association Request frame IEs in association events
Date:   Fri, 15 Feb 2019 02:14:33 +0200
Message-Id: <1550189673-16269-1-git-send-email-jouni@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This extends the NL80211_CMD_ASSOCIATE event case to report
NL80211_ATTR_REQ_IE similarly to what is already done with the
NL80211_CMD_CONNECT events if the driver provides this information. In
practice, this adds (Re)Association Request frame information element
reporting to mac80211 drivers for the cases where user space SME is
used.

This provides more information for user space to figure out which
capabilities were negotiated for the association. For example, this can
be used to determine whether HT, VHT, or HE is used.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
v2:
- fix memory allocation in nl80211_send_mlme_event() to avoid dropping
  events that include large set of request IEs (e.g., FILS+FT
  association)

 include/net/cfg80211.h     |  7 +++++--
 net/mac80211/ieee80211_i.h |  6 ++++++
 net/mac80211/mlme.c        | 14 ++++++++++++--
 net/wireless/mlme.c        |  8 ++++++--
 net/wireless/nl80211.c     | 24 +++++++++++++++---------
 net/wireless/nl80211.h     |  3 ++-
 6 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b61b71f..d2d9d48 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5678,10 +5678,12 @@ void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr);
  * @dev: network device
  * @bss: the BSS that association was requested with, ownership of the pointer
  *	moves to cfg80211 in this call
- * @buf: authentication frame (header + body)
+ * @buf: (Re)Association Response frame (header + body)
  * @len: length of the frame data
  * @uapsd_queues: bitmap of queues configured for uapsd. Same format
  *	as the AC bitmap in the QoS info field
+ * @req_ies: information elements from the (Re)Association Request frame
+ * @req_ies_len: length of req_ies data
  *
  * After being asked to associate via cfg80211_ops::assoc() the driver must
  * call either this function or cfg80211_auth_timeout().
@@ -5691,7 +5693,8 @@ void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr);
 void cfg80211_rx_assoc_resp(struct net_device *dev,
 			    struct cfg80211_bss *bss,
 			    const u8 *buf, size_t len,
-			    int uapsd_queues);
+			    int uapsd_queues,
+			    const u8 *req_ies, size_t req_ies_len);
 
 /**
  * cfg80211_assoc_timeout - notification of timed out association
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6a39ad7..b4a2447 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -556,6 +556,12 @@ struct ieee80211_if_managed {
 	 * get stuck in a downgraded situation and flush takes forever.
 	 */
 	struct delayed_work tx_tspec_wk;
+
+	/* Information elements from the last transmitted (Re)Association
+	 * Request frame.
+	 */
+	u8 *assoc_req_ies;
+	size_t assoc_req_ies_len;
 };
 
 struct ieee80211_if_ibss {
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a49fbb3..df5d4b9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -644,7 +644,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	u8 *pos, qos_info;
+	u8 *pos, qos_info, *ie_start;
 	size_t offset = 0, noffset;
 	int i, count, rates_len, supp_rates_len, shift;
 	u16 capab;
@@ -752,6 +752,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	/* SSID */
 	pos = skb_put(skb, 2 + assoc_data->ssid_len);
+	ie_start = pos;
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = assoc_data->ssid_len;
 	memcpy(pos, assoc_data->ssid, assoc_data->ssid_len);
@@ -976,6 +977,11 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		return;
 	}
 
+	pos = skb_tail_pointer(skb);
+	kfree(ifmgd->assoc_req_ies);
+	ifmgd->assoc_req_ies = kmemdup(ie_start, pos - ie_start, GFP_ATOMIC);
+	ifmgd->assoc_req_ies_len = pos - ie_start;
+
 	drv_mgd_prepare_tx(local, sdata, 0);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
@@ -3544,7 +3550,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 				uapsd_queues |= ieee80211_ac_to_qos_mask[ac];
 	}
 
-	cfg80211_rx_assoc_resp(sdata->dev, bss, (u8 *)mgmt, len, uapsd_queues);
+	cfg80211_rx_assoc_resp(sdata->dev, bss, (u8 *)mgmt, len, uapsd_queues,
+			       ifmgd->assoc_req_ies, ifmgd->assoc_req_ies_len);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -5576,6 +5583,9 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 		ifmgd->teardown_skb = NULL;
 		ifmgd->orig_teardown_skb = NULL;
 	}
+	kfree(ifmgd->assoc_req_ies);
+	ifmgd->assoc_req_ies = NULL;
+	ifmgd->assoc_req_ies_len = 0;
 	spin_unlock_bh(&ifmgd->teardown_lock);
 	del_timer_sync(&ifmgd->timer);
 	sdata_unlock(sdata);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 1615e50..f946201 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -21,7 +21,8 @@
 
 
 void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
-			    const u8 *buf, size_t len, int uapsd_queues)
+			    const u8 *buf, size_t len, int uapsd_queues,
+			    const u8 *req_ies, size_t req_ies_len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -33,6 +34,8 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 	cr.status = (int)le16_to_cpu(mgmt->u.assoc_resp.status_code);
 	cr.bssid = mgmt->bssid;
 	cr.bss = bss;
+	cr.req_ie = req_ies;
+	cr.req_ie_len = req_ies_len;
 	cr.resp_ie = mgmt->u.assoc_resp.variable;
 	cr.resp_ie_len =
 		len - offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
@@ -52,7 +55,8 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 		return;
 	}
 
-	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL, uapsd_queues);
+	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL, uapsd_queues,
+			      req_ies, req_ies_len);
 	/* update current_bss etc., consumes the bss reference */
 	__cfg80211_connect_result(dev, &cr, cr.status == WLAN_STATUS_SUCCESS);
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 80878b4..d5badbb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -14491,12 +14491,13 @@ static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
 				    struct net_device *netdev,
 				    const u8 *buf, size_t len,
 				    enum nl80211_commands cmd, gfp_t gfp,
-				    int uapsd_queues)
+				    int uapsd_queues, const u8 *req_ies,
+				    size_t req_ies_len)
 {
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(100 + len, gfp);
+	msg = nlmsg_new(100 + len + req_ies_len, gfp);
 	if (!msg)
 		return;
 
@@ -14508,7 +14509,9 @@ static void nl80211_send_mlme_event(struct cfg80211_registered_device *rdev,
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
-	    nla_put(msg, NL80211_ATTR_FRAME, len, buf))
+	    nla_put(msg, NL80211_ATTR_FRAME, len, buf) ||
+	    (req_ies &&
+	     nla_put(msg, NL80211_ATTR_REQ_IE, req_ies_len, req_ies)))
 		goto nla_put_failure;
 
 	if (uapsd_queues >= 0) {
@@ -14539,15 +14542,17 @@ void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 			  size_t len, gfp_t gfp)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_AUTHENTICATE, gfp, -1);
+				NL80211_CMD_AUTHENTICATE, gfp, -1, NULL, 0);
 }
 
 void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev, const u8 *buf,
-			   size_t len, gfp_t gfp, int uapsd_queues)
+			   size_t len, gfp_t gfp, int uapsd_queues,
+			   const u8 *req_ies, size_t req_ies_len)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_ASSOCIATE, gfp, uapsd_queues);
+				NL80211_CMD_ASSOCIATE, gfp, uapsd_queues,
+				req_ies, req_ies_len);
 }
 
 void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
@@ -14555,7 +14560,7 @@ void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
 			 size_t len, gfp_t gfp)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_DEAUTHENTICATE, gfp, -1);
+				NL80211_CMD_DEAUTHENTICATE, gfp, -1, NULL, 0);
 }
 
 void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
@@ -14563,7 +14568,7 @@ void nl80211_send_disassoc(struct cfg80211_registered_device *rdev,
 			   size_t len, gfp_t gfp)
 {
 	nl80211_send_mlme_event(rdev, netdev, buf, len,
-				NL80211_CMD_DISASSOCIATE, gfp, -1);
+				NL80211_CMD_DISASSOCIATE, gfp, -1, NULL, 0);
 }
 
 void cfg80211_rx_unprot_mlme_mgmt(struct net_device *dev, const u8 *buf,
@@ -14584,7 +14589,8 @@ void cfg80211_rx_unprot_mlme_mgmt(struct net_device *dev, const u8 *buf,
 		cmd = NL80211_CMD_UNPROT_DISASSOCIATE;
 
 	trace_cfg80211_rx_unprot_mlme_mgmt(dev, buf, len);
-	nl80211_send_mlme_event(rdev, dev, buf, len, cmd, GFP_ATOMIC, -1);
+	nl80211_send_mlme_event(rdev, dev, buf, len, cmd, GFP_ATOMIC, -1,
+				NULL, 0);
 }
 EXPORT_SYMBOL(cfg80211_rx_unprot_mlme_mgmt);
 
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 531c82d..a41e94a 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -67,7 +67,8 @@ void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 void nl80211_send_rx_assoc(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev,
 			   const u8 *buf, size_t len, gfp_t gfp,
-			   int uapsd_queues);
+			   int uapsd_queues,
+			   const u8 *req_ies, size_t req_ies_len);
 void nl80211_send_deauth(struct cfg80211_registered_device *rdev,
 			 struct net_device *netdev,
 			 const u8 *buf, size_t len, gfp_t gfp);
-- 
2.7.4

