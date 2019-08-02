Return-Path: <SRS0=iUGz=V6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F17DC32750
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Aug 2019 13:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18FA92173E
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Aug 2019 13:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564752040;
	bh=APQlIZNNtq6raPbDv8u/kL/aZQAC1kTYsHljTaTbghA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mvvt36N792gh6gZJeGWMEVBaq3C2UHmDSyaYpoOVjV36kU0m/xLD2NOQDXwJ2ACQQ
	 gH4CbgrsOT4SFvpiShwMs4gCFL/M7aiiBete/LJalvrLM6Atjz8JfshniVQQmjF+iM
	 85jISZ45W8myeYXAtyYgDyis5Gg85OwkVXLy5eKk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393417AbfHBNUi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Aug 2019 09:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393409AbfHBNUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD94121841;
        Fri,  2 Aug 2019 13:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752036;
        bh=APQlIZNNtq6raPbDv8u/kL/aZQAC1kTYsHljTaTbghA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbZbKS+IyShnBeJOE7oK8Ot+IYpPBpR1UdpjDqBcOmwQSSBuAVST+OVAJthDLm6F/
         BMBVEHnOZ5TTrJQ6ZpRj/8d4U9HsJlV+yjsS/jqQCeA2VuekYuqRMqpbCPYI4DghRS
         CdW8YyEzfEPBL6n0SfaIBHoDoyaTbZRngN2ApgxE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 29/76] mac80211: don't warn about CW params when not using them
Date:   Fri,  2 Aug 2019 09:19:03 -0400
Message-Id: <20190802131951.11600-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit d2b3fe42bc629c2d4002f652b3abdfb2e72991c7 ]

ieee80211_set_wmm_default() normally sets up the initial CW min/max for
each queue, except that it skips doing this if the driver doesn't
support ->conf_tx. We still end up calling drv_conf_tx() in some cases
(e.g., ieee80211_reconfig()), which also still won't do anything
useful...except it complains here about the invalid CW parameters.

Let's just skip the WARN if we weren't going to do anything useful with
the parameters.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Link: https://lore.kernel.org/r/20190718015712.197499-1-briannorris@chromium.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/driver-ops.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index acd4afb4944b8..c9a8a2433e8ac 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -187,11 +187,16 @@ int drv_conf_tx(struct ieee80211_local *local,
 	if (!check_sdata_in_driver(sdata))
 		return -EIO;
 
-	if (WARN_ONCE(params->cw_min == 0 ||
-		      params->cw_min > params->cw_max,
-		      "%s: invalid CW_min/CW_max: %d/%d\n",
-		      sdata->name, params->cw_min, params->cw_max))
+	if (params->cw_min == 0 || params->cw_min > params->cw_max) {
+		/*
+		 * If we can't configure hardware anyway, don't warn. We may
+		 * never have initialized the CW parameters.
+		 */
+		WARN_ONCE(local->ops->conf_tx,
+			  "%s: invalid CW_min/CW_max: %d/%d\n",
+			  sdata->name, params->cw_min, params->cw_max);
 		return -EINVAL;
+	}
 
 	trace_drv_conf_tx(local, sdata, ac, params);
 	if (local->ops->conf_tx)
-- 
2.20.1

