Return-Path: <SRS0=Z1rL=YC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B7D9ECE58D
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 17:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA64420679
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Oct 2019 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570642216;
	bh=NJb3PdRwSfT1QSxxEObHPqMhGSClyyumJNuAzDmURQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MWh7AN5IQr4e8LTm3WpAqwgvLoTyI1l5vl+LQK6WWW2cjYf2RMF2jz7zo74rWfMB3
	 v/E+OvGMJ7kYdtwoH+IO3VoRjUl+HKHeEgfX/B8L9VWAfRTBxLE4mw5ah5ZblX8UWp
	 S2REW0Q4ws5iN4951fio/0XaEv40XqKkDdfCttH4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732471AbfJIRaK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Oct 2019 13:30:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732004AbfJIRYK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:10 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D23A21D7C;
        Wed,  9 Oct 2019 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641849;
        bh=NJb3PdRwSfT1QSxxEObHPqMhGSClyyumJNuAzDmURQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1uJa8R0kbCxZdQ5qUiW8s5JVaX82IUiqemxXHRfrBhDWitwXC5RxwpxYxz2/0aAWs
         GF9ld6ShXXtr8YSceudmzx+CZrgvp47+87v0OroxXVewhM7/wwms5PzZmOjsNpqUXz
         KoEnLlDWdTO0KWZFm7y2zqPMEuZchx/9jMQeZMEY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/26] mac80211: fix txq null pointer dereference
Date:   Wed,  9 Oct 2019 13:05:49 -0400
Message-Id: <20191009170558.32517-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170558.32517-1-sashal@kernel.org>
References: <20191009170558.32517-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit 8ed31a264065ae92058ce54aa3cc8da8d81dc6d7 ]

If the interface type is P2P_DEVICE or NAN, read the file of
'/sys/kernel/debug/ieee80211/phyx/netdev:wlanx/aqm' will get a
NULL pointer dereference. As for those interface type, the
pointer sdata->vif.txq is NULL.

Unable to handle kernel NULL pointer dereference at virtual address 00000011
CPU: 1 PID: 30936 Comm: cat Not tainted 4.14.104 #1
task: ffffffc0337e4880 task.stack: ffffff800cd20000
PC is at ieee80211_if_fmt_aqm+0x34/0xa0 [mac80211]
LR is at ieee80211_if_fmt_aqm+0x34/0xa0 [mac80211]
[...]
Process cat (pid: 30936, stack limit = 0xffffff800cd20000)
[...]
[<ffffff8000b7cd00>] ieee80211_if_fmt_aqm+0x34/0xa0 [mac80211]
[<ffffff8000b7c414>] ieee80211_if_read+0x60/0xbc [mac80211]
[<ffffff8000b7ccc4>] ieee80211_if_read_aqm+0x28/0x30 [mac80211]
[<ffffff80082eff94>] full_proxy_read+0x2c/0x48
[<ffffff80081eef00>] __vfs_read+0x2c/0xd4
[<ffffff80081ef084>] vfs_read+0x8c/0x108
[<ffffff80081ef494>] SyS_read+0x40/0x7c

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/1569549796-8223-1-git-send-email-miaoqing@codeaurora.org
[trim useless data from commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/debugfs_netdev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index d37d4acafebf5..316250ae90712 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -490,9 +490,14 @@ static ssize_t ieee80211_if_fmt_aqm(
 	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct txq_info *txqi = to_txq_info(sdata->vif.txq);
+	struct txq_info *txqi;
 	int len;
 
+	if (!sdata->vif.txq)
+		return 0;
+
+	txqi = to_txq_info(sdata->vif.txq);
+
 	spin_lock_bh(&local->fq.lock);
 	rcu_read_lock();
 
@@ -659,7 +664,9 @@ static void add_common_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_vht_mcs_mask_5ghz);
 	DEBUGFS_ADD(hw_queues);
 
-	if (sdata->local->ops->wake_tx_queue)
+	if (sdata->local->ops->wake_tx_queue &&
+	    sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE &&
+	    sdata->vif.type != NL80211_IFTYPE_NAN)
 		DEBUGFS_ADD(aqm);
 }
 
-- 
2.20.1

