Return-Path: <SRS0=7mY+=OP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C33D5C04EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 20:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 887752146F
	for <linux-wireless@archiver.kernel.org>; Thu,  6 Dec 2018 20:58:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AhBLb/Hk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 887752146F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbeLFU6n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 6 Dec 2018 15:58:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55524 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbeLFU6m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Dec 2018 15:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xEWM+8O68kcxM5hBX4jdLMvZ7KKlmhadOXeFtvDkR4M=; b=AhBLb/HkSReXGLYGri2A79PcSp
        mcBjJJdVVaPGI8yeXF7hid/eaDeLzAKVClKnXjJyPjcIjc1mR9Bx6qbEYA4wAFF5L1n077dVdF092
        TuXuPjjW3o13sbXoUsUC7HQ6jC6sna8VdBcoc9XvaJx0++c9g28C9J/Z/0yr7GQZ4A0e9ti8hoY3u
        euiuUU9BsnNPpE9Z5FeTjzqTwn7is4zVrC0Omb1PjtdNs4VfNexnWLuS5tEeg6nNHYMTOJHs0ChOu
        LC77Ctn/6H2oHQ/1FYhIt6emlIPj9yYz1KA87MKTp4B/c/wGbW0IOZt0XWcRdN7LU52CYOugvnQzl
        3UpD9iZQ==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gV0jF-0001xY-OS; Thu, 06 Dec 2018 20:58:38 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        David Spinadel <david.spinadel@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] net: wireless: FTM: fix kernel-doc "cannot understand"
 warnings
Message-ID: <ab51d1af-5635-b8dd-31dd-72c2ec75f54c@infradead.org>
Date:   Thu, 6 Dec 2018 12:58:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warnings in FTM due to missing "struct" keyword.

Fixes 109 warnings from <net/cfg80211.h>:
../include/net/cfg80211.h:2838: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '

and fixes 88 warnings from <net/mac80211.h>:
../include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '

Fixes: 81e54d08d9d8 ("cfg80211: support FTM responder configuration/statistics")
Fixes: bc847970f432 ("mac80211: support FTM responder configuration/statistics")

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: David Spinadel <david.spinadel@intel.com>
---
 include/net/cfg80211.h |    2 +-
 include/net/mac80211.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- lnx-420-rc5.orig/include/net/cfg80211.h
+++ lnx-420-rc5/include/net/cfg80211.h
@@ -2815,7 +2815,7 @@ struct cfg80211_external_auth_params {
 };
 
 /**
- * cfg80211_ftm_responder_stats - FTM responder statistics
+ * struct cfg80211_ftm_responder_stats - FTM responder statistics
  *
  * @filled: bitflag of flags using the bits of &enum nl80211_ftm_stats to
  *	indicate the relevant values in this struct for them
--- lnx-420-rc5.orig/include/net/mac80211.h
+++ lnx-420-rc5/include/net/mac80211.h
@@ -467,7 +467,7 @@ struct ieee80211_mu_group_data {
 };
 
 /**
- * ieee80211_ftm_responder_params - FTM responder parameters
+ * struct ieee80211_ftm_responder_params - FTM responder parameters
  *
  * @lci: LCI subelement content
  * @civicloc: CIVIC location subelement content


