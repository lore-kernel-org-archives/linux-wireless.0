Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541BCC04A6A
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Aug 2023 12:44:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbjHNMnf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Aug 2023 08:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjHNMnY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2023 08:43:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8082E4A
        for <linux-wireless@vger.kernel.org>; Mon, 14 Aug 2023 05:43:23 -0700 (PDT)
Received: from kwepemi500008.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RPYt63gFCzTmqQ;
        Mon, 14 Aug 2023 20:41:18 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemi500008.china.huawei.com
 (7.221.188.139) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Mon, 14 Aug
 2023 20:43:20 +0800
From:   Ruan Jinjie <ruanjinjie@huawei.com>
To:     <kvalo@kernel.org>, <briannorris@chromium.org>,
        <johannes.berg@intel.com>, <Jason@zx2c4.com>, <toke@toke.dk>,
        <tj@kernel.org>, <mukesh.sisodiya@intel.com>,
        <quic_vjakkam@quicinc.com>,
        <johannes.wiesboeck@aisec.fraunhofer.de>,
        <linux-wireless@vger.kernel.org>
CC:     <ruanjinjie@huawei.com>
Subject: [PATCH net-next 0/2] wifi: Use helpers to check multicast Ether addresses
Date:   Mon, 14 Aug 2023 20:42:10 +0800
Message-ID: <20230814124212.302738-1-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500008.china.huawei.com (7.221.188.139)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use is_multicast_ether_addr() and is_unicast_ether_addr()
instead of open-coding them to perfom the Checking.

Ruan Jinjie (2):
  wifi: ath: Use is_multicast_ether_addr() to check multicast Ether
    address
  wifi: mwifiex: Use helpers to check multicast addresses

 drivers/net/wireless/ath/key.c                  | 2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.34.1

