Return-Path: <SRS0=QcoQ=US=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53991C43613
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jun 2019 22:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F484215EA
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jun 2019 22:36:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WaktpQ2z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfFSWgh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Jun 2019 18:36:37 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46289 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfFSWgh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jun 2019 18:36:37 -0400
Received: by mail-io1-f68.google.com with SMTP id i10so2155562iol.13
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jun 2019 15:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=flf/jyuZHHx4BWbkpqUKVHZFnIAhH9zD/e6FJs0qr9A=;
        b=WaktpQ2zwSXajh/p1faKb5E9X5aqSOfI9aGlyBYiAHqZw09CfHmLGRd8QPc3ctpHf9
         XkGpzi+qyaxo+cyL73EmiRlez8NjoEiavrFfWZS9VdgzBViy0JnqMqJIUBezlKfNP5Ei
         tisQNsc03faXqhgpe63wU+mspFhLrOXGj/nl3eY3jgX6V2CWwNNkpzcUuQXW2UNJ0Uod
         G9sph2OKqbobqSu0D5axInVy9hgtBQYPEgHv3er2fqh0DPNJdH1c2PVOqktL8T5ITS7T
         D5Ddz7GkEqa+CXYFgTr+DxgtT/6DLhoUGkR9K9jZjgR9QtS9Ay/ELGMnHmFLKflkJNSY
         xpew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=flf/jyuZHHx4BWbkpqUKVHZFnIAhH9zD/e6FJs0qr9A=;
        b=TpbmfZi8NfFJTdj7lFj+Yp9TIf3C04FiWMCh3fR261Q1kq72XQzrvEWEYJBXgTpGLP
         LxhchbnLyVBgppr36fhup2JCh7C9FXonosLpB8c0G8WzwPnY0SKYRWOBHvob22OWk6U0
         n6tCLkvn4XqczuIAwel/jtqEOOTf23sqWq87ZITxryEvEK4yRVoiJPfghm4Iv2L8DfsD
         psKnazDG4Il+JznQXAJMfROK3pCvKawKcyA8W4HUiWVOOcWJ9vVbgeu617qyEW+PwKle
         rziAhHrYCqcloOHz0jlvinPCxdbRNq8SnHxaFol8lTGt3RjyaCpf5I978JT+xoUMyQ8B
         SyzQ==
X-Gm-Message-State: APjAAAXtB0soVab8Mxc1K3FNWp6v+Z8RCEHChBVO/VjKM4J23jbWbQjv
        9IYDIxvE93mAzx/ulop0Zzk=
X-Google-Smtp-Source: APXvYqxeXfFgkHYqn6o3csSfVXoLGw4Wp9a5/pMhDG2WAh2oc6D/51WQFmJBDX8DJyuEPyUPJdziMA==
X-Received: by 2002:a6b:e615:: with SMTP id g21mr8893032ioh.178.1560983796362;
        Wed, 19 Jun 2019 15:36:36 -0700 (PDT)
Received: from new-host-2.home.home ([2605:a601:808:1001:37ba:4f0a:192f:f945])
        by smtp.gmail.com with ESMTPSA id y20sm15928646ion.77.2019.06.19.15.36.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Jun 2019 15:36:35 -0700 (PDT)
From:   Denis Kenzior <denkenz@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH 1/3] nl80211: Update uapi for CMD_FRAME_WAIT_CANCEL
Date:   Wed, 19 Jun 2019 17:36:04 -0500
Message-Id: <20190619223606.4575-1-denkenz@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

1c38c7f2 added the possibility of NL80211_CMD_FRAME_WAIT_CANCEL
being sent whenever the off-channel wait time associated with a
CMD_FRAME completes.  Document this in the uapi/linux/nl80211.h file.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/uapi/linux/nl80211.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 8fc3a43cac75..0d9aad98c983 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -657,7 +657,9 @@
  *	is used during CSA period.
  * @NL80211_CMD_FRAME_WAIT_CANCEL: When an off-channel TX was requested, this
  *	command may be used with the corresponding cookie to cancel the wait
- *	time if it is known that it is no longer necessary.
+ *	time if it is known that it is no longer necessary.  This command is
+ *	also sent as an event whenever the driver has completed the off-channel
+ *	wait time.
  * @NL80211_CMD_ACTION: Alias for @NL80211_CMD_FRAME for backward compatibility.
  * @NL80211_CMD_FRAME_TX_STATUS: Report TX status of a management frame
  *	transmitted with %NL80211_CMD_FRAME. %NL80211_ATTR_COOKIE identifies
-- 
2.21.0

