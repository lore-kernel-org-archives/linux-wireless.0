Return-Path: <SRS0=nAss=VM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01989C7618F
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 13:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C384820C01
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Jul 2019 13:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563199190;
	bh=9DlUVL7BiJn9Yics0/xXX3gpC0iVA/PUk9BWm+XnRF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=DYg8/ToapRy33XHta/xCCNuk+La5dZgqxr+EmvnXIazYTp3ZG7N2vt7f5zLBImzse
	 ZT6Diobo6oPxpMs8ebKy5CGr47AgpIB9FuaOvvBjHkyEjgWhktnrvTOHDmHpcGQUu/
	 EC0m1fdfR23yfOnQNffZnXdN8xocONPXNnFEPAhY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733271AbfGON7h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732859AbfGON7g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jul 2019 09:59:36 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E42AB2083D;
        Mon, 15 Jul 2019 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199175;
        bh=9DlUVL7BiJn9Yics0/xXX3gpC0iVA/PUk9BWm+XnRF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFgFcmjHxKaVzJEnc70ZC6LCbVaccAi3otORjLGSc+7n1jk6LYeC/eG9VtWMLSItH
         coQ6/2PbGW0VvhnCqAbWOXdTTwFVQCdDIGe9iQYbreLWjYWSYmda0fdOLHiMEaCxdb
         H9vVBp7cG9kN7MYHoRdeY/THlLDY2WAJCBuqAgLY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 208/249] iwlwifi: mvm: Drop large non sta frames
Date:   Mon, 15 Jul 2019 09:46:13 -0400
Message-Id: <20190715134655.4076-208-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit ac70499ee97231a418dc1a4d6c9dc102e8f64631 ]

In some buggy scenarios we could possible attempt to transmit frames larger
than maximum MSDU size. Since our devices don't know how to handle this,
it may result in asserts, hangs etc.
This can happen, for example, when we receive a large multicast frame
and try to transmit it back to the air in AP mode.
Since in a legal scenario this should never happen, drop such frames and
warn about it.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 0c2aabc842f9..96f8d38ea321 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -726,6 +726,9 @@ int iwl_mvm_tx_skb_non_sta(struct iwl_mvm *mvm, struct sk_buff *skb)
 
 	memcpy(&info, skb->cb, sizeof(info));
 
+	if (WARN_ON_ONCE(skb->len > IEEE80211_MAX_DATA_LEN + hdrlen))
+		return -1;
+
 	if (WARN_ON_ONCE(info.flags & IEEE80211_TX_CTL_AMPDU))
 		return -1;
 
-- 
2.20.1

