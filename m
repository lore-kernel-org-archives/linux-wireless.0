Return-Path: <SRS0=TwMq=7D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B708C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 21 May 2020 12:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17D452078B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 May 2020 12:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590064503;
	bh=FHL2jEvxOll6vmZM4DX6DqzH90iBYE9p2hBWzKlPxkE=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=aHrz+IKo7CajCFSnD+4+HB6ul2Basy7t78WmBliu11jD1HPVKoHXZ0hknY5TF1+ND
	 fFJVLQ7k3x7RXl014FsAcrff3/M5GzI1+UnPsKmxo/Jf34P70vtnIdlRvFOorbBUYa
	 3Cj7gAFHjGTJ03i8ifbM1Wxc5majLxWfFkAQdz2k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgEUMe5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 May 2020 08:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728160AbgEUMe4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 May 2020 08:34:56 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F394D2070A;
        Thu, 21 May 2020 12:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590064496;
        bh=FHL2jEvxOll6vmZM4DX6DqzH90iBYE9p2hBWzKlPxkE=;
        h=From:To:Cc:Subject:Date:From;
        b=Z3uh7cHNKQpZCISsf6c+gxtdwdCXNbRFeQ0vnkQaA2rGWm7WSWfcTRs+TbArLs7Nt
         23/qWplkyfMdUlfFIo03HzGrdvHCr9hAwOhEDS9nmBS7ubVszAZA2AKNXBkqf2BLSK
         vTp2L2NyZzYW0cv9W+IXCGqoBeB4kkbNUaHDJYhU=
Received: by pali.im (Postfix)
        id 9332C34B; Thu, 21 May 2020 14:34:53 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: Parse all API_VER_ID properties
Date:   Thu, 21 May 2020 14:34:44 +0200
Message-Id: <20200521123444.28957-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

During initialization of SD8997 wifi chip kernel prints warnings:

  mwifiex_sdio mmc0:0001:1: Unknown api_id: 3
  mwifiex_sdio mmc0:0001:1: Unknown api_id: 4

This patch adds support for parsing all api ids provided by SD8997
firmware.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 17 +++++++++++++++--
 drivers/net/wireless/marvell/mwifiex/fw.h     |  2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 7e4b8cd52..589cc5eb1 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1581,8 +1581,21 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 					adapter->fw_api_ver =
 							api_rev->major_ver;
 					mwifiex_dbg(adapter, INFO,
-						    "Firmware api version %d\n",
-						    adapter->fw_api_ver);
+						    "Firmware api version %d.%d\n",
+						    adapter->fw_api_ver,
+						    api_rev->minor_ver);
+					break;
+				case UAP_FW_API_VER_ID:
+					mwifiex_dbg(adapter, INFO,
+						    "uAP api version %d.%d\n",
+						    api_rev->major_ver,
+						    api_rev->minor_ver);
+					break;
+				case CHANRPT_API_VER_ID:
+					mwifiex_dbg(adapter, INFO,
+						    "channel report api version %d.%d\n",
+						    api_rev->major_ver,
+						    api_rev->minor_ver);
 					break;
 				default:
 					mwifiex_dbg(adapter, FATAL,
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index a415d73a7..6f86f5b96 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1052,6 +1052,8 @@ struct host_cmd_ds_802_11_ps_mode_enh {
 enum API_VER_ID {
 	KEY_API_VER_ID = 1,
 	FW_API_VER_ID = 2,
+	UAP_FW_API_VER_ID = 3,
+	CHANRPT_API_VER_ID = 4,
 };
 
 struct hw_spec_api_rev {
-- 
2.20.1

