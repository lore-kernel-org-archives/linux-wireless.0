Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:47019 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3J1BxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 21:53:12 -0400
Received: by mail-we0-f169.google.com with SMTP id q58so6009080wes.14
        for <linux-wireless@vger.kernel.org>; Sun, 27 Oct 2013 18:53:11 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linux-wireless@vger.kernel.org
Cc: wireless-regdb@lists.infradead.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 2/6] crda: fix -pedantic gcc compilation
Date: Mon, 28 Oct 2013 02:52:58 +0100
Message-Id: <1382925182-7393-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131028_025317_049926_D9E296AF)
In-Reply-To: <1382925182-7393-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382925182-7393-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc likes to complain about this, fix that as we're
going to get a bit more anal with code here soon as
we're moving towards making a library out of reglib.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 crda.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crda.c b/crda.c
index 2a601eb..4751a39 100644
--- a/crda.c
+++ b/crda.c
@@ -141,13 +141,15 @@ int main(int argc, char **argv)
 {
 	int fd = -1;
 	int i = 0, j, r;
-	char alpha2[3] = {}; /* NUL-terminate */
+	char alpha2[3];
 	char *env_country;
 	struct nl80211_state nlstate;
 	struct nl_cb *cb = NULL;
 	struct nl_msg *msg;
 	int finished = 0;
 
+	memset(alpha2, 0, 3);
+
 	struct nlattr *nl_reg_rules;
 	const struct ieee80211_regdomain *rd = NULL;
 
-- 
1.8.4.rc3

