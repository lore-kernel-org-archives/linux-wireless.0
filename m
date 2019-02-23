Return-Path: <SRS0=o7U+=Q6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE99C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 08:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04BF7206A3
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 08:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbfBWIg2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Feb 2019 03:36:28 -0500
Received: from smtpbg202.qq.com ([184.105.206.29]:57444 "EHLO smtpbg202.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbfBWIg2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Feb 2019 03:36:28 -0500
X-QQ-mid: bizesmtp3t1550910981tfjb6n09y
Received: from localhost.localdomain (unknown [116.236.177.50])
        by esmtp4.qq.com (ESMTP) with SMTP id 0
        for <linux-wireless@vger.kernel.org>; Sat, 23 Feb 2019 16:35:55 +0800 (CST)
X-QQ-SSF: 01400000002000C0EF82B00A0000000
X-QQ-FEAT: 8GRh8dgRWfcuemsQYUv2L/skPJTdnUx8utOADJk0Gzdi/zRbAYvmoZZFfo9+E
        JskHEPAY5UdeQ6gcbgByLL8RiBGlEolhhAROPMSWWiEnplkANlUnzRgTyjsPdc9EtTNZIFL
        cDXgssCrqzPy75JMCuf+uS7pCYM6i3POJb0kx2K2530SbhDa6RCZKpOEMBd3Tbsa1OQheml
        DLmekxQh5/frNNVqpH3T3A9yquiluf77nMEZEIxjtOG3gBJhVo1+CtEe389N6kpAbhOn+Xl
        23lihfW6NMwAgm
X-QQ-GoodBg: 2
From:   Wang Xuerui <wangxuerui@qiniu.com>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH v2] iwlwifi: mvm: fix unaligned read of rx_pkt_status
Date:   Sat, 23 Feb 2019 16:35:42 +0800
Message-Id: <20190223083543.6009-1-wangxuerui@qiniu.com>
X-Mailer: git-send-email 2.16.1
In-Reply-To: <20190218150952.6889-1-wangxuerui@qiniu.com>
References: <20190218150952.6889-1-wangxuerui@qiniu.com>
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:qiniu.com:qybgforeign:qybgforeign1
X-QQ-Bgrelay: 1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixed redundant calls per review.

Sorry for the delay; I inadvertently broke my test box and it took some
time to fix.


