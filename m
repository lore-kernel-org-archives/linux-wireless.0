Return-Path: <SRS0=bGvd=SS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9C8C10F13
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66E84206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Apr 2019 07:25:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i8USXuHt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BPJ1VBL1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfDPHZI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Apr 2019 03:25:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbfDPHZI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Apr 2019 03:25:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5102961155; Tue, 16 Apr 2019 07:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555399507;
        bh=b84iQHmq3pLgs/0fPPCrO4wYwRqB4mvcFrRYcZWOtaM=;
        h=From:To:Cc:Subject:Date:From;
        b=i8USXuHtk+NZUiHIcWvrBh3yaiizqxa1S8lJwnM8AB4sR7+916wmRJ0rAQurPJtts
         TBigdcai4UKeWvtggT86YUE/wGZBTTv8tsBkOW8IYny/MRsWlHje0PAOSX8FL6lpOC
         YtUSKRXpLGTz4q4ymMsxdAZE6v6pYDJJbHHLVsbk=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: bperumal@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2263560D0C;
        Tue, 16 Apr 2019 07:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555399506;
        bh=b84iQHmq3pLgs/0fPPCrO4wYwRqB4mvcFrRYcZWOtaM=;
        h=From:To:Cc:Subject:Date:From;
        b=BPJ1VBL17APOj2qQXyGQTf0NvIboL3jNnLZ0FFB52co1BsseX1jkM/WckY/Mt74E0
         NvNfN6nriLuC7VLCX+cY3UZT2BXp1QE1d1kyzuz0BN6fb8l1KbABe3KxAbrWFQRC2U
         vAbM+YGHi7K96LlM8vFNOqW4rsBRaj/y+RXi8sbI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2263560D0C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=bperumal@codeaurora.org
From:   Bhagavathi Perumal S <bperumal@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     Bhagavathi Perumal S <bperumal@codeaurora.org>
Subject: [PATCH] mac80211: Fix kernel panic due to use of txq after free
Date:   Tue, 16 Apr 2019 12:54:40 +0530
Message-Id: <1555399480-30537-1-git-send-email-bperumal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The txq of vif is added to active_txqs list for ATF TXQ scheduling
in the function ieee80211_queue_skb(), but it was not properly removed
before freeing the txq object. It was causing use after free of the txq
objects from the active_txqs list, result was kernel panic
due to invalid memory access.

Fix kernel invalid memory access by properly removing txq object
from active_txqs list before free the object.

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
---
 net/mac80211/iface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 94459b2..410685d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1907,6 +1907,9 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
+	if (sdata->vif.txq)
+		ieee80211_txq_purge(sdata->local, to_txq_info(sdata->vif.txq));
+
 	synchronize_rcu();
 
 	if (sdata->dev) {
-- 
1.9.1

