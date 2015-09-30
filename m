Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35928 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbbI3XBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 19:01:19 -0400
Received: by wicgb1 with SMTP id gb1so4339427wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2015 16:01:18 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 1 Oct 2015 01:01:18 +0200
Message-ID: <CABAco3AMgZSv9kCYkE6yQDcDE0+-7rA4ZzYazxSqAS99LHHMGQ@mail.gmail.com> (sfid-20151001_010144_746069_0DC981C6)
Subject: [PATCH] iw: Memory leak in error condition
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 5239e8e9aa79a131b716398efbf7a1203decbd9b Mon Sep 17 00:00:00 2001
From: Ola Olsson <ola.olsson@sonymobile.com>
Date: Thu, 1 Oct 2015 00:43:06 +0200
Subject: [PATCH] iw: Memory leak in error condition Signed-off-by: Ola
 Olsson <ola.olsson@sonymobile.com>

---
 scan.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/scan.c b/scan.c
index e959c1b..f248981 100644
--- a/scan.c
+++ b/scan.c
@@ -446,6 +446,8 @@ static int handle_scan(struct nl80211_state *state,
        if (ies || meshid) {
                tmpies = (unsigned char *) malloc(ies_len + meshid_len);
                if (!tmpies)
+                       free(ies);
+                       free(meshid);
                        goto nla_put_failure;
                if (ies) {
                        memcpy(tmpies, ies, ies_len);
-- 
1.7.9.5
