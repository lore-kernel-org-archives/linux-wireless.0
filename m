Return-Path: <SRS0=xhmE=EB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D972C4363A
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Oct 2020 21:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FC29207C4
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Oct 2020 21:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603748007;
	bh=4I92PPLIQB5XcQu2mSRXjGUg9oeT73D13rPFwKftJFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RNuJQiB7PqpGoZKtrYxOXn8/2PiKognlqulbv0MbI/UuO164QI7Q3bOMoQQhJm5/E
	 e7f4nDUbe0KNVDwXw91MySwvok7Tx401SDE3oQHJZNz6Aq6efpZb1UOo2j/JammJlM
	 JwBD20wQm257UF/le9foYNS4y6pKt9TFQj+Y1ZlI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389288AbgJZVdX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 26 Oct 2020 17:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:44590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389257AbgJZVdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Oct 2020 17:33:22 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6EBA207C4;
        Mon, 26 Oct 2020 21:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603748002;
        bh=4I92PPLIQB5XcQu2mSRXjGUg9oeT73D13rPFwKftJFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03uQ+/v4na+HGwRf8uaX5Fv+YAd5PjCzc11Z/c6GODb+rB9P6PSxox8433dTIjtHH
         z1D1tAghB+GRPv20lDvGXWc2xbhLrcuEAKj/wEmPMOnXZLicebU4vULQzKklovfeFW
         aER73e5aFxJ5fIoRqqDuwVZ0z2MzDsTE4zDwHtiQ=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Chris Chiu <chiu@endlessm.com>,
        Zong-Zhe Yang <kevin_yang@realtek.com>,
        Tzu-En Huang <tehuang@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH net-next 07/11] rtw88: remove extraneous 'const' qualifier
Date:   Mon, 26 Oct 2020 22:29:54 +0100
Message-Id: <20201026213040.3889546-7-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

clang -Wextra warns about functions returning a 'const' integer:

drivers/net/wireless/realtek/rtw88/rtw8822b.c:90:8: warning: 'const' type qualifier on return type has no effect [-Wignored-qualifiers]
static const u8 rtw8822b_get_swing_index(struct rtw_dev *rtwdev)

Remove the extra qualifier here.

Fixes: c97ee3e0bea2 ("rtw88: add power tracking support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 22d0dd640ac9..b420eb914879 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -87,7 +87,7 @@ static const u32 rtw8822b_txscale_tbl[RTW_TXSCALE_SIZE] = {
 	0x2d3, 0x2fe, 0x32b, 0x35c, 0x38e, 0x3c4, 0x3fe
 };
 
-static const u8 rtw8822b_get_swing_index(struct rtw_dev *rtwdev)
+static u8 rtw8822b_get_swing_index(struct rtw_dev *rtwdev)
 {
 	u8 i = 0;
 	u32 swing, table_value;
-- 
2.27.0

