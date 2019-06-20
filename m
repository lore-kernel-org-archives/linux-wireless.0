Return-Path: <SRS0=u1b0=UT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5FFC43613
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Jun 2019 22:07:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C2052070B
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Jun 2019 22:07:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="posaOAQ2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbfFTWH4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Jun 2019 18:07:56 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44236 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfFTWHz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jun 2019 18:07:55 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so744814iob.11
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jun 2019 15:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uBaTHL1n99aWQykM3vZn3tUPSZBa+eBLGOQu3ENxmnQ=;
        b=posaOAQ2vkbmQv5q52Tphku4VUyQeShnzzvkMoM01wIMpFm9Jz22NMn4CjrUOZFvbl
         P+ctIwdugMR+RnIXg68yO4lIM6QaQQEzXy3DtQc+4AD3+X0vJuJ2bW/FwpjZ6PdIj9Vn
         oyPOx0gMMQveYXPDZsDmkVn/7n8eBqLh5HmekbIWKwVxKWHms2IaPHof2qFwb5o26QCG
         OkFAcP9ESaAYgolFWv1O1HxuIRAkdAXdfi3oAUowmcrOl10rOeqn4OAYT3lXCJHizdKf
         WckEJx/tlJgoAOZC8Tdhx4o0EkCqcB6nDRHwUicozSZcHXbecvjSreBPymliPVHAG1ZQ
         TYKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uBaTHL1n99aWQykM3vZn3tUPSZBa+eBLGOQu3ENxmnQ=;
        b=E2WxdOJUQVo+HOQXVuwFHT+Xd2l8asgtsKTrrtWJD3wJ1sdBPMJdWjLY+KV6GobaQ1
         vVkIcZpP2+v8ewekB1u3t5J+oF32tAZiFu+nIlmlVZiVnDN/VLcC8g/V6/1A+Mwrvhx8
         bkcZDyZ4DKKzZbEHukHPmBRNG69gEqtTriRhPsQenoXuSCmPEI9th64Ito1BYLowuy6J
         2cfV1352p6ZayivC94p9T6+mn+b5eNvWkqxIayPNyiHOaRyPyXTqq7AtvMNrBIT39aW1
         /SBUtBwydxtpaGnjPP27bZ5TLlO+tQYexjr5pnuEtGqd1WhBa26vT+rBCGNyKZHklkmJ
         olHw==
X-Gm-Message-State: APjAAAWA5nFcOpqm/0HljaJsrUs9TaIYjJsWLEOHJDdQVXjwW6VnQ4gm
        2y57o0KN3YaYYvZlnS8VOjc=
X-Google-Smtp-Source: APXvYqyGOxOJ672UND4rkxX01Ofa3ZB/45OW8r/Mt2sjqkwOmJszkuhcM2eKL74a/FugqQ0AVWif+Q==
X-Received: by 2002:a6b:c80a:: with SMTP id y10mr18074586iof.170.1561068474992;
        Thu, 20 Jun 2019 15:07:54 -0700 (PDT)
Received: from new-host-2.home.home ([2605:a601:808:1001:37ba:4f0a:192f:f945])
        by smtp.gmail.com with ESMTPSA id e84sm1691921iof.39.2019.06.20.15.07.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 15:07:54 -0700 (PDT)
From:   Denis Kenzior <denkenz@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v2 1/3] nl80211: Update uapi for CMD_FRAME_WAIT_CANCEL
Date:   Thu, 20 Jun 2019 17:07:47 -0500
Message-Id: <20190620220749.10071-1-denkenz@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Commit 1c38c7f22068 ("nl80211: send event when CMD_FRAME duration
expires") added the possibility of NL80211_CMD_FRAME_WAIT_CANCEL
being sent whenever the off-channel wait time associated with a
CMD_FRAME completes.  Document this in the uapi/linux/nl80211.h file.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/uapi/linux/nl80211.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

 Changes in v2:
  - update commit formatting

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

