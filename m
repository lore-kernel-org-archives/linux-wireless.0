Return-Path: <SRS0=+b/P=TQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CEB2C04AAF
	for <linux-wireless@archiver.kernel.org>; Thu, 16 May 2019 11:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35B1F20833
	for <linux-wireless@archiver.kernel.org>; Thu, 16 May 2019 11:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558007070;
	bh=OTD57Cwg5sWePEP5ap+yjtgWv0JL8IEuxixNXzAh11E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tNesmyxR/XZSthajDHN3SoUp8oxZYAm/DtvRnuTndc9fzakyolRaZSDnD+WbbXKAD
	 SW+mRAfqWLYULNIpBEFoR0eTa2h7SP8PQZnZ+PbjVUM+LsJaAZ3gemkTQsg1FKATXv
	 C4BmZqefkiMBM5L93AVPdp0h7q1dOCHJIhW2TFdg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfEPLoY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 May 2019 07:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbfEPLlT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 May 2019 07:41:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C79E21734;
        Thu, 16 May 2019 11:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006878;
        bh=OTD57Cwg5sWePEP5ap+yjtgWv0JL8IEuxixNXzAh11E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X18Ua0ssGV7xqYJxhQNpys8nSSEjaVsCixOrD0gtmtO9c8REb7E333xjnX2/LXJ2M
         XZTlOaEj8nnZ3alC6p/M1JUsHM68X3Hsb98iUcvtjPpyjO5/b6WId+PKVvsSbZRJlg
         Iq1rJYbjcr7F4l3KWR4bad3OJ9lMtTJ15G0gFo28=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhagavathi Perumal S <bperumal@codeaurora.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 09/16] mac80211: Fix kernel panic due to use of txq after free
Date:   Thu, 16 May 2019 07:41:00 -0400
Message-Id: <20190516114107.8963-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114107.8963-1-sashal@kernel.org>
References: <20190516114107.8963-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Bhagavathi Perumal S <bperumal@codeaurora.org>

[ Upstream commit f1267cf3c01b12e0f843fb6a7450a7f0b2efab8a ]

The txq of vif is added to active_txqs list for ATF TXQ scheduling
in the function ieee80211_queue_skb(), but it was not properly removed
before freeing the txq object. It was causing use after free of the txq
objects from the active_txqs list, result was kernel panic
due to invalid memory access.

Fix kernel invalid memory access by properly removing txq object
from active_txqs list before free the object.

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 222c063244f56..6ce13e976b7a2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1924,6 +1924,9 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
+	if (sdata->vif.txq)
+		ieee80211_txq_purge(sdata->local, to_txq_info(sdata->vif.txq));
+
 	synchronize_rcu();
 
 	if (sdata->dev) {
-- 
2.20.1

