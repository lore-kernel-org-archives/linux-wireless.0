Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B583ECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 21:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D786A2064A
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 21:22:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D786A2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbeJTF1D (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 01:27:03 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36799 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeJTF1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 01:27:03 -0400
Received: by mail-pg1-f195.google.com with SMTP id f18-v6so16293731pgv.3
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 14:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b2Z4L+tJLmO/LFiX44+43cWewwao+2V9bOsj+DCBHcs=;
        b=N4m4x/U3/4by0cdSt//1jDuvlSeD2QypUVziBkBzdvC62dkjp09FHKfungi7AxjRZP
         EVPz4bnkeoRAxjIHrsEiU/BJZ/jhlDYIW3J3SSdvDffw4q9CKzBqpsXpyfYkbxm5cDtB
         3+IV+xDZKmUZF7DF9X50pXzRstREFfOwTHx3rUryjCsR2vzvEFJSrM2SDA5EmtdcUH7n
         L4BwKzpssOGm7EWP10QKFxO9XnEhPC4RZf4SjJp4Dz6Z9O5ZeDdMVds7NZgQWg3ls54t
         vsFNyj5ulS3QJXRAhy831zMj5vBq4CWpvpMLkU4wrS6n6U3dxC3ZMHbof9PgG2m6glJB
         8p4Q==
X-Gm-Message-State: ABuFfojjWrQiD1HJUc2rHrWfun7x/C4g39N0PJiPtsx+06RDdYXfTzYU
        olj4QBgWEnGHJ+c3AL6gbXA/ibxYod4=
X-Google-Smtp-Source: ACcGV60MR0SPoRvPh6oSP3eliY5lgv3wwqFSwRrQ5yYDEPKPR7gRDNjRKyfrB+lvEbls6CHQNXnTOw==
X-Received: by 2002:a63:ff23:: with SMTP id k35-v6mr34035184pgi.62.1539983954894;
        Fri, 19 Oct 2018 14:19:14 -0700 (PDT)
Received: from iss.ger.corp.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id a15-v6sm27269649pff.8.2018.10.19.14.19.12
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Oct 2018 14:19:14 -0700 (PDT)
From:   Andrew Zaborowski <andrew.zaborowski@intel.com>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2] nl80211: Emit a SET_INTERFACE on iftype change
Date:   Fri, 19 Oct 2018 23:19:06 +0200
Message-Id: <20181019211906.23390-1-andrew.zaborowski@intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Let userspace learn about iftype changes by sending a notification
when handling the NL80211_CMD_SET_INTERFACE command.  There seems
to be no other place where the iftype can change: nl80211_set_interface
is the only caller of cfg80211_change_iface which is the only caller of
ops->change_virtual_intf.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 net/wireless/nl80211.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ac08ba5f0a..de727a69c4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2788,14 +2788,15 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
-			      struct wireless_dev *wdev, bool removal)
+			      struct wireless_dev *wdev,
+			      enum nl80211_commands cmd)
 {
 	struct net_device *dev = wdev->netdev;
-	u8 cmd = NL80211_CMD_NEW_INTERFACE;
 	void *hdr;
 
-	if (removal)
-		cmd = NL80211_CMD_DEL_INTERFACE;
+	WARN_ON(cmd != NL80211_CMD_NEW_INTERFACE &&
+		cmd != NL80211_CMD_DEL_INTERFACE &&
+		cmd != NL80211_CMD_SET_INTERFACE);
 
 	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
@@ -2943,7 +2944,8 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 			}
 			if (nl80211_send_iface(skb, NETLINK_CB(cb->skb).portid,
 					       cb->nlh->nlmsg_seq, NLM_F_MULTI,
-					       rdev, wdev, false) < 0) {
+					       rdev, wdev,
+					       NL80211_CMD_NEW_INTERFACE) < 0) {
 				goto out;
 			}
 			if_idx++;
@@ -2973,7 +2975,7 @@ static int nl80211_get_interface(struct sk_buff *skb, struct genl_info *info)
 		return -ENOMEM;
 
 	if (nl80211_send_iface(msg, info->snd_portid, info->snd_seq, 0,
-			       rdev, wdev, false) < 0) {
+			       rdev, wdev, NL80211_CMD_NEW_INTERFACE) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
@@ -3165,6 +3167,12 @@ static int nl80211_set_interface(struct sk_buff *skb, struct genl_info *info)
 	if (!err && params.use_4addr != -1)
 		dev->ieee80211_ptr->use_4addr = params.use_4addr;
 
+	if (change && !err) {
+		struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+		nl80211_notify_iface(rdev, wdev, NL80211_CMD_SET_INTERFACE);
+	}
+
 	return err;
 }
 
@@ -3267,7 +3275,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (nl80211_send_iface(msg, info->snd_portid, info->snd_seq, 0,
-			       rdev, wdev, false) < 0) {
+			       rdev, wdev, NL80211_CMD_NEW_INTERFACE) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
 	}
@@ -13946,15 +13954,11 @@ void nl80211_notify_iface(struct cfg80211_registered_device *rdev,
 {
 	struct sk_buff *msg;
 
-	WARN_ON(cmd != NL80211_CMD_NEW_INTERFACE &&
-		cmd != NL80211_CMD_DEL_INTERFACE);
-
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return;
 
-	if (nl80211_send_iface(msg, 0, 0, 0, rdev, wdev,
-			       cmd == NL80211_CMD_DEL_INTERFACE) < 0) {
+	if (nl80211_send_iface(msg, 0, 0, 0, rdev, wdev, cmd) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
-- 
2.19.1

