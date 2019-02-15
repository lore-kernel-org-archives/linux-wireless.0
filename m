Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DEEC10F04
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 009C020840
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550197765;
	bh=EzBlGYCEMzUagoaUlIyK6y0LsygZV7ynp5frefzAFGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=COsSlPXRrKJnP8Bp3isYRbdDM6K0oAHMR2z3V/FCeU1mwxlxPg5tTEws2QuZrg/+u
	 aLENX5euY3aKdHlc3KtjFQ99nXHj0Hnv04khOMlJcj3JKCNj6CTxxocKSIL9/LqI3i
	 +zJlPAO30NQdbrgVQfmxfhL4eFWvAciVhMjeylyA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391305AbfBOCNF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:13:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404522AbfBOCNE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 21:13:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAFAE21934;
        Fri, 15 Feb 2019 02:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550196783;
        bh=EzBlGYCEMzUagoaUlIyK6y0LsygZV7ynp5frefzAFGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AeUDgxAgvykN9SGd1JvZNGEvyMM06e0KbVJhpd9e4bPLPOexwBfMQB82+FrUycqJl
         DW5mH52q8/fhJ7njCZN913Ea4iiA8Mjjp9PucbEvnUJGHea+mU1y6ZXft4XxHKCdd1
         Vt7TQm7LSG7YWQAY9rbfVyrD+wjJ5rYl60oTxzIs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chaitanya Tata <chaitanya.tata@bluwirelesstechnology.com>,
        Chaitanya Tata <Chaitanya.Tata@bluwireless.co.uk>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 61/65] cfg80211: extend range deviation for DMG
Date:   Thu, 14 Feb 2019 21:11:17 -0500
Message-Id: <20190215021121.177674-61-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190215021121.177674-1-sashal@kernel.org>
References: <20190215021121.177674-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chaitanya Tata <chaitanya.tata@bluwirelesstechnology.com>

[ Upstream commit 93183bdbe73bbdd03e9566c8dc37c9d06b0d0db6 ]

Recently, DMG frequency bands have been extended till 71GHz, so extend
the range check till 20GHz (45-71GHZ), else some channels will be marked
as disabled.

Signed-off-by: Chaitanya Tata <Chaitanya.Tata@bluwireless.co.uk>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 24cfa2776f50..8002ace7c9f6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1249,7 +1249,7 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
  * definitions (the "2.4 GHz band", the "5 GHz band" and the "60GHz band"),
  * however it is safe for now to assume that a frequency rule should not be
  * part of a frequency's band if the start freq or end freq are off by more
- * than 2 GHz for the 2.4 and 5 GHz bands, and by more than 10 GHz for the
+ * than 2 GHz for the 2.4 and 5 GHz bands, and by more than 20 GHz for the
  * 60 GHz band.
  * This resolution can be lowered and should be considered as we add
  * regulatory rule support for other "bands".
@@ -1264,7 +1264,7 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
 	 * with the Channel starting frequency above 45 GHz.
 	 */
 	u32 limit = freq_khz > 45 * ONE_GHZ_IN_KHZ ?
-			10 * ONE_GHZ_IN_KHZ : 2 * ONE_GHZ_IN_KHZ;
+			20 * ONE_GHZ_IN_KHZ : 2 * ONE_GHZ_IN_KHZ;
 	if (abs(freq_khz - freq_range->start_freq_khz) <= limit)
 		return true;
 	if (abs(freq_khz - freq_range->end_freq_khz) <= limit)
-- 
2.19.1

