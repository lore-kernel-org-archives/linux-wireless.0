Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1223C4332F
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Nov 2022 10:08:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiKZKIo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 26 Nov 2022 05:08:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKZKIn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Nov 2022 05:08:43 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2B21FFAF;
        Sat, 26 Nov 2022 02:08:41 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NK6qm3x78zmW9f;
        Sat, 26 Nov 2022 18:08:04 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 18:08:39 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <johannes@sipsolutions.net>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH 0/2] Add check for nla_nest_start()
Date:   Sat, 26 Nov 2022 10:06:32 +0000
Message-ID: <20221126100634.106887-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series contains two patches about checking the return value of
nla_nest_start().

Yuan Can (2):
  udp_tunnel: Add checks for nla_nest_start() in
    __udp_tunnel_nic_dump_write()
  wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()

 net/ipv4/udp_tunnel_nic.c | 2 ++
 net/wireless/nl80211.c    | 3 +++
 2 files changed, 5 insertions(+)

-- 
2.17.1

