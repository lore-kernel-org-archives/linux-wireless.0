Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DB93C433FE
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Dec 2020 11:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C44B9238EB
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Dec 2020 11:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgLHLhj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Dec 2020 06:37:39 -0500
Received: from mail-m974.mail.163.com ([123.126.97.4]:44478 "EHLO
        mail-m974.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbgLHLhj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Dec 2020 06:37:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=JFdQz613CrrAqkk0wa
        rhc6uhxkVWpMeQ+fnHZ1p81kY=; b=ThuyozpUOKUf/rwBFvmPA6biBGFQr7Utxm
        jWYOSmmI3uV7FR5vzc1RlENMdJxtxIZMJLJE3olOO+H+c4uU+xtBGMaoglqYbBMt
        9Dy8lIZp0NA1pl7+X+whSqu8pduLTfm15Eq6JP6KFzIbze2OPPduxCmjeD881Cks
        ZtGwu/Vc8=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp4 (Coremail) with SMTP id HNxpCgBnd2stZc9f36G3bg--.51101S4;
        Tue, 08 Dec 2020 19:36:16 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] mwifiex: Fix possible buffer overflows in mwifiex_uap_bss_param_prepare
Date:   Tue,  8 Dec 2020 19:36:07 +0800
Message-Id: <20201208113607.24967-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: HNxpCgBnd2stZc9f36G3bg--.51101S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr43urWUZrWUuw1rArW7XFb_yoW8WFyxpF
        Z0gay8Cr18Zr1qkrs7Ja1DGas0ga1UKF13urZ5A34rCr1ftr1fZFyUKFy09ry7uan7t34j
        9r48J3Z5Zrn3GFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRKQ6JUUUUU=
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbiHhD0MFSIrffLfAAAs7
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>

mwifiex_uap_bss_param_prepare() calls memcpy() without checking
the destination size may trigger a buffer overflower,
which a local user could use to cause denial of service or the
execution of arbitrary code.
Fix it by putting the length check before calling memcpy().

Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
---
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index b48a85d79..fb937c7ee 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -496,13 +496,16 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 	struct mwifiex_ie_types_wmmcap *wmm_cap;
 	struct mwifiex_uap_bss_param *bss_cfg = cmd_buf;
 	int i;
+	int ssid_size;
 	u16 cmd_size = *param_size;
 
 	if (bss_cfg->ssid.ssid_len) {
 		ssid = (struct host_cmd_tlv_ssid *)tlv;
 		ssid->header.type = cpu_to_le16(TLV_TYPE_UAP_SSID);
 		ssid->header.len = cpu_to_le16((u16)bss_cfg->ssid.ssid_len);
-		memcpy(ssid->ssid, bss_cfg->ssid.ssid, bss_cfg->ssid.ssid_len);
+		ssid_size = bss_cfg->ssid.ssid_len > strlen(ssid->ssid) ?
+				strlen(ssid->ssid) : bss_cfg->ssid.ssid_len;
+		memcpy(ssid->ssid, bss_cfg->ssid.ssid, ssid_size);
 		cmd_size += sizeof(struct mwifiex_ie_types_header) +
 			    bss_cfg->ssid.ssid_len;
 		tlv += sizeof(struct mwifiex_ie_types_header) +
-- 
2.17.1

