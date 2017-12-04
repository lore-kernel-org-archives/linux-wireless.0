Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35543 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751630AbdLDUxK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 15:53:10 -0500
Received: by mail-wm0-f66.google.com with SMTP id f9so16783765wmh.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Dec 2017 12:53:09 -0800 (PST)
From: Jelle van der Waa <jelle@vdwaa.nl>
To: "Luis R . Rodriguez" <mcgrof@kernel.org>
Cc: linux-wireless@vger.kernel.org, Jelle van der Waa <jelle@vdwaa.nl>
Subject: [PATCH] =?UTF-8?q?crda:=20Fix=20error:=20`keys=E2=80=99=20defined?= =?UTF-8?q?=20but=20not=20used?=
Date: Mon,  4 Dec 2017 21:52:39 +0100
Message-Id: <20171204205239.6296-1-jelle@vdwaa.nl> (sfid-20171204_215313_579493_97A40BB1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix error: ‘keys’ defined but not used [-Werror=unused-const-variable=]
by informing GCC keys is unused.

Signed-off-by: Jelle van der Waa <jelle@vdwaa.nl>
---
 utils/key2pub.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils/key2pub.py b/utils/key2pub.py
index 3e84cd2..9bb04cd 100755
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -115,7 +115,7 @@ struct key_params {
 	.n = _n, .len_n = sizeof(_n),	\
 }
 
-static const struct key_params keys[] = {
+static const struct key_params __attribute__ ((unused)) keys[] = {
 ''')
     for n in xrange(n + 1):
         output.write('	KEYS(e_%d, n_%d),\n' % (n, n))
-- 
2.15.1
