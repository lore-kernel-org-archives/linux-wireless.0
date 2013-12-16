Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:64953 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3LPQ2B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 11:28:01 -0500
Received: by mail-we0-f180.google.com with SMTP id t61so4820412wes.39
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 08:28:00 -0800 (PST)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 16 Dec 2013 21:57:39 +0530
Message-ID: <CABPxzY+CnnssaZpqgWuJ=QH-k=zJbHpLaGkJXAQSWSxq7kKa6Q@mail.gmail.com> (sfid-20131216_172806_041475_12934CFB)
Subject: [RFC] crda: Fix the linking order to avoid compilation error
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wireless-regdb@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While linking the crda.o and libreg.so, first put crda.o
and then -lreg. This fixed the below error:

# make
  GEN  keys-gcrypt.c
  Trusted pubkeys: pubkeys/linville.key.pub.pem
  CC   libreg.so
  CC   crda.o
  LD   crda
crda.o: In function `main':
crda/crda.c:196: undefined reference to `reglib_get_rd_alpha2'
collect2: ld returned 1 exit status
make: *** [crda] Error 1

Note: This still doesn't fix the below error (will send another mail)

  CHK  /usr/lib/crda/regulatory.bin
Database signature verification failed.
Invalid or empty regulatory file, note: a binary regulatory file should be used.
make: *** [verify] Error 234

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
 Makefile |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 4a351c6..0b2f0d7 100644
--- a/Makefile
+++ b/Makefile
@@ -28,10 +28,11 @@ RUNTIME_PUBKEY_DIR?=/etc/wireless-regdb/pubkeys
 CFLAGS += -O2 -fpic
 CFLAGS += -std=gnu99 -Wall -Werror -pedantic
 CFLAGS += -Wall -g
-LDLIBS += -lm
 LDLIBREG += -lreg
+LDLIBS += $(LDLIBREG)
+LDLIBS += -lm
 LIBREG += libreg.so
-LDFLAGS += -L ./ $(LDLIBREG)
+LDFLAGS += -L ./

 all: all_noverify verify
