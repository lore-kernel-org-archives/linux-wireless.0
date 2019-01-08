Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E092AC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 20:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6C3520660
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 20:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546978248;
	bh=c/aR64mQpq70LLqGgOeZ/0UuSCwlmMQg4rFdK9J855E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Bpjplw6BV6M0DU960nXkOFoA7jVFSt98lxHxzMw/rpl17IbTordQFgWqNV2nsnoDE
	 kPX+JW3XYGPi630yWDTuj9w2CBEsLWtT1az7zAQdDQH8WOWm6TpgHV4qZtEiDW3vXE
	 Vwe4lbV0J3nGxPs2LII1SeJU4OR5OMyh13zKdPps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbfAHT0p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:60706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728984AbfAHT0n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 14:26:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C88820827;
        Tue,  8 Jan 2019 19:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975603;
        bh=c/aR64mQpq70LLqGgOeZ/0UuSCwlmMQg4rFdK9J855E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAefuSXI3mzkK+RJxRFcFxgdAA+rZbpNn8mBNQoOmfPNzYPBvLnNy+RdWNtWm8ow3
         n7ZzlDIYO8LymPpxjPwup0FnRnRWLpyNgoEbCEz3LQBIfMx5kAMaGI3vRJNDuETL0B
         ZMflOoZDnkSBj3ZOZgaxVJGysYFWAy5m5pX7tmsE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 006/117] qtnfmac: fix error handling in control path
Date:   Tue,  8 Jan 2019 14:24:34 -0500
Message-Id: <20190108192628.121270-6-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192628.121270-1-sashal@kernel.org>
References: <20190108192628.121270-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit 1066bd193d681bda0fbacda9df351241a5ee04d9 ]

This patch fixes the following warnings:

- smatch
drivers/net/wireless/quantenna/qtnfmac/commands.c:132 qtnf_cmd_send_with_reply() warn: variable dereferenced before check 'resp' (see line 117)
drivers/net/wireless/quantenna/qtnfmac/commands.c:716  qtnf_cmd_get_sta_info() error: uninitialized symbol 'var_resp_len'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:1668 qtnf_cmd_get_mac_info() error: uninitialized symbol 'var_data_len'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:1697 qtnf_cmd_get_hw_info() error: uninitialized symbol 'info_len'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:1753 qtnf_cmd_band_info_get() error: uninitialized symbol 'info_len'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:1782 qtnf_cmd_send_get_phy_params() error: uninitialized symbol 'response_size'.
drivers/net/wireless/quantenna/qtnfmac/commands.c:2438 qtnf_cmd_get_chan_stats() error: uninitialized symbol 'var_data_len'.

- gcc-8.2.1
drivers/net/wireless/quantenna/qtnfmac/commands.c: In function 'qtnf_cmd_send_with_reply':
drivers/net/wireless/quantenna/qtnfmac/commands.c:133:54: error: 'resp' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/quantenna/qtnfmac/commands.c | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index bfdc1ad30c13..659e7649fe22 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -84,7 +84,7 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 				    size_t *var_resp_size)
 {
 	struct qlink_cmd *cmd;
-	const struct qlink_resp *resp;
+	struct qlink_resp *resp = NULL;
 	struct sk_buff *resp_skb = NULL;
 	u16 cmd_id;
 	u8 mac_id;
@@ -113,7 +113,12 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 	if (ret)
 		goto out;
 
-	resp = (const struct qlink_resp *)resp_skb->data;
+	if (WARN_ON(!resp_skb || !resp_skb->data)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	resp = (struct qlink_resp *)resp_skb->data;
 	ret = qtnf_cmd_check_reply_header(resp, cmd_id, mac_id, vif_id,
 					  const_resp_size);
 	if (ret)
@@ -686,7 +691,7 @@ int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u8 *sta_mac,
 	struct sk_buff *cmd_skb, *resp_skb = NULL;
 	struct qlink_cmd_get_sta_info *cmd;
 	const struct qlink_resp_get_sta_info *resp;
-	size_t var_resp_len;
+	size_t var_resp_len = 0;
 	int ret = 0;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -1650,7 +1655,7 @@ int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
 {
 	struct sk_buff *cmd_skb, *resp_skb = NULL;
 	const struct qlink_resp_get_mac_info *resp;
-	size_t var_data_len;
+	size_t var_data_len = 0;
 	int ret = 0;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
@@ -1680,8 +1685,8 @@ int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
 {
 	struct sk_buff *cmd_skb, *resp_skb = NULL;
 	const struct qlink_resp_get_hw_info *resp;
+	size_t info_len = 0;
 	int ret = 0;
-	size_t info_len;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
 					    QLINK_CMD_GET_HW_INFO,
@@ -1709,9 +1714,9 @@ int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
 			   struct ieee80211_supported_band *band)
 {
 	struct sk_buff *cmd_skb, *resp_skb = NULL;
-	size_t info_len;
 	struct qlink_cmd_band_info_get *cmd;
 	struct qlink_resp_band_info_get *resp;
+	size_t info_len = 0;
 	int ret = 0;
 	u8 qband;
 
@@ -1764,8 +1769,8 @@ int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
 int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *mac)
 {
 	struct sk_buff *cmd_skb, *resp_skb = NULL;
-	size_t response_size;
 	struct qlink_resp_phy_params *resp;
+	size_t response_size = 0;
 	int ret = 0;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
@@ -2431,7 +2436,7 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u16 channel,
 	struct sk_buff *cmd_skb, *resp_skb = NULL;
 	struct qlink_cmd_get_chan_stats *cmd;
 	struct qlink_resp_get_chan_stats *resp;
-	size_t var_data_len;
+	size_t var_data_len = 0;
 	int ret = 0;
 
 	cmd_skb = qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
-- 
2.19.1

