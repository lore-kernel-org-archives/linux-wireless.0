Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36356 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbbJGQpD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 12:45:03 -0400
Received: by wicgb1 with SMTP id gb1so219858198wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2015 09:45:02 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 7 Oct 2015 18:45:02 +0200
Message-ID: <CABAco3A+7-gJ6CZ+8qCnt_vnYA35dyzhjwoA4D+6D4iqi8-U=Q@mail.gmail.com> (sfid-20151007_184509_771894_BE051637)
Subject: [PATCH] iw: Fix return values when parameters are wrong
From: Ola Olsson <ola1olsson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to header file, wrong parameters
yield 1 as return value.
Also tried to fix the comments since one part
of it was unreadable.

Signed-off-by: Ola Olsson <ola1olsson@gmail.com>
---
 interface.c |    6 ++----
 iw.h        |    4 ++--
 ps.c        |    6 ++----
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/interface.c b/interface.c
index 4f0821d..e931454 100644
--- a/interface.c
+++ b/interface.c
@@ -559,10 +559,8 @@ static int set_mcast_rate(struct nl80211_state *state,
     float rate;
     char *end;

-    if (argc != 1) {
-        printf("Invalid parameters!\n");
-        return 2;
-    }
+    if (argc != 1)
+        return 1;

     rate = strtod(argv[0], &end);
     if (*end != '\0')
diff --git a/iw.h b/iw.h
index cef9da8..263e8b1 100644
--- a/iw.h
+++ b/iw.h
@@ -48,8 +48,8 @@ struct cmd {
     const enum command_identify_by idby;
     /*
      * The handler should return a negative error code,
-     * zero on success, 1 if the arguments were wrong
-     * and the usage message should and 2 otherwise.
+     * zero on success, 1 if the arguments were wrong.
+     * Return 2 iff you provide the error message yourself.
      */
     int (*handler)(struct nl80211_state *state,
                struct nl_msg *msg,
diff --git a/ps.c b/ps.c
index b774b7e..de36d2b 100644
--- a/ps.c
+++ b/ps.c
@@ -15,10 +15,8 @@ static int set_power_save(struct nl80211_state *state,
 {
     enum nl80211_ps_state ps_state;

-    if (argc != 1) {
-        printf("Invalid parameters!\n");
-        return 2;
-    }
+    if (argc != 1)
+        return 1;

     if (strcmp(argv[0], "on") == 0)
         ps_state = NL80211_PS_ENABLED;
-- 
1.7.9.5
