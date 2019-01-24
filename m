Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77D27C282C5
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 433CA2184C
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 18:20:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bKQ8M2wu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfAXSUO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:20:14 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53199 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfAXSUN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 13:20:13 -0500
Received: by mail-wm1-f65.google.com with SMTP id m1so4222850wml.2;
        Thu, 24 Jan 2019 10:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BIBJq82hkm+qIkG+xr4tAkKYfkF+2DF/cutYzEy5If0=;
        b=bKQ8M2wuEfKQzvBgV+EVfavWhZZLbIWeiy3lDuS2FiS2Dc3ugs8yE4PmG51F3ine2S
         GJ3+JVP3xXSgSiNTv6jB2yRbmwcSG5KPpv+NuqBDHEP+OowIlm1FlINOaYi3rjc+lZZc
         rGFwBS45dBRA/JPzP1Cb5NeMmKRnA7XngAH09uGT0gUD2jPp3oGm1lSNFTRtDpZYiVFS
         5rfy+cTsqufOuzd1JBo9sXJknZ5HJ5R78xhXzpxrzk1rfCxMWfhjxLHQGjdaI02Uq+GD
         Y2CJNE/b9DDG2Xx5u6KMYnxOweA9iXxBrXbcGFsXzm55EaQWmqwuiOAopuCQAoqwXtLJ
         N/Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=BIBJq82hkm+qIkG+xr4tAkKYfkF+2DF/cutYzEy5If0=;
        b=KrUTXHTS/CLRzpWlXbZnDJyxafz9ouPEy0UHRN8FdIQuU/KVgP0RMyW8NTw8vcoHjJ
         c0uREGKmhzDkWc91LBEJszBYTV8kKn4fMFzqJOYl152TDctsd3Z6UNc9zszucudFsyLT
         boeO8ewVQg6aGm6fizhlXKQ7Gq6P7VNWn88DNvIfRSH2aB6ey53JEa+bBna4RkBdK9Kn
         4PZnMau39BmRJmhDwkpuoMzq777Im3yYyDzPx+zj1gGPz3Btw7FBFqc3O7SkKlWTTFLj
         0lo/xP1ekryrcxfoT+I6TbrqT/ja/ZF1/s+Trr8+5jQQRMitRhgiQ+mfg/BWB/N6aRNX
         ePXw==
X-Gm-Message-State: AJcUukfWcL5WkJKz7Pt/AMWfMOVRmXY0GZLaLmVgmrLmYojBk7PnHKyh
        /Py67m53QqmRF5ZkzSGCJjs=
X-Google-Smtp-Source: ALg8bN5m51Z20rtSvf7lI9wWrOsfvn8OAlHeX/HsScX66o3ByR5sXtJ0XkhssrK5yWmWqJtl5NwVzA==
X-Received: by 2002:a1c:9ed7:: with SMTP id h206mr3552223wme.28.1548354011486;
        Thu, 24 Jan 2019 10:20:11 -0800 (PST)
Received: from macbookpro.malat.net (bru31-1-78-225-224-134.fbx.proxad.net. [78.225.224.134])
        by smtp.gmail.com with ESMTPSA id p12sm62275538wmi.5.2019.01.24.10.20.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Jan 2019 10:20:10 -0800 (PST)
Received: by macbookpro.malat.net (Postfix, from userid 1000)
        id 83ED41143573; Thu, 24 Jan 2019 19:20:04 +0100 (CET)
From:   Mathieu Malaterre <malat@debian.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Mathieu Malaterre <malat@debian.org>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] mac80211: Add attribute aligned(2) to struct 'action'
Date:   Thu, 24 Jan 2019 19:19:57 +0100
Message-Id: <20190124181957.22915-1-malat@debian.org>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190124180535.20216-1-malat@debian.org>
References: <20190124180535.20216-1-malat@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

During refactor in commit 9e478066eae4 ("mac80211: fix MU-MIMO
follow-MAC mode") a new struct 'action' was declared with packed
attribute as:

  struct {
          struct ieee80211_hdr_3addr hdr;
          u8 category;
          u8 action_code;
  } __packed action;

But since struct 'ieee80211_hdr_3addr' is declared with an aligned
keyword as:

  struct ieee80211_hdr {
  	__le16 frame_control;
  	__le16 duration_id;
  	u8 addr1[ETH_ALEN];
  	u8 addr2[ETH_ALEN];
  	u8 addr3[ETH_ALEN];
  	__le16 seq_ctrl;
  	u8 addr4[ETH_ALEN];
  } __packed __aligned(2);

Solve the ambiguity of placing aligned structure in a packed one by
adding the aligned(2) attribute to struct 'action'. This seems to be the
behavior of gcc anyway, since the following is still compiling:

  BUILD_BUG_ON(sizeof(action) != IEEE80211_MIN_ACTION_SIZE + 1);

This removes the following warning (W=1):

  net/mac80211/rx.c:234:2: warning: alignment 1 of 'struct <anonymous>' is less than 2 [-Wpacked-not-aligned]

Cc: Johannes Berg <johannes.berg@intel.com>
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Mathieu Malaterre <malat@debian.org>
---
v2: It was suggested by Johannes that an arch actually need the pack attribute (alpha).

 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 45aad3d3108c..885df250b67e 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -231,7 +231,7 @@ static void ieee80211_handle_mu_mimo_mon(struct ieee80211_sub_if_data *sdata,
 		struct ieee80211_hdr_3addr hdr;
 		u8 category;
 		u8 action_code;
-	} __packed action;
+	} __packed __aligned(2) action;
 
 	if (!sdata)
 		return;
-- 
2.19.2

