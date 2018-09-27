Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BAFC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 23:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EDB5216FE
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 23:05:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ATQKR6Vn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EDB5216FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbeI1F0C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 01:26:02 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:38696 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbeI1FZ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 01:25:58 -0400
Received: by mail-it1-f193.google.com with SMTP id p129-v6so551728ite.3
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 16:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EGPQKS9QAFsXKRvVZGbetCzzPksevUpCvkfR7rrWeW8=;
        b=ATQKR6VnPyCVoqS9yz4vtyoApwEntOu68/67lS4jXTsw8PoPYHz4XIjnDFMCcx6SSg
         k1EUpPmDPzXbtHQ+pvGkbSl1rxCrVD/Lg4JjQIcZRB0ilQ17F5aiwC0bSLSnCl1FltYh
         enbPSzj0xgiLM8r4iCmiPNl82yZHGkFbLlDzAgaxjjW8t5x+CQZnoa0N7t4TraA3KqJI
         VpXkbshJnChKVwqgtpmVeNwuGR+yE1RS/HqWdoVAQ3rwDJ473jpRJggL6Ln9ZxPJuICv
         GVRjjpuFMhT7Sr6GkymaZ1167qYnruytDeyBVOo1UDlLn5hwncixFTaur5fiZvcxtwPf
         uJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EGPQKS9QAFsXKRvVZGbetCzzPksevUpCvkfR7rrWeW8=;
        b=jjETe8K7NJo1rhJ08CiAlu7+sDhbLDJbynpgWzJWeLVHNObM7LIxT5J1uxETJ2VQN2
         anc+o8Phmg6VW/4tFwFnhsRVmBCAZvSxv0a5N0/KJ0vGT/yzl98QZh/Yi3shtUeFhAw4
         Mn4B00y4dQBvJ4MefXSS1twahYsgkC27TNosWI30lcTVv/c/pus770nyDuhq+3rRYpvJ
         93+Ecnr0r8A21yyZQKWZyS7DWFCKvDOVp3kn99CfeQYqV2mMCXPyBOQ4bOaq771QSYrO
         SvSGfR/7t/jOsRtTgXGmuh0V1EnwKbTK9sskQbCNR82k4FPX6EUO3bsHzlwQLhGunrdN
         BtCg==
X-Gm-Message-State: ABuFfoh+8ZOS4dPLgyJpzMyK6e5fvIgzvaUru1eyEFfS9Gmtebn4MxNZ
        L6u86wHU9YNFiBzyyRs7ndcDLgDIasjtSWAX
X-Google-Smtp-Source: ACcGV63e0V7CwAvk/TzQ9Q+GXYuS7cGW80anCP79Wv8cZqP3rC/sZCFXeQjHLgPrw1AKV7Pj/EVR0Q==
X-Received: by 2002:a24:2487:: with SMTP id f129-v6mr571824ita.51.1538089516862;
        Thu, 27 Sep 2018 16:05:16 -0700 (PDT)
Received: from yuzhao.bld.corp.google.com ([2620:15c:183:0:a0c3:519e:9276:fc96])
        by smtp.gmail.com with ESMTPSA id o201-v6sm211331ito.41.2018.09.27.16.05.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Sep 2018 16:05:15 -0700 (PDT)
From:   Yu Zhao <yuzhao@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>
Subject: [PATCH] cfg80211: fix use-after-free in reg_process_hint()
Date:   Thu, 27 Sep 2018 17:05:04 -0600
Message-Id: <20180927230504.214931-1-yuzhao@google.com>
X-Mailer: git-send-email 2.19.0.605.g01d371f741-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

reg_process_hint_country_ie() can free regulatory_request and return
REG_REQ_ALREADY_SET. We shouldn't use regulatory_request after it's
called. KASAN error was observed when this happens.

BUG: KASAN: use-after-free in reg_process_hint+0x839/0x8aa [cfg80211]
Read of size 4 at addr ffff8800c430d434 by task kworker/1:3/89
<snipped>
Workqueue: events reg_todo [cfg80211]
Call Trace:
 dump_stack+0xc1/0x10c
 ? _atomic_dec_and_lock+0x1ad/0x1ad
 ? _raw_spin_lock_irqsave+0xa0/0xd2
 print_address_description+0x86/0x26f
 ? reg_process_hint+0x839/0x8aa [cfg80211]
 kasan_report+0x241/0x29b
 reg_process_hint+0x839/0x8aa [cfg80211]
 reg_todo+0x204/0x5b9 [cfg80211]
 process_one_work+0x55f/0x8d0
 ? worker_detach_from_pool+0x1b5/0x1b5
 ? _raw_spin_unlock_irq+0x65/0xdd
 ? _raw_spin_unlock_irqrestore+0xf3/0xf3
 worker_thread+0x5dd/0x841
 ? kthread_parkme+0x1d/0x1d
 kthread+0x270/0x285
 ? pr_cont_work+0xe3/0xe3
 ? rcu_read_unlock_sched_notrace+0xca/0xca
 ret_from_fork+0x22/0x40

Allocated by task 2718:
 set_track+0x63/0xfa
 __kmalloc+0x119/0x1ac
 regulatory_hint_country_ie+0x38/0x329 [cfg80211]
 __cfg80211_connect_result+0x854/0xadd [cfg80211]
 cfg80211_rx_assoc_resp+0x3bc/0x4f0 [cfg80211]
smsc95xx v1.0.6
 ieee80211_sta_rx_queued_mgmt+0x1803/0x7ed5 [mac80211]
 ieee80211_iface_work+0x411/0x696 [mac80211]
 process_one_work+0x55f/0x8d0
 worker_thread+0x5dd/0x841
 kthread+0x270/0x285
 ret_from_fork+0x22/0x40

Freed by task 89:
 set_track+0x63/0xfa
 kasan_slab_free+0x6a/0x87
 kfree+0xdc/0x470
 reg_process_hint+0x31e/0x8aa [cfg80211]
 reg_todo+0x204/0x5b9 [cfg80211]
 process_one_work+0x55f/0x8d0
 worker_thread+0x5dd/0x841
 kthread+0x270/0x285
 ret_from_fork+0x22/0x40
<snipped>

Signed-off-by: Yu Zhao <yuzhao@google.com>
---
 net/wireless/reg.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 765dedb12361..24cfa2776f50 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2661,11 +2661,12 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 {
 	struct wiphy *wiphy = NULL;
 	enum reg_request_treatment treatment;
+	enum nl80211_reg_initiator initiator = reg_request->initiator;
 
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
 
-	switch (reg_request->initiator) {
+	switch (initiator) {
 	case NL80211_REGDOM_SET_BY_CORE:
 		treatment = reg_process_hint_core(reg_request);
 		break;
@@ -2683,7 +2684,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		treatment = reg_process_hint_country_ie(wiphy, reg_request);
 		break;
 	default:
-		WARN(1, "invalid initiator %d\n", reg_request->initiator);
+		WARN(1, "invalid initiator %d\n", initiator);
 		goto out_free;
 	}
 
@@ -2698,7 +2699,7 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	 */
 	if (treatment == REG_REQ_ALREADY_SET && wiphy &&
 	    wiphy->regulatory_flags & REGULATORY_STRICT_REG) {
-		wiphy_update_regulatory(wiphy, reg_request->initiator);
+		wiphy_update_regulatory(wiphy, initiator);
 		wiphy_all_share_dfs_chan_state(wiphy);
 		reg_check_channels();
 	}
-- 
2.19.0.605.g01d371f741-goog

