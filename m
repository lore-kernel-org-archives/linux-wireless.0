Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083ADC04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 15:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD6512081C
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 15:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="dCQ4JH4W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD6512081C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bobcopeland.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbeLDPWI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 10:22:08 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:39927 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbeLDPWI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 10:22:08 -0500
Received: by mail-it1-f195.google.com with SMTP id a6so14955060itl.4
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2018 07:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=fMn3dPX1OnX7Yqg4OcTgMG47IkL6rNVhb+NxzrQaBIM=;
        b=dCQ4JH4W+Pyyx9xR/kjKSZhjYgoiI+l8oHTB45y6X0/FJZAI9HpYPB8VUd9HEs9H9i
         rk10SWHQO/x+nJHdrr4KEJJgEvYWXP/jHeWviFrSGwcojTiNKCtfccJ0MDWPbonINlZK
         9RjOUvzkHEBoKj8lb1ML5+vgqCp/D8C5FE+9h7VXjbtS9YPYTtAu7yx3zKC1z81v3ego
         Sg7RZChGrn9LBojuXeKg07P178L+6RhoJHGrLUYWj3sKDseTCixk/PQQcCfW6oxC/kLq
         D+qLdwBmtrd3J9tCkWPURr+EximY6O9m1/4GY3HPR6SSWuCdgaCzvXcHgCCmx3/pi1g7
         1DHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fMn3dPX1OnX7Yqg4OcTgMG47IkL6rNVhb+NxzrQaBIM=;
        b=gNaUsXTaIqrhe64aRGNgln8w8SWmL/0t+YUZm21Fehw662UYT7/0vcTb8P0KdDyUGL
         ufNEjlye11bqLTGmaeugiKfyQCC1sf0nSATeUUfKWMZhuoAflKED6vkI/9idAqnlLb/Q
         jRvru/l4L22jL4dM5lhmTd3sEXm6DrbwLP1XQgs4rkbYD1uXxiQM189lM9RfcnLdiQLq
         ZtcNhYV21jZzJ2ZutSi2k71K/EbMiceXb+9aY2GLGk1iBS4viTsvnQccMkcof/vY7Ik9
         Hi6mdITCO/bw8H7RCWmM8Juw/WzeIBjbXyBswz8fX7YRTd/918oa/khnJwoxzW0puyis
         q3aw==
X-Gm-Message-State: AA+aEWaPWh6YhJdDat9iRaomqVxeMKIAQDTkxf5bfxja6K0lGDRo0ke1
        UQrQ3zzHrX8X9xakBCh03GWW/5BBuu4=
X-Google-Smtp-Source: AFSGD/WfRnLa2sB/V7+iStO+/mCgNIkCwXS6L1OvRbjrn3f73ZTbMBjWSIOXTtLRHh0gSzlGwGCpww==
X-Received: by 2002:a24:eec7:: with SMTP id b190mr10813583iti.18.1543936927681;
        Tue, 04 Dec 2018 07:22:07 -0800 (PST)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id x79sm5421650ita.34.2018.12.04.07.22.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Dec 2018 07:22:07 -0800 (PST)
Received: from bob by hash with local (Exim 4.89)
        (envelope-from <me@bobcopeland.com>)
        id 1gUCWU-0000b3-1g; Tue, 04 Dec 2018 10:22:06 -0500
From:   Bob Copeland <me@bobcopeland.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Lubomir Rintel <lkundrak@v3.sk>, linux-wireless@vger.kernel.org,
        Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>
Subject: [PATCH] mac80211: rewrite Kconfig text for mesh
Date:   Tue,  4 Dec 2018 10:22:00 -0500
Message-Id: <20181204152200.2252-1-me@bobcopeland.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lubomir Rintel recently pointed out a dead link for o11s.org, and
repointed it to a still live, but also stale website.  As far as I
know, no one is updating the content at open80211s.org.

Since this Kconfig text was originally written, though, the 802.11s
mesh drafts were approved and ultimately rolled into 802.11 proper.
Meanwhile, the implementation has converged on the final standard,
so we can lose all of the text here and provide something that's a
little more helpful and accurate.

Signed-off-by: Bob Copeland <bobcopeland@fb.com>
---
 net/mac80211/Kconfig | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index f869e35d0974..6b09355dfc90 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -57,14 +57,13 @@ comment "Some wireless drivers require a rate control algorithm"
 	depends on MAC80211 && MAC80211_HAS_RC=n
 
 config MAC80211_MESH
-	bool "Enable mac80211 mesh networking (pre-802.11s) support"
+	bool "Enable mac80211 mesh networking support"
 	depends on MAC80211
 	---help---
-	 This options enables support of Draft 802.11s mesh networking.
-	 The implementation is based on Draft 2.08 of the Mesh Networking
-	 amendment.  However, no compliance with that draft is claimed or even
-	 possible, as drafts leave a number of identifiers to be defined after
-	 ratification.  For more information visit http://o11s.org/.
+	  Select this option to enable 802.11 mesh operation in mac80211
+	  drivers that support it.  802.11 mesh connects multiple stations
+	  over (possibly multi-hop) wireless links to form a single logical
+	  LAN.
 
 config MAC80211_LEDS
 	bool "Enable LED triggers"
-- 
2.11.0

