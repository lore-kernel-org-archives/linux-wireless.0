Return-Path: <SRS0=Sl5Z=XU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D03BC432C1
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 09:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E65520640
	for <linux-wireless@archiver.kernel.org>; Wed, 25 Sep 2019 09:16:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fedux.com.ar header.i=@fedux.com.ar header.b="yePeTKb3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbfIYJPw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 25 Sep 2019 05:15:52 -0400
Received: from mail.fedux.com.ar ([116.203.58.232]:59242 "EHLO
        mail.fedux.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfIYJPc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Sep 2019 05:15:32 -0400
Received: from kaoz-xps.fedux.com.ar (unknown [192.168.12.12])
        by mail.fedux.com.ar (Postfix) with ESMTP id 90AAC2911FA;
        Wed, 25 Sep 2019 11:08:58 +0200 (CEST)
Authentication-Results: mail.fedux.com.ar; dmarc=fail (p=none dis=none) header.from=fedux.com.ar
Authentication-Results: mail.fedux.com.ar; spf=fail smtp.mailfrom=fedux@fedux.com.ar
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fedux.com.ar;
        s=default; t=1569402538;
        bh=rvX46RF6nf0sD/QksdtcBCmzkEhusG9u1aHeTNBCeJo=;
        h=From:To:Cc:Subject:Date:From;
        b=yePeTKb3SaJJRQU41Ga0SO+v8wY72ncVQz/X89AcaV39E5EmEG8OUlrsVQ+15/6mF
         i+IDHz6RYtx12GM6MtrUj3u1QQwwEENGZqjyT6g71PXFtIuhBdwove/9YOx/WxMKx8
         k+1NGWW7H7quLiMZxE1mXG48Gxmpk+cVVIFfLOTs=
Received: by kaoz-xps.fedux.com.ar (Postfix, from userid 1000)
        id 65253140C0E; Wed, 25 Sep 2019 11:08:58 +0200 (CEST)
From:   Federico Cuello <fedux@fedux.com.ar>
To:     linux-wireless@vger.kernel.org
Cc:     wgong@codeaurora.org
Subject: ath10k: Poor performance with kernel 5.3 fixed
Date:   Wed, 25 Sep 2019 11:08:55 +0200
Message-Id: <20190925090856.6964-1-fedux@fedux.com.ar>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When upgrading to 5.3 my AP started to work really slow. I tracked the problem to 4504f0e5b5714d9d26b1a80bf1fc133c95830588 and fixed the issue.

Logs before the patch:

 ath10k_pci 0000:04:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043222ff sub 0000:0000
 ath10k_pci 0000:04:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 0 testmode 0
 ath10k_pci 0000:04:00.0: firmware ver 10.2.4-1.0-00047 api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 35bd9258
 ath10k_pci 0000:04:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
 ath10k_pci 0000:04:00.0: UART prints enabled

Notice that UART prints were enabled (when they were not enabled by param)

The attached patch fixes the issue when uart_print is false and uart_pin_workaround also false.


