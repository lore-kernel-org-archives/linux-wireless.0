Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 358F9C48BD4
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 11:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01C6520656
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 11:20:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="f/UUTtVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbfFYLUf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 07:20:35 -0400
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48886 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728900AbfFYLUe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 07:20:34 -0400
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id DE0F030C01C;
        Tue, 25 Jun 2019 04:10:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com DE0F030C01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1561461031;
        bh=wQW1g9afgWHv3wlMgELh7kRgNcwwtNlfiR3bhHlhj34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/UUTtVKUrH/0wkQlIPfhveHEZaCyID36CfPsYY0VCAB0SAlt30GbY3WUff/WrOAn
         AHjwrrgh8MBUcCKlQ/Flbh6y2HTdHoHOfnR2ir3eoAnFJQud63sUaARXTGXsSdjiq7
         Zp34NLb0eyfz2mmZ8E1M6PtC01s+wraop6Aj+CMI=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 3BF9760D7E;
        Tue, 25 Jun 2019 04:10:32 -0700 (PDT)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id CE354B02A66; Tue, 25 Jun 2019 13:10:29 +0200 (CEST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V2 4/8] cfg80211: extend ieee80211_operating_class_to_band() for 6GHz
Date:   Tue, 25 Jun 2019 13:10:23 +0200
Message-Id: <1561461027-10793-5-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1561461027-10793-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1561461027-10793-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add 6GHz operating class range as defined in 802.11ax D4.1 Annex E.

Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Leon Zegers <leon.zegers@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4e633d4..4462837 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1474,6 +1474,9 @@ bool ieee80211_operating_class_to_band(u8 operating_class,
 	case 128 ... 130:
 		*band = NL80211_BAND_5GHZ;
 		return true;
+	case 131 ... 135:
+		*band = NL80211_BAND_6GHZ;
+		return true;
 	case 81:
 	case 82:
 	case 83:
-- 
1.9.1

