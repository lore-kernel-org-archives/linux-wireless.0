Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46700 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbeHVQrU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 12:47:20 -0400
Received: by mail-lf1-f68.google.com with SMTP id e23-v6so1354562lfc.13
        for <linux-wireless@vger.kernel.org>; Wed, 22 Aug 2018 06:22:25 -0700 (PDT)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] brcmfmac: fix wrong strnchr usage
Date: Wed, 22 Aug 2018 15:22:15 +0200
Message-Id: <20180822132215.27669-1-linux@rasmusvillemoes.dk> (sfid-20180822_152229_293745_B84822C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

strnchr takes arguments in the order of its name: string, max bytes to
read, character to search for. Here we're passing '\n' aka 10 as the
buffer size, and searching for sizeof(buf) aka BRCMF_DCMD_SMLEN aka
256 (aka '\0', since it's implicitly converted to char) within those 10
bytes.

Just interchanging the last two arguments would still leave a bug,
because if we've been successful once, there are not sizeof(buf)
characters left after the new value of p.

Since clmver is immediately afterwards passed as a %s argument, I assume
that it is actually a properly nul-terminated string. For that case, we
have strreplace().

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
Incidentally, I found this because I was looking at our strnchr
implementation and noticed a corner case: strchr() is specified by C and
POSIX standards to consider the trailing '\0' to be part of the string,
so strchr(foo, '\0') must be equivalent to "foo +
strlen(foo)". strnchr() is not specified by anyone. Our implementation
returns NULL as soon as count is depleted or hitting a '\0' byte, so
since we were here looking for a '\0' byte, the first strnchr() call was
guaranteed to return NULL.

Had strnchr() instead returned a pointer to the '\0' if such was found
within the first count (in this case 10) bytes, we'd be overwriting that
with a ' ', and continue until no '\0' was found within the next 10
bytes.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index cd3651069d0c..94044a7a6021 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -296,9 +296,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		/* Replace all newline/linefeed characters with space
 		 * character
 		 */
-		ptr = clmver;
-		while ((ptr = strnchr(ptr, '\n', sizeof(buf))) != NULL)
-			*ptr = ' ';
+		strreplace(clmver, '\n', ' ');
 
 		brcmf_dbg(INFO, "CLM version = %s\n", clmver);
 	}
-- 
2.16.4
