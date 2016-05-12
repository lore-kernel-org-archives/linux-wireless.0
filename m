Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:34515 "EHLO
	mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbcELQQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2016 12:16:31 -0400
Received: by mail-yw0-f171.google.com with SMTP id j74so77715767ywg.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2016 09:16:31 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 May 2016 09:16:30 -0700
Message-ID: <CAFiGRCEyxdcuMf5yn3WU-bhnD5AhQmuP++eXaB1j8jmPkx7yQA@mail.gmail.com> (sfid-20160512_181633_983966_F484BECD)
Subject: [PATCH] iw: Fix -Wabsolute-value compiler warning in iw.c
From: Aurimas Liutikas <aurimas@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Aurimas Liutikas <aurimas@google.com>

diff --git a/iw.c b/iw.c
index 2aabddb..a6efe5b 100644
--- a/iw.c
+++ b/iw.c
@@ -516,7 +516,7 @@ int main(int argc, char **argv)
        const struct cmd *cmd = NULL;

        /* calculate command size including padding */
-       cmd_size = abs((long)&__section_set - (long)&__section_get);
+       cmd_size = labs((long)&__section_set - (long)&__section_get);
        /* strip off self */
        argc--;
        argv0 = *argv++;
