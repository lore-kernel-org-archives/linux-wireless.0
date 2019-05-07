Return-Path: <SRS0=kZdm=TH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A904CC004C9
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 06:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70823205C9
	for <linux-wireless@archiver.kernel.org>; Tue,  7 May 2019 06:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557208854;
	bh=DJuL2ejuLOji21RwsU2T4+wD8kSXrsBUmaAO2NFzV3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RdCPesVZVK6Fg6M0tCPhijNZyO3+TVBZt1NZubpDRbqPdHCFjZrIGhgAG7lfOsgiY
	 zT3POUG96gWNzUE//c/D7c6O5PBYtwz5yup4CSHm/CDtOnlgCR11rFXuOS+RjPC6UC
	 kQ19SLUR8mmNq9HWqZj77tey+ryd/Cx770pISrEQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728014AbfEGFgM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 May 2019 01:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbfEGFgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 May 2019 01:36:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BD2E20C01;
        Tue,  7 May 2019 05:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207371;
        bh=DJuL2ejuLOji21RwsU2T4+wD8kSXrsBUmaAO2NFzV3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKuLi4UyLC53kpD+u8NQ3JAtiWpNDw5vMAozSwd2nD5qT1zgN7AVP0WiyMWROcuG3
         460zptDbIREi0BB3g2KneDEvD8mODdeQkm74jDWC/2Kz2QHJQgTXjL1U7tpF5DFCDu
         yN75ry0qFO/Gu0VT2WeatC3LYOgR0RzIg5Wzx9ks=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/81] mac80211: Increase MAX_MSG_LEN
Date:   Tue,  7 May 2019 01:34:43 -0400
Message-Id: <20190507053554.30848-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit 78be2d21cc1cd3069c6138dcfecec62583130171 ]

Looks that 100 chars isn't enough for messages, as we keep getting
warnings popping from different places due to message shortening.
Instead of trying to shorten the prints, just increase the buffer size.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/trace_msg.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/trace_msg.h b/net/mac80211/trace_msg.h
index 366b9e6f043e..40141df09f25 100644
--- a/net/mac80211/trace_msg.h
+++ b/net/mac80211/trace_msg.h
@@ -1,4 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Portions of this file
+ * Copyright (C) 2019 Intel Corporation
+ */
+
 #ifdef CONFIG_MAC80211_MESSAGE_TRACING
 
 #if !defined(__MAC80211_MSG_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
@@ -11,7 +16,7 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211_msg
 
-#define MAX_MSG_LEN	100
+#define MAX_MSG_LEN	120
 
 DECLARE_EVENT_CLASS(mac80211_msg_event,
 	TP_PROTO(struct va_format *vaf),
-- 
2.20.1

