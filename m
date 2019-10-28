Return-Path: <SRS0=NkA/=YV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9EBCA9EC2
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Oct 2019 18:47:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EBB4208C0
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Oct 2019 18:47:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CV13MzP4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfJ1SrC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Oct 2019 14:47:02 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32891 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727218AbfJ1SrC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Oct 2019 14:47:02 -0400
Received: by mail-pg1-f196.google.com with SMTP id u23so7505918pgo.0;
        Mon, 28 Oct 2019 11:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=4FYNWJKX/XjWeMthjDP9NPXXb7ZZAxlczEJEW9ICuKU=;
        b=CV13MzP4UL8JmJrN7U5nk+/QEyD0gNzZjlLYkJ+qDnJs3ORyFCtvspFYL4vzzUhDAv
         oMxicNK3UGKtq1l7G4yKokbkgdVyRz38FLPtBW9iag6EYoxjNGVofnQQQFpeJgOZWool
         GLEUXsjYkx48bTPS4KQdnBmxvYX6hbW8nG6ywiAwjtTjNbYxhDV1gBO5rsvWDLDg37H5
         S4dajOQ/kOplGbLqpjooPQkz9sVynUToBe9WrNP96wfFSWQx7jndg3yOC+toZPhWa+2W
         2UjATvddCQD9RPXrVvjPzVE5Q66heV5BMSD2b5qU7j82jQ05S+mYSy47WHsY46E5hnUS
         gGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=4FYNWJKX/XjWeMthjDP9NPXXb7ZZAxlczEJEW9ICuKU=;
        b=uFgXZ7vjXq1zATsizvaTpsneHg++rxn/qaaPNOwYPF4TA0PbfSIcxsByP0/16HV7Uu
         Sgl9FHVt5euueUmveDmOFe3dnbxLRyl2bkuoHZzUhR1UF2X2YvjxWYA6c8XY/6RuAhUK
         9CdnP3fHSCht9K74wnjEulQRmbyhbq4sY5nnaegN4SYdMKgNYuH7IQ2SxH4z9g1shP82
         HGXEFHC//1HB19rCz5B4tCfGUuWpH29eFq28LwygN1cUpfyd8EbZHetxDWjX9xMjnSKC
         Xe+J44Zyteam1JDv4czAXFjTbA1jTKPNhqdoGmiJUeXOotDujsS0P5xj/abf5V3P9r5F
         1DPg==
X-Gm-Message-State: APjAAAUcX/7wjscLHznC5Zm37QbPWXjrJ80U46txCZRKFfDHnyT4XiYG
        trmiRIcDzlVLgMes8beS1Bk=
X-Google-Smtp-Source: APXvYqwbkABVl9FeCIXxt4Gwq6nhf1e5mB7GmhmE5wX02AhR7dC+OP+DXrSoleU/keVHrv99oGU6Dw==
X-Received: by 2002:a17:90b:94f:: with SMTP id dw15mr931709pjb.21.1572288421568;
        Mon, 28 Oct 2019 11:47:01 -0700 (PDT)
Received: from saurav ([27.62.167.137])
        by smtp.gmail.com with ESMTPSA id 129sm12417083pfg.38.2019.10.28.11.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 11:47:00 -0700 (PDT)
Date:   Tue, 29 Oct 2019 00:16:54 +0530
From:   Saurav Girepunje <saurav.girepunje@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        Larry.Finger@lwfinger.net, saurav.girepunje@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     saurav.girepunje@hotmail.com
Subject: [PATCH] net: wireless: rtlwifi: rtl8192c:Drop condition with no
 effect
Message-ID: <20191028184654.GA26755@saurav>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As the "else if" and "else" branch body are identical the condition
has no effect. So drop the "else if" condition.

Signed-off-by: Saurav Girepunje <saurav.girepunje@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
index f2908ee5f860..4bef237f488d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
@@ -1649,8 +1649,6 @@ static void rtl92c_bt_ant_isolation(struct ieee80211_hw *hw, u8 tmp1byte)
 			    (rtlpriv->btcoexist.bt_rssi_state &
 			    BT_RSSI_STATE_SPECIAL_LOW)) {
 			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, 0xa0);
-		} else if (rtlpriv->btcoexist.bt_service == BT_PAN) {
-			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, tmp1byte);
 		} else {
 			rtl_write_byte(rtlpriv, REG_GPIO_MUXCFG, tmp1byte);
 		}
-- 
2.20.1

