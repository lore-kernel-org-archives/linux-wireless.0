Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7EBC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 12:44:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 769BB20854
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 12:44:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbfCYMoW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 08:44:22 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:51243 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731043AbfCYMoW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 08:44:22 -0400
Received: from wuerfel.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MoNu2-1gbJGm1gwC-00omWj; Mon, 25 Mar 2019 13:43:56 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wireless: carl9170: fix clang build warning
Date:   Mon, 25 Mar 2019 13:43:44 +0100
Message-Id: <20190325124354.1413529-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:UJEE+690qtoqc0+6QE1rpuNULFFV3R4QEgmmMAtZRDqIVsFR3GW
 xTGq2R4H+lO1Uck0S25/23uZNxLhGiH50mmo/c+M8RtRmfKM8NzkMw3o+gU5U7iEDe6R5YQ
 RyTg4WyyH56h7QtRUy4HtM5CyYaqEvjN9mYxc2gkE12I5Z0moZbwEcyRTITDjEXOgxrwiTZ
 0spQKnV3m5yYJR7CPVotA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:HR07PaPTuSs=:LbsKnalSBTt0U0SGi7zw3q
 LFvvZjYZRZP1wddNYCLLSZP+0mXl8UhhvQarelTVSIPizxx5gEtm7XffUpZYIBPxHHjVg76ui
 w+EOrRzagp37kRVdfmwdvAnQaNOQQWlAOznF3OzSRapcEaHW/BJM4rx7eg7nWIaowljmkyxW8
 XaSecp/Z//GlXs+nVWSeGK01+vh/Y8T2ZmYsYJP2lWBnT0LUuucvlrn+MxinswKaOIF+mEkNy
 sMYauVgq8X/3hFWffb1TOv/YXhoSgT9Qufyz2yvNJJhbHN52fZbi/x29/LrOSMgkxgZ+DYepH
 yI2BLh/Q4g6VN4H+gGjlRLSEDNqVjIH38L0CoJ0458m5iqqWsmmhm4sxLGZTSvaX/IqYav9Y8
 /8jKjcyMTBif9bnugsAkf7QX6n1XetPkuujk0M2sUS2lTS5kMbol8GdVKg5VFoMXB5tv9uaAt
 trzpbm6941SpXh/tcO0NYaJz9guuyNPBdOkYYRgpK13aW4+X1rQHtzdUY36dCyZ+qSQjYFCQW
 gH+2u3kxrJqQCWXl1VriTUl+xW4yeFOjW2tlvQiQFelEMH8XsS62j/dgm70QlYfEVkZ4PjPqH
 V/HALPTwLZ+9ryQGfa6G+cUCk0Cg0C3eGUlPjHPbJT7mcBSmCiCz/q/BJQDLzVbpQMVyKEWYd
 qoJjLgYPxgHNGERXmPCs1QijmbVZaWxy8ZCl4eAdjdPqaJqhZoyiZfuLKgkMzfZp8PguwPdqw
 8f2vArPbRz20ZACSJZuKlqXByHjxq4mpcWol0w==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

clang fails to eliminate some dead code with always-taken branches
when CONFIG_PROFILE_ANNOTATED_BRANCHES is set, leading to a false-positive
warning:

drivers/net/wireless/ath/carl9170/mac.c:522:3: error: variable 'power' is used uninitialized whenever 'if' condition is
      false [-Werror,-Wsometimes-uninitialized]
                BUG_ON(1);
                ^~~~~~~~~

Change both instances of BUG_ON(1) in carl9170 to the simpler BUG()
to avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/carl9170/mac.c | 2 +-
 drivers/net/wireless/ath/carl9170/rx.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index 7d4a72dc98db..b2eeb9fd68d2 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -519,7 +519,7 @@ int carl9170_set_mac_tpc(struct ar9170 *ar, struct ieee80211_channel *channel)
 		power = ar->power_5G_leg[0] & 0x3f;
 		break;
 	default:
-		BUG_ON(1);
+		BUG();
 	}
 
 	power = min_t(unsigned int, power, ar->hw->conf.power_level * 2);
diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 8e154f6364a3..23ab8a80c18c 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -795,7 +795,7 @@ static void carl9170_rx_untie_data(struct ar9170 *ar, u8 *buf, int len)
 		break;
 
 	default:
-		BUG_ON(1);
+		BUG();
 		break;
 	}
 
-- 
2.20.0

