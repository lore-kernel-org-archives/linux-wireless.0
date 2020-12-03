Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263D6C64E7B
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 08:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE1D20C56
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Dec 2020 08:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388195AbgLCILI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Dec 2020 03:11:08 -0500
Received: from mail-m965.mail.126.com ([123.126.96.5]:49104 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbgLCILH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Dec 2020 03:11:07 -0500
X-Greylist: delayed 10807 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2020 03:11:07 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=ExFPH
        COLd096nai3tHpoE+85NQSm9PMpe0XKckFen/s=; b=gF5Jn0J+VlsX8p4oubkgN
        23J7JpQ+X+R4WgaGdFMJ+cnB1F0ZHMaZlW2iriAOieKYLZ3d+3qK9dHXg5G0k1LK
        DtLUXCElWxjseGoNufv07whHgskoifyDe1nrLAZ2kuDzPCKAFKI2fjLkbUsx+svP
        6LLc1BY+QsT0QcjCTfN0z8=
Received: from localhost.localdomain (unknown [58.33.86.165])
        by smtp10 (Coremail) with SMTP id NuRpCgCneLRUXchfi3OrhQ--.2067S2;
        Thu, 03 Dec 2020 11:36:58 +0800 (CST)
From:   zhouliangya@126.com
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, lzhou <zhouliangya@126.com>
Subject: [PATCH 0/1] ath10k_pci_wait_for_target_init() should relax cpu for other task instead of calling medelay() so that cpu can run other tasks. Signed-off-by: lzhou <lzhou@sonicwall.com> ---
Date:   Thu,  3 Dec 2020 11:36:49 +0800
Message-Id: <20201203033650.381992-1-zhouliangya@126.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NuRpCgCneLRUXchfi3OrhQ--.2067S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUwNtxUUUUU
X-Originating-IP: [58.33.86.165]
X-CM-SenderInfo: p2kr3z5ldqw5bd6rjloofrz/1tbijhrvsVpEBN+65wAAsS
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: lzhou <zhouliangya@126.com>

 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.17.1

