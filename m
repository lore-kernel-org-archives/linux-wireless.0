Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26C4C004D1
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7538D204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7538D204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbeIYET4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:19:56 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46860 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728720AbeIYETx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:53 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOI012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 08/11] qtnfmac: add missing header includes to bus.h
Date:   Mon, 24 Sep 2018 15:15:11 -0700
Message-Id: <20180924221514.4273-9-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A few include directives were missing in bus.h resulting in dependency
of include order in other modules. Add missing includes.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wireless/quantenna/qtnfmac/bus.h
index 2beca5b..7c4f856 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -20,6 +20,9 @@
 #include <linux/netdevice.h>
 #include <linux/workqueue.h>
 
+#include "trans.h"
+#include "core.h"
+
 #define QTNF_MAX_MAC		3
 
 enum qtnf_fw_state {
-- 
2.9.5

