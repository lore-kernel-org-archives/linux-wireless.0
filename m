Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9ABC10F0C
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 394A92084D
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 07:44:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="HSEMC8Pf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfCKHn4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 03:43:56 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:48648 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfCKHnz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 03:43:55 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 306BB9CD
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 07:43:54 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i7Vk_uaKfmzD for <linux-wireless@vger.kernel.org>;
        Mon, 11 Mar 2019 02:43:54 -0500 (CDT)
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id F07889CE
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 02:43:53 -0500 (CDT)
Received: by mail-io1-f72.google.com with SMTP id 68so3512477iov.7
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 00:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=uDqWIZLXGYyXvT1xTD4WeCEmfgQ08bNpiydHC0zjAq0=;
        b=HSEMC8Pf3uzLqDuexNC46GCzrs0KB5vexlC9+EcbNg/ZGHsg0CiwNKNmpgm0YkCiOG
         93EK00kMnapXzu3EYSCZG5qTm046CwSWRrtOkhcCgLvOXY87vww439UoDXIbhrX0r3kj
         AWofnkigxCRvFuI1u0rwe1xE4CKtL+B6ehVABMK6Iacu8HB5tHPfUsWuhiEXouv0yEmO
         OVR3wmcSyf1R2oXhF4yWGsU8NkB38CVZU7AquXoapCxkCnv5Ffdj27Tr81DjrgObNkYr
         QbGyseWzQF4Mi/6nzrJREuO+XhIBXfbQq3oSSr//caExMqVa3h/BHV6sV5zHTDk/oHkn
         iesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=uDqWIZLXGYyXvT1xTD4WeCEmfgQ08bNpiydHC0zjAq0=;
        b=pF5yoFFA8Rq5W+1JdCCm9JIoYNhgfAKgm3eevHGgIBn0OZLulnF4YmpN82JhUWdiFd
         5c4mEUclyjPGDGYmITm1/5Wz7cXlGOhrlRddySUbrRjA0FYuVPa53ALGDMfxyS4ndVSD
         Y68SzvpRWI9OsaCvIQObz6Faad3V2k/Lwqu8Gdembtcfy39cu9VdwWSWTLSIXTknLGT6
         Ag8h0X33Tcid85v8LhpX0uKMr4JnzQqAjPbmPr9Mn5Pn75VZXmreSKw6nJ00wWUQKvy+
         1Pyv8fF0WN6/G8lVDAQi0D8JesCFRVjttt1B1rpi7EULpJQ57vFvdQFZOvDhokP090aH
         mYcA==
X-Gm-Message-State: APjAAAUNRwBNJdaMZKKOIujVbu9XGL4ZrVWw+jm4CEdE1XP46ZMSvQoY
        s6C8fNQ65/CCtIfuE+iMBFYjHONhpK+99/VRDIZjI3XHy69q1YyUqb/L7USA6WBpSA+dd31hfdR
        lU9VkZENm29PA+gzYTF7HjBbslm+WuYE=
X-Received: by 2002:a24:2149:: with SMTP id e70mr14187722ita.23.1552290233524;
        Mon, 11 Mar 2019 00:43:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz5wOY5jqVPWXZLW8zW2WWxD7ErBmRGL3KpF3kCbexUn10+STaK4Yzg4mSy5m9MOq7rgmKmJw==
X-Received: by 2002:a24:2149:: with SMTP id e70mr14187706ita.23.1552290233303;
        Mon, 11 Mar 2019 00:43:53 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id 7sm2001530iow.58.2019.03.11.00.43.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Mar 2019 00:43:52 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     pakki001@umn.edu, Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: mwifiex: fix a NULL pointer dereference
Date:   Mon, 11 Mar 2019 02:43:47 -0500
Message-Id: <20190311074347.32003-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In case dev_alloc_skb fails, the fix returns -ENOMEM to avoid
NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 60db2b969e20..5565f18039ab 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -341,6 +341,12 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		sleep_cfm_tmp =
 			dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm)
 				      + MWIFIEX_TYPE_LEN);
+		if (!sleep_cfm_tmp) {
+			mwifiex_dbg(adapter, ERROR, 
+				    "SLEEP_CFM: dev_alloc_skb failed\n");
+			return -ENOMEM;
+		}
+
 		skb_put(sleep_cfm_tmp, sizeof(struct mwifiex_opt_sleep_confirm)
 			+ MWIFIEX_TYPE_LEN);
 		put_unaligned_le32(MWIFIEX_USB_TYPE_CMD, sleep_cfm_tmp->data);
-- 
2.17.1

