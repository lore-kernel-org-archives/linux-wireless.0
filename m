Return-Path: <SRS0=YfBD=WY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BC1C3A5A6
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 21:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0EA522DA7
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Aug 2019 21:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLDmMYK8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfH1VQe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Aug 2019 17:16:34 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45109 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1VQe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Aug 2019 17:16:34 -0400
Received: by mail-oi1-f195.google.com with SMTP id v12so839626oic.12;
        Wed, 28 Aug 2019 14:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UZ8/awWTq6cNNlpOfMcpLe0hFlviAxwzUTQVPhW35AY=;
        b=FLDmMYK8Nomgd5BV8aX5uue5BsU/74nkB8cA+cc+SkvzJJS1K9MBCFcaW4LuVk+jAi
         zqwkgV6oDoNCnXhdtfKlOym14TsZK5ZyRMcJCdbXNrXjbxRzgTC+JyUNmB6gXk66EBTB
         p46Hu+U/aAefSS23vwIZJEUlgYUL2I9nqP/gU+vZ3bOJ4umkTQ4fjAc2aPtucT+IcqCu
         wgN+pKA3ntLHP7x//HrCawf0IerRBuwxnWn2qdeRG5i0ySh/kGVfpZcOk5W8MYzbSvoO
         Gw4qrCHYKOz9Rq0+3a+ZbkiFuAVgAE4v+HfXPL/7OAoGpbD3MF5Wgy8+FLuPZjjIJ1sg
         ZjXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UZ8/awWTq6cNNlpOfMcpLe0hFlviAxwzUTQVPhW35AY=;
        b=OicbXZh9NvebxEiUz9kmHUXeHsh4ZfIwCFEu+DmtjX/oY+ZJfeo6KY3mSodb5bMmSX
         HlPlGYnXqXyaOmlAxbLGEN52eYgkUA7TWft+puXNpJiiX3C/dZPw6KNaDsvJYJYkfLud
         mc124szUJ2VZnJRhcU5gQnXE6EpQyZ63JHSiI7jKoyQVua32UyLeb0Vz/hd5wg2tzAyc
         kKcPoNTgfFWQPcWDZt6BWIGIEY2Nxs8ZzO7wcULSSl4fQHjjVKcyUnEqsFGpliIYIedC
         qir5p5yF5tqiegUQrKmyTkXSwaI2ESru07s9GvPXWVobvCKl6UVGHWhcI+hp15V4TLxm
         mXYg==
X-Gm-Message-State: APjAAAWA5SJ9UONiC8i4B16LnaGmCrYAAKZ8bfzDGvzl6nG0MAUvpRZy
        HeYJ1YINmrwX5x2CHRgZJ/yEvXvR
X-Google-Smtp-Source: APXvYqzo7wpp4z+FyKGJBUCFpbBfLoN4fkvhh1vncucKq/vxbX1HAl8WCTzLD5gSJiFFYze+rFJQSw==
X-Received: by 2002:a54:4814:: with SMTP id j20mr4139687oij.33.1567026993118;
        Wed, 28 Aug 2019 14:16:33 -0700 (PDT)
Received: from localhost.localdomain (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.gmail.com with ESMTPSA id z26sm85608oih.16.2019.08.28.14.16.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 14:16:32 -0700 (PDT)
From:   Denis Kenzior <denkenz@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] cfg80211: Purge frame registrations on iftype change
Date:   Wed, 28 Aug 2019 16:11:10 -0500
Message-Id: <20190828211110.15005-1-denkenz@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently frame registrations are not purged, even when changing the
interface type.  This can lead to potentially weird / dangerous
situations where frames possibly not relevant to a given interface
type remain registered and mgmt_frame_register is not called for the
no-longer-relevant frame types.

The kernel currently relies on userspace apps to actually purge the
registrations themselves, e.g. by closing the nl80211 socket associated
with those frames.  However, this requires multiple nl80211 sockets to
be open by the userspace app, and for userspace to be aware of all state
changes.  This is not something that the kernel should rely on.

This commit adds a call to cfg80211_mlme_purge_registrations() to
forcefully remove any registrations left over prior to switching the
iftype.

Cc: stable@vger.kernel.org

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index c99939067bb0..3fa092b78e62 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -964,6 +964,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		}
 
 		cfg80211_process_rdev_events(rdev);
+		cfg80211_mlme_purge_registrations(dev->ieee80211_ptr);
 	}
 
 	err = rdev_change_virtual_intf(rdev, dev, ntype, params);
-- 
2.19.2

