Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCA5C10F03
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 13:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D56520851
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 13:48:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UbKUSia3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388201AbfCANsk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 08:48:40 -0500
Received: from nbd.name ([46.4.11.11]:48212 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387620AbfCANsk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 08:48:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X073gWWHXWDbNTa1Y1zcoDVnEJjVW39Y64jZ04GTwJg=; b=UbKUSia37tASKS7lAtw1rMnVjk
        N2As1zuCkKE5YYxehFKIvpz9aFGL/ZvtqdzI/02cCUEREusjFTx4saALghF1TsQSVTds8SPXKXQzM
        lMdaN7hcTiblDCz8hvRWr4CJy3jW1mX+pwxWDJeawCydCxCE0RKiUML9c4e9bDbSg3qg=;
Received: by maeck.lan (Postfix, from userid 501)
        id B32D550AD975; Fri,  1 Mar 2019 14:48:37 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org
Subject: [PATCH] mac80211: do not call driver wake_tx_queue op during reconfig
Date:   Fri,  1 Mar 2019 14:48:37 +0100
Message-Id: <20190301134837.88087-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There are several scenarios in which mac80211 can call drv_wake_tx_queue
after ieee80211_restart_hw has been called and has not yet completed.
Driver private structs are considered uninitialized until mac80211 has
uploaded the vifs, stations and keys again, so using private tx queue
data during that time is not safe.

The driver can also not rely on drv_reconfig_complete to figure out when
it is safe to accept drv_wake_tx_queue calls again, because it is only
called after all tx queues are woken again.

To fix this, bail out early in drv_wake_tx_queue if local->in_reconfig
is set.

Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/driver-ops.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 28d022a3eee3..ae4f0be3b393 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1195,6 +1195,9 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->txq.vif);
 
+	if (local->in_reconfig)
+		return;
+
 	if (!check_sdata_in_driver(sdata))
 		return;
 
-- 
2.17.0

