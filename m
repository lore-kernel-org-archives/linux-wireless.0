Return-Path: <SRS0=zppH=7Q=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5BFC433E0
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jun 2020 08:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78C0E20810
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Jun 2020 08:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591172580;
	bh=uSmHbbvEYpZnPu0zZHvhJ/ANKlr8Qu+RlgX1/y92C3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=R9rw2IAL9sESl2wEmPLhwgXZIPrQxI6QsyvwScOM0WPxZrXH88ZferXDMJKP+oqXu
	 jtr+ffvwSZoJ9J6JoUX67YAobqNHSbKRKEkrK7KB257nMZ9E/wP5C5KQQPl1ZhFwTq
	 IsKvJwpjFE68eGX5MvVmYtaNGk721SglJG5Tlsvo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgFCIW4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Jun 2020 04:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:48508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgFCIWz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jun 2020 04:22:55 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A352720810;
        Wed,  3 Jun 2020 08:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591172574;
        bh=uSmHbbvEYpZnPu0zZHvhJ/ANKlr8Qu+RlgX1/y92C3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AunphaSwlq0g+Q8Eomu01vPzj/JObXQhZTQl72XC9PRfE6zbrVTCuc4HoPPk6n6Bp
         L8BnZK79phKO+jtVkF+Yz1a4DGJcrC9msz6SzyeOddEiqfC5YEQMUOWnjjnqOwDq2o
         4vwXzDu5JwMFJdDsIi70zeYzRek591sZC3GI5zhA=
Received: by pali.im (Postfix)
        id DF21A6F0; Wed,  3 Jun 2020 10:22:52 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
Cc:     linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Hemantkumar Suthar <shemant@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhaoyang Liu <liuzy@marvell.com>, Cathy Luo <cluo@marvell.com>
Subject: [PATCH 2/4] mwifiex: Fix firmware filename for sd8997 chipset
Date:   Wed,  3 Jun 2020 10:22:27 +0200
Message-Id: <20200603082229.15043-3-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200603082229.15043-1-pali@kernel.org>
References: <20200603082229.15043-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Firmware for sd8997 chipset is distributed by Marvell package and also as
part of the linux-firmware repository in filename sdsd8997_combo_v4.bin.

This patch fixes mwifiex driver to load correct firmware file for sd8997.

Fixes: 6d85ef00d9dfe ("mwifiex: add support for 8997 chipset")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sdio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.h b/drivers/net/wireless/marvell/mwifiex/sdio.h
index 0cac2296ed53..8b476b007c5e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.h
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.h
@@ -38,7 +38,7 @@
 #define SD8801_DEFAULT_FW_NAME "mrvl/sd8801_uapsta.bin"
 #define SD8977_DEFAULT_FW_NAME "mrvl/sdsd8977_combo_v2.bin"
 #define SD8987_DEFAULT_FW_NAME "mrvl/sd8987_uapsta.bin"
-#define SD8997_DEFAULT_FW_NAME "mrvl/sd8997_uapsta.bin"
+#define SD8997_DEFAULT_FW_NAME "mrvl/sdsd8997_combo_v4.bin"
 
 #define BLOCK_MODE	1
 #define BYTE_MODE	0
-- 
2.20.1

