Return-Path: <SRS0=XE1e=U2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CCA3C48BD3
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 00:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7092020663
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jun 2019 00:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561596875;
	bh=AHobH1/9iKwPcpIwDFnixvX3zbiA/aLX5C1BflQFJsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MhzEDGzu/I2Nv7ko9IhRdH/Ea3/UNksMTDYYI7cchcxVdw2rNKVytxhermha8x5ZF
	 k4MjzTFIzt18668Nfe54w7nFukAQMRwQyK0zxlsq6GPjP4wZuSXch+xM2UKyCOwlr0
	 9zSzQLvCfZ/moSMPd6ReZtDMwGGDjihUSERq32p8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbfF0AbY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Jun 2019 20:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727140AbfF0AbX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:23 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE160216E3;
        Thu, 27 Jun 2019 00:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595482;
        bh=AHobH1/9iKwPcpIwDFnixvX3zbiA/aLX5C1BflQFJsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lWzg0Mc7CXx0BuzzCeLjALtbylp7J05X6gTS8UnlogcarF3rf4xbMq93zQsDrkeat
         2w2vfR4+2ByMLYKx6TyQCYxXG51fFqbIJ+iQdvj2LK9PMdQuywVLDlCtdagVPnsHGn
         CXIAHERTPmh3I39U/vzX4VF5VoY/mieG5ooKQA7Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 20/95] mac80211: free peer keys before vif down in mesh
Date:   Wed, 26 Jun 2019 20:29:05 -0400
Message-Id: <20190627003021.19867-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

[ Upstream commit 0112fa557c3bb3a002bc85760dc3761d737264d3 ]

freeing peer keys after vif down is resulting in peer key uninstall
to fail due to interface lookup failure. so fix that.

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d5aba5029cb0..fe44f0d98de0 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -929,6 +929,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata);
+	ieee80211_free_keys(sdata, true);
 	mesh_path_flush_by_iface(sdata);
 
 	/* stop the beacon */
-- 
2.20.1

